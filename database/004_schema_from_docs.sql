-- Extracted from docs/SCHEMA.md on 2026-03-12

-- Run this file in Supabase SQL Editor, not the Markdown document.



-- Habilitar extensões necessárias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";

-- Schema público padrão do Supabase
SET search_path = public;

-- Função reutilizada por todos os triggers de updated_at
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Extensão do auth.users do Supabase
-- Criada automaticamente via trigger ao registrar novo usuário
CREATE TABLE profiles (
  id                    uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email                 text NOT NULL,
  full_name             text,
  phone                 text,
  company_name          text,
  industry              text,
  timezone              text NOT NULL DEFAULT 'America/Sao_Paulo',
  language              text NOT NULL DEFAULT 'pt-BR',
  avatar_url            text,

  -- Plano e assinatura
  plan                  text NOT NULL DEFAULT 'trial'
                          CHECK (plan IN ('trial','starter','pro','business','enterprise')),
  plan_status           text NOT NULL DEFAULT 'active'
                          CHECK (plan_status IN ('active','canceled','expired','past_due')),
  trial_started_at      timestamptz,
  trial_ends_at         timestamptz,
  subscription_id       text,   -- ID da assinatura no Stripe
  customer_id           text,   -- ID do customer no Stripe

  -- Instagram
  instagram_connected   boolean NOT NULL DEFAULT false,

  -- Configurações de horário comercial
  business_hours        jsonb DEFAULT '{
    "monday":    {"open": "09:00", "close": "18:00", "active": true},
    "tuesday":   {"open": "09:00", "close": "18:00", "active": true},
    "wednesday": {"open": "09:00", "close": "18:00", "active": true},
    "thursday":  {"open": "09:00", "close": "18:00", "active": true},
    "friday":    {"open": "09:00", "close": "18:00", "active": true},
    "saturday":  {"open": "09:00", "close": "13:00", "active": false},
    "sunday":    {"open": "09:00", "close": "13:00", "active": false}
  }'::jsonb,
  out_of_hours_message  text DEFAULT 'Olá! Estamos fora do horário de atendimento. Retornaremos em breve!',

  -- Onboarding
  onboarding_completed  boolean NOT NULL DEFAULT false,
  onboarding_step       int NOT NULL DEFAULT 0,

  created_at            timestamptz NOT NULL DEFAULT NOW(),
  updated_at            timestamptz NOT NULL DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_profiles_email ON profiles(email);
CREATE INDEX idx_profiles_plan ON profiles(plan);
CREATE INDEX idx_profiles_customer_id ON profiles(customer_id);

-- Trigger updated_at
CREATE TRIGGER trg_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário vê apenas seu próprio perfil"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Usuário atualiza apenas seu próprio perfil"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE TABLE instagram_accounts (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  instagram_user_id     text NOT NULL,
  instagram_username    text NOT NULL,
  instagram_name        text,
  profile_pic_url       text,
  followers_count       int NOT NULL DEFAULT 0,

  -- Token criptografado com pgcrypto
  access_token          text NOT NULL,
  token_expires_at      timestamptz,

  webhook_verified      boolean NOT NULL DEFAULT false,

  -- Permissões concedidas pela conta (ex: ["instagram_basic","instagram_manage_messages"])
  permissions           jsonb NOT NULL DEFAULT '[]'::jsonb,

  is_active             boolean NOT NULL DEFAULT true,
  connected_at          timestamptz NOT NULL DEFAULT NOW(),
  last_sync_at          timestamptz,

  created_at            timestamptz NOT NULL DEFAULT NOW(),
  updated_at            timestamptz NOT NULL DEFAULT NOW(),

  UNIQUE(user_id, instagram_user_id)
);

CREATE INDEX idx_instagram_accounts_user_id ON instagram_accounts(user_id);
CREATE INDEX idx_instagram_accounts_instagram_user_id ON instagram_accounts(instagram_user_id);
CREATE INDEX idx_instagram_accounts_is_active ON instagram_accounts(is_active);

CREATE TRIGGER trg_instagram_accounts_updated_at
  BEFORE UPDATE ON instagram_accounts
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE instagram_accounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia suas contas Instagram"
  ON instagram_accounts FOR ALL
  USING (auth.uid() = user_id);

