-- ===========================================
-- DirectFlow AI v3.0 — Schema Inicial
-- Arquivo: 001_schema.sql
-- Data: 2026-02-23
-- Descrição: Cria todas as tabelas, indexes e
--            relacionamentos do banco de dados.
--
-- Como executar:
-- 1. Acesse seu projeto no Supabase
-- 2. Vá em SQL Editor
-- 3. Cole este arquivo e clique em "Run"
-- ===========================================

-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";    -- Para gerar UUIDs
CREATE EXTENSION IF NOT EXISTS "pgcrypto";     -- Para criptografia
CREATE EXTENSION IF NOT EXISTS "vector";       -- Para embeddings de IA (busca semântica)


-- ===========================================
-- TABELA: profiles
-- Perfil de usuário (complementa auth.users)
-- ===========================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id                          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at                  TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at                  TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  -- Dados pessoais
  full_name                   VARCHAR(255),
  phone                       VARCHAR(50),
  company_name                VARCHAR(255),
  industry                    VARCHAR(100),
  timezone                    VARCHAR(50) DEFAULT 'America/Sao_Paulo' NOT NULL,
  language                    VARCHAR(10) DEFAULT 'pt-BR' NOT NULL,
  avatar_url                  TEXT,

  -- Plano e assinatura
  plan                        VARCHAR(50) DEFAULT 'trial' NOT NULL
                                CHECK (plan IN ('trial', 'starter', 'professional', 'business', 'enterprise')),
  plan_status                 VARCHAR(50) DEFAULT 'active' NOT NULL
                                CHECK (plan_status IN ('active', 'canceled', 'expired')),
  trial_ends_at               TIMESTAMPTZ,
  subscription_id             VARCHAR(255),

  -- Integração Instagram
  instagram_user_id           VARCHAR(255),
  instagram_username          VARCHAR(255),
  instagram_access_token      TEXT,
  instagram_token_expires_at  TIMESTAMPTZ,
  instagram_connected         BOOLEAN DEFAULT FALSE NOT NULL,

  -- Configurações gerais
  business_hours              JSONB,
  out_of_hours_message        TEXT,
  is_active                   BOOLEAN DEFAULT TRUE NOT NULL,
  last_login_at               TIMESTAMPTZ,
  login_count                 INTEGER DEFAULT 0 NOT NULL
);

-- Index para buscar usuários pelo username do Instagram
CREATE INDEX IF NOT EXISTS idx_profiles_instagram_username ON public.profiles(instagram_username);


-- ===========================================
-- TABELA: agents
-- Agentes de IA configurados pelos usuários
-- ===========================================
CREATE TABLE IF NOT EXISTS public.agents (
  id                              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id                         UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at                      TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at                      TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  -- Identificação
  name                            VARCHAR(255) NOT NULL,
  description                     TEXT,
  personality                     TEXT,
  system_prompt                   TEXT NOT NULL,
  avatar_url                      TEXT,

  -- Configurações do modelo de IA
  ai_model                        VARCHAR(100) DEFAULT 'gpt-4-turbo' NOT NULL,
  temperature                     DECIMAL(3,2) DEFAULT 0.7 NOT NULL CHECK (temperature >= 0 AND temperature <= 2),
  max_tokens                      INTEGER DEFAULT 500 NOT NULL CHECK (max_tokens > 0),
  response_delay_seconds          INTEGER DEFAULT 5 NOT NULL CHECK (response_delay_seconds >= 0),
  max_messages_per_conversation   INTEGER DEFAULT 20 NOT NULL CHECK (max_messages_per_conversation > 0),

  -- Comportamento
  tone                            VARCHAR(50) CHECK (tone IN ('formal', 'friendly', 'casual')),
  allow_human_handoff             BOOLEAN DEFAULT TRUE NOT NULL,
  save_conversation_history       BOOLEAN DEFAULT TRUE NOT NULL,
  debug_mode                      BOOLEAN DEFAULT FALSE NOT NULL,

  -- Status
  is_active                       BOOLEAN DEFAULT TRUE NOT NULL,
  is_default                      BOOLEAN DEFAULT FALSE NOT NULL,

  -- Estatísticas (atualizadas via triggers)
  total_conversations             INTEGER DEFAULT 0 NOT NULL,
  total_messages_sent             INTEGER DEFAULT 0 NOT NULL,
  average_satisfaction_score      DECIMAL(3,2)
);

