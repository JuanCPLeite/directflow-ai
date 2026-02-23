-- ===========================================
-- DirectFlow AI v3.0 — Adicionar Embeddings (pgvector)
-- Arquivo: 003_add_vectors.sql
-- Data: 2026-02-23
-- Pré-requisito: pgvector deve estar ativado no Supabase
--
-- Como ativar pgvector:
-- 1. Supabase Dashboard → Database → Extensions
-- 2. Procure "vector" e ative
-- 3. Execute este arquivo no SQL Editor
-- ===========================================

-- Habilitar extensão (deve estar disponível após ativar no dashboard)
CREATE EXTENSION IF NOT EXISTS vector;

-- Adicionar coluna de embeddings na tabela knowledge_base
ALTER TABLE public.knowledge_base
  ADD COLUMN IF NOT EXISTS vector_embeddings VECTOR(1536);

-- Criar index para busca semântica eficiente
CREATE INDEX IF NOT EXISTS idx_knowledge_base_embeddings
  ON public.knowledge_base USING ivfflat (vector_embeddings vector_cosine_ops)
  WITH (lists = 100);

-- Função auxiliar: busca semântica na base de conhecimento
-- Recebe um vetor de query e retorna os documentos mais similares
CREATE OR REPLACE FUNCTION public.search_knowledge_base(
  p_agent_id    UUID,
  p_embedding   VECTOR(1536),
  p_limit       INT DEFAULT 5,
  p_threshold   FLOAT DEFAULT 0.7
)
RETURNS TABLE (
  id                  UUID,
  name                VARCHAR,
  processed_content   TEXT,
  similarity          FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    kb.id,
    kb.name,
    kb.processed_content,
    1 - (kb.vector_embeddings <=> p_embedding) AS similarity
  FROM public.knowledge_base kb
  WHERE
    kb.agent_id = p_agent_id
    AND kb.is_active = TRUE
    AND kb.status = 'active'
    AND kb.vector_embeddings IS NOT NULL
    AND 1 - (kb.vector_embeddings <=> p_embedding) >= p_threshold
  ORDER BY kb.vector_embeddings <=> p_embedding
  LIMIT p_limit;
END;
$$;