-- Tabela gerenciada pelo admin da plataforma
-- Usuários não inserem/alteram — apenas leem
CREATE TABLE ai_models (
  id                        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  provider                  text NOT NULL CHECK (provider IN ('openai','anthropic','google')),
  model_id                  text NOT NULL UNIQUE, -- ex: gpt-4o, claude-3-5-sonnet-20241022
  display_name              text NOT NULL,
  description               text,
  min_plan                  text NOT NULL DEFAULT 'starter'
                              CHECK (min_plan IN ('starter','pro','business','enterprise')),
  is_active                 boolean NOT NULL DEFAULT true,

  -- Custo em USD por 1000 tokens
  cost_per_1k_input_tokens  numeric(10,6) NOT NULL DEFAULT 0,
  cost_per_1k_output_tokens numeric(10,6) NOT NULL DEFAULT 0,

  max_tokens                int NOT NULL DEFAULT 4096,
  supports_vision           boolean NOT NULL DEFAULT false,
  supports_streaming        boolean NOT NULL DEFAULT true,

  -- Capacidades extras (ex: {"function_calling": true, "json_mode": true})
  capabilities              jsonb NOT NULL DEFAULT '{}'::jsonb,

  created_at                timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ai_models_provider ON ai_models(provider);
CREATE INDEX idx_ai_models_is_active ON ai_models(is_active);
CREATE INDEX idx_ai_models_min_plan ON ai_models(min_plan);

ALTER TABLE ai_models ENABLE ROW LEVEL SECURITY;

-- Todos os usuários autenticados podem ler os modelos disponíveis
CREATE POLICY "Modelos visíveis para usuários autenticados"
  ON ai_models FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE TABLE agents (
  id                          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                     uuid REFERENCES profiles(id) ON DELETE CASCADE,

  name                        text NOT NULL,
  description                 text,
  avatar_url                  text,

  -- Personalidade e estilo
  personality                 text, -- descrição livre da personalidade
  tone                        text NOT NULL DEFAULT 'friendly'
                                CHECK (tone IN ('formal','friendly','casual')),
  system_prompt               text NOT NULL,

  -- Modelo de IA
  model_id                    uuid NOT NULL REFERENCES ai_models(id),
  temperature                 numeric(3,2) NOT NULL DEFAULT 0.7
                                CHECK (temperature >= 0 AND temperature <= 2),
  max_tokens                  int NOT NULL DEFAULT 1024,

  -- Comportamento
  response_delay_seconds      int NOT NULL DEFAULT 2,   -- simula digitação humana
  max_messages_per_conversation int NOT NULL DEFAULT 50,

  -- Transferência humana
  allow_human_handoff         boolean NOT NULL DEFAULT true,
  handoff_message             text DEFAULT 'Vou transferir você para um de nossos atendentes. Um momento!',

  -- Histórico e debug
  save_conversation_history   boolean NOT NULL DEFAULT true,
  debug_mode                  boolean NOT NULL DEFAULT false,

  is_active                   boolean NOT NULL DEFAULT true,
  is_default                  boolean NOT NULL DEFAULT false, -- apenas 1 por usuário

  -- Métricas
  total_conversations         int NOT NULL DEFAULT 0,
  total_messages_sent         int NOT NULL DEFAULT 0,
  avg_satisfaction_score      numeric(3,2),

  created_at                  timestamptz NOT NULL DEFAULT NOW(),
  updated_at                  timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_agents_user_id ON agents(user_id);
CREATE INDEX idx_agents_model_id ON agents(model_id);
CREATE INDEX idx_agents_is_active ON agents(is_active);
CREATE INDEX idx_agents_is_default ON agents(is_default);

CREATE TRIGGER trg_agents_updated_at
  BEFORE UPDATE ON agents
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE agents ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia seus agentes"
  ON agents FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE prompt_templates (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name              text NOT NULL,
  description       text,
  category          text NOT NULL
                      CHECK (category IN ('ecommerce','health','education','realestate',
                                          'delivery','services','beauty','legal','finance','other')),
  prompt_content    text NOT NULL,

  -- Ex: [{"key": "produto", "label": "Nome do Produto", "type": "text"}]
  variables         jsonb NOT NULL DEFAULT '[]'::jsonb,
  preview_message   text, -- mensagem de exemplo com variáveis preenchidas

  usage_count       int NOT NULL DEFAULT 0,
  is_system         boolean NOT NULL DEFAULT false, -- true = plataforma, false = usuário

  -- null quando is_system = true
  user_id           uuid REFERENCES profiles(id) ON DELETE CASCADE,

  created_at        timestamptz NOT NULL DEFAULT NOW(),
  updated_at        timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_prompt_templates_user_id ON prompt_templates(user_id);
CREATE INDEX idx_prompt_templates_category ON prompt_templates(category);
CREATE INDEX idx_prompt_templates_is_system ON prompt_templates(is_system);

CREATE TRIGGER trg_prompt_templates_updated_at
  BEFORE UPDATE ON prompt_templates
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE prompt_templates ENABLE ROW LEVEL SECURITY;

-- Templates do sistema visíveis para todos; templates do usuário apenas para ele
CREATE POLICY "Usuário vê templates do sistema e os seus"
  ON prompt_templates FOR SELECT
  USING (is_system = true OR auth.uid() = user_id);

CREATE POLICY "Usuário gerencia seus próprios templates"
  ON prompt_templates FOR INSERT
  WITH CHECK (auth.uid() = user_id AND is_system = false);

CREATE POLICY "Usuário atualiza seus próprios templates"
  ON prompt_templates FOR UPDATE
  USING (auth.uid() = user_id AND is_system = false);

CREATE POLICY "Usuário remove seus próprios templates"
  ON prompt_templates FOR DELETE
  USING (auth.uid() = user_id AND is_system = false);

CREATE TABLE knowledge_base (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  -- null = conhecimento global do usuário (não vinculado a agente específico)
  agent_id            uuid REFERENCES agents(id) ON DELETE SET NULL,

  name                text NOT NULL,
  description         text,
  type                text NOT NULL
                        CHECK (type IN ('pdf','url','text','faq','video','audio','spreadsheet')),
  source_url          text,
  file_path           text, -- caminho no Supabase Storage

  raw_content         text,       -- conteúdo bruto extraído
  processed_content   text,       -- conteúdo após limpeza e chunking
  content_metadata    jsonb DEFAULT '{}'::jsonb, -- {"pages": 10, "size_bytes": 204800, "language": "pt-BR"}

  status              text NOT NULL DEFAULT 'pending'
                        CHECK (status IN ('pending','processing','active','error')),
  error_message       text,

  tokens_count        int NOT NULL DEFAULT 0,
  chunks_count        int NOT NULL DEFAULT 0,

  last_synced_at      timestamptz,
  sync_frequency      text DEFAULT 'manual'
                        CHECK (sync_frequency IN ('daily','weekly','manual')),
  auto_sync           boolean NOT NULL DEFAULT false,

  is_active           boolean NOT NULL DEFAULT true,

  created_at          timestamptz NOT NULL DEFAULT NOW(),
  updated_at          timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_knowledge_base_user_id ON knowledge_base(user_id);
CREATE INDEX idx_knowledge_base_agent_id ON knowledge_base(agent_id);
CREATE INDEX idx_knowledge_base_status ON knowledge_base(status);
CREATE INDEX idx_knowledge_base_type ON knowledge_base(type);

CREATE TRIGGER trg_knowledge_base_updated_at
  BEFORE UPDATE ON knowledge_base
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE knowledge_base ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia sua knowledge base"
  ON knowledge_base FOR ALL
  USING (auth.uid() = user_id);

-- Chunks para busca semântica via pgvector
CREATE TABLE knowledge_chunks (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  knowledge_base_id   uuid NOT NULL REFERENCES knowledge_base(id) ON DELETE CASCADE,
  user_id             uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  content             text NOT NULL,
  embedding           vector(1536), -- OpenAI text-embedding-3-small

  chunk_index         int NOT NULL, -- posição dentro do documento
  metadata            jsonb DEFAULT '{}'::jsonb, -- {"page": 1, "section": "Preços"}

  created_at          timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_knowledge_chunks_knowledge_base_id ON knowledge_chunks(knowledge_base_id);
CREATE INDEX idx_knowledge_chunks_user_id ON knowledge_chunks(user_id);

-- Índice HNSW para busca vetorial aproximada (mais rápido que IVFFlat)
CREATE INDEX idx_knowledge_chunks_embedding
  ON knowledge_chunks
  USING hnsw (embedding vector_cosine_ops)
  WITH (m = 16, ef_construction = 64);

ALTER TABLE knowledge_chunks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário acessa chunks de sua knowledge base"
  ON knowledge_chunks FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE pipeline_stages (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  name            text NOT NULL,
  color           text NOT NULL DEFAULT '#6366f1', -- hex color
  order_position  int NOT NULL,
  description     text,

  is_won_stage    boolean NOT NULL DEFAULT false, -- etapa de fechamento/ganho
  is_lost_stage   boolean NOT NULL DEFAULT false, -- etapa de perda

  -- Ações automáticas ao mover lead para esta etapa
  -- Ex: [{"type": "add_tag", "tag_id": "..."}, {"type": "notify", "message": "..."}]
  auto_actions    jsonb NOT NULL DEFAULT '[]'::jsonb,

  created_at      timestamptz NOT NULL DEFAULT NOW(),
  updated_at      timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_pipeline_stages_user_id ON pipeline_stages(user_id);
CREATE INDEX idx_pipeline_stages_order ON pipeline_stages(user_id, order_position);

CREATE TRIGGER trg_pipeline_stages_updated_at
  BEFORE UPDATE ON pipeline_stages
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE pipeline_stages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia seu funil"
  ON pipeline_stages FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE leads (
  id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                 uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  instagram_account_id    uuid REFERENCES instagram_accounts(id) ON DELETE SET NULL,

  -- Dados do Instagram
  instagram_id            text,
  instagram_username      text,
  instagram_name          text,
  profile_pic_url         text,
  follower_count          int DEFAULT 0,
  is_verified             boolean NOT NULL DEFAULT false,

  -- Dados de contato
  email                   text,
  phone                   text,
  full_name               text,

  -- CRM
  deal_value              numeric(12,2),
  currency                text NOT NULL DEFAULT 'BRL',
  pipeline_stage_id       uuid REFERENCES pipeline_stages(id) ON DELETE SET NULL,

  -- Origem
  source                  text NOT NULL DEFAULT 'instagram_dm'
                            CHECK (source IN ('instagram_dm','comment','story_reply','manual','import')),
  source_detail           text, -- ex: nome da campanha, ID do post

  -- Interações
  first_interaction_at    timestamptz,
  last_interaction_at     timestamptz,
  last_message_preview    text,
  interaction_count       int NOT NULL DEFAULT 0,

  -- Qualificação
  is_qualified            boolean NOT NULL DEFAULT false,
  is_customer             boolean NOT NULL DEFAULT false,
  score                   int NOT NULL DEFAULT 0 CHECK (score >= 0 AND score <= 100),

  -- Campos customizados (preenchidos via custom_fields)
  custom_fields           jsonb NOT NULL DEFAULT '{}'::jsonb,
  notes                   text,

  preferred_contact       text DEFAULT 'instagram'
                            CHECK (preferred_contact IN ('instagram','email','phone','whatsapp')),

  created_at              timestamptz NOT NULL DEFAULT NOW(),
  updated_at              timestamptz NOT NULL DEFAULT NOW(),

  UNIQUE(user_id, instagram_id)
);

CREATE INDEX idx_leads_user_id ON leads(user_id);
CREATE INDEX idx_leads_instagram_account_id ON leads(instagram_account_id);
CREATE INDEX idx_leads_pipeline_stage_id ON leads(pipeline_stage_id);
CREATE INDEX idx_leads_score ON leads(user_id, score DESC);
CREATE INDEX idx_leads_last_interaction ON leads(user_id, last_interaction_at DESC);
CREATE INDEX idx_leads_source ON leads(user_id, source);
CREATE INDEX idx_leads_is_qualified ON leads(user_id, is_qualified);

CREATE TRIGGER trg_leads_updated_at
  BEFORE UPDATE ON leads
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia seus leads"
  ON leads FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE tags (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  name        text NOT NULL,
  color       text NOT NULL DEFAULT '#10b981',
  description text,

  -- Regras automáticas para aplicar/remover a tag
  -- Ex: [{"trigger": "keyword_match", "value": "orçamento", "action": "add"}]
  auto_rules  jsonb NOT NULL DEFAULT '[]'::jsonb,

  leads_count int NOT NULL DEFAULT 0, -- cache, atualizado por trigger

  created_at  timestamptz NOT NULL DEFAULT NOW(),

  UNIQUE(user_id, name)
);

CREATE INDEX idx_tags_user_id ON tags(user_id);

ALTER TABLE tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia suas tags"
  ON tags FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE lead_tags (
  lead_id   uuid NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
  tag_id    uuid NOT NULL REFERENCES tags(id) ON DELETE CASCADE,

  added_by  text NOT NULL DEFAULT 'user'
              CHECK (added_by IN ('user','flow','agent','keyword','import')),
  added_at  timestamptz NOT NULL DEFAULT NOW(),

  PRIMARY KEY (lead_id, tag_id)
);

CREATE INDEX idx_lead_tags_tag_id ON lead_tags(tag_id);
CREATE INDEX idx_lead_tags_lead_id ON lead_tags(lead_id);

ALTER TABLE lead_tags ENABLE ROW LEVEL SECURITY;

-- Acesso via lead (que já pertence ao user)
CREATE POLICY "Usuário gerencia tags de seus leads"
  ON lead_tags FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM leads
      WHERE leads.id = lead_tags.lead_id
        AND leads.user_id = auth.uid()
    )
  );

CREATE TABLE custom_fields (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  name            text NOT NULL,
  field_key       text NOT NULL, -- chave usada no jsonb custom_fields da tabela leads
  type            text NOT NULL
                    CHECK (type IN ('text','textarea','number','currency','date','datetime',
                                    'select','multiselect','checkbox','url','cpf','cnpj','cep','file')),

  -- Para tipos select e multiselect: [{"value": "opcao1", "label": "Opção 1"}]
  options         jsonb DEFAULT '[]'::jsonb,

  is_required     boolean NOT NULL DEFAULT false,
  order_position  int NOT NULL DEFAULT 0,

  created_at      timestamptz NOT NULL DEFAULT NOW(),

  UNIQUE(user_id, field_key)
);

CREATE INDEX idx_custom_fields_user_id ON custom_fields(user_id);

ALTER TABLE custom_fields ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia seus campos customizados"
  ON custom_fields FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE flows (
  id                          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                     uuid REFERENCES profiles(id) ON DELETE CASCADE,

  name                        text NOT NULL,
  description                 text,
  category                    text,

  -- Estrutura completa do fluxo visual (nodes + edges do ReactFlow)
  flow_data                   jsonb NOT NULL DEFAULT '{"nodes": [], "edges": []}'::jsonb,

  trigger_type                text NOT NULL DEFAULT 'manual'
                                CHECK (trigger_type IN ('new_message','comment','story_reply',
                                                        'keyword','scheduled','webhook','manual')),
  -- Configuração do trigger
  -- Ex para keyword: {"keywords": ["oi", "olá"], "match_type": "contains"}
  -- Ex para scheduled: {"cron": "0 9 * * 1", "timezone": "America/Sao_Paulo"}
  trigger_config              jsonb NOT NULL DEFAULT '{}'::jsonb,

  is_active                   boolean NOT NULL DEFAULT false,

  -- Template
  is_template                 boolean NOT NULL DEFAULT false,
  template_category           text,
  template_description        text,

  -- Métricas
  total_executions            int NOT NULL DEFAULT 0,
  completion_rate             numeric(5,2) NOT NULL DEFAULT 0, -- percentual 0-100
  avg_completion_time_seconds int NOT NULL DEFAULT 0,

  -- Versionamento
  version                     int NOT NULL DEFAULT 1,
  parent_flow_id              uuid REFERENCES flows(id) ON DELETE SET NULL,

  created_at                  timestamptz NOT NULL DEFAULT NOW(),
  updated_at                  timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_flows_user_id ON flows(user_id);
CREATE INDEX idx_flows_trigger_type ON flows(user_id, trigger_type);
CREATE INDEX idx_flows_is_active ON flows(user_id, is_active);
CREATE INDEX idx_flows_is_template ON flows(is_template);

CREATE TRIGGER trg_flows_updated_at
  BEFORE UPDATE ON flows
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE flows ENABLE ROW LEVEL SECURITY;

-- Fluxos do usuário + templates do sistema (user_id null)
CREATE POLICY "Usuário vê seus fluxos e templates do sistema"
  ON flows FOR SELECT
  USING (auth.uid() = user_id OR (is_template = true AND user_id IS NULL));

CREATE POLICY "Usuário gerencia seus fluxos"
  ON flows FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuário atualiza seus fluxos"
  ON flows FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Usuário remove seus fluxos"
  ON flows FOR DELETE
  USING (auth.uid() = user_id);

CREATE TABLE flow_executions (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  flow_id          uuid NOT NULL REFERENCES flows(id) ON DELETE CASCADE,
  user_id          uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lead_id          uuid REFERENCES leads(id) ON DELETE SET NULL,
  conversation_id  uuid, -- FK adicionada após criar tabela conversations

  started_at       timestamptz NOT NULL DEFAULT NOW(),
  completed_at     timestamptz,

  status           text NOT NULL DEFAULT 'running'
                     CHECK (status IN ('running','completed','failed','abandoned')),
  current_node_id  text, -- ID do node atual no ReactFlow

  -- Estado completo da execução (variáveis, histórico de nodes)
  execution_data   jsonb NOT NULL DEFAULT '{}'::jsonb,
  error_message    text
);

CREATE INDEX idx_flow_executions_flow_id ON flow_executions(flow_id);
CREATE INDEX idx_flow_executions_user_id ON flow_executions(user_id);
CREATE INDEX idx_flow_executions_lead_id ON flow_executions(lead_id);
CREATE INDEX idx_flow_executions_status ON flow_executions(status);
CREATE INDEX idx_flow_executions_started_at ON flow_executions(user_id, started_at DESC);

ALTER TABLE flow_executions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário acessa execuções de seus fluxos"
  ON flow_executions FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE keywords (
  id                        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                   uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  instagram_account_id      uuid REFERENCES instagram_accounts(id) ON DELETE CASCADE,

  name                      text NOT NULL,
  keywords                  jsonb NOT NULL DEFAULT '[]'::jsonb, -- ["oi", "olá", "bom dia"]

  match_type                text NOT NULL DEFAULT 'contains'
                              CHECK (match_type IN ('exact','contains','starts_with','ends_with','regex')),
  is_case_sensitive         boolean NOT NULL DEFAULT false,

  -- Onde aplicar
  apply_to_dm               boolean NOT NULL DEFAULT true,
  apply_to_comments         boolean NOT NULL DEFAULT false,
  apply_to_story_replies    boolean NOT NULL DEFAULT false,

  -- Resposta
  response_type             text NOT NULL DEFAULT 'message'
                              CHECK (response_type IN ('message','trigger_flow','call_agent','webhook','none')),
  response_message          text,
  response_media_url        text,
  response_buttons          jsonb DEFAULT '[]'::jsonb, -- botões de resposta rápida

  -- Ações encadeadas
  flow_id                   uuid REFERENCES flows(id) ON DELETE SET NULL,
  agent_id                  uuid REFERENCES agents(id) ON DELETE SET NULL,
  add_tag_ids               jsonb DEFAULT '[]'::jsonb, -- tags a adicionar automaticamente
  move_to_stage_id          uuid REFERENCES pipeline_stages(id) ON DELETE SET NULL,

  notify_team               boolean NOT NULL DEFAULT false,
  webhook_url               text,

  priority                  int NOT NULL DEFAULT 0, -- maior = verifica primeiro
  apply_only_to_new_leads   boolean NOT NULL DEFAULT false,
  apply_only_with_tag_ids   jsonb DEFAULT '[]'::jsonb, -- ativar apenas se lead tiver essas tags
  max_uses_per_lead         int, -- null = ilimitado

  -- Horário de ativação: {"start": "09:00", "end": "18:00", "days": [1,2,3,4,5]}
  active_hours              jsonb,

  is_active                 boolean NOT NULL DEFAULT true,

  -- Métricas
  total_triggers            int NOT NULL DEFAULT 0,
  conversion_rate           numeric(5,2) NOT NULL DEFAULT 0,

  created_at                timestamptz NOT NULL DEFAULT NOW(),
  updated_at                timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_keywords_user_id ON keywords(user_id);
CREATE INDEX idx_keywords_instagram_account_id ON keywords(instagram_account_id);
CREATE INDEX idx_keywords_is_active ON keywords(user_id, is_active);
CREATE INDEX idx_keywords_priority ON keywords(user_id, priority DESC);

CREATE TRIGGER trg_keywords_updated_at
  BEFORE UPDATE ON keywords
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE keywords ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia seus gatilhos de palavras-chave"
  ON keywords FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE conversations (
  id                      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                 uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lead_id                 uuid NOT NULL REFERENCES leads(id) ON DELETE CASCADE,
  instagram_account_id    uuid REFERENCES instagram_accounts(id) ON DELETE SET NULL,
  agent_id                uuid REFERENCES agents(id) ON DELETE SET NULL,
  flow_id                 uuid REFERENCES flows(id) ON DELETE SET NULL,

  started_at              timestamptz NOT NULL DEFAULT NOW(),
  ended_at                timestamptz,

  type                    text NOT NULL DEFAULT 'agent'
                            CHECK (type IN ('agent','flow','human','hybrid')),
  channel                 text NOT NULL DEFAULT 'dm'
                            CHECK (channel IN ('dm','comment','story_reply')),
  status                  text NOT NULL DEFAULT 'active'
                            CHECK (status IN ('active','resolved','transferred','abandoned')),

  -- Atendimento humano
  assigned_to             uuid REFERENCES profiles(id) ON DELETE SET NULL,
  transferred_to_human_at timestamptz,
  human_takeover_by       uuid REFERENCES profiles(id) ON DELETE SET NULL,

  -- Feedback
  satisfaction_score      int CHECK (satisfaction_score >= 1 AND satisfaction_score <= 5),
  resolution_notes        text,

  -- Métricas
  total_messages          int NOT NULL DEFAULT 0,
  avg_response_time_seconds int NOT NULL DEFAULT 0,
  duration_seconds        int NOT NULL DEFAULT 0,

  created_at              timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_conversations_user_id ON conversations(user_id);
CREATE INDEX idx_conversations_lead_id ON conversations(lead_id);
CREATE INDEX idx_conversations_status ON conversations(user_id, status);
CREATE INDEX idx_conversations_agent_id ON conversations(agent_id);
CREATE INDEX idx_conversations_started_at ON conversations(user_id, started_at DESC);

ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário acessa suas conversas"
  ON conversations FOR ALL
  USING (auth.uid() = user_id);

-- Adicionar FK de flow_executions para conversations
ALTER TABLE flow_executions
  ADD CONSTRAINT fk_flow_executions_conversation
  FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE SET NULL;

CREATE TABLE messages (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id       uuid NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  user_id               uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  lead_id               uuid NOT NULL REFERENCES leads(id) ON DELETE CASCADE,

  created_at            timestamptz NOT NULL DEFAULT NOW(),

  -- Remetente
  sender_type           text NOT NULL
                          CHECK (sender_type IN ('lead','agent','human','system')),
  sender_user_id        uuid REFERENCES profiles(id) ON DELETE SET NULL, -- preenchido quando human

  -- Conteúdo
  content               text,
  media_type            text NOT NULL DEFAULT 'text'
                          CHECK (media_type IN ('text','image','video','audio','file',
                                                'story_mention','story_reply')),
  media_url             text,

  -- Rastreamento Instagram
  instagram_message_id  text,

  -- Leitura
  is_read               boolean NOT NULL DEFAULT false,
  read_at               timestamptz,

  -- Metadados de IA
  ai_model_used         text, -- ex: gpt-4o
  ai_confidence         numeric(4,3), -- 0.000 - 1.000
  intent                text, -- intenção detectada: "compra", "suporte", "cancelamento"
  sentiment             text CHECK (sentiment IN ('positive','neutral','negative')),
  entities              jsonb DEFAULT '{}'::jsonb, -- entidades extraídas: {"produto": "camiseta azul"}
  tokens_used           int NOT NULL DEFAULT 0,

  -- Nota interna (não visível para o lead)
  is_internal_note      boolean NOT NULL DEFAULT false
);

CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_user_id ON messages(user_id);
CREATE INDEX idx_messages_lead_id ON messages(lead_id);
CREATE INDEX idx_messages_created_at ON messages(conversation_id, created_at DESC);
CREATE INDEX idx_messages_instagram_message_id ON messages(instagram_message_id);
CREATE INDEX idx_messages_is_read ON messages(user_id, is_read) WHERE is_read = false;

ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário acessa mensagens de suas conversas"
  ON messages FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE broadcasts (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  instagram_account_id  uuid NOT NULL REFERENCES instagram_accounts(id) ON DELETE CASCADE,

  name                  text NOT NULL,
  description           text,

  -- Segmentação
  target_type           text NOT NULL DEFAULT 'all'
                          CHECK (target_type IN ('all','segment','tags','custom','csv')),
  target_segment_id     uuid,
  target_tag_ids        jsonb DEFAULT '[]'::jsonb,
  target_custom_filter  jsonb DEFAULT '{}'::jsonb, -- filtro customizado
  exclude_filter        jsonb DEFAULT '{}'::jsonb,  -- leads a excluir

  -- Mensagem
  message_type          text NOT NULL DEFAULT 'text'
                          CHECK (message_type IN ('text','image','video','carousel')),
  message_content       text,
  message_media_url     text,
  message_buttons       jsonb DEFAULT '[]'::jsonb,
  message_variables     jsonb DEFAULT '{}'::jsonb, -- variáveis dinâmicas: {"nome": "{{lead.first_name}}"}

  -- Velocidade de envio
  send_speed            text NOT NULL DEFAULT 'normal'
                          CHECK (send_speed IN ('fast','normal','slow')),
  messages_per_minute   int NOT NULL DEFAULT 20,

  scheduled_at          timestamptz,
  sent_at               timestamptz,

  status                text NOT NULL DEFAULT 'draft'
                          CHECK (status IN ('draft','scheduled','sending','sent','paused','failed','canceled')),

  -- Métricas
  total_recipients      int NOT NULL DEFAULT 0,
  total_sent            int NOT NULL DEFAULT 0,
  total_delivered       int NOT NULL DEFAULT 0,
  total_read            int NOT NULL DEFAULT 0,
  total_replied         int NOT NULL DEFAULT 0,
  total_clicked         int NOT NULL DEFAULT 0,
  total_converted       int NOT NULL DEFAULT 0,
  total_revenue         numeric(12,2) NOT NULL DEFAULT 0,

  -- Teste A/B
  ab_test_enabled       boolean NOT NULL DEFAULT false,
  ab_test_config        jsonb DEFAULT '{}'::jsonb,

  created_at            timestamptz NOT NULL DEFAULT NOW(),
  updated_at            timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_broadcasts_user_id ON broadcasts(user_id);
CREATE INDEX idx_broadcasts_status ON broadcasts(user_id, status);
CREATE INDEX idx_broadcasts_scheduled_at ON broadcasts(scheduled_at) WHERE status = 'scheduled';

CREATE TRIGGER trg_broadcasts_updated_at
  BEFORE UPDATE ON broadcasts
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE broadcasts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia seus broadcasts"
  ON broadcasts FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE broadcast_recipients (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  broadcast_id  uuid NOT NULL REFERENCES broadcasts(id) ON DELETE CASCADE,
  lead_id       uuid NOT NULL REFERENCES leads(id) ON DELETE CASCADE,

  status        text NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending','sent','delivered','read','replied','failed')),

  sent_at       timestamptz,
  delivered_at  timestamptz,
  read_at       timestamptz,
  replied_at    timestamptz,
  error_message text,
  revenue       numeric(12,2) NOT NULL DEFAULT 0,

  UNIQUE(broadcast_id, lead_id)
);

CREATE INDEX idx_broadcast_recipients_broadcast_id ON broadcast_recipients(broadcast_id);
CREATE INDEX idx_broadcast_recipients_lead_id ON broadcast_recipients(lead_id);
CREATE INDEX idx_broadcast_recipients_status ON broadcast_recipients(broadcast_id, status);

ALTER TABLE broadcast_recipients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário acessa destinatários de seus broadcasts"
  ON broadcast_recipients FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM broadcasts
      WHERE broadcasts.id = broadcast_recipients.broadcast_id
        AND broadcasts.user_id = auth.uid()
    )
  );

CREATE TABLE segments (
  id                  uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id             uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  name                text NOT NULL,
  description         text,

  -- Filtros em formato AND/OR
  -- Ex: {"operator": "AND", "conditions": [{"field": "score", "op": "gte", "value": 70}]}
  filter_config       jsonb NOT NULL DEFAULT '{}'::jsonb,

  leads_count         int NOT NULL DEFAULT 0, -- cache recalculado periodicamente
  last_calculated_at  timestamptz,

  created_at          timestamptz NOT NULL DEFAULT NOW(),
  updated_at          timestamptz NOT NULL DEFAULT NOW()
);

-- Agora que segments existe, adicionar FK em broadcasts
ALTER TABLE broadcasts
  ADD CONSTRAINT fk_broadcasts_segment
  FOREIGN KEY (target_segment_id) REFERENCES segments(id) ON DELETE SET NULL;

CREATE INDEX idx_segments_user_id ON segments(user_id);

CREATE TRIGGER trg_segments_updated_at
  BEFORE UPDATE ON segments
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE segments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia seus segmentos"
  ON segments FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE team_members (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_user_id uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE, -- dono do workspace
  invited_email     text NOT NULL,
  invited_by        uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  role              text NOT NULL DEFAULT 'agent'
                      CHECK (role IN ('admin','manager','agent','viewer')),

  -- Permissões granulares
  -- Ex: {"leads": "write", "broadcasts": "read", "settings": "none"}
  permissions       jsonb NOT NULL DEFAULT '{}'::jsonb,

  status            text NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending','active','suspended')),

  invited_at        timestamptz NOT NULL DEFAULT NOW(),
  accepted_at       timestamptz,
  last_active_at    timestamptz,

  UNIQUE(workspace_user_id, invited_email)
);

CREATE INDEX idx_team_members_workspace_user_id ON team_members(workspace_user_id);
CREATE INDEX idx_team_members_invited_email ON team_members(invited_email);

ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia sua equipe"
  ON team_members FOR ALL
  USING (auth.uid() = workspace_user_id);

-- Membro convidado vê sua própria entrada
CREATE POLICY "Membro vê seu próprio convite"
  ON team_members FOR SELECT
  USING (
    invited_email = (SELECT email FROM profiles WHERE id = auth.uid())
  );

CREATE TABLE canned_responses (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_by  uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  title       text NOT NULL,
  content     text NOT NULL,
  shortcut    text, -- ex: /saudacao — ativa com /
  category    text,
  usage_count int NOT NULL DEFAULT 0,

  created_at  timestamptz NOT NULL DEFAULT NOW(),
  updated_at  timestamptz NOT NULL DEFAULT NOW(),

  UNIQUE(user_id, shortcut)
);

CREATE INDEX idx_canned_responses_user_id ON canned_responses(user_id);
CREATE INDEX idx_canned_responses_shortcut ON canned_responses(user_id, shortcut);

CREATE TRIGGER trg_canned_responses_updated_at
  BEFORE UPDATE ON canned_responses
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE canned_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia suas respostas salvas"
  ON canned_responses FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE post_schedules (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  instagram_account_id  uuid NOT NULL REFERENCES instagram_accounts(id) ON DELETE CASCADE,

  content               text,
  media_urls            jsonb NOT NULL DEFAULT '[]'::jsonb, -- até 10 imagens/vídeo
  caption_generated_by_ai boolean NOT NULL DEFAULT false,

  scheduled_at          timestamptz NOT NULL,
  published_at          timestamptz,

  status                text NOT NULL DEFAULT 'draft'
                          CHECK (status IN ('draft','scheduled','published','failed')),
  instagram_post_id     text, -- ID do post publicado no Instagram

  -- Automações pós-publicação
  linked_flow_id        uuid REFERENCES flows(id) ON DELETE SET NULL,
  linked_keyword        text, -- palavra-chave ativada ao comentar no post
  automation_config     jsonb DEFAULT '{}'::jsonb,

  created_at            timestamptz NOT NULL DEFAULT NOW(),
  updated_at            timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_post_schedules_user_id ON post_schedules(user_id);
CREATE INDEX idx_post_schedules_scheduled_at ON post_schedules(scheduled_at) WHERE status = 'scheduled';

CREATE TRIGGER trg_post_schedules_updated_at
  BEFORE UPDATE ON post_schedules
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE post_schedules ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia seus posts agendados"
  ON post_schedules FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE integrations (
  id                    uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  type                  text NOT NULL
                          CHECK (type IN ('zapier','make','webhook','google_drive','stripe',
                                          'shopify','woocommerce','nuvemshop')),
  name                  text NOT NULL,
  config                jsonb NOT NULL DEFAULT '{}'::jsonb,
  credentials_encrypted text, -- JSON criptografado com pgcrypto

  is_active             boolean NOT NULL DEFAULT true,
  last_sync_at          timestamptz,
  sync_status           text DEFAULT 'ok' CHECK (sync_status IN ('ok','error','syncing')),
  error_message         text,

  -- Métricas
  total_calls           int NOT NULL DEFAULT 0,
  successful_calls      int NOT NULL DEFAULT 0,
  failed_calls          int NOT NULL DEFAULT 0,

  created_at            timestamptz NOT NULL DEFAULT NOW(),
  updated_at            timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_integrations_user_id ON integrations(user_id);
CREATE INDEX idx_integrations_type ON integrations(user_id, type);

CREATE TRIGGER trg_integrations_updated_at
  BEFORE UPDATE ON integrations
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE integrations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia suas integrações"
  ON integrations FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE webhooks (
  id                uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  name              text NOT NULL,
  url               text NOT NULL,
  secret            text, -- HMAC secret para verificação de assinatura
  events            jsonb NOT NULL DEFAULT '[]'::jsonb, -- ["lead.created", "message.received"]

  is_active         boolean NOT NULL DEFAULT true,
  retry_count       int NOT NULL DEFAULT 3, -- tentativas máximas em caso de falha

  -- Métricas
  total_sent        int NOT NULL DEFAULT 0,
  total_failed      int NOT NULL DEFAULT 0,
  last_triggered_at timestamptz,

  created_at        timestamptz NOT NULL DEFAULT NOW(),
  updated_at        timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_webhooks_user_id ON webhooks(user_id);
CREATE INDEX idx_webhooks_is_active ON webhooks(user_id, is_active);

CREATE TRIGGER trg_webhooks_updated_at
  BEFORE UPDATE ON webhooks
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE webhooks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário gerencia seus webhooks"
  ON webhooks FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE webhook_deliveries (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  webhook_id      uuid NOT NULL REFERENCES webhooks(id) ON DELETE CASCADE,

  event_type      text NOT NULL,
  payload         jsonb NOT NULL DEFAULT '{}'::jsonb,
  response_status int,  -- HTTP status recebido
  response_body   text,

  attempt_number  int NOT NULL DEFAULT 1,
  delivered_at    timestamptz NOT NULL DEFAULT NOW(),
  error_message   text
);

CREATE INDEX idx_webhook_deliveries_webhook_id ON webhook_deliveries(webhook_id);
CREATE INDEX idx_webhook_deliveries_delivered_at ON webhook_deliveries(webhook_id, delivered_at DESC);

ALTER TABLE webhook_deliveries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário acessa entregas de seus webhooks"
  ON webhook_deliveries FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM webhooks
      WHERE webhooks.id = webhook_deliveries.webhook_id
        AND webhooks.user_id = auth.uid()
    )
  );

-- Tabela de eventos para analytics (append-only)
CREATE TABLE analytics_events (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at      timestamptz NOT NULL DEFAULT NOW(),

  -- Classificação do evento
  event_type      text NOT NULL, -- ex: "conversation", "lead", "broadcast", "flow"
  event_name      text NOT NULL, -- ex: "started", "created", "sent", "completed"

  -- Contexto (nulls para eventos não relacionados)
  lead_id         uuid REFERENCES leads(id) ON DELETE SET NULL,
  conversation_id uuid REFERENCES conversations(id) ON DELETE SET NULL,
  flow_id         uuid REFERENCES flows(id) ON DELETE SET NULL,
  broadcast_id    uuid REFERENCES broadcasts(id) ON DELETE SET NULL,
  keyword_id      uuid REFERENCES keywords(id) ON DELETE SET NULL,
  agent_id        uuid REFERENCES agents(id) ON DELETE SET NULL,

  -- Dados do evento
  event_data      jsonb NOT NULL DEFAULT '{}'::jsonb,
  revenue         numeric(12,2) NOT NULL DEFAULT 0,
  session_id      text -- agrupador de sessão de usuário
);

-- Particionamento por mês seria ideal em produção
-- Por ora, índices para queries de analytics
CREATE INDEX idx_analytics_events_user_id ON analytics_events(user_id, created_at DESC);
CREATE INDEX idx_analytics_events_type ON analytics_events(user_id, event_type, created_at DESC);
CREATE INDEX idx_analytics_events_lead_id ON analytics_events(lead_id) WHERE lead_id IS NOT NULL;
CREATE INDEX idx_analytics_events_created_at ON analytics_events(created_at DESC);

ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário acessa seus eventos de analytics"
  ON analytics_events FOR ALL
  USING (auth.uid() = user_id);

-- Conquistas disponíveis na plataforma (gerenciadas pelo admin)
CREATE TABLE gamification_achievements (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name            text NOT NULL,
  description     text NOT NULL,
  icon            text NOT NULL, -- emoji ou nome do ícone
  category        text NOT NULL, -- "leads", "conversations", "broadcasts", "flows", "general"

  condition_type  text NOT NULL, -- "leads_created", "messages_sent", "broadcasts_sent", etc.
  condition_value int NOT NULL,  -- valor para desbloquear (ex: 10 leads)

  reward_type     text NOT NULL DEFAULT 'xp' CHECK (reward_type IN ('xp','badge','feature_unlock')),
  reward_value    int NOT NULL DEFAULT 100, -- XP ganho

  created_at      timestamptz NOT NULL DEFAULT NOW()
);

ALTER TABLE gamification_achievements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Conquistas visíveis para todos os usuários"
  ON gamification_achievements FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE TABLE user_achievements (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  achievement_id  uuid NOT NULL REFERENCES gamification_achievements(id) ON DELETE CASCADE,

  unlocked_at     timestamptz NOT NULL DEFAULT NOW(),
  notified        boolean NOT NULL DEFAULT false,

  UNIQUE(user_id, achievement_id)
);

CREATE INDEX idx_user_achievements_user_id ON user_achievements(user_id);

ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário vê suas conquistas"
  ON user_achievements FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE user_xp (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  total_xp      int NOT NULL DEFAULT 0,
  current_level int NOT NULL DEFAULT 1,
  created_at    timestamptz NOT NULL DEFAULT NOW(),
  updated_at    timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_user_xp_user_id ON user_xp(user_id);
CREATE INDEX idx_user_xp_total_xp ON user_xp(total_xp DESC); -- ranking

CREATE TRIGGER trg_user_xp_updated_at
  BEFORE UPDATE ON user_xp
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE user_xp ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário vê e atualiza seu próprio XP"
  ON user_xp FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE xp_events (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  xp_amount   int NOT NULL,
  reason      text NOT NULL, -- ex: "Primeira conversa iniciada", "10 leads cadastrados"
  created_at  timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_xp_events_user_id ON xp_events(user_id, created_at DESC);

ALTER TABLE xp_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário vê seu histórico de XP"
  ON xp_events FOR ALL
  USING (auth.uid() = user_id);

CREATE TABLE notifications (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  type        text NOT NULL, -- "lead_assigned", "broadcast_completed", "achievement_unlocked", etc.
  title       text NOT NULL,
  message     text NOT NULL,
  data        jsonb DEFAULT '{}'::jsonb, -- dados extras para deep link

  is_read     boolean NOT NULL DEFAULT false,
  read_at     timestamptz,

  created_at  timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notifications_user_id ON notifications(user_id, created_at DESC);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read) WHERE is_read = false;

ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Usuário vê suas notificações"
  ON notifications FOR ALL
  USING (auth.uid() = user_id);

-- Logs de auditoria para compliance com LGPD
-- Registro imutável de ações sensíveis
CREATE TABLE audit_logs (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,

  action        text NOT NULL, -- "lead.deleted", "data.exported", "settings.changed"
  resource_type text NOT NULL, -- "lead", "conversation", "profile"
  resource_id   uuid,

  old_data      jsonb, -- estado anterior (para updates/deletes)
  new_data      jsonb, -- novo estado (para creates/updates)

  ip_address    inet,
  user_agent    text,

  created_at    timestamptz NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id, created_at DESC);
CREATE INDEX idx_audit_logs_resource ON audit_logs(resource_type, resource_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action, created_at DESC);

ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- Usuário pode ler seus próprios logs mas não deletar (imutabilidade)
CREATE POLICY "Usuário lê seus logs de auditoria"
  ON audit_logs FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Sistema insere logs de auditoria"
  ON audit_logs FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email),
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

CREATE OR REPLACE FUNCTION activate_trial_on_profile()
RETURNS TRIGGER AS $$
BEGIN
  -- Ativa trial de 7 dias ao criar o perfil
  NEW.trial_started_at = NOW();
  NEW.trial_ends_at = NOW() + INTERVAL '7 days';
  NEW.plan = 'trial';
  NEW.plan_status = 'active';

  -- Cria registro de XP inicial
  INSERT INTO user_xp (user_id, total_xp, current_level)
  VALUES (NEW.id, 0, 1)
  ON CONFLICT (user_id) DO NOTHING;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER trg_activate_trial
  BEFORE INSERT ON profiles
  FOR EACH ROW EXECUTE FUNCTION activate_trial_on_profile();

CREATE OR REPLACE FUNCTION calculate_initial_lead_score()
RETURNS TRIGGER AS $$
DECLARE
  v_score int := 0;
BEGIN
  -- Pontuação base por origem
  CASE NEW.source
    WHEN 'instagram_dm'   THEN v_score := v_score + 20;
    WHEN 'story_reply'    THEN v_score := v_score + 15;
    WHEN 'comment'        THEN v_score := v_score + 10;
    WHEN 'manual'         THEN v_score := v_score + 5;
    ELSE v_score := v_score + 0;
  END CASE;

  -- Bônus por dados de contato preenchidos
  IF NEW.email IS NOT NULL THEN v_score := v_score + 10; END IF;
  IF NEW.phone IS NOT NULL THEN v_score := v_score + 10; END IF;
  IF NEW.full_name IS NOT NULL THEN v_score := v_score + 5; END IF;

  -- Bônus por conta verificada no Instagram
  IF NEW.is_verified THEN v_score := v_score + 15; END IF;

  -- Bônus por seguidores
  IF NEW.follower_count > 10000 THEN v_score := v_score + 10;
  ELSIF NEW.follower_count > 1000 THEN v_score := v_score + 5;
  END IF;

  NEW.score := LEAST(v_score, 100);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_lead_initial_score
  BEFORE INSERT ON leads
  FOR EACH ROW EXECUTE FUNCTION calculate_initial_lead_score();

CREATE OR REPLACE FUNCTION update_conversation_on_message()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE conversations
  SET
    total_messages = total_messages + 1,
    -- Atualiza preview na tabela leads
    ended_at = CASE
      WHEN status = 'active' THEN NULL
      ELSE ended_at
    END
  WHERE id = NEW.conversation_id;

  -- Atualiza last_message_preview e last_interaction_at no lead
  UPDATE leads
  SET
    last_message_preview = LEFT(NEW.content, 150),
    last_interaction_at = NEW.created_at,
    interaction_count = interaction_count + 1
  WHERE id = NEW.lead_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_message_update_conversation
  AFTER INSERT ON messages
  FOR EACH ROW EXECUTE FUNCTION update_conversation_on_message();

CREATE OR REPLACE FUNCTION update_tag_leads_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE tags SET leads_count = leads_count + 1 WHERE id = NEW.tag_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE tags SET leads_count = GREATEST(leads_count - 1, 0) WHERE id = OLD.tag_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_lead_tags_count
  AFTER INSERT OR DELETE ON lead_tags
  FOR EACH ROW EXECUTE FUNCTION update_tag_leads_count();

CREATE OR REPLACE FUNCTION is_subscription_active(user_uuid uuid)
RETURNS boolean AS $$
DECLARE
  v_plan        text;
  v_plan_status text;
  v_trial_ends  timestamptz;
BEGIN
  SELECT plan, plan_status, trial_ends_at
  INTO v_plan, v_plan_status, v_trial_ends
  FROM profiles
  WHERE id = user_uuid;

  IF NOT FOUND THEN
    RETURN false;
  END IF;

  -- Trial ativo
  IF v_plan = 'trial' AND v_plan_status = 'active' AND v_trial_ends > NOW() THEN
    RETURN true;
  END IF;

  -- Plano pago ativo
  IF v_plan != 'trial' AND v_plan_status = 'active' THEN
    RETURN true;
  END IF;

  RETURN false;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION search_knowledge_base(
  user_uuid           uuid,
  agent_uuid          uuid,
  query_embedding     vector(1536),
  similarity_threshold float DEFAULT 0.7,
  match_count         int DEFAULT 5
)
RETURNS TABLE(
  chunk_id          uuid,
  knowledge_base_id uuid,
  content           text,
  similarity        float,
  metadata          jsonb
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    kc.id                                       AS chunk_id,
    kc.knowledge_base_id,
    kc.content,
    1 - (kc.embedding <=> query_embedding)      AS similarity,
    kc.metadata
  FROM knowledge_chunks kc
  JOIN knowledge_base kb ON kb.id = kc.knowledge_base_id
  WHERE
    kc.user_id = user_uuid
    AND kb.is_active = true
    AND (
      -- Inclui knowledge bases globais do usuário ou específicas do agente
      kb.agent_id IS NULL
      OR kb.agent_id = agent_uuid
    )
    AND 1 - (kc.embedding <=> query_embedding) >= similarity_threshold
  ORDER BY kc.embedding <=> query_embedding ASC
  LIMIT match_count;
END;
$$ LANGUAGE plpgsql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION calculate_lead_score(lead_uuid uuid)
RETURNS int AS $$
DECLARE
  v_lead        leads%ROWTYPE;
  v_score       int := 0;
  v_msg_count   int;
  v_conv_count  int;
BEGIN
  SELECT * INTO v_lead FROM leads WHERE id = lead_uuid;

  IF NOT FOUND THEN
    RETURN 0;
  END IF;

  -- Pontuação base por origem
  CASE v_lead.source
    WHEN 'instagram_dm'   THEN v_score := v_score + 20;
    WHEN 'story_reply'    THEN v_score := v_score + 15;
    WHEN 'comment'        THEN v_score := v_score + 10;
    WHEN 'manual'         THEN v_score := v_score + 5;
    ELSE NULL;
  END CASE;

  -- Dados de contato
  IF v_lead.email IS NOT NULL    THEN v_score := v_score + 10; END IF;
  IF v_lead.phone IS NOT NULL    THEN v_score := v_score + 10; END IF;
  IF v_lead.full_name IS NOT NULL THEN v_score := v_score + 5; END IF;

  -- Conta verificada
  IF v_lead.is_verified THEN v_score := v_score + 15; END IF;

  -- Seguidores
  IF v_lead.follower_count > 10000 THEN v_score := v_score + 10;
  ELSIF v_lead.follower_count > 1000 THEN v_score := v_score + 5;
  END IF;

  -- Engajamento: número de conversas
  SELECT COUNT(*) INTO v_conv_count
  FROM conversations WHERE lead_id = lead_uuid;

  IF v_conv_count >= 5  THEN v_score := v_score + 15;
  ELSIF v_conv_count >= 2 THEN v_score := v_score + 8;
  ELSIF v_conv_count >= 1 THEN v_score := v_score + 3;
  END IF;

  -- Bônus por ser cliente
  IF v_lead.is_customer THEN v_score := v_score + 20; END IF;

  -- Bônus por deal value preenchido
  IF v_lead.deal_value IS NOT NULL AND v_lead.deal_value > 0 THEN
    v_score := v_score + 10;
  END IF;

  -- Interação recente (últimas 48h)
  IF v_lead.last_interaction_at > NOW() - INTERVAL '48 hours' THEN
    v_score := v_score + 10;
  END IF;

  v_score := LEAST(v_score, 100);

  -- Atualiza o score na tabela
  UPDATE leads SET score = v_score WHERE id = lead_uuid;

  RETURN v_score;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION add_user_xp(
  user_uuid   uuid,
  xp_amount   int,
  reason      text
)
RETURNS void AS $$
DECLARE
  v_total_xp    int;
  v_new_level   int;
BEGIN
  -- Registra o evento de XP
  INSERT INTO xp_events (user_id, xp_amount, reason)
  VALUES (user_uuid, xp_amount, reason);

  -- Atualiza total
  UPDATE user_xp
  SET total_xp = total_xp + xp_amount
  WHERE user_id = user_uuid
  RETURNING total_xp INTO v_total_xp;

  IF NOT FOUND THEN
    INSERT INTO user_xp (user_id, total_xp) VALUES (user_uuid, xp_amount)
    RETURNING total_xp INTO v_total_xp;
  END IF;

  -- Calcula nível (100 XP por nível, escala linear simples)
  v_new_level := GREATEST(1, FLOOR(v_total_xp / 100)::int + 1);

  UPDATE user_xp
  SET current_level = v_new_level
  WHERE user_id = user_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Os buckets são criados via API do Supabase ou dashboard
-- Documentação de configuração equivalente:

-- bucket: knowledge-base
-- Privado (requer auth), max 50MB por arquivo
-- Tipos permitidos: application/pdf, text/plain, text/csv,
--   application/vnd.openxmlformats-officedocument.*
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'knowledge-base', 'knowledge-base', false,
  52428800, -- 50MB em bytes
  ARRAY['application/pdf','text/plain','text/csv',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']
);

-- bucket: avatars
-- Público, max 2MB, apenas imagens
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'avatars', 'avatars', true,
  2097152, -- 2MB em bytes
  ARRAY['image/jpeg','image/png','image/webp','image/gif']
);

-- bucket: broadcast-media
-- Privado, max 100MB, imagens e vídeos
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'broadcast-media', 'broadcast-media', false,
  104857600, -- 100MB em bytes
  ARRAY['image/jpeg','image/png','image/webp','video/mp4','video/quicktime']
);

-- bucket: post-media
-- Privado, max 100MB, imagens e vídeos
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'post-media', 'post-media', false,
  104857600,
  ARRAY['image/jpeg','image/png','image/webp','video/mp4','video/quicktime']
);

-- Policies de storage
CREATE POLICY "Usuário faz upload na sua pasta"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id IN ('knowledge-base', 'broadcast-media', 'post-media')
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Usuário acessa seus próprios arquivos"
  ON storage.objects FOR SELECT
  USING (
    bucket_id IN ('knowledge-base', 'broadcast-media', 'post-media')
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

CREATE POLICY "Avatares são públicos"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

CREATE POLICY "Usuário faz upload do próprio avatar"
  ON storage.objects FOR INSERT
  WITH CHECK (
    bucket_id = 'avatars'
    AND auth.uid()::text = (storage.foldername(name))[1]
  );

INSERT INTO ai_models (provider, model_id, display_name, description, min_plan, cost_per_1k_input_tokens, cost_per_1k_output_tokens, max_tokens, supports_vision, capabilities) VALUES
-- OpenAI
('openai', 'gpt-4o',                'GPT-4o',              'Modelo mais avançado da OpenAI, multimodal',        'pro',      0.005000, 0.015000, 4096,  true,  '{"json_mode": true, "function_calling": true}'),
('openai', 'gpt-4o-mini',           'GPT-4o Mini',         'Versão econômica do GPT-4o, ótimo custo-benefício', 'starter',  0.000150, 0.000600, 4096,  true,  '{"json_mode": true, "function_calling": true}'),
('openai', 'gpt-4-turbo',           'GPT-4 Turbo',         'GPT-4 com contexto longo de 128k tokens',           'business', 0.010000, 0.030000, 4096,  true,  '{"json_mode": true, "function_calling": true}'),
('openai', 'gpt-3.5-turbo',         'GPT-3.5 Turbo',       'Rápido e econômico para casos simples',             'starter',  0.000500, 0.001500, 4096,  false, '{"json_mode": true, "function_calling": true}'),

-- Anthropic
('anthropic', 'claude-3-5-sonnet-20241022', 'Claude 3.5 Sonnet', 'Melhor equilíbrio inteligência/velocidade',   'pro',      0.003000, 0.015000, 8192,  true,  '{"streaming": true}'),
('anthropic', 'claude-3-haiku-20240307',    'Claude 3 Haiku',    'Mais rápido e econômico da família Claude',   'starter',  0.000250, 0.001250, 4096,  true,  '{"streaming": true}'),
('anthropic', 'claude-3-opus-20240229',     'Claude 3 Opus',     'Mais poderoso da Anthropic, para tarefas complexas', 'enterprise', 0.015000, 0.075000, 4096, true, '{"streaming": true}'),

-- Google
('google', 'gemini-1.5-pro',   'Gemini 1.5 Pro',   'Contexto de 2M tokens, multimodal avançado',    'business', 0.003500, 0.010500, 8192, true, '{"long_context": true}'),
('google', 'gemini-1.5-flash', 'Gemini 1.5 Flash', 'Ultra-rápido com contexto longo',               'starter',  0.000350, 0.001050, 8192, true, '{"long_context": true}'),
('google', 'gemini-1.0-pro',   'Gemini 1.0 Pro',   'Modelo base estável do Google',                 'starter',  0.000500, 0.001500, 2048, false, '{}');

-- Executado via Edge Function on_profile_created
-- Aqui como referência do seed que deve ser criado por usuário:
/*
INSERT INTO pipeline_stages (user_id, name, color, order_position, is_won_stage, is_lost_stage) VALUES
  (NEW.id, 'Novo Lead',    '#6366f1', 1, false, false),
  (NEW.id, 'Em Contato',   '#f59e0b', 2, false, false),
  (NEW.id, 'Negociação',   '#3b82f6', 3, false, false),
  (NEW.id, 'Proposta',     '#8b5cf6', 4, false, false),
  (NEW.id, 'Fechado',      '#10b981', 5, true,  false),
  (NEW.id, 'Perdido',      '#ef4444', 6, false, true);
*/

INSERT INTO prompt_templates (name, description, category, is_system, prompt_content, variables, preview_message) VALUES

-- E-commerce
('Boas-vindas Loja Virtual', 'Mensagem de boas-vindas para novos clientes de loja virtual', 'ecommerce', true,
'Olá {{nome}}! Bem-vindo(a) à {{loja}}! 🛍️

Sou {{agente}}, seu assistente virtual. Estou aqui para te ajudar a encontrar os produtos perfeitos, tirar dúvidas sobre pedidos e garantir que sua experiência seja incrível!

Como posso te ajudar hoje?',
'[{"key": "nome", "label": "Nome do Lead", "type": "text"}, {"key": "loja", "label": "Nome da Loja", "type": "text"}, {"key": "agente", "label": "Nome do Agente", "type": "text"}]',
'Olá Maria! Bem-vindo(a) à ModaExpress! Sou Luna, seu assistente virtual.'),

('Recuperação de Carrinho', 'Mensagem para leads que demonstraram interesse mas não compraram', 'ecommerce', true,
'Oi {{nome}}! Vi que você estava olhando {{produto}} no nosso Instagram. 👀

Ainda está interessado(a)? Posso te dar mais detalhes sobre o produto ou condições especiais de pagamento!

O que você gostaria de saber?',
'[{"key": "nome", "label": "Nome do Lead", "type": "text"}, {"key": "produto", "label": "Produto de Interesse", "type": "text"}]',
'Oi João! Vi que você estava olhando nosso Tênis Air Max no Instagram.'),

('Confirmação de Pedido', 'Confirmação automática após compra', 'ecommerce', true,
'Oi {{nome}}! Seu pedido #{{numero_pedido}} foi confirmado! ✅

📦 Produto: {{produto}}
💰 Valor: R$ {{valor}}
🚚 Previsão de entrega: {{prazo}}

Qualquer dúvida é só chamar aqui! Obrigado pela confiança. 🙏',
'[{"key": "nome", "label": "Nome"}, {"key": "numero_pedido", "label": "Número do Pedido"}, {"key": "produto", "label": "Produto"}, {"key": "valor", "label": "Valor"}, {"key": "prazo", "label": "Prazo de Entrega"}]',
'Oi Ana! Seu pedido #12345 foi confirmado!'),

-- Saúde e Beleza
('Agendamento de Consulta', 'Para clínicas e profissionais de saúde', 'health', true,
'Olá {{nome}}! Tudo bem? 😊

Sou {{agente}} da {{clinica}}. Vi seu interesse em agendar uma consulta!

Temos horários disponíveis:
📅 {{horario1}}
📅 {{horario2}}
📅 {{horario3}}

Qual horário fica melhor para você?',
'[{"key": "nome", "label": "Nome"}, {"key": "agente", "label": "Agente"}, {"key": "clinica", "label": "Clínica"}, {"key": "horario1", "label": "Horário 1"}, {"key": "horario2", "label": "Horário 2"}, {"key": "horario3", "label": "Horário 3"}]',
'Olá Carla! Temos horários disponíveis na segunda, quarta e sexta!'),

('Resultado de Exame', 'Notificação de resultado disponível', 'health', true,
'Oi {{nome}}! Seu resultado de {{exame}} já está disponível! 🔬

Você pode acessar pelo nosso portal ou vir buscar na clínica.

Deseja agendar uma consulta de retorno para discutir os resultados com o Dr(a). {{medico}}?',
'[{"key": "nome", "label": "Nome"}, {"key": "exame", "label": "Tipo de Exame"}, {"key": "medico", "label": "Nome do Médico"}]',
'Oi Roberto! Seu resultado de hemograma já está disponível!'),

-- Imobiliário
('Apresentação de Imóvel', 'Para corretores e imobiliárias', 'realestate', true,
'Olá {{nome}}! Obrigado pelo seu interesse! 🏠

Vi que você curtiu o imóvel em {{endereco}}. Tenho informações exclusivas para compartilhar:

✅ {{quartos}} quartos | {{banheiros}} banheiros
✅ {{area}}m² de área total
✅ {{diferenciais}}
💰 Valor: R$ {{valor}}

Posso agendar uma visita para você? Quando seria melhor?',
'[{"key": "nome", "label": "Nome"}, {"key": "endereco", "label": "Endereço"}, {"key": "quartos", "label": "Quartos"}, {"key": "banheiros", "label": "Banheiros"}, {"key": "area", "label": "Área"}, {"key": "diferenciais", "label": "Diferenciais"}, {"key": "valor", "label": "Valor"}]',
'Olá Pedro! Vi que você curtiu o imóvel na Rua das Flores, 123!'),

-- Educação
('Matrícula Aberta', 'Para escolas, cursos e instituições de ensino', 'education', true,
'Oi {{nome}}! As matrículas para {{curso}} estão abertas! 🎓

📚 Início das aulas: {{inicio}}
⏰ Horário: {{horario}}
📍 Modalidade: {{modalidade}}
💰 Investimento: R$ {{valor}}

Temos condições especiais para os primeiros inscritos! Quer garantir sua vaga?',
'[{"key": "nome", "label": "Nome"}, {"key": "curso", "label": "Nome do Curso"}, {"key": "inicio", "label": "Data de Início"}, {"key": "horario", "label": "Horário"}, {"key": "modalidade", "label": "Presencial/Online"}, {"key": "valor", "label": "Valor"}]',
'Oi Fernanda! As matrículas para o Curso de Marketing Digital estão abertas!'),

-- Delivery
('Pedido Recebido', 'Confirmação de pedido para delivery e restaurantes', 'delivery', true,
'Oi {{nome}}! Recebemos seu pedido! 🍕

🛵 Número do pedido: #{{numero}}
⏱️ Tempo estimado: {{tempo}} minutos
📍 Entrega em: {{endereco}}

Você pode acompanhar seu pedido aqui no chat. Bom apetite! 😋',
'[{"key": "nome", "label": "Nome"}, {"key": "numero", "label": "Número do Pedido"}, {"key": "tempo", "label": "Tempo Estimado"}, {"key": "endereco", "label": "Endereço"}]',
'Oi Lucas! Recebemos seu pedido! #4521 - 35 minutos estimados.'),

-- Serviços Gerais
('Orçamento Solicitado', 'Para prestadores de serviços em geral', 'services', true,
'Olá {{nome}}! Recebi seu pedido de orçamento para {{servico}}.

Vou precisar de algumas informações para te passar o melhor preço:

1. Qual o tamanho/escopo do serviço?
2. Qual a localização?
3. Tem data preferencial para realização?

Me conta mais detalhes! 😊',
'[{"key": "nome", "label": "Nome"}, {"key": "servico", "label": "Tipo de Serviço"}]',
'Olá Mariana! Recebi seu pedido de orçamento para limpeza de estofado.'),

-- Beleza
('Agendamento Salão', 'Para salões de beleza, barbearias e estúdios', 'beauty', true,
'Oi {{nome}}! Bem-vind@ ao {{salao}}! 💇

Adorei que você nos encontrou! Veja nossos serviços mais populares:

✨ {{servico1}} — R$ {{valor1}}
✨ {{servico2}} — R$ {{valor2}}
✨ {{servico3}} — R$ {{valor3}}

Qual serviço você deseja agendar? Temos horários hoje!',
'[{"key": "nome", "label": "Nome"}, {"key": "salao", "label": "Nome do Salão"}, {"key": "servico1", "label": "Serviço 1"}, {"key": "valor1", "label": "Valor 1"}, {"key": "servico2", "label": "Serviço 2"}, {"key": "valor2", "label": "Valor 2"}, {"key": "servico3", "label": "Serviço 3"}, {"key": "valor3", "label": "Valor 3"}]',
'Oi Julia! Bem-vinda ao Studio Beauty!'),

-- Financeiro
('Simulação de Crédito', 'Para financeiras, bancos e fintechs', 'finance', true,
'Olá {{nome}}! Vi que você tem interesse em {{produto_financeiro}}. 💰

Fiz uma simulação inicial para você:

💵 Valor solicitado: R$ {{valor}}
📅 Prazo: {{prazo}} meses
💳 Parcela estimada: R$ {{parcela}}/mês
✅ Taxa: {{taxa}}% a.m.

Quer prosseguir com a solicitação? Posso te ajudar com o processo!',
'[{"key": "nome", "label": "Nome"}, {"key": "produto_financeiro", "label": "Produto"}, {"key": "valor", "label": "Valor"}, {"key": "prazo", "label": "Prazo"}, {"key": "parcela", "label": "Parcela"}, {"key": "taxa", "label": "Taxa"}]',
'Olá Carlos! Simulação de empréstimo pessoal pronta!'),

-- Jurídico
('Triagem Jurídica', 'Para escritórios de advocacia e consultorias', 'legal', true,
'Olá {{nome}}! Obrigado por entrar em contato com o escritório {{escritorio}}. ⚖️

Para podermos te atender da melhor forma, me conta brevemente:

1. Qual área do direito está relacionada ao seu caso?
2. Há alguma urgência ou prazo envolvido?
3. Já buscou orientação jurídica antes sobre este assunto?

Nossos especialistas estão prontos para ajudar!',
'[{"key": "nome", "label": "Nome"}, {"key": "escritorio", "label": "Nome do Escritório"}]',
'Olá Paulo! Obrigado por entrar em contato com o escritório Silva & Associados.');

INSERT INTO gamification_achievements (name, description, icon, category, condition_type, condition_value, reward_type, reward_value) VALUES

-- Primeiros passos
('Primeiro Lead!', 'Cadastrou seu primeiro lead', '🎯', 'leads', 'leads_created', 1, 'xp', 50),
('Decolando!', 'Cadastrou 10 leads', '🚀', 'leads', 'leads_created', 10, 'xp', 100),
('Máquina de Leads', 'Cadastrou 100 leads', '💥', 'leads', 'leads_created', 100, 'xp', 500),
('Mil Contatos', 'Cadastrou 1000 leads', '🏆', 'leads', 'leads_created', 1000, 'xp', 2000),

-- Conversas
('Primeira Conversa', 'Iniciou sua primeira conversa', '💬', 'conversations', 'conversations_started', 1, 'xp', 50),
('Bom Papo', 'Conduziu 50 conversas', '🗣️', 'conversations', 'conversations_started', 50, 'xp', 200),
('Comunicador', 'Conduziu 500 conversas', '📢', 'conversations', 'conversations_started', 500, 'xp', 1000),
('Satisfação Total', 'Recebeu 10 avaliações 5 estrelas', '⭐', 'conversations', 'five_star_ratings', 10, 'xp', 300),

-- Broadcasts
('Primeiro Disparo', 'Enviou seu primeiro broadcast', '📣', 'broadcasts', 'broadcasts_sent', 1, 'xp', 100),
('Megafone', 'Enviou 10 broadcasts', '📯', 'broadcasts', 'broadcasts_sent', 10, 'xp', 300),
('Alcance Máximo', 'Atingiu 1000 pessoas em um broadcast', '🌐', 'broadcasts', 'broadcast_recipients', 1000, 'xp', 500),

-- Fluxos
('Automatizador', 'Criou e ativou seu primeiro fluxo', '⚡', 'flows', 'flows_activated', 1, 'xp', 150),
('Engenheiro de Fluxos', 'Criou 10 fluxos ativos', '🔧', 'flows', 'flows_activated', 10, 'xp', 500),
('100 Execuções', 'Seus fluxos foram executados 100 vezes', '🔄', 'flows', 'flow_executions', 100, 'xp', 300),
('1000 Execuções', 'Seus fluxos foram executados 1000 vezes', '🤖', 'flows', 'flow_executions', 1000, 'xp', 1500),

-- Revenue
('Primeira Venda', 'Atribuiu receita de R$1 a um lead', '💰', 'general', 'revenue_attributed', 1, 'xp', 200),
('R$1.000 em Vendas', 'Atribuiu R$1.000 em receita', '💵', 'general', 'revenue_attributed', 1000, 'xp', 500),
('R$10.000 em Vendas', 'Atribuiu R$10.000 em receita', '💎', 'general', 'revenue_attributed', 10000, 'xp', 2000),

-- Agentes
('IA Ativa', 'Ativou seu primeiro agente de IA', '🤖', 'general', 'agents_activated', 1, 'xp', 100),
('Time de IA', 'Criou 5 agentes de IA', '👥', 'general', 'agents_activated', 5, 'xp', 500),

-- Fidelidade
('7 Dias Seguidos', 'Usou a plataforma por 7 dias consecutivos', '🔥', 'general', 'consecutive_days', 7, 'xp', 200),
('30 Dias', 'Completou 30 dias na plataforma', '📅', 'general', 'days_active', 30, 'xp', 500),
('6 Meses', 'Completou 6 meses na plataforma', '🎂', 'general', 'days_active', 180, 'xp', 2000),

-- Configuração
('Perfil Completo', 'Preencheu todas as informações do perfil', '✅', 'general', 'profile_complete', 1, 'xp', 100),
('Instagram Conectado', 'Conectou sua conta do Instagram', '📸', 'general', 'instagram_connected', 1, 'xp', 150),
('Equipe Formada', 'Adicionou um membro à equipe', '👋', 'general', 'team_members', 1, 'xp', 200),
('Base de Conhecimento', 'Criou sua primeira base de conhecimento', '📚', 'general', 'knowledge_base_created', 1, 'xp', 200),

-- Conquistas especiais
('Power User', 'Atingiu nível 10', '⚡', 'general', 'level_reached', 10, 'badge', 0),
('Expert', 'Atingiu nível 25', '🎓', 'general', 'level_reached', 25, 'badge', 0),
('Lenda', 'Atingiu nível 50', '🦁', 'general', 'level_reached', 50, 'badge', 0);

INSERT INTO flows (user_id, name, description, category, is_template, template_category, template_description, trigger_type, trigger_config, flow_data) VALUES

(NULL, 'Boas-vindas Automático', 'Fluxo de boas-vindas para novos leads que enviam DM pela primeira vez', 'onboarding', true, 'Engajamento', 'Ideal para ativar quando um novo seguidor envia a primeira mensagem', 'new_message',
'{"first_message_only": true}',
'{"nodes": [{"id": "start", "type": "trigger", "data": {"label": "Nova Mensagem"}}, {"id": "welcome", "type": "message", "data": {"content": "Olá! Que ótimo ter você aqui! 😊 Como posso te ajudar hoje?"}}, {"id": "menu", "type": "buttons", "data": {"content": "Escolha uma opção:", "buttons": ["Ver produtos", "Preços", "Falar com atendente"]}}], "edges": [{"source": "start", "target": "welcome"}, {"source": "welcome", "target": "menu"}]}'),

(NULL, 'Qualificação de Lead', 'Coleta informações essenciais para qualificar o lead automaticamente', 'qualification', true, 'Vendas', 'Ideal para qualificar leads antes de passar para o time de vendas', 'keyword',
'{"keywords": ["orçamento", "preço", "quanto custa", "valor"], "match_type": "contains"}',
'{"nodes": [{"id": "start", "type": "trigger"}, {"id": "q1", "type": "question", "data": {"content": "Ótimo! Para te passar um orçamento certeiro, me conta: qual é o principal produto/serviço que você precisa?"}}, {"id": "q2", "type": "question", "data": {"content": "Qual seria o volume/quantidade aproximada?"}}, {"id": "q3", "type": "question", "data": {"content": "Qual é o melhor contato para retornar (WhatsApp ou e-mail)?"}}, {"id": "tag", "type": "action", "data": {"action": "add_tag", "tag": "Qualificado"}}, {"id": "notify", "type": "action", "data": {"action": "notify_team"}}], "edges": []}'),

(NULL, 'Recuperação de Lead Frio', 'Reengaja leads que não interagem há mais de 7 dias', 'retention', true, 'CRM', 'Para manter leads aquecidos e reativar interesse', 'scheduled',
'{"cron": "0 10 * * 1", "timezone": "America/Sao_Paulo"}',
'{"nodes": [], "edges": []}'),

(NULL, 'Pós-venda e NPS', 'Coleta feedback após a compra e calcula NPS automaticamente', 'post-sale', true, 'Relacionamento', 'Enviar 3 dias após confirmar venda/entrega', 'manual',
'{}',
'{"nodes": [], "edges": []}'),

(NULL, 'Agendamento de Consulta', 'Fluxo completo para agendamento com verificação de disponibilidade', 'scheduling', true, 'Serviços', 'Para clínicas, salões e prestadores de serviço', 'keyword',
'{"keywords": ["agendar", "marcar", "consulta", "horário"], "match_type": "contains"}',
'{"nodes": [], "edges": []}'),

(NULL, 'Lançamento de Produto', 'Sequência de aquecimento para lançamento de produto ou serviço', 'launch', true, 'Marketing', 'Cria antecipação e gera lista de espera automaticamente', 'keyword',
'{"keywords": ["lançamento", "novidade", "lista vip", "lista de espera"], "match_type": "contains"}',
'{"nodes": [], "edges": []}'),

(NULL, 'Atendimento por FAQ', 'Responde automaticamente as 10 perguntas mais frequentes', 'support', true, 'Suporte', 'Reduz volume de atendimento humano para dúvidas comuns', 'new_message',
'{}',
'{"nodes": [], "edges": []}'),

(NULL, 'Funil de Vendas Completo', 'Da primeira mensagem até o fechamento em um único fluxo', 'sales', true, 'Vendas', 'Fluxo end-to-end para negócios com processo de venda definido', 'new_message',
'{}',
'{"nodes": [], "edges": []}'),

(NULL, 'Captação de E-mail', 'Converte seguidores em assinantes de newsletter', 'lead-gen', true, 'Marketing', 'Oferece material gratuito em troca do e-mail do lead', 'keyword',
'{"keywords": ["material gratuito", "ebook", "guia grátis", "newsletter"], "match_type": "contains"}',
'{"nodes": [], "edges": []}'),

(NULL, 'Confirmação de Pedido Delivery', 'Confirmação automática e acompanhamento de pedido para delivery', 'ecommerce', true, 'E-commerce', 'Mantém o cliente informado do status do pedido automaticamente', 'webhook',
'{"event": "order.created"}',
'{"nodes": [], "edges": []}');

-- Token encryption should be handled in application or Edge Functions, not in initial schema bootstrap.
-- Keep instagram_accounts.access_token and integrations.credentials_encrypted writes behind server-side code paths.
-- If you need backfill encryption later, create a dedicated migration after secrets are configured.


-- Via Supabase Dashboard > Database > Replication
-- Habilitar para:
-- - messages (chat em tempo real)
-- - notifications (notificações push)
-- - conversations (status de atendimento)
-- - flow_executions (progresso de fluxos)
-- - broadcast_recipients (progresso de envio)

-- analytics_events e messages são candidatas a particionamento mensal
-- Implementar quando volume > 10M registros por tabela