-- Apenas um agente pode ser o padrão por usuário
CREATE UNIQUE INDEX IF NOT EXISTS idx_agents_default_per_user
  ON public.agents(user_id)
  WHERE is_default = TRUE;

CREATE INDEX IF NOT EXISTS idx_agents_user_id ON public.agents(user_id);


-- ===========================================
-- TABELA: knowledge_base
-- Documentos e fontes de conhecimento dos agentes
-- ===========================================
CREATE TABLE IF NOT EXISTS public.knowledge_base (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id             UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  agent_id            UUID NOT NULL REFERENCES public.agents(id) ON DELETE CASCADE,
  created_at          TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at          TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  -- Tipo e origem
  type                VARCHAR(50) NOT NULL
                        CHECK (type IN ('pdf', 'url', 'text', 'video', 'audio', 'integration')),
  name                VARCHAR(255) NOT NULL,
  description         TEXT,
  source_url          TEXT,

  -- Conteúdo processado
  raw_content         TEXT,
  processed_content   TEXT,
  content_metadata    JSONB,

  -- Embeddings para busca semântica com IA
  -- O vetor tem 1536 dimensões (padrão do modelo text-embedding-ada-002 da OpenAI)
  vector_embeddings   VECTOR(1536),
  tokens_count        INTEGER,

  -- Status de processamento
  status              VARCHAR(50) DEFAULT 'pending' NOT NULL
                        CHECK (status IN ('pending', 'processing', 'active', 'error')),
  error_message       TEXT,
  is_active           BOOLEAN DEFAULT TRUE NOT NULL,

  -- Sincronização automática (para URLs)
  last_synced_at      TIMESTAMPTZ,
  sync_frequency      VARCHAR(50) CHECK (sync_frequency IN ('daily', 'weekly', 'manual')),
  auto_sync           BOOLEAN DEFAULT FALSE NOT NULL
);

-- Index para busca vetorial (necessário para similarity search)
CREATE INDEX IF NOT EXISTS idx_knowledge_base_embeddings
  ON public.knowledge_base USING ivfflat (vector_embeddings vector_cosine_ops)
  WITH (lists = 100);

CREATE INDEX IF NOT EXISTS idx_knowledge_base_agent_id ON public.knowledge_base(agent_id);
CREATE INDEX IF NOT EXISTS idx_knowledge_base_user_id ON public.knowledge_base(user_id);


-- ===========================================
-- TABELA: pipeline_stages
-- Etapas do funil de vendas (colunas do Kanban)
-- ===========================================
CREATE TABLE IF NOT EXISTS public.pipeline_stages (
  id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id             UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at          TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at          TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  name                VARCHAR(100) NOT NULL,
  color               VARCHAR(50) DEFAULT '#6366f1',
  order_position      INTEGER NOT NULL,
  is_won_stage        BOOLEAN DEFAULT FALSE NOT NULL,
  is_lost_stage       BOOLEAN DEFAULT FALSE NOT NULL,

  -- Automações que disparam ao entrar/sair da etapa
  automation_on_enter JSONB,
  automation_on_exit  JSONB,

  -- Constraint: cada usuário tem posições únicas no funil
  UNIQUE(user_id, order_position)
);

CREATE INDEX IF NOT EXISTS idx_pipeline_stages_user_id ON public.pipeline_stages(user_id, order_position);


