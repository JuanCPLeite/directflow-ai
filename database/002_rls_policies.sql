-- ===========================================
-- DirectFlow AI v3.0 — Row Level Security (RLS)
-- Arquivo: 002_rls_policies.sql
-- Data: 2026-02-23
-- Descrição: Políticas de segurança que garantem
--            que cada usuário só veja seus próprios dados.
--
-- IMPORTANTE: Executar APÓS o 001_schema.sql
-- ===========================================

-- ===========================================
-- Habilitar RLS em todas as tabelas
-- ===========================================
ALTER TABLE public.profiles           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.agents             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.knowledge_base     ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pipeline_stages    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.leads              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tags               ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lead_tags          ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.flows              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.keywords           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversations      ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.broadcasts         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.integrations       ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.analytics_events   ENABLE ROW LEVEL SECURITY;


-- ===========================================
-- POLÍTICAS: profiles
-- Cada usuário vê e edita apenas o próprio perfil
-- ===========================================
CREATE POLICY "profiles_select_own" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "profiles_insert_own" ON public.profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "profiles_update_own" ON public.profiles
  FOR UPDATE USING (auth.uid() = id);


-- ===========================================
-- POLÍTICAS: agents
-- ===========================================
CREATE POLICY "agents_all_own" ON public.agents
  FOR ALL USING (auth.uid() = user_id);


-- ===========================================
-- POLÍTICAS: knowledge_base
-- ===========================================
CREATE POLICY "knowledge_base_all_own" ON public.knowledge_base
  FOR ALL USING (auth.uid() = user_id);


-- ===========================================
-- POLÍTICAS: pipeline_stages
-- ===========================================
CREATE POLICY "pipeline_stages_all_own" ON public.pipeline_stages
  FOR ALL USING (auth.uid() = user_id);


-- ===========================================
-- POLÍTICAS: leads
-- ===========================================
CREATE POLICY "leads_all_own" ON public.leads
  FOR ALL USING (auth.uid() = user_id);


-- ===========================================
-- POLÍTICAS: tags
-- ===========================================
CREATE POLICY "tags_all_own" ON public.tags
  FOR ALL USING (auth.uid() = user_id);


-- ===========================================
-- POLÍTICAS: lead_tags
-- Usuário pode gerenciar tags dos seus leads
-- ===========================================
CREATE POLICY "lead_tags_select" ON public.lead_tags
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.leads
      WHERE leads.id = lead_tags.lead_id
      AND leads.user_id = auth.uid()
    )
  );

CREATE POLICY "lead_tags_insert" ON public.lead_tags
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.leads
      WHERE leads.id = lead_tags.lead_id
      AND leads.user_id = auth.uid()
    )
  );

CREATE POLICY "lead_tags_delete" ON public.lead_tags
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.leads
      WHERE leads.id = lead_tags.lead_id
      AND leads.user_id = auth.uid()
    )
  );


-- ===========================================
-- POLÍTICAS: flows
-- ===========================================
CREATE POLICY "flows_all_own" ON public.flows
  FOR ALL USING (auth.uid() = user_id);

-- Templates são visíveis para todos os usuários autenticados
CREATE POLICY "flows_select_templates" ON public.flows
  FOR SELECT USING (is_template = TRUE AND auth.uid() IS NOT NULL);


-- ===========================================
-- POLÍTICAS: keywords
-- ===========================================
CREATE POLICY "keywords_all_own" ON public.keywords
  FOR ALL USING (auth.uid() = user_id);


-- ===========================================
-- POLÍTICAS: conversations
-- ===========================================
CREATE POLICY "conversations_all_own" ON public.conversations
  FOR ALL USING (auth.uid() = user_id);


-- ===========================================
-- POLÍTICAS: messages
-- Usuário acessa mensagens das suas conversas
-- ===========================================
CREATE POLICY "messages_select" ON public.messages
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.conversations
      WHERE conversations.id = messages.conversation_id
      AND conversations.user_id = auth.uid()
    )
  );

CREATE POLICY "messages_insert" ON public.messages
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.conversations
      WHERE conversations.id = messages.conversation_id
      AND conversations.user_id = auth.uid()
    )
  );

CREATE POLICY "messages_update" ON public.messages
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.conversations
      WHERE conversations.id = messages.conversation_id
      AND conversations.user_id = auth.uid()
    )
  );


-- ===========================================
-- POLÍTICAS: broadcasts
-- ===========================================
CREATE POLICY "broadcasts_all_own" ON public.broadcasts
  FOR ALL USING (auth.uid() = user_id);


-- ===========================================
-- POLÍTICAS: integrations
-- ===========================================
CREATE POLICY "integrations_all_own" ON public.integrations
  FOR ALL USING (auth.uid() = user_id);


-- ===========================================
-- POLÍTICAS: analytics_events
-- ===========================================
CREATE POLICY "analytics_events_select_own" ON public.analytics_events
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "analytics_events_insert_own" ON public.analytics_events
  FOR INSERT WITH CHECK (auth.uid() = user_id);