-- ===========================================
-- TABELA: leads
-- Contatos e leads do CRM
-- ===========================================
CREATE TABLE IF NOT EXISTS public.leads (
  id                        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id                   UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at                TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at                TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  -- Dados básicos
  name                      VARCHAR(255),
  email                     VARCHAR(255),
  phone                     VARCHAR(50),

  -- Dados do Instagram
  instagram_id              VARCHAR(255),
  instagram_username        VARCHAR(255),
  instagram_profile_pic     TEXT,
  instagram_follower_count  INTEGER,
  is_follower               BOOLEAN,

  -- Dados de negócio
  deal_value                DECIMAL(10,2),
  currency                  VARCHAR(10) DEFAULT 'BRL' NOT NULL,
  pipeline_stage_id         UUID REFERENCES public.pipeline_stages(id) ON DELETE SET NULL,

  -- Origem do lead
  source                    VARCHAR(100)
                              CHECK (source IN ('instagram_dm', 'comment', 'story', 'website', 'manual')),
  source_detail             TEXT,
  utm_source                VARCHAR(255),
  utm_campaign              VARCHAR(255),

  -- Última interação
  last_message              TEXT,
  last_response             TEXT,
  last_interaction_at       TIMESTAMPTZ,
  last_response_at          TIMESTAMPTZ,
  interaction_type          VARCHAR(50) CHECK (interaction_type IN ('dm', 'comment', 'story')),

  -- Status
  is_qualified              BOOLEAN DEFAULT FALSE NOT NULL,
  is_customer               BOOLEAN DEFAULT FALSE NOT NULL,

  -- Campos customizados (flexível, armazenado como JSON)
  custom_fields             JSONB,

  -- Preferências de contato
  preferred_contact_method  VARCHAR(50),
  best_time_to_contact      VARCHAR(50),
  notes                     TEXT
);

-- Index para buscas frequentes
CREATE INDEX IF NOT EXISTS idx_leads_user_id ON public.leads(user_id);
CREATE INDEX IF NOT EXISTS idx_leads_instagram_username ON public.leads(instagram_username);
CREATE INDEX IF NOT EXISTS idx_leads_pipeline_stage ON public.leads(pipeline_stage_id);
CREATE INDEX IF NOT EXISTS idx_leads_last_interaction ON public.leads(last_interaction_at DESC);


-- ===========================================
-- TABELA: tags
-- Etiquetas para organizar leads
-- ===========================================
CREATE TABLE IF NOT EXISTS public.tags (
  id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id     UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  name        VARCHAR(100) NOT NULL,
  color       VARCHAR(50) DEFAULT '#6366f1',
  is_active   BOOLEAN DEFAULT TRUE NOT NULL,

  -- Cada usuário não pode ter duas tags com o mesmo nome
  UNIQUE(user_id, name)
);

CREATE INDEX IF NOT EXISTS idx_tags_user_id ON public.tags(user_id);


-- ===========================================
-- TABELA: lead_tags
-- Relação N:N entre leads e tags
-- ===========================================
CREATE TABLE IF NOT EXISTS public.lead_tags (
  lead_id     UUID NOT NULL REFERENCES public.leads(id) ON DELETE CASCADE,
  tag_id      UUID NOT NULL REFERENCES public.tags(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  PRIMARY KEY (lead_id, tag_id)
);

CREATE INDEX IF NOT EXISTS idx_lead_tags_tag_id ON public.lead_tags(tag_id);


-- ===========================================
-- TABELA: flows
-- Fluxos de automação visuais (estilo Manychat)
-- ===========================================
CREATE TABLE IF NOT EXISTS public.flows (
  id                        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id                   UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at                TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at                TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  -- Informações básicas
  name                      VARCHAR(255) NOT NULL,
  description               TEXT,
  category                  VARCHAR(100)
                              CHECK (category IN ('sales', 'support', 'lead_qualification', 'other')),

  -- Estrutura do fluxo (nós e conexões armazenados como JSON)
  flow_data                 JSONB NOT NULL DEFAULT '{"nodes": [], "edges": []}',
  trigger_type              VARCHAR(50)
                              CHECK (trigger_type IN ('new_message', 'comment', 'story_reply', 'keyword', 'schedule')),
  trigger_config            JSONB,

  -- Status
  is_active                 BOOLEAN DEFAULT TRUE NOT NULL,
  is_template               BOOLEAN DEFAULT FALSE NOT NULL,

  -- Estatísticas
  total_executions          INTEGER DEFAULT 0 NOT NULL,
  completion_rate           DECIMAL(5,2),
  average_completion_time   INTEGER,   -- em segundos

  -- Versionamento
  version                   INTEGER DEFAULT 1 NOT NULL,
  parent_flow_id            UUID REFERENCES public.flows(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_flows_user_id ON public.flows(user_id);
CREATE INDEX IF NOT EXISTS idx_flows_is_template ON public.flows(is_template) WHERE is_template = TRUE;


-- ===========================================
-- TABELA: keywords
-- Palavras-chave para automação de respostas
-- ===========================================
CREATE TABLE IF NOT EXISTS public.keywords (
  id                        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id                   UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at                TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at                TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  -- Gatilhos
  keywords                  JSONB NOT NULL,  -- array: ["preço", "valor", "quanto custa"]
  match_type                VARCHAR(50) DEFAULT 'contains' NOT NULL
                              CHECK (match_type IN ('exact', 'contains', 'starts_with', 'ends_with')),

  -- Canais de aplicação
  apply_to_dm               BOOLEAN DEFAULT TRUE NOT NULL,
  apply_to_comments         BOOLEAN DEFAULT TRUE NOT NULL,
  apply_to_stories          BOOLEAN DEFAULT TRUE NOT NULL,

  -- Resposta automática
  response_type             VARCHAR(50)
                              CHECK (response_type IN ('message', 'trigger_flow', 'webhook')),
  response_message          TEXT,
  response_media_url        TEXT,
  response_buttons          JSONB,    -- botões de resposta rápida
  flow_id                   UUID REFERENCES public.flows(id) ON DELETE SET NULL,

  -- Ações adicionais ao detectar keyword
  add_tags                  JSONB,    -- array de tag_ids para adicionar ao lead
  move_to_stage_id          UUID REFERENCES public.pipeline_stages(id) ON DELETE SET NULL,
  notify_user               BOOLEAN DEFAULT FALSE NOT NULL,

  -- Configurações de uso
  priority                  INTEGER DEFAULT 0 NOT NULL,
  is_active                 BOOLEAN DEFAULT TRUE NOT NULL,
  apply_only_to_new_leads   BOOLEAN DEFAULT FALSE NOT NULL,
  apply_only_with_tags      JSONB,
  max_uses_per_lead         INTEGER,
  active_hours              JSONB,    -- horários em que a keyword funciona

  -- Estatísticas
  total_triggers            INTEGER DEFAULT 0 NOT NULL,
  conversion_rate           DECIMAL(5,2)
);

CREATE INDEX IF NOT EXISTS idx_keywords_user_id ON public.keywords(user_id);
CREATE INDEX IF NOT EXISTS idx_keywords_active ON public.keywords(user_id, is_active) WHERE is_active = TRUE;


-- ===========================================
-- TABELA: conversations
-- Conversas (agrupam mensagens)
-- ===========================================
CREATE TABLE IF NOT EXISTS public.conversations (
  id                      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id                 UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  lead_id                 UUID NOT NULL REFERENCES public.leads(id) ON DELETE CASCADE,
  agent_id                UUID REFERENCES public.agents(id) ON DELETE SET NULL,
  flow_id                 UUID REFERENCES public.flows(id) ON DELETE SET NULL,

  started_at              TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  ended_at                TIMESTAMPTZ,

  -- Tipo e canal
  type                    VARCHAR(50) CHECK (type IN ('agent', 'flow', 'human')),
  channel                 VARCHAR(50) CHECK (channel IN ('dm', 'comment', 'story')),

  -- Status
  status                  VARCHAR(50) DEFAULT 'active' NOT NULL
                            CHECK (status IN ('active', 'resolved', 'transferred')),
  transferred_to_human    BOOLEAN DEFAULT FALSE NOT NULL,
  transferred_at          TIMESTAMPTZ,

  -- Qualidade
  satisfaction_score      INTEGER CHECK (satisfaction_score BETWEEN 1 AND 5),
  resolved                BOOLEAN,

  -- Métricas
  total_messages          INTEGER DEFAULT 0 NOT NULL,
  response_time_avg       INTEGER,    -- em segundos
  duration_seconds        INTEGER
);

CREATE INDEX IF NOT EXISTS idx_conversations_user_id ON public.conversations(user_id);
CREATE INDEX IF NOT EXISTS idx_conversations_lead_id ON public.conversations(lead_id);
CREATE INDEX IF NOT EXISTS idx_conversations_status ON public.conversations(status);
CREATE INDEX IF NOT EXISTS idx_conversations_started_at ON public.conversations(started_at DESC);


-- ===========================================
-- TABELA: messages
-- Mensagens individuais dentro de conversas
-- ===========================================
CREATE TABLE IF NOT EXISTS public.messages (
  id                      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  conversation_id         UUID NOT NULL REFERENCES public.conversations(id) ON DELETE CASCADE,
  created_at              TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  -- Quem enviou
  from_type               VARCHAR(50) NOT NULL CHECK (from_type IN ('lead', 'agent', 'human')),
  from_user_id            UUID REFERENCES public.profiles(id) ON DELETE SET NULL,

  -- Conteúdo
  content                 TEXT,
  media_type              VARCHAR(50) CHECK (media_type IN ('text', 'image', 'video', 'audio', 'file')),
  media_url               TEXT,

  -- Metadados do Instagram
  instagram_message_id    VARCHAR(255),
  is_read                 BOOLEAN DEFAULT FALSE NOT NULL,
  read_at                 TIMESTAMPTZ,

  -- Análise de IA
  ai_confidence           DECIMAL(5,2),
  intent                  VARCHAR(100),
  sentiment               VARCHAR(50) CHECK (sentiment IN ('positive', 'neutral', 'negative')),
  entities                JSONB
);

CREATE INDEX IF NOT EXISTS idx_messages_conversation_id ON public.messages(conversation_id);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON public.messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_messages_unread ON public.messages(conversation_id, is_read) WHERE is_read = FALSE;


-- ===========================================
-- TABELA: broadcasts
-- Campanhas de mensagens em massa
-- ===========================================
CREATE TABLE IF NOT EXISTS public.broadcasts (
  id                      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id                 UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at              TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  scheduled_at            TIMESTAMPTZ,
  sent_at                 TIMESTAMPTZ,

  -- Identificação
  name                    VARCHAR(255) NOT NULL,

  -- Público-alvo
  target_type             VARCHAR(50) NOT NULL
                            CHECK (target_type IN ('all', 'segment', 'tags', 'custom')),
  target_segment_id       UUID,
  target_tags             JSONB,
  target_custom_filter    JSONB,
  exclude_filter          JSONB,

  -- Conteúdo da mensagem
  message_type            VARCHAR(50) NOT NULL
                            CHECK (message_type IN ('text', 'image', 'video', 'carousel')),
  message_content         TEXT,
  message_media_url       TEXT,
  message_buttons         JSONB,

  -- Configurações de envio
  send_speed              VARCHAR(50) DEFAULT 'normal' NOT NULL
                            CHECK (send_speed IN ('fast', 'normal', 'slow')),
  messages_per_minute     INTEGER,

  -- Status da campanha
  status                  VARCHAR(50) DEFAULT 'draft' NOT NULL
                            CHECK (status IN ('draft', 'scheduled', 'sending', 'sent', 'failed')),

  -- Estatísticas de entrega
  total_recipients        INTEGER,
  total_sent              INTEGER DEFAULT 0 NOT NULL,
  total_delivered         INTEGER DEFAULT 0 NOT NULL,
  total_read              INTEGER DEFAULT 0 NOT NULL,
  total_clicked           INTEGER DEFAULT 0 NOT NULL,
  total_replied           INTEGER DEFAULT 0 NOT NULL,
  total_converted         INTEGER DEFAULT 0 NOT NULL,
  total_revenue           DECIMAL(10,2),

  -- A/B Testing
  ab_test                 BOOLEAN DEFAULT FALSE NOT NULL,
  ab_test_config          JSONB
);

CREATE INDEX IF NOT EXISTS idx_broadcasts_user_id ON public.broadcasts(user_id);
CREATE INDEX IF NOT EXISTS idx_broadcasts_status ON public.broadcasts(status);
CREATE INDEX IF NOT EXISTS idx_broadcasts_scheduled ON public.broadcasts(scheduled_at) WHERE scheduled_at IS NOT NULL;


-- ===========================================
-- TABELA: integrations
-- Integrações com sistemas externos
-- ===========================================
CREATE TABLE IF NOT EXISTS public.integrations (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at        TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at        TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  integration_type  VARCHAR(100) NOT NULL,  -- 'zapier', 'make', 'webhook', 'stripe', etc.
  name              VARCHAR(255),
  config            JSONB NOT NULL DEFAULT '{}',
  credentials       JSONB,     -- Criptografado via pgcrypto

  -- Status
  is_active         BOOLEAN DEFAULT TRUE NOT NULL,
  last_sync_at      TIMESTAMPTZ,
  sync_status       VARCHAR(50) CHECK (sync_status IN ('success', 'error', 'pending')),
  error_message     TEXT,

  -- Uso
  total_calls       INTEGER DEFAULT 0 NOT NULL,
  successful_calls  INTEGER DEFAULT 0 NOT NULL,
  failed_calls      INTEGER DEFAULT 0 NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_integrations_user_id ON public.integrations(user_id);


-- ===========================================
-- TABELA: analytics_events
-- Registro de todos os eventos para analytics
-- ===========================================
CREATE TABLE IF NOT EXISTS public.analytics_events (
  id                UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id           UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at        TIMESTAMPTZ DEFAULT NOW() NOT NULL,

  -- Identificação do evento
  event_type        VARCHAR(100) NOT NULL,  -- 'lead_created', 'message_sent', 'sale_closed', etc.
  event_name        VARCHAR(255),

  -- Contexto (qual recurso gerou o evento)
  lead_id           UUID REFERENCES public.leads(id) ON DELETE SET NULL,
  conversation_id   UUID REFERENCES public.conversations(id) ON DELETE SET NULL,
  flow_id           UUID REFERENCES public.flows(id) ON DELETE SET NULL,
  broadcast_id      UUID REFERENCES public.broadcasts(id) ON DELETE SET NULL,

  -- Dados do evento
  event_data        JSONB,
  revenue           DECIMAL(10,2),

  -- Metadados técnicos
  user_agent        TEXT,
  ip_address        INET,
  session_id        VARCHAR(255)
);

-- Particionamento por data para melhor performance em analytics
CREATE INDEX IF NOT EXISTS idx_analytics_events_user_id ON public.analytics_events(user_id);
CREATE INDEX IF NOT EXISTS idx_analytics_events_type ON public.analytics_events(event_type);
CREATE INDEX IF NOT EXISTS idx_analytics_events_created_at ON public.analytics_events(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_analytics_events_lead ON public.analytics_events(lead_id) WHERE lead_id IS NOT NULL;


-- ===========================================
-- FUNÇÃO: atualiza o campo updated_at automaticamente
-- Chamada por triggers nas tabelas
-- ===========================================
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- ===========================================
-- TRIGGERS: updated_at automático
-- ===========================================
CREATE OR REPLACE TRIGGER trigger_profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE OR REPLACE TRIGGER trigger_agents_updated_at
  BEFORE UPDATE ON public.agents
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE OR REPLACE TRIGGER trigger_knowledge_base_updated_at
  BEFORE UPDATE ON public.knowledge_base
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE OR REPLACE TRIGGER trigger_pipeline_stages_updated_at
  BEFORE UPDATE ON public.pipeline_stages
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE OR REPLACE TRIGGER trigger_leads_updated_at
  BEFORE UPDATE ON public.leads
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE OR REPLACE TRIGGER trigger_flows_updated_at
  BEFORE UPDATE ON public.flows
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE OR REPLACE TRIGGER trigger_keywords_updated_at
  BEFORE UPDATE ON public.keywords
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

CREATE OR REPLACE TRIGGER trigger_integrations_updated_at
  BEFORE UPDATE ON public.integrations
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();


-- ===========================================
-- FUNÇÃO: cria perfil automaticamente quando
-- um novo usuário se registra no Supabase Auth
-- ===========================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url, trial_ends_at)
  VALUES (
    NEW.id,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url',
    NOW() + INTERVAL '14 days'   -- Trial de 14 dias ao criar conta
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger que dispara a função acima quando um usuário é criado
CREATE OR REPLACE TRIGGER trigger_on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


-- ===========================================
-- FUNÇÃO: cria etapas padrão do funil para
-- novos usuários (ao criar o perfil)
-- ===========================================
CREATE OR REPLACE FUNCTION public.create_default_pipeline_stages()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.pipeline_stages (user_id, name, color, order_position, is_won_stage, is_lost_stage)
  VALUES
    (NEW.id, 'Novo Lead',    '#6366f1', 1, FALSE, FALSE),
    (NEW.id, 'Contato',      '#f59e0b', 2, FALSE, FALSE),
    (NEW.id, 'Negociação',   '#3b82f6', 3, FALSE, FALSE),
    (NEW.id, 'Proposta',     '#8b5cf6', 4, FALSE, FALSE),
    (NEW.id, 'Fechado',      '#10b981', 5, TRUE,  FALSE),
    (NEW.id, 'Perdido',      '#ef4444', 6, FALSE, TRUE);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER trigger_create_default_pipeline
  AFTER INSERT ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.create_default_pipeline_stages();
