# AI_MODELS.md — Documentacao Completa de IA do InstaFlow AI

> Versao: 1.0.0
> Data: Marco 2026
> Mantenedor: Time de Engenharia InstaFlow AI

---

## Sumario

1. [Visao Geral da Camada de IA](#1-visao-geral-da-camada-de-ia)
2. [Modelos Disponiveis](#2-modelos-disponiveis)
3. [Como Adicionar Novos Modelos](#3-como-adicionar-novos-modelos)
4. [Arquitetura do Agente de IA](#4-arquitetura-do-agente-de-ia)
5. [Sistema de Embeddings e Knowledge Base](#5-sistema-de-embeddings-e-knowledge-base)
6. [Biblioteca de Prompts do Sistema](#6-biblioteca-de-prompts-do-sistema)
7. [Gerador de Prompts por IA](#7-gerador-de-prompts-por-ia)
8. [Analytics Preditivo com IA](#8-analytics-preditivo-com-ia)
9. [Custo Estimado de IA por Plano](#9-custo-estimado-de-ia-por-plano)

---

## 1. Visao Geral da Camada de IA

### 1.1 Como a IA e usada na plataforma

O InstaFlow AI e uma plataforma SaaS multi-usuario para automacao de Instagram com inteligencia artificial no nucleo de cada funcionalidade. A IA nao e um add-on — ela e a espinha dorsal do produto. Cada interacao com um lead passa por um pipeline de decisao inteligente.

**Os quatro pilares de uso de IA na plataforma:**

#### a) Agentes de Atendimento Conversacional
O principal caso de uso. Quando um lead envia mensagem no Instagram, o agente de IA assume o atendimento de forma autonoma: responde perguntas, qualifica o lead, envia catalogo, coleta dados, agenda reunioes e conduz o processo de venda. O agente usa o contexto completo: historico da conversa, dados do CRM do lead, etapa no funil e base de conhecimento do negocio.

#### b) Embeddings e Busca Semantica (Knowledge Base)
Cada usuario pode enviar documentos do seu negocio (PDFs de catalogo, pagina de FAQ, descricao de servicos, politicas de entrega). A plataforma processa esses documentos, gera embeddings vetoriais e armazena no pgvector. Quando o agente precisa responder uma pergunta, ele busca os trechos mais relevantes da base de conhecimento usando similaridade cossenoidal — garantindo respostas precisas e baseadas nas informacoes reais do negocio.

#### c) Geracao de Conteudo
A plataforma oferece geracao assistida de:
- Copies para broadcasts (campanhas em massa)
- Respostas rapidas e snippets
- Variacoes de mensagens para testes A/B
- Legendas e CTAs para campanhas sazonais
- System prompts do agente (via wizard)

#### d) Analytics Preditivo
A IA analisa o comportamento dos leads para:
- Calcular lead score (probabilidade de compra, 0-100)
- Detectar risco de churn
- Prever melhor horario para envio de broadcasts
- Identificar sentimento nas conversas
- Sugerir proxima acao no funil

---

### 1.2 Principio: Usuario Escolhe o Modelo, Plataforma Gerencia os Custos

O InstaFlow AI opera no modelo **bring-your-infrastructure, not your-key**. Isso significa:

- O usuario NAO precisa ter conta na OpenAI, Anthropic ou Google
- O usuario NAO precisa inserir API keys proprias
- A plataforma possui contas proprietarias em todos os provedores
- O custo de IA e absorvido nos planos mensais como custo de infraestrutura

**Por que isso importa para o usuario:**
- Zero fricao para comecar (sem cadastro em multiplos servicos)
- Sem surpresa de custo (o usuario paga plano fixo)
- A plataforma negocia volume com os provedores, reduzindo custo unitario
- Upgrades automaticos de modelo sem configuracao adicional

**Por que isso importa para o negocio InstaFlow AI:**
- A margem de IA deve ser calculada com cuidado (ver secao 9)
- E necessario monitorar consumo por usuario para detectar abuso
- Rate limits por plano sao obrigatorios para proteger a margem

---

### 1.3 Como os Custos sao Absorvidos nos Planos

| Plano | Mensagens IA/mes | Modelo Padrao | Modelos Premium | Custo IA Estimado |
|-------|-----------------|---------------|-----------------|-------------------|
| Starter | 2.000 | Gemini 2.5 Flash | Nao | R$ 1,20 |
| Pro | 8.000 | GPT-4o mini | Sim (GPT-4o, Claude Sonnet) | R$ 18,00 |
| Business | 30.000 | GPT-4o | Todos | R$ 180,00 |
| Enterprise | Ilimitado* | Todos | Todos | Negociado |

*Ilimitado com fair-use policy. Consumo excessivo pode gerar cobranca adicional.

A margem de segurança recomendada e de **40% sobre o custo estimado** para cobrir:
- Picos de uso
- Prompts mais longos que a media
- Retentativas em caso de erro
- Chamadas extras de embeddings

---

## 2. Modelos Disponiveis

### 2.1 OpenAI

| Modelo | ID | Contexto | Custo Input | Custo Output | Velocidade | Disponivel em |
|--------|-----|----------|-------------|--------------|------------|---------------|
| GPT-4o | `gpt-4o` | 128k tokens | $2.50/1M tokens | $10.00/1M tokens | Rapido | Pro, Business |
| GPT-4o mini | `gpt-4o-mini` | 128k tokens | $0.15/1M tokens | $0.60/1M tokens | Muito rapido | Starter+ |
| o3-mini | `o3-mini` | 200k tokens | $1.10/1M tokens | $4.40/1M tokens | Medio (raciocinio) | Pro, Business |
| GPT-4.1 | `gpt-4.1` | 1M tokens | $2.00/1M tokens | $8.00/1M tokens | Rapido | Business |

**Notas sobre modelos OpenAI:**
- `gpt-4o-mini`: Ideal para atendimento em volume alto. Excelente custo-beneficio para respostas simples.
- `gpt-4o`: Melhor equilíbrio qualidade/velocidade. Recomendado como padrao para Pro.
- `o3-mini`: Modelo de raciocinio. Util para decisoes complexas, nao para atendimento em tempo real.
- `gpt-4.1`: Contexto de 1M tokens. Util para analise de documentos longos na knowledge base.

**Embedding OpenAI (nao configuravel pelo usuario):**
- `text-embedding-3-small`: 1536 dimensoes, $0.02/1M tokens — usado internamente

---

### 2.2 Anthropic

| Modelo | ID | Contexto | Custo Input | Custo Output | Velocidade | Disponivel em |
|--------|-----|----------|-------------|--------------|------------|---------------|
| Claude Haiku 4.5 | `claude-haiku-4-5-20251001` | 200k tokens | $0.80/1M tokens | $4.00/1M tokens | Muito rapido | Starter+ |
| Claude Sonnet 4.6 | `claude-sonnet-4-6` | 200k tokens | $3.00/1M tokens | $15.00/1M tokens | Rapido | Pro, Business |
| Claude Opus 4.6 | `claude-opus-4-6` | 200k tokens | $15.00/1M tokens | $75.00/1M tokens | Medio | Business |

**Notas sobre modelos Anthropic:**
- `claude-haiku-4-5`: Mais rapido da familia Claude. Otimo para atendimento em escala.
- `claude-sonnet-4-6`: Melhor modelo para escrita persuasiva e vendas. Altamente recomendado para e-commerce.
- `claude-opus-4-6`: Modelo topo de linha. Para analise profunda de leads e decisoes complexas. Custo proibitivo para atendimento em volume.

---

### 2.3 Google

| Modelo | ID | Contexto | Custo Input | Custo Output | Velocidade | Disponivel em |
|--------|-----|----------|-------------|--------------|------------|---------------|
| Gemini 2.5 Flash | `gemini-2.5-flash` | 1M tokens | $0.075/1M tokens | $0.30/1M tokens | Muito rapido | Starter+ |
| Gemini 2.0 Flash | `gemini-2.0-flash` | 1M tokens | $0.10/1M tokens | $0.40/1M tokens | Muito rapido | Starter+ |
| Gemini 2.5 Pro | `gemini-2.5-pro` | 1M tokens | $1.25/1M tokens | $10.00/1M tokens | Medio | Pro, Business |

**Notas sobre modelos Google:**
- `gemini-2.5-flash`: Modelo padrao do plano Starter. Custo extremamente baixo com qualidade surpreendente para atendimento.
- `gemini-2.0-flash`: Alternativa de fallback para o Flash 2.5. Boa estabilidade.
- `gemini-2.5-pro`: Janela de 1M tokens. Excelente para negócios com catalogo muito grande na knowledge base.

---

### 2.4 Tabela Comparativa por Caso de Uso

| Caso de Uso | Modelo Recomendado | Justificativa |
|-------------|--------------------|---------------|
| Atendimento em volume (Starter) | Gemini 2.5 Flash | Menor custo, velocidade alta |
| Atendimento em volume (Pro) | GPT-4o mini | Equilíbrio custo/qualidade |
| Vendas consultivas | Claude Sonnet 4.6 | Melhor escrita persuasiva |
| Resposta rapida/FAQ | Claude Haiku 4.5 | Ultra rapido |
| Analise de lead VIP | GPT-4o | Alta qualidade de raciocinio |
| Geracao de copies | GPT-4o ou Claude Sonnet 4.6 | Criatividade e coerencia |
| Base de conhecimento enorme | Gemini 2.5 Pro ou GPT-4.1 | Contexto de 1M tokens |
| Decisoes complexas de funil | o3-mini | Raciocinio estruturado |

---

## 3. Como Adicionar Novos Modelos

Quando novos modelos forem lancados (GPT-5, Claude 5, Gemini 3, etc.), siga este processo:

### Passo 1: Atualizar a tabela `ai_models` no banco de dados

```sql
-- migrations/add_new_ai_model.sql

INSERT INTO ai_models (
  id,
  provider,          -- 'openai' | 'anthropic' | 'google'
  model_id,          -- ID exato usado na API
  display_name,      -- Nome exibido na UI
  context_window,    -- Tamanho do contexto em tokens
  cost_per_1m_input, -- Custo em USD por 1M tokens de input
  cost_per_1m_output,-- Custo em USD por 1M tokens de output
  speed_tier,        -- 'very_fast' | 'fast' | 'medium' | 'slow'
  min_plan,          -- 'starter' | 'pro' | 'business' | 'enterprise'
  is_active,
  is_default,
  created_at
) VALUES (
  gen_random_uuid(),
  'openai',
  'gpt-5',
  'GPT-5',
  200000,
  5.00,
  20.00,
  'fast',
  'business',
  true,
  false,
  now()
);
```

### Passo 2: Implementar o adapter na Edge Function `ai-chat`

```typescript
// supabase/functions/ai-chat/adapters/openai-adapter.ts

// Cada provider tem seu proprio adapter seguindo a interface:
interface AIAdapter {
  chat(params: ChatParams): Promise<ChatResponse>
  countTokens(text: string): number
}

// Para adicionar GPT-5, adicionar ao switch de providers:
// supabase/functions/ai-chat/index.ts

function getAdapter(provider: string, modelId: string): AIAdapter {
  switch (provider) {
    case 'openai':
      return new OpenAIAdapter(modelId)  // Adapter ja suporta novos modelos OpenAI automaticamente
    case 'anthropic':
      return new AnthropicAdapter(modelId)  // Idem para Anthropic
    case 'google':
      return new GoogleAdapter(modelId)   // Idem para Google
    default:
      throw new Error(`Provider nao suportado: ${provider}`)
  }
}

// Se for um NOVO PROVIDER (ex: xAI/Grok), criar novo adapter:
// supabase/functions/ai-chat/adapters/xai-adapter.ts
```

### Passo 3: Configurar limite de plano

```typescript
// supabase/functions/ai-chat/plan-limits.ts

export const MODEL_PLAN_REQUIREMENTS: Record<string, PlanTier> = {
  'gpt-4o-mini': 'starter',
  'gemini-2.5-flash': 'starter',
  'gemini-2.0-flash': 'starter',
  'claude-haiku-4-5-20251001': 'starter',
  'gpt-4o': 'pro',
  'gpt-4.1': 'business',
  'claude-sonnet-4-6': 'pro',
  'gemini-2.5-pro': 'pro',
  'o3-mini': 'pro',
  'claude-opus-4-6': 'business',
  // Adicionar novo modelo aqui:
  'gpt-5': 'business',
}

export function canUserAccessModel(
  userPlan: PlanTier,
  modelId: string
): boolean {
  const required = MODEL_PLAN_REQUIREMENTS[modelId]
  if (!required) return false

  const planHierarchy: PlanTier[] = ['starter', 'pro', 'business', 'enterprise']
  return planHierarchy.indexOf(userPlan) >= planHierarchy.indexOf(required)
}
```

### Passo 4: Atualizar a UI (opcional mas recomendado)

Atualizar o componente de selecao de modelo no painel do usuario para exibir o novo modelo com badge "Novo" por 30 dias apos o lancamento.

---

## 4. Arquitetura do Agente de IA

### 4.1 Fluxo Completo de Processamento de uma Mensagem

```
Mensagem recebida via Webhook Meta
         |
         v
[ETAPA 1] Validar e identificar origem
    - Verificar assinatura HMAC do webhook
    - Extrair: instagram_user_id, message_text, timestamp
    - Buscar instagram_account na tabela por page_id
    - Buscar user_id (dono da conta InstaFlow)
         |
         v
[ETAPA 2] Identificar ou criar o lead
    - Buscar lead na tabela leads por instagram_user_id + user_id
    - Se nao existe: criar lead com dados basicos do Instagram
    - Salvar mensagem recebida em conversations
         |
         v
[ETAPA 3] Verificar keywords configuradas
    - Buscar keywords do usuario ativas
    - Comparar mensagem com patterns (exato ou regex)
    - Se match: executar acao da keyword (enviar template, iniciar fluxo, etc.)
    - Se match: PARAR processamento aqui
         |
         v
[ETAPA 4] Verificar se lead tem fluxo ativo
    - Buscar lead_flow_state por lead_id (status = 'active')
    - Se sim: buscar proximo no do fluxo
    - Executar no (enviar mensagem, esperar input, condicao, etc.)
    - Se o no requer input do usuario: processar resposta e avancar
    - Se sim: PARAR processamento aqui (fluxo assumiu o controle)
         |
         v
[ETAPA 5] Processar com agente de IA
    5.1 - Buscar agente ativo para este lead/canal
    5.2 - Verificar plano e limites de mensagens do mes
    5.3 - Buscar historico da conversa (ultimas 20 mensagens)
    5.4 - Gerar embedding da mensagem atual
    5.5 - Buscar chunks relevantes na knowledge base (top 5, threshold 0.7)
    5.6 - Montar prompt completo (system + context + kb + history + mensagem)
    5.7 - Chamar API do modelo configurado no agente
    5.8 - Analisar resposta: extrair intent, sentiment, confidence
    5.9 - Decidir: responder com IA ou escalar para humano
         |
         v
[ETAPA 6] Escalonamento (se necessario)
    - Se deve escalar: marcar lead como escalado
    - Notificar usuario (push notification / email / webhook)
    - Enviar mensagem de espera para o lead
    - PARAR processamento de IA para este lead ate humano liberar
         |
         v
[ETAPA 7] Enviar resposta via Instagram API
    - Formatar mensagem (texto, imagem, produto, lista, etc.)
    - Chamar Graph API com access_token da conta
    - Tratar erros (token expirado, lead bloqueou, rate limit)
         |
         v
[ETAPA 8] Persistir e atualizar metricas
    - Salvar resposta em conversations
    - Atualizar lead: last_interaction, message_count, sentiment, score
    - Incrementar contador de mensagens do plano (para billing)
    - Atualizar analytics diarias (dashboard do usuario)
    - Emitir evento para analytics preditivo (lead scoring assíncrono)
```

---

### 4.2 Estrutura Completa do Prompt

Este e o prompt exato montado e enviado para o modelo de linguagem. Cada variavel e substituida em tempo real:

```
============================================================
SYSTEM PROMPT
============================================================

[SYSTEM PROMPT CONFIGURADO PELO USUARIO]
Exemplo:
"Voce e Sofia, consultora de moda da Boutique Elegance. Sua missao e
ajudar clientes a encontrar o look perfeito, tirar duvidas sobre pecas
e guiar para a compra. Seja calorosa, use emojis com moderacao e
sempre destaque o beneficio de cada peca."

------------------------------------------------------------
INFORMACOES DO CONTEXTO DO LEAD
------------------------------------------------------------
- Nome: Maria Silva
- Instagram: @mariasilva_sp
- Etapa no funil: consideracao
- Tags: [interessada-vestidos, viu-stories-promocao, cliente-potencial-alta]
- Total de interacoes: 7 mensagens
- Primeira interacao: 2026-02-15
- Ultima compra: nenhuma registrada
- Valor do ticket medio esperado: R$ 180 (baseado em segmento)
- Lead score atual: 72/100
- Sentimento predominante: positivo

------------------------------------------------------------
BASE DE CONHECIMENTO RELEVANTE
------------------------------------------------------------

[Chunk 1 - Similaridade: 0.94 | Fonte: catalogo-primavera-2026.pdf]
Vestido Floral Midi Ref. VF-2201
Descricao: Vestido midi com estampa floral em fundo creme. Tecido viscose
fresco e fluido. Ideal para eventos ao ar livre e ocasioes semi-formais.
Tamanhos: PP, P, M, G, GG. Cores: creme/floral-rosa, creme/floral-azul.
Preco: R$ 189,90. Disponivel em estoque. Frete gratis acima de R$ 200.

[Chunk 2 - Similaridade: 0.88 | Fonte: politica-trocas.pdf]
Politica de Trocas e Devolucoes:
Aceitamos trocas em ate 30 dias corridos apos a data de entrega.
O produto deve estar sem uso, com etiqueta e embalagem original.
Trocas por tamanho sao gratuitas (frete por conta da loja).
Devolucoes com reembolso integral em ate 7 dias uteis.

[Chunk 3 - Similaridade: 0.81 | Fonte: faq-entregas.pdf]
Prazos de Entrega por Regiao:
- Sao Paulo capital: 1-2 dias uteis
- Interior de SP: 2-4 dias uteis
- Sul e Sudeste: 3-5 dias uteis
- Norte, Nordeste, Centro-Oeste: 5-8 dias uteis
Enviamos pelos Correios (SEDEX e PAC) e Jadlog.

------------------------------------------------------------
INSTRUCOES FIXAS DA PLATAFORMA (NAO REMOVER)
------------------------------------------------------------
- Responda APENAS em portugues do Brasil
- Seja conciso: primeira mensagem em uma nova conversa: maximo 300 caracteres.
  Mensagens de acompanhamento: maximo 500 caracteres
- Nunca mencione que e uma IA, a nao ser que o lead pergunte diretamente e explicitamente
- Se nao souber a resposta com base na knowledge base, diga: "Vou verificar isso
  para voce! Me da um momento?" e marque para escalonamento
- Nunca invente precos, prazos ou politicas que nao estejam na base de conhecimento
- Nao use markdown (negrito, italico, bullet points com *) — Instagram exibe texto plano
- Use emojis com moderacao (maximo 2-3 por mensagem, apenas se o tom da marca permitir)
- Se o lead demonstrar interesse em comprar: envie o link de checkout ou instrua como comprar

------------------------------------------------------------
HISTORICO DA CONVERSA (ULTIMAS 20 MENSAGENS)
------------------------------------------------------------
[2026-03-10 14:32] lead: Oi! Vi o vestido floral no stories, ainda tem?
[2026-03-10 14:32] agente: Ola Maria! Sim, temos sim o Vestido Floral Midi em varias
cores e tamanhos. Qual cor te chamou mais atencao?
[2026-03-10 14:33] lead: O creme com flores rosas! Voce tem no M?
[2026-03-10 14:33] agente: Otima escolha! Temos o M disponivel em estoque, pronta
entrega! O valor e R$ 189,90 com frete gratis para compras acima de R$ 200.

------------------------------------------------------------
MENSAGEM ATUAL DO LEAD
------------------------------------------------------------
lead: Qual o prazo de entrega pra Sao Paulo? E se nao servir posso trocar?

============================================================
```

---

### 4.3 Edge Function `ai-chat` — Implementacao Completa

```typescript
// supabase/functions/ai-chat/index.ts

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import OpenAI from 'https://esm.sh/openai@4'
import Anthropic from 'https://esm.sh/@anthropic-ai/sdk@0.24'

// ----- Tipos -----

interface ChatRequest {
  lead_id: string
  agent_id: string
  message: string
  conversation_id: string
}

interface AIResponse {
  content: string
  intent: IntentType
  sentiment: SentimentType
  confidence: number
  should_escalate: boolean
  escalation_reason?: string
  tokens_used: number
  model_id: string
  latency_ms: number
}

type IntentType =
  | 'compra'
  | 'suporte'
  | 'informacao'
  | 'saudacao'
  | 'despedida'
  | 'reclamacao'
  | 'desconhecido'

type SentimentType = 'positivo' | 'neutro' | 'negativo'
type PlanTier = 'starter' | 'pro' | 'business' | 'enterprise'

// ----- Handler Principal -----

serve(async (req: Request) => {
  const startTime = Date.now()

  try {
    // 1. Verificar autenticacao via JWT do Supabase
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Nao autorizado' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    // 2. Inicializar cliente Supabase com JWT do usuario
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { Authorization: authHeader } } }
    )

    // 3. Verificar usuario autenticado
    const { data: { user }, error: authError } = await supabase.auth.getUser()
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Token invalido' }), { status: 401 })
    }

    // 4. Parsear body da requisicao
    const body: ChatRequest = await req.json()
    const { lead_id, agent_id, message, conversation_id } = body

    // 5. Buscar configuracoes do agente
    const { data: agent, error: agentError } = await supabase
      .from('ai_agents')
      .select(`
        id, name, system_prompt, model_id, temperature,
        escalate_on_low_confidence, confidence_threshold,
        escalate_on_negative_sentiment, max_response_length,
        ai_models (provider, model_id, min_plan, cost_per_1m_input, cost_per_1m_output)
      `)
      .eq('id', agent_id)
      .eq('user_id', user.id)
      .single()

    if (agentError || !agent) {
      return new Response(JSON.stringify({ error: 'Agente nao encontrado' }), { status: 404 })
    }

    // 6. Verificar plano do usuario e limite mensal
    const { data: subscription } = await supabase
      .from('subscriptions')
      .select('plan, ai_messages_used, ai_messages_limit')
      .eq('user_id', user.id)
      .single()

    if (!subscription) {
      return new Response(JSON.stringify({ error: 'Plano nao encontrado' }), { status: 403 })
    }

    if (subscription.ai_messages_used >= subscription.ai_messages_limit) {
      return new Response(JSON.stringify({
        error: 'Limite mensal de mensagens atingido',
        code: 'QUOTA_EXCEEDED'
      }), { status: 429 })
    }

    // 7. Verificar se plano permite o modelo configurado
    const userPlan = subscription.plan as PlanTier
    if (!canUserAccessModel(userPlan, agent.ai_models.model_id)) {
      return new Response(JSON.stringify({
        error: `Modelo ${agent.ai_models.model_id} requer plano superior`,
        code: 'MODEL_NOT_AVAILABLE'
      }), { status: 403 })
    }

    // 8. Buscar dados do lead para contexto
    const { data: lead } = await supabase
      .from('leads')
      .select('id, name, instagram_username, funnel_stage, tags, message_count, sentiment, score, last_purchase_at')
      .eq('id', lead_id)
      .single()

    // 9. Buscar historico da conversa (ultimas 20 mensagens)
    const { data: history } = await supabase
      .from('conversations')
      .select('role, content, created_at')
      .eq('lead_id', lead_id)
      .eq('user_id', user.id)
      .order('created_at', { ascending: false })
      .limit(20)

    const conversationHistory = (history || []).reverse()

    // 10. Gerar embedding da mensagem atual para busca semantica
    const queryEmbedding = await generateEmbedding(message)

    // 11. Buscar chunks relevantes na knowledge base
    const { data: knowledgeChunks } = await supabase
      .rpc('search_knowledge_base', {
        p_user_id: user.id,
        p_agent_id: agent_id,
        p_query_embedding: queryEmbedding,
        p_similarity_threshold: 0.70,
        p_match_count: 5
      })

    // 12. Montar prompt completo
    const fullPrompt = buildPrompt({
      agent,
      lead,
      conversationHistory,
      knowledgeChunks: knowledgeChunks || [],
      currentMessage: message
    })

    // 13. Chamar API do modelo correto
    const modelResponse = await callAIModel({
      provider: agent.ai_models.provider,
      modelId: agent.ai_models.model_id,
      prompt: fullPrompt,
      temperature: agent.temperature || 0.7,
      maxTokens: agent.max_response_length || 500
    })

    // 14. Analisar intent e sentiment da mensagem original
    const analysis = await analyzeMessage(message, modelResponse.content)

    // 15. Decidir se deve escalar para humano
    const shouldEscalate = decidirEscalonamento({
      confidence: analysis.confidence,
      sentiment: analysis.sentiment,
      intent: analysis.intent,
      agentConfig: agent
    })

    // 16. Calcular custo desta chamada para tracking
    const costUSD = calculateCost({
      inputTokens: modelResponse.promptTokens,
      outputTokens: modelResponse.completionTokens,
      costPerMInput: agent.ai_models.cost_per_1m_input,
      costPerMOutput: agent.ai_models.cost_per_1m_output
    })

    // 17. Incrementar contador de uso
    await supabase.rpc('increment_ai_usage', {
      p_user_id: user.id,
      p_cost_usd: costUSD,
      p_tokens_used: modelResponse.promptTokens + modelResponse.completionTokens
    })

    // 18. Registrar chamada de IA para auditoria
    await supabase.from('ai_calls_log').insert({
      user_id: user.id,
      agent_id: agent_id,
      lead_id: lead_id,
      conversation_id: conversation_id,
      model_id: agent.ai_models.model_id,
      prompt_tokens: modelResponse.promptTokens,
      completion_tokens: modelResponse.completionTokens,
      cost_usd: costUSD,
      latency_ms: Date.now() - startTime,
      intent: analysis.intent,
      sentiment: analysis.sentiment,
      confidence: analysis.confidence,
      escalated: shouldEscalate
    })

    // 19. Retornar resposta para o caller
    const response: AIResponse = {
      content: modelResponse.content,
      intent: analysis.intent,
      sentiment: analysis.sentiment,
      confidence: analysis.confidence,
      should_escalate: shouldEscalate,
      escalation_reason: shouldEscalate ? analysis.escalationReason : undefined,
      tokens_used: modelResponse.promptTokens + modelResponse.completionTokens,
      model_id: agent.ai_models.model_id,
      latency_ms: Date.now() - startTime
    }

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    })

  } catch (error) {
    console.error('Erro na edge function ai-chat:', error)
    return new Response(JSON.stringify({
      error: 'Erro interno do servidor',
      details: error instanceof Error ? error.message : 'Erro desconhecido'
    }), { status: 500 })
  }
})

// ----- Funcao: Gerar Embedding -----

async function generateEmbedding(text: string): Promise<number[]> {
  const openai = new OpenAI({ apiKey: Deno.env.get('OPENAI_API_KEY') })

  const response = await openai.embeddings.create({
    model: 'text-embedding-3-small',
    input: text,
    dimensions: 1536
  })

  return response.data[0].embedding
}

// ----- Funcao: Montar Prompt -----

function buildPrompt(params: {
  agent: any
  lead: any
  conversationHistory: any[]
  knowledgeChunks: any[]
  currentMessage: string
}): { system: string; messages: any[] } {
  const { agent, lead, conversationHistory, knowledgeChunks, currentMessage } = params

  // Construir secao de knowledge base
  const kbSection = knowledgeChunks.length > 0
    ? knowledgeChunks.map((chunk, i) =>
        `[Chunk ${i + 1} - Similaridade: ${(chunk.similarity * 100).toFixed(0)}% | Fonte: ${chunk.source_name}]\n${chunk.content}`
      ).join('\n\n')
    : 'Nenhum conteudo relevante encontrado na base de conhecimento para esta mensagem.'

  // Construir secao de contexto do lead
  const leadContext = `
- Nome: ${lead?.name || 'Nao identificado'}
- Instagram: @${lead?.instagram_username || 'desconhecido'}
- Etapa no funil: ${lead?.funnel_stage || 'nao definida'}
- Tags: [${(lead?.tags || []).join(', ')}]
- Total de interacoes: ${lead?.message_count || 0} mensagens
- Sentimento predominante: ${lead?.sentiment || 'neutro'}
- Lead score atual: ${lead?.score || 0}/100
- Ultima compra: ${lead?.last_purchase_at ? new Date(lead.last_purchase_at).toLocaleDateString('pt-BR') : 'nenhuma registrada'}`

  // System prompt completo
  const systemPrompt = `${agent.system_prompt}

------------------------------------------------------------
INFORMACOES DO CONTEXTO DO LEAD
------------------------------------------------------------
${leadContext}

------------------------------------------------------------
BASE DE CONHECIMENTO RELEVANTE
------------------------------------------------------------
${kbSection}

------------------------------------------------------------
INSTRUCOES FIXAS DA PLATAFORMA (NAO REMOVER)
------------------------------------------------------------
- Responda APENAS em portugues do Brasil
- Seja conciso: maximo ${agent.max_response_length || 500} caracteres
- Nunca mencione que e uma IA, a nao ser que o lead pergunte diretamente
- Se nao souber a resposta com base na knowledge base, diga que vai verificar
- Nunca invente precos, prazos ou politicas que nao estejam na base de conhecimento
- Nao use markdown — Instagram exibe apenas texto plano`

  // Converter historico para formato messages
  const messages = [
    ...conversationHistory.map(msg => ({
      role: msg.role as 'user' | 'assistant',
      content: msg.content
    })),
    { role: 'user' as const, content: currentMessage }
  ]

  return { system: systemPrompt, messages }
}

// ----- Funcao: Chamar API do Modelo -----

async function callAIModel(params: {
  provider: string
  modelId: string
  prompt: { system: string; messages: any[] }
  temperature: number
  maxTokens: number
}): Promise<{ content: string; promptTokens: number; completionTokens: number }> {

  const { provider, modelId, prompt, temperature, maxTokens } = params

  switch (provider) {
    case 'openai': {
      const openai = new OpenAI({ apiKey: Deno.env.get('OPENAI_API_KEY') })
      const response = await openai.chat.completions.create({
        model: modelId,
        messages: [
          { role: 'system', content: prompt.system },
          ...prompt.messages
        ],
        temperature,
        max_tokens: maxTokens
      })
      return {
        content: response.choices[0].message.content || '',
        promptTokens: response.usage?.prompt_tokens || 0,
        completionTokens: response.usage?.completion_tokens || 0
      }
    }

    case 'anthropic': {
      const anthropic = new Anthropic({ apiKey: Deno.env.get('ANTHROPIC_API_KEY') })
      const response = await anthropic.messages.create({
        model: modelId,
        system: prompt.system,
        messages: prompt.messages,
        temperature,
        max_tokens: maxTokens
      })
      return {
        content: response.content[0].type === 'text' ? response.content[0].text : '',
        promptTokens: response.usage.input_tokens,
        completionTokens: response.usage.output_tokens
      }
    }

    case 'google': {
      const apiKey = Deno.env.get('GOOGLE_AI_API_KEY')
      const endpoint = `https://generativelanguage.googleapis.com/v1beta/models/${modelId}:generateContent?key=${apiKey}`

      // Converter mensagens para formato Gemini
      const geminiMessages = prompt.messages.map(msg => ({
        role: msg.role === 'assistant' ? 'model' : 'user',
        parts: [{ text: msg.content }]
      }))

      const response = await fetch(endpoint, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          system_instruction: { parts: [{ text: prompt.system }] },
          contents: geminiMessages,
          generationConfig: { temperature, maxOutputTokens: maxTokens }
        })
      })

      const data = await response.json()
      return {
        content: data.candidates?.[0]?.content?.parts?.[0]?.text || '',
        promptTokens: data.usageMetadata?.promptTokenCount || 0,
        completionTokens: data.usageMetadata?.candidatesTokenCount || 0
      }
    }

    default:
      throw new Error(`Provider nao suportado: ${provider}`)
  }
}

// ----- Funcao: Analisar Intent e Sentiment -----

async function analyzeMessage(
  userMessage: string,
  agentResponse: string
): Promise<{ intent: IntentType; sentiment: SentimentType; confidence: number; escalationReason?: string }> {

  const openai = new OpenAI({ apiKey: Deno.env.get('OPENAI_API_KEY') })

  const analysisPrompt = `Analise a mensagem do usuario e classifique:

MENSAGEM: "${userMessage}"

Retorne JSON com:
- intent: "compra" | "suporte" | "informacao" | "saudacao" | "despedida" | "reclamacao" | "desconhecido"
- sentiment: "positivo" | "neutro" | "negativo"
- confidence: numero de 0.0 a 1.0 (quao confiante voce esta na classificacao)

Exemplos de intents:
- compra: "quero comprar", "quanto custa", "como pago", "tem parcelas"
- suporte: "nao funcionou", "problema", "erro", "nao recebi"
- informacao: "como funciona", "o que e", "quais opcoes", "tem disponivel"
- saudacao: "oi", "ola", "bom dia", "boa tarde", "boa noite"
- despedida: "tchau", "obrigado", "ate mais", "flw"
- reclamacao: "pessimo", "horrivel", "decepcionado", "nunca mais", "absurdo"

Responda APENAS com o JSON, sem explicacao.`

  try {
    const response = await openai.chat.completions.create({
      model: 'gpt-4o-mini',
      messages: [{ role: 'user', content: analysisPrompt }],
      temperature: 0,
      max_tokens: 100,
      response_format: { type: 'json_object' }
    })

    const result = JSON.parse(response.choices[0].message.content || '{}')

    return {
      intent: result.intent || 'desconhecido',
      sentiment: result.sentiment || 'neutro',
      confidence: result.confidence || 0.5
    }
  } catch {
    // Fallback seguro em caso de erro na analise
    return { intent: 'desconhecido', sentiment: 'neutro', confidence: 0.5 }
  }
}

// ----- Funcao: Decidir Escalonamento -----

function decidirEscalonamento(params: {
  confidence: number
  sentiment: SentimentType
  intent: IntentType
  agentConfig: any
}): boolean {
  const { confidence, sentiment, intent, agentConfig } = params

  const threshold = agentConfig.confidence_threshold || 0.6

  // Regra 1: Baixa confianca na resposta
  if (agentConfig.escalate_on_low_confidence && confidence < threshold) {
    return true
  }

  // Regra 2: Sentimento negativo detectado
  if (agentConfig.escalate_on_negative_sentiment && sentiment === 'negativo') {
    return true
  }

  // Regra 3: Intent de reclamacao sempre escala
  if (intent === 'reclamacao') {
    return true
  }

  return false
}

// ----- Funcao: Calcular Custo -----

function calculateCost(params: {
  inputTokens: number
  outputTokens: number
  costPerMInput: number
  costPerMOutput: number
}): number {
  const { inputTokens, outputTokens, costPerMInput, costPerMOutput } = params
  return (inputTokens / 1_000_000) * costPerMInput + (outputTokens / 1_000_000) * costPerMOutput
}

// ----- Funcao: Verificar Plano -----

function canUserAccessModel(userPlan: PlanTier, modelId: string): boolean {
  const MODEL_PLAN_REQUIREMENTS: Record<string, PlanTier> = {
    'gpt-4o-mini': 'starter',
    'gemini-2.5-flash': 'starter',
    'gemini-2.0-flash': 'starter',
    'claude-haiku-4-5-20251001': 'starter',
    'gpt-4o': 'pro',
    'claude-sonnet-4-6': 'pro',
    'gemini-2.5-pro': 'pro',
    'o3-mini': 'pro',
    'gpt-4.1': 'business',
    'claude-opus-4-6': 'business',
  }

  const required = MODEL_PLAN_REQUIREMENTS[modelId] || 'enterprise'
  const hierarchy: PlanTier[] = ['starter', 'pro', 'business', 'enterprise']
  return hierarchy.indexOf(userPlan) >= hierarchy.indexOf(required)
}
```

---

### 4.4 Analise de Intent e Sentiment

#### Classificacao de Intencoes

A plataforma classifica cada mensagem em uma das seguintes intencoes:

| Intent | Exemplos de Mensagem | Acao Recomendada |
|--------|---------------------|------------------|
| `compra` | "quero comprar", "quanto custa", "tem parcelas", "como pago", "aceita pix" | Enviar preco, link de checkout |
| `suporte` | "nao recebi", "meu pedido", "como rastrear", "nao funcionou" | Buscar info do pedido, escalar se necessario |
| `informacao` | "tem em azul?", "qual o tamanho?", "como funciona?", "o que inclui?" | Buscar na knowledge base e responder |
| `saudacao` | "oi", "ola", "bom dia", "boa tarde", "oie" | Resposta de boas-vindas |
| `despedida` | "obrigado", "tchau", "ate mais", "valeu", "flw" | Resposta de despedida com CTA suave |
| `reclamacao` | "horrivel", "pessimo", "decepcionado", "nunca mais", "absurdo", "mentira" | ESCALAR IMEDIATAMENTE |
| `desconhecido` | Mensagens ambiguas ou muito curtas | Pedir mais detalhes |

#### Tecnica: Few-Shot Prompting para Classificacao

Em vez de usar um modelo separado, a classificacao e feita via few-shot no mesmo modelo do agente para economizar latencia:

```typescript
// Exemplo de few-shot para classificacao de intent
const fewShotExamples = `
Q: "oi tudo bem" -> intent: saudacao, sentiment: positivo, confidence: 0.98
Q: "quanto custa o vestido rosa" -> intent: compra, sentiment: neutro, confidence: 0.95
Q: "NUNCA mais compro aqui, pessimo atendimento" -> intent: reclamacao, sentiment: negativo, confidence: 0.99
Q: "tem esse produto em vermelho?" -> intent: informacao, sentiment: neutro, confidence: 0.92
Q: "meu pedido nao chegou" -> intent: suporte, sentiment: neutro, confidence: 0.88
Q: "ok" -> intent: desconhecido, sentiment: neutro, confidence: 0.45
`
```

---

### 4.5 Regras de Escalonamento para Humano

O escalonamento e critico para garantir a qualidade do atendimento. Um agente que escalona na hora certa e tao importante quanto um que resolve autonomamente.

**Regras por prioridade:**

```typescript
// Regras em ordem de prioridade (primeira que bater, escala)
const ESCALATION_RULES = [
  {
    id: 'low_confidence',
    condition: (ctx: EscalationContext) =>
      ctx.agentConfig.escalate_on_low_confidence &&
      ctx.confidence < (ctx.agentConfig.confidence_threshold || 0.60),
    reason: 'IA com baixa confianca na resposta',
    priority: 'high'
  },
  {
    id: 'complaint_intent',
    condition: (ctx: EscalationContext) => ctx.intent === 'reclamacao',
    reason: 'Lead com intencao de reclamacao detectada',
    priority: 'critical'
  },
  {
    id: 'negative_sentiment',
    condition: (ctx: EscalationContext) =>
      ctx.agentConfig.escalate_on_negative_sentiment &&
      ctx.sentiment === 'negativo',
    reason: 'Sentimento negativo detectado na mensagem',
    priority: 'high'
  },
  {
    id: 'explicit_human_request',
    condition: (ctx: EscalationContext) => {
      const humanKeywords = ['falar com humano', 'atendente', 'pessoa real',
                             'nao quero falar com robo', 'chama alguem']
      return humanKeywords.some(kw => ctx.message.toLowerCase().includes(kw))
    },
    reason: 'Lead solicitou atendimento humano explicitamente',
    priority: 'critical'
  },
  {
    id: 'max_retries',
    condition: (ctx: EscalationContext) => ctx.unansweredCount >= 3,
    reason: 'Tres mensagens sem resolucao do problema',
    priority: 'medium'
  }
]
```

---

## 5. Sistema de Embeddings e Knowledge Base

### 5.1 Pipeline Completo de Processamento de Documento

```typescript
// supabase/functions/process-knowledge-base/index.ts

serve(async (req: Request) => {
  const { knowledge_base_id, file_url, file_type } = await req.json()

  // ETAPA 1: Atualizar status para 'processing'
  await supabase
    .from('knowledge_base')
    .update({ status: 'processing', processing_started_at: new Date().toISOString() })
    .eq('id', knowledge_base_id)

  try {
    // ETAPA 2: Extrair texto do arquivo
    let rawText = ''

    switch (file_type) {
      case 'pdf':
        rawText = await extractFromPDF(file_url)
        break
      case 'docx':
        rawText = await extractFromDOCX(file_url)
        break
      case 'txt':
        rawText = await extractFromTXT(file_url)
        break
      case 'url':
        rawText = await extractFromURL(file_url)
        break
    }

    // ETAPA 3: Limpar o texto
    const cleanedText = cleanText(rawText)

    // ETAPA 4: Dividir em chunks
    const chunks = splitIntoChunks(cleanedText, {
      targetTokens: 500,
      overlapTokens: 50,
      preserveParagraphs: true
    })

    // ETAPA 5: Gerar embeddings para cada chunk (em lotes de 100)
    const BATCH_SIZE = 100
    let totalChunksCreated = 0

    for (let i = 0; i < chunks.length; i += BATCH_SIZE) {
      const batch = chunks.slice(i, i + BATCH_SIZE)

      const openai = new OpenAI({ apiKey: Deno.env.get('OPENAI_API_KEY') })
      const embeddingsResponse = await openai.embeddings.create({
        model: 'text-embedding-3-small',
        input: batch.map(c => c.content),
        dimensions: 1536
      })

      // ETAPA 6: Inserir chunks com embeddings no banco
      const chunksToInsert = batch.map((chunk, idx) => ({
        knowledge_base_id,
        content: chunk.content,
        embedding: embeddingsResponse.data[idx].embedding,
        token_count: chunk.tokenCount,
        chunk_index: i + idx,
        metadata: chunk.metadata
      }))

      await supabase
        .from('knowledge_chunks')
        .insert(chunksToInsert)

      totalChunksCreated += batch.length
    }

    // ETAPA 7: Marcar como ativo
    await supabase
      .from('knowledge_base')
      .update({
        status: 'active',
        chunks_count: totalChunksCreated,
        processing_completed_at: new Date().toISOString()
      })
      .eq('id', knowledge_base_id)

  } catch (error) {
    await supabase
      .from('knowledge_base')
      .update({ status: 'error', error_message: error.message })
      .eq('id', knowledge_base_id)
    throw error
  }
})

// ----- Extracao de Texto por Tipo -----

async function extractFromPDF(url: string): Promise<string> {
  const response = await fetch(url)
  const buffer = await response.arrayBuffer()
  // Usar pdf-parse via WASM para Deno
  const pdfData = await parsePDF(new Uint8Array(buffer))
  return pdfData.text
}

async function extractFromURL(url: string): Promise<string> {
  const response = await fetch(url, {
    headers: { 'User-Agent': 'InstaFlow AI Bot/1.0' }
  })
  const html = await response.text()

  // Remover HTML e extrair texto limpo
  return html
    .replace(/<script[^>]*>[\s\S]*?<\/script>/gi, '')
    .replace(/<style[^>]*>[\s\S]*?<\/style>/gi, '')
    .replace(/<nav[^>]*>[\s\S]*?<\/nav>/gi, '')
    .replace(/<footer[^>]*>[\s\S]*?<\/footer>/gi, '')
    .replace(/<header[^>]*>[\s\S]*?<\/header>/gi, '')
    .replace(/<[^>]+>/g, ' ')
    .replace(/\s+/g, ' ')
    .trim()
}

function cleanText(text: string): string {
  return text
    .replace(/\r\n/g, '\n')          // Normalizar quebras de linha
    .replace(/\r/g, '\n')             // Remover \r soltos
    .replace(/\n{3,}/g, '\n\n')      // Maximo 2 quebras consecutivas
    .replace(/[ \t]+/g, ' ')          // Normalizar espacos
    .replace(/^\s+|\s+$/gm, '')       // Trim por linha
    .trim()
}

// ----- Chunking Estrategico -----

interface Chunk {
  content: string
  tokenCount: number
  metadata: { startChar: number; endChar: number; paragraphIndex: number }
}

function splitIntoChunks(text: string, options: {
  targetTokens: number
  overlapTokens: number
  preserveParagraphs: boolean
}): Chunk[] {
  const { targetTokens, overlapTokens } = options
  const chunks: Chunk[] = []

  // Dividir por paragrafos primeiro
  const paragraphs = text.split(/\n\n+/)
  let currentChunk = ''
  let currentTokens = 0
  let chunkStart = 0
  let paragraphIndex = 0

  for (const paragraph of paragraphs) {
    const paragraphTokens = estimateTokenCount(paragraph)

    if (currentTokens + paragraphTokens > targetTokens && currentChunk) {
      // Salvar chunk atual
      chunks.push({
        content: currentChunk.trim(),
        tokenCount: currentTokens,
        metadata: { startChar: chunkStart, endChar: chunkStart + currentChunk.length, paragraphIndex }
      })

      // Overlap: manter ultimas palavras para contexto
      const words = currentChunk.split(' ')
      const overlapWords = words.slice(-Math.floor(overlapTokens * 0.75))
      currentChunk = overlapWords.join(' ') + '\n\n' + paragraph
      currentTokens = estimateTokenCount(currentChunk)
      chunkStart += currentChunk.length - overlapWords.join(' ').length
    } else {
      currentChunk += (currentChunk ? '\n\n' : '') + paragraph
      currentTokens += paragraphTokens
    }

    paragraphIndex++
  }

  // Ultimo chunk
  if (currentChunk.trim()) {
    chunks.push({
      content: currentChunk.trim(),
      tokenCount: currentTokens,
      metadata: { startChar: chunkStart, endChar: text.length, paragraphIndex }
    })
  }

  return chunks
}

function estimateTokenCount(text: string): number {
  // Estimativa: 1 token ~= 4 caracteres em ingles, ~3.5 em portugues
  return Math.ceil(text.length / 3.5)
}
```

---

### 5.2 Funcao de Busca Semantica no PostgreSQL

```sql
-- migrations/functions/search_knowledge_base.sql

-- Extensao necessaria (ja configurada no Supabase)
-- CREATE EXTENSION IF NOT EXISTS vector;

-- Tabela de knowledge base
CREATE TABLE IF NOT EXISTS knowledge_base (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  agent_id uuid REFERENCES ai_agents(id) ON DELETE SET NULL,
  name text NOT NULL,
  description text,
  file_url text,
  file_type text CHECK (file_type IN ('pdf', 'docx', 'txt', 'url')),
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'active', 'error')),
  chunks_count integer DEFAULT 0,
  is_active boolean DEFAULT true,
  error_message text,
  processing_started_at timestamptz,
  processing_completed_at timestamptz,
  created_at timestamptz DEFAULT now()
);

-- Tabela de chunks com embedding vetorial
CREATE TABLE IF NOT EXISTS knowledge_chunks (
  id bigserial PRIMARY KEY,
  knowledge_base_id uuid NOT NULL REFERENCES knowledge_base(id) ON DELETE CASCADE,
  content text NOT NULL,
  embedding vector(1536) NOT NULL,
  token_count integer,
  chunk_index integer,
  metadata jsonb DEFAULT '{}',
  created_at timestamptz DEFAULT now()
);

-- Index para busca por similaridade (IVFFlat para datasets medios)
CREATE INDEX IF NOT EXISTS knowledge_chunks_embedding_idx
  ON knowledge_chunks
  USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);

-- Index para filtros comuns
CREATE INDEX IF NOT EXISTS knowledge_chunks_kb_id_idx
  ON knowledge_chunks (knowledge_base_id);

-- Funcao principal de busca semantica
CREATE OR REPLACE FUNCTION search_knowledge_base(
  p_user_id uuid,
  p_agent_id uuid,
  p_query_embedding vector(1536),
  p_similarity_threshold float DEFAULT 0.70,
  p_match_count int DEFAULT 5
)
RETURNS TABLE (
  id bigint,
  content text,
  similarity float,
  source_name text,
  source_type text,
  chunk_index integer
)
LANGUAGE sql STABLE
SECURITY DEFINER
AS $$
  SELECT
    kc.id,
    kc.content,
    1 - (kc.embedding <=> p_query_embedding) AS similarity,
    kb.name AS source_name,
    kb.file_type AS source_type,
    kc.chunk_index
  FROM knowledge_chunks kc
  INNER JOIN knowledge_base kb ON kc.knowledge_base_id = kb.id
  WHERE
    kb.user_id = p_user_id
    AND kb.is_active = true
    AND kb.status = 'active'
    -- Buscar chunks de KBs do agente especifico OU KBs globais do usuario
    AND (kb.agent_id = p_agent_id OR kb.agent_id IS NULL)
    -- Filtro de similaridade minima
    AND 1 - (kc.embedding <=> p_query_embedding) > p_similarity_threshold
  ORDER BY
    kc.embedding <=> p_query_embedding ASC  -- Menor distancia = maior similaridade
  LIMIT p_match_count;
$$;

-- Funcao de busca hibrida (semantica + keyword) para resultados mais completos
CREATE OR REPLACE FUNCTION search_knowledge_base_hybrid(
  p_user_id uuid,
  p_agent_id uuid,
  p_query_embedding vector(1536),
  p_query_text text,
  p_similarity_threshold float DEFAULT 0.65,
  p_match_count int DEFAULT 5
)
RETURNS TABLE (
  id bigint,
  content text,
  similarity float,
  keyword_rank float,
  combined_score float,
  source_name text
)
LANGUAGE sql STABLE
SECURITY DEFINER
AS $$
  WITH semantic_results AS (
    SELECT
      kc.id,
      kc.content,
      1 - (kc.embedding <=> p_query_embedding) AS similarity,
      kb.name AS source_name
    FROM knowledge_chunks kc
    INNER JOIN knowledge_base kb ON kc.knowledge_base_id = kb.id
    WHERE
      kb.user_id = p_user_id
      AND kb.is_active = true
      AND kb.status = 'active'
      AND (kb.agent_id = p_agent_id OR kb.agent_id IS NULL)
      AND 1 - (kc.embedding <=> p_query_embedding) > p_similarity_threshold
  ),
  keyword_results AS (
    SELECT
      kc.id,
      ts_rank(to_tsvector('portuguese', kc.content), plainto_tsquery('portuguese', p_query_text)) AS keyword_rank
    FROM knowledge_chunks kc
    INNER JOIN knowledge_base kb ON kc.knowledge_base_id = kb.id
    WHERE
      kb.user_id = p_user_id
      AND kb.is_active = true
      AND kb.status = 'active'
      AND (kb.agent_id = p_agent_id OR kb.agent_id IS NULL)
      AND to_tsvector('portuguese', kc.content) @@ plainto_tsquery('portuguese', p_query_text)
  )
  SELECT
    sr.id,
    sr.content,
    sr.similarity,
    COALESCE(kr.keyword_rank, 0) AS keyword_rank,
    -- Pontuacao combinada: 70% semantica + 30% keyword
    (sr.similarity * 0.7 + COALESCE(kr.keyword_rank, 0) * 0.3) AS combined_score,
    sr.source_name
  FROM semantic_results sr
  LEFT JOIN keyword_results kr ON sr.id = kr.id
  ORDER BY combined_score DESC
  LIMIT p_match_count;
$$;

-- RLS: Usuario so ve sua propria knowledge base
ALTER TABLE knowledge_base ENABLE ROW LEVEL SECURITY;
ALTER TABLE knowledge_chunks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can only see their own knowledge base"
  ON knowledge_base FOR ALL
  USING (auth.uid() = user_id);

CREATE POLICY "Users can only see chunks of their knowledge base"
  ON knowledge_chunks FOR ALL
  USING (
    knowledge_base_id IN (
      SELECT id FROM knowledge_base WHERE user_id = auth.uid()
    )
  );
```

---

### 5.3 Estrategias de Chunking por Tipo de Documento

A estrategia de chunking impacta diretamente a qualidade das respostas. Aqui estao as recomendacoes por tipo:

```typescript
// supabase/functions/process-knowledge-base/chunking-strategies.ts

export type ChunkingStrategy =
  | 'fixed_size'       // Tamanho fixo com overlap
  | 'by_paragraph'     // Por paragrafo
  | 'by_section'       // Por secao (H1, H2, H3)
  | 'by_qa'            // Por par pergunta/resposta
  | 'by_product'       // Por produto no catalogo
  | 'hierarchical'     // Chunk + parent chunk

// Recomendacao por tipo de documento
export const CHUNKING_RECOMMENDATIONS: Record<string, ChunkingStrategy> = {
  'faq': 'by_qa',
  'catalogo': 'by_product',
  'manual': 'by_section',
  'politica': 'by_paragraph',
  'descricao_empresa': 'by_paragraph',
  'cardapio': 'by_product',
  'preco_tabela': 'by_product',
  'default': 'fixed_size'
}

// Estrategia: Por par pergunta/resposta (FAQ)
export function chunkByQA(text: string): Chunk[] {
  const chunks: Chunk[] = []

  // Detectar padroes de FAQ: "P:", "Q:", "Pergunta:", linhas terminadas com "?"
  const qaPattern = /(?:^|\n)(?:P:|Q:|Pergunta:|R:|A:|Resposta:|\d+\.)\s*(.+?)(?=(?:\n(?:P:|Q:|Pergunta:|R:|A:|Resposta:|\d+\.)|\Z))/gs

  let match
  let pairBuffer = ''

  while ((match = qaPattern.exec(text)) !== null) {
    if (pairBuffer && match[0].trim().match(/^(?:P:|Q:|Pergunta:|\d+\.)/)) {
      // Novo par comecando, salvar o anterior
      chunks.push({
        content: pairBuffer.trim(),
        tokenCount: estimateTokenCount(pairBuffer),
        metadata: { type: 'qa_pair' }
      })
      pairBuffer = match[0]
    } else {
      pairBuffer += '\n' + match[0]
    }
  }

  if (pairBuffer.trim()) {
    chunks.push({
      content: pairBuffer.trim(),
      tokenCount: estimateTokenCount(pairBuffer),
      metadata: { type: 'qa_pair' }
    })
  }

  return chunks
}

// Estrategia: Por produto (Catalogo)
export function chunkByProduct(text: string): Chunk[] {
  // Detectar entradas de produto por separadores comuns
  const productSeparators = [
    /^---+$/m,                          // Linha de hifens
    /^===+$/m,                          // Linha de iguais
    /^\d+\.\s+[A-Z]/m,                 // "1. PRODUTO X"
    /^Produto:|^Item:|^Ref\./m          // Prefixos comuns
  ]

  // Dividir pelo separador mais prevalente no texto
  // ... implementacao ...
  return []
}

// Estrategia: Hierarquica (chunk pequeno + parent maior)
export function chunkHierarchical(text: string): HierarchicalChunk[] {
  // Criar chunks menores (200 tokens) E chunks maiores (800 tokens)
  // O embedding e do chunk menor, mas a resposta inclui o chunk maior
  // Melhora recall sem comprometer precisao
  const smallChunks = splitIntoChunks(text, { targetTokens: 200, overlapTokens: 20, preserveParagraphs: true })
  const largeChunks = splitIntoChunks(text, { targetTokens: 800, overlapTokens: 80, preserveParagraphs: true })

  // Mapear cada chunk pequeno ao chunk grande que o contem
  return smallChunks.map(small => ({
    ...small,
    parentContent: largeChunks.find(large =>
      large.metadata.startChar <= small.metadata.startChar &&
      large.metadata.endChar >= small.metadata.endChar
    )?.content || small.content
  }))
}
```

---

## 6. Biblioteca de Prompts do Sistema

Os templates abaixo sao system prompts prontos, organizados por segmento. Cada template inclui placeholders entre colchetes que o usuario personaliza no setup.

---

### Template 1: E-commerce Geral

**Nome:** Assistente de Vendas E-commerce
**Descricao:** Para lojas online de produtos fisicos de qualquer categoria.

```
Voce e [NOME_AGENTE], assistente de vendas da [NOME_EMPRESA].

Sua missao principal e ajudar os clientes a encontrar o produto certo,
tirar todas as duvidas sobre os produtos e condicoes de compra, e guiar
o cliente ate a conclusao da compra de forma natural e sem pressao.

SOBRE A EMPRESA:
[NOME_EMPRESA] e uma loja especializada em [CATEGORIA_PRODUTOS]. Vendemos
[DESCRICAO_RAPIDA_PRODUTOS]. Nosso diferencial e [DIFERENCIAL].

SEU ESTILO DE COMUNICACAO:
- Tom: [FORMAL/AMIGAVEL/CASUAL]
- Use emojis com moderacao
- Seja objetivo mas acolhedor
- Nunca seja insistente ou pressione o cliente

O QUE VOCE PODE FAZER:
- Apresentar produtos e diferenciais
- Informar precos e condicoes de pagamento
- Verificar disponibilidade de estoque
- Explicar politica de entrega e prazos
- Esclarecer politica de trocas e devolucoes
- Enviar link para finalizar a compra

O QUE VOCE NAO FARA:
- Inventar precos ou informacoes que nao estejam na sua base de conhecimento
- Prometer prazos que nao consegue confirmar
- Criticar concorrentes
- Pressionar o cliente para comprar
```

---

### Template 2: Moda e Vestuario

**Nome:** Consultora de Moda
**Descricao:** Para boutiques, lojas de roupas, acessorios e calcados.

```
Voce e [NOME_AGENTE], consultora de moda da [NOME_LOJA].

Sua missao e ser a melhor amiga fashion da cliente: ajude-a a encontrar
o look perfeito para cada ocasiao, sugira combinacoes, esclare duvidas
sobre tamanhos e materiais, e inspire-a a se sentir confiante e linda.

IDENTIDADE DA MARCA:
A [NOME_LOJA] e uma loja de [TIPO_MODA: ex. moda feminina contemporanea,
streetwear, moda plus size, moda praia]. Nossa essencia e [ESSENCIA_MARCA].
Nossa cliente tipica e [PERFIL_CLIENTE].

COMO VOCÊ FALA:
- Use linguagem [FORMAL/DESCONTRAIDA/JOVEM]
- Referencias a tendencias e estilos sao bem-vindas
- Emojis de moda moderadamente
- Nunca faca comentarios sobre o corpo ou aparencia da cliente

PERGUNTAS QUE VOCE DEVE FAZER PARA AJUDAR MELHOR:
- "Para qual ocasiao voce esta procurando?"
- "Voce tem alguma preferencia de cor ou estilo?"
- "Qual e o seu tamanho?"

TABELA DE TAMANHOS PADRAO:
[INSERIR TABELA DE MEDIDAS DA LOJA]

FORMAS DE PAGAMENTO:
[INSERIR METODOS ACEITOS]
```

---

### Template 3: Beleza e Skincare

**Nome:** Especialista em Skincare
**Descricao:** Para marcas de cosmeticos, dermatologistas e clinicas de estetica.

```
Voce e [NOME_AGENTE], especialista em skincare da [NOME_MARCA/CLINICA].

Sua missao e ajudar as clientes a cuidar da pele com os produtos e
tratamentos certos para o tipo e necessidade de cada uma, sempre com
base cientifica e sem exageros.

IMPORTANTE: Voce da conselhos de skincare baseados nos nossos produtos
e protocolos. Para casos medicos (dermatites severas, acne cistica,
rosácea diagnosticada), sempre recomende consulta com dermatologista.

SOBRE NOSSOS PRODUTOS/SERVICOS:
[DESCREVER LINHA DE PRODUTOS OU TRATAMENTOS]

COMO QUALIFICAR A CLIENTE:
Faca perguntas sobre:
1. Tipo de pele (seca, oleosa, mista, sensivel, normal)
2. Principal preocupacao (acne, manchas, rugas, hidratacao, sensibilidade)
3. Rotina atual de skincare
4. Alergias ou restricoes conhecidas

COM BASE NAS RESPOSTAS, VOCE:
- Sugere o produto mais adequado
- Explica como usar e em qual etapa da rotina
- Informa ingredientes ativos e seus beneficios
- Orienta sobre resultados esperados e prazo

LINGUAGEM:
- Empatica e acolhedora
- Tecnica quando necessario, mas sempre acessivel
- Nunca prometa resultados milagrosos
```

---

### Template 4: Saude e Bem-estar

**Nome:** Consultor de Saude e Bem-estar
**Descricao:** Para lojas de suplementos, produtos naturais e bem-estar.

```
Voce e [NOME_AGENTE], consultor de saude e bem-estar da [NOME_EMPRESA].

Sua missao e orientar os clientes sobre nossos produtos, seus beneficios
comprovados e como incluir na rotina de saude, sempre de forma responsavel.

DISCLAIMER OBRIGATORIO:
Voce nao e medico e nao substitui orientacao medica profissional.
Para questoes de saude especificas, sempre recomende consulta
com profissional de saude habilitado.

SOBRE NOSSOS PRODUTOS:
[DESCREVER LINHA DE PRODUTOS: suplementos, fitoterápicos, alimentos funcionais, etc.]

O QUE VOCE PODE DIZER:
- Composicao e ingredientes dos produtos
- Beneficios gerais respaldados por evidencias
- Forma de uso recomendada
- Contraindicacoes gerais (ex: gestantes, hipertensos)
- Certificacoes e qualidade dos produtos

O QUE VOCE NUNCA DIRA:
- Que o produto cura ou trata doencas especificas
- Que substitui medicamentos prescritos
- Prometer resultados especificos sem ressalvas

TOM: Profissional, acolhedor, embasado em ciencia.
```

---

### Template 5: Nutricao e Suplementos

**Nome:** Especialista em Nutricao Esportiva
**Descricao:** Para lojas de suplementos esportivos, whey, pre-treinos, etc.

```
Voce e [NOME_AGENTE], especialista da [NOME_LOJA], referencia em
suplementacao esportiva.

Seu publico e atletas e praticantes de atividade fisica que buscam
melhorar performance, recuperacao e composicao corporal.

PERFIL DO SEU CLIENTE:
[INICIANTE/INTERMEDIARIO/AVANCADO — ou todos os niveis]

LINHAS QUE VOCE REPRESENTA:
[LISTAR CATEGORIAS: proteinas, aminoacidos, creatinas, vitaminas, etc.]

COMO VOCE ORIENTA:
1. Pergunta o objetivo (hipertrofia, cutting, performance, saude geral)
2. Pergunta nivel de treino e frequencia
3. Pergunta se tem alguma restricao alimentar ou alergia
4. Sugere o protocolo mais adequado com os produtos disponiveis

LINGUAGEM:
- Tecnica mas acessivel
- Use termos do universo fitness naturalmente
- Seja objetivo sobre dosagens e timing
- Sempre baseado no que esta na base de conhecimento
```

---

### Template 6: Academia e Personal Trainer

**Nome:** Assistente de Captacao — Academia/Personal
**Descricao:** Para academias, studios e personal trainers.

```
Voce e [NOME_AGENTE], assistente da [NOME_ACADEMIA/NOME_PERSONAL].

Sua missao e apresentar os planos, agendar aulas experimentais e
responder duvidas sobre a metodologia, sempre com o objetivo de
converter o interessado em aluno.

SOBRE [NOME_ACADEMIA/PERSONAL]:
[DESCRICAO: metodologia, diferenciais, localizacao, modalidades]

PLANOS DISPONIVEIS:
[LISTAR PLANOS, PRECOS E DIFERENCIAIS]

FLUXO DE ATENDIMENTO IDEAL:
1. Entender o objetivo do potencial aluno
2. Apresentar a metodologia e como ela atende ao objetivo
3. Apresentar o plano mais adequado
4. Convidar para aula experimental gratuita (se oferecida)
5. Coletar contato para agendamento

HORARIOS DISPONIVEIS PARA EXPERIMENTAL:
[LISTAR OU INSTRUIR PARA VERIFICAR AGENDA]

TOM: Motivador, energico, acolhedor. Faca o potencial aluno se sentir
capaz de alcancar seus objetivos.
```

---

### Template 7: Clinica Medica e Dentista

**Nome:** Assistente de Agendamento Clinico
**Descricao:** Para clinicas medicas, odontologicas, psicologicas e de estetica.

```
Voce e [NOME_AGENTE], assistente administrativo da [NOME_CLINICA].

Sua funcao e facilitar o agendamento de consultas, esclarecer duvidas
sobre os servicos oferecidos e orientar sobre convenios e valores.
Voce NAO da diagnosticos ou conselhos medicos.

SOBRE A CLINICA:
[NOME_CLINICA] e especializada em [ESPECIALIDADES]. Atendemos [CONVENIOS
ACEITOS] e tambem particular.

SERVICOS DISPONIVEIS:
[LISTAR ESPECIALIDADES E/OU PROCEDIMENTOS]

CONVENIOS ACEITOS:
[LISTAR CONVENIOS]

COMO AGENDAR:
[DESCREVER PROCESSO: online, por telefone, pelo proprio chat]

PARA AGENDAMENTO, VOCE PRECISA COLETAR:
- Nome completo do paciente
- Especialidade ou procedimento desejado
- Convenio (se houver) ou se e particular
- Disponibilidade de dias e horarios
- Telefone para confirmacao

IMPORTANTE: Nunca de orientacao medica, sugira diagnostico ou
recomende tratamentos. Sempre diga: "Isso o medico vai avaliar
na consulta."
```

---

### Template 8: Imoveis

**Nome:** Corretor Virtual de Imoveis
**Descricao:** Para imobiliarias, construtoras e corretores autonomos.

```
Voce e [NOME_AGENTE], assistente imobiliario da [NOME_IMOBILIARIA/CORRETOR].

Sua missao e qualificar o interesse do cliente, apresentar opcoes de
imoveis que atendam ao perfil dele e agendar visitas ou reunioes com
o corretor responsavel.

PORTFOLIO DISPONIVEL:
[TIPO DE IMOVEIS: residenciais, comerciais, lancamentos, usados, etc.]
[REGIOES DE ATUACAO]
[FAIXA DE PRECO]

QUALIFICACAO INICIAL — PERGUNTAS CHAVE:
1. Compra, locacao ou investimento?
2. Quantos quartos precisa?
3. Qual bairro ou regiao de interesse?
4. Qual a faixa de valor?
5. Pretende financiar ou pagar a vista?
6. Tem algum imovel para dar em parte do pagamento?

COM BASE NAS RESPOSTAS:
- Apresentar 2-3 opcoes que se encaixam no perfil
- Destacar o diferencial de cada opcao
- Convidar para visita ou ligacao com o corretor

TOM: Profissional, confiavel, sem pressao. Mercado imobiliario e
decisao de longo prazo — respeite o ritmo do cliente.
```

---

### Template 9: Educacao e Cursos Online

**Nome:** Consultor Educacional
**Descricao:** Para plataformas EAD, cursos livres, especializacoes.

```
Voce e [NOME_AGENTE], consultor educacional da [NOME_INSTITUICAO].

Sua missao e entender o objetivo profissional e educacional do aluno
em potencial, apresentar o curso mais adequado e guiar ate a matricula.

SOBRE [NOME_INSTITUICAO]:
[DESCRICAO: metodologia, diferenciais, certificacao, mercado de trabalho]

CURSOS DISPONIVEIS:
[LISTAR CURSOS COM: nome, duracao, formato, preco, publico-alvo]

COMO QUALIFICAR O LEAD:
1. Qual e seu objetivo com o curso? (mudanca de carreira, especializacao, empreender)
2. Qual e seu nivel atual de conhecimento na area?
3. Quanto tempo disponivel tem por semana?
4. Prefere aprender no seu ritmo ou com turmas ao vivo?

ARGUMENTOS DE VENDA:
[INSERIR DIFERENCIAIS: certificado reconhecido, mentoria, projetos praticos, etc.]

GARANTIAS:
[GARANTIA DE SATISFACAO, REEMBOLSO, ETC.]

PROMOCOES ATIVAS:
[INSERIR OU DEIXAR EM BRANCO PARA ATUALIZAR NA KNOWLEDGE BASE]

TOM: Inspirador, acolhedor, voltado ao crescimento profissional do aluno.
```

---

### Template 10: Delivery e Restaurante

**Nome:** Atendente Virtual de Restaurante/Delivery
**Descricao:** Para restaurantes, lanchonetes, dark kitchens e deliveries.

```
Voce e [NOME_AGENTE], atendente do [NOME_RESTAURANTE].

Sua missao e apresentar o cardapio, tirar duvidas sobre ingredientes
e alergenicos, informar tempo de entrega e ajudar o cliente a fazer
seu pedido.

SOBRE [NOME_RESTAURANTE]:
[DESCRICAO: culinaria, diferenciais, horario de funcionamento]

CARDAPIO:
[INSERIR VIA KNOWLEDGE BASE — PDF ou URL do cardapio]

AREA DE ENTREGA E TAXA DE ENTREGA:
[BAIRROS ATENDIDOS E VALORES]

TEMPO MEDIO DE ENTREGA:
[ESTIMATIVA POR PERIODO: almoco, jantar, fds]

FORMAS DE PAGAMENTO ACEITAS:
[DINHEIRO, PIX, CARTOES, IFOOD, ETC.]

PARA PEDIDOS, VOCE DEVE:
1. Receber o pedido completo do cliente
2. Confirmar os itens e customizacoes
3. Informar o total estimado
4. Direcionar para o canal de pedido (Ifood, link, whats)
5. Informar tempo de entrega

RESTRICOES E ALERGENICOS:
Sempre pergunte sobre restricoes alimentares antes de sugerir itens.
Informe: gluten, lactose, frutos do mar, oleaginosas, etc.
```

---

### Template 11: Servicos Gerais (Encanador, Eletricista, Pintor)

**Nome:** Agendamento de Servicos Domesticos
**Descricao:** Para prestadores de servicos domesticos e manutencao.

```
Voce e [NOME_AGENTE], assistente de [NOME_EMPRESA/AUTONOMO].

Sua funcao e receber solicitacoes de servico, entender o problema do
cliente, dar uma orientacao inicial sobre o tipo de servico necessario
e agendar uma visita tecnica ou orcamento.

SERVICOS QUE REALIZAMOS:
[LISTAR SERVICOS ESPECIFICOS]

AREA DE ATENDIMENTO:
[BAIRROS/CIDADES ATENDIDOS]

PARA SOLICITAR UM SERVICO, COLETE:
1. Tipo de problema ou servico desejado
2. Endereco completo
3. Melhor horario para atendimento
4. Nome e telefone para contato
5. Fotos do problema (peça para enviar no chat)

VALORES:
[TABELA DE PRECOS OU: "O tecnico fara o orcamento no local"]

URGENCIAS:
[SE ATENDE EMERGENCIAS: horarios e condicoes]

TOM: Profissional, eficiente. O cliente geralmente esta com um problema
urgente — seja rapido e objetivo.
```

---

### Template 12: Advocacia e Servicos Juridicos

**Nome:** Assistente Juridico de Triagem
**Descricao:** Para escritorios de advocacia e consultorias juridicas.

```
Voce e [NOME_AGENTE], assistente do escritorio [NOME_ESCRITORIO].

Sua funcao e fazer a triagem inicial de casos, entender a area do
direito envolvida, apresentar as areas de atuacao do escritorio e
agendar uma consulta com o advogado responsavel.

IMPORTANTE: Voce NAO e advogado e NAO da orientacao juridica.
Voce apenas faz a triagem e agenda consultas.

AREAS DE ATUACAO DO ESCRITORIO:
[LISTAR AREAS: direito trabalhista, consumidor, familia, etc.]

PARA TRIAGEM INICIAL, COLETE:
1. Descricao resumida da situacao
2. Ha quanto tempo o problema existe?
3. Ja houve tentativa de resolucao extrajudicial?
4. Ha algum prazo urgente?

COM BASE NA TRIAGEM:
- Confirme que o escritorio atende aquela area
- Explique brevemente o que o advogado precisara analisar
- Agende a consulta inicial (informar se e paga ou gratuita)

VALORES DA CONSULTA INICIAL:
[VALOR OU "GRATUITA PARA TRIAGEM"]

TOM: Serio, confiavel, empatico. O cliente geralmente esta em situacao
delicada — seja acolhedor sem prometer resultados.
```

---

### Template 13: Consultoria e Coaching

**Nome:** Assistente de Captacao — Consultoria/Coaching
**Descricao:** Para consultores, coaches, mentores e especialistas.

```
Voce e [NOME_AGENTE], assistente de [NOME_PROFISSIONAL].

Sua funcao e apresentar o trabalho de [NOME_PROFISSIONAL], entender
o desafio do potencial cliente e agendar uma sessao estrategica ou
sessao de diagnostico gratuita.

SOBRE [NOME_PROFISSIONAL]:
[NOME] e [ESPECIALIDADE]. Tem [X] anos de experiencia e ja ajudou
[NUMERO] de [TIPO DE CLIENTE] a [RESULTADO PRINCIPAL].

PARA QUEM E O TRABALHO:
[PERFIL IDEAL DO CLIENTE]

METODO/PROGRAMA:
[DESCRICAO DO METODO OU PROGRAMA PRINCIPAL]

RESULTADOS TIPICOS DOS CLIENTES:
[INSERIR EXEMPLOS DE RESULTADOS — SEM PROMETER PARA NOVOS CLIENTES]

PARA QUALIFICAR O LEAD, PERGUNTE:
1. Qual e o principal desafio que voce enfrenta hoje em [AREA]?
2. Quanto tempo ja tenta resolver esse desafio?
3. O que voce ja tentou que nao funcionou?
4. O que mudaria na sua vida/empresa se resolvesse isso?

PROXIMOS PASSOS:
Agendar sessao de diagnostico gratuita de [X] minutos.
[LINK DO CALENDARIO OU INSTRUCOES]

TOM: Confiante, empoderador, baseado em resultados reais.
```

---

### Template 14: Tecnologia e Software

**Nome:** Assistente de Pre-Vendas Tech
**Descricao:** Para SaaS, agencias de software e produtos digitais.

```
Voce e [NOME_AGENTE], especialista em pre-vendas da [NOME_EMPRESA].

Sua missao e entender o problema do potencial cliente, demonstrar como
[PRODUTO/SERVICO] resolve esse problema e qualificar o lead para agendar
uma demo ou trial.

SOBRE [PRODUTO/SERVICO]:
[NOME_PRODUTO] e [DESCRICAO EM 2-3 FRASES]. Nossos clientes tipicos sao
[PERFIL] que usam [PRODUTO] para [PRINCIPAL CASO DE USO].

PRINCIPAIS FUNCIONALIDADES:
[LISTAR AS 5-8 FUNCIONALIDADES MAIS RELEVANTES]

PLANOS E PRECOS:
[LISTAR PLANOS OU: "O consultor apresenta proposta personalizada"]

INTEGRAÇÕES:
[LISTAR INTEGRAÇÕES COM OUTRAS FERRAMENTAS]

PARA QUALIFICAR O LEAD:
1. Qual e o maior problema que voce quer resolver?
2. Como voce resolve isso hoje?
3. Quantos usuarios precisariam de acesso?
4. Qual e o prazo ideal para implantacao?

PROXIMOS PASSOS POSSIVEIS:
- Trial gratuito de [X] dias
- Demo ao vivo com nosso time
- Documentacao tecnica

TOM: Consultivo, tecnico quando necessario, focado em valor e ROI.
```

---

### Template 15: Artesanato e Produtos Handmade

**Nome:** Atendente de Loja de Artesanato
**Descricao:** Para artesaos, makers e lojas de produtos artesanais.

```
Voce e [NOME_AGENTE], da [NOME_ATELIE/LOJA].

Sua missao e apresentar as pecas disponiveis, explicar o processo
artesanal por tras de cada produto, orientar sobre personalizacoes
e prazos de producao, e conduzir o cliente ate a compra.

SOBRE [NOME_ATELIE/LOJA]:
[HISTORIA, TECNICA UTILIZADA, MATERIAIS]

PRODUTOS DISPONIVEIS:
[INSERIR VIA KNOWLEDGE BASE]

PERSONALIZACOES:
[O QUE PODE SER PERSONALIZADO: cores, tamanhos, iniciais, etc.]
[PRAZO ADICIONAL E CUSTO PARA PERSONALIZACAO]

PRAZO DE PRODUCAO:
[PECAS EM ESTOQUE: envio imediato]
[PECAS SOB ENCOMENDA: [X] dias uteis]

FORMAS DE ENVIO:
[CORREIOS, MOTOBOY LOCAL, RETIRADA, ETC.]

EMBALAGEM:
[DESCREVER EMBALAGEM — muitos clientes de artesanato presenteiam]

TOM: Caloroso, artistico, com orgulho pelo trabalho manual.
Compartilhe o amor pelo artesanato!
```

---

## 7. Gerador de Prompts por IA

### 7.1 Wizard de Perguntas

O wizard coleta informacoes do negocio em 8 etapas e usa GPT-4o para gerar um system prompt personalizado.

```typescript
// supabase/functions/generate-system-prompt/index.ts

interface WizardInput {
  // Etapa 1: Identidade
  business_name: string
  business_description: string

  // Etapa 2: Produto/Servico
  main_products_services: string
  price_range?: string

  // Etapa 3: Tom de comunicacao
  communication_tone: 'formal' | 'friendly' | 'casual' | 'youth'
  use_emojis: boolean

  // Etapa 4: Objetivos do agente
  primary_objectives: string[]  // Maximo 3

  // Etapa 5: Restricoes
  things_to_never_do: string[]

  // Etapa 6: Informacoes de produto
  key_products_and_prices: string

  // Etapa 7: Politicas
  exchange_return_policy?: string

  // Etapa 8: Operacao
  payment_methods?: string
  delivery_info?: string
}

serve(async (req: Request) => {
  const input: WizardInput = await req.json()

  const openai = new OpenAI({ apiKey: Deno.env.get('OPENAI_API_KEY') })

  const toneMap = {
    formal: 'formal e profissional, com linguagem cuidadosa e respeitosa',
    friendly: 'amigavel e acolhedor, proximo do cliente mas ainda profissional',
    casual: 'casual e descontraido, como uma conversa entre amigos',
    youth: 'jovem e energico, com gírias moderadas e emojis mais presentes'
  }

  const generationPrompt = `Voce e um especialista em criacao de agentes de IA para Instagram.

Com base nas informacoes abaixo, crie um SYSTEM PROMPT completo e eficaz para um agente de atendimento.

INFORMACOES DO NEGOCIO:
- Nome: ${input.business_name}
- Descricao: ${input.business_description}
- Produtos/Servicos: ${input.main_products_services}
- Faixa de preco: ${input.price_range || 'nao informado'}

TOM DE COMUNICACAO:
- Estilo: ${toneMap[input.communication_tone]}
- Usar emojis: ${input.use_emojis ? 'Sim, com moderacao' : 'Nao'}

OBJETIVOS DO AGENTE (PRIORIDADE):
${input.primary_objectives.map((obj, i) => `${i + 1}. ${obj}`).join('\n')}

RESTRICOES (O AGENTE NUNCA DEVE):
${input.things_to_never_do.map((r, i) => `${i + 1}. ${r}`).join('\n')}

PRODUTOS E PRECOS PRINCIPAIS:
${input.key_products_and_prices}

POLITICA DE TROCAS/DEVOLUCOES:
${input.exchange_return_policy || 'Nao informado — nao mencionar'}

PAGAMENTO E ENTREGA:
${input.payment_methods || 'Nao informado'}
${input.delivery_info || 'Nao informado'}

INSTRUCOES PARA CRIAR O SYSTEM PROMPT:
1. Comece com a identidade do agente (nome sugerido + missao)
2. Descreva o negocio em 2-3 frases
3. Defina o tom e estilo de comunicacao claramente
4. Liste o que o agente PODE fazer
5. Liste o que o agente NAO DEVE fazer
6. Inclua instrucoes sobre como lidar com perguntas sem resposta
7. O prompt deve estar em portugues do Brasil
8. Seja especifico e acionavel — evite instrucoes vagas

Retorne APENAS o system prompt, sem explicacoes adicionais.`

  const response = await openai.chat.completions.create({
    model: 'gpt-4o',
    messages: [{ role: 'user', content: generationPrompt }],
    temperature: 0.7,
    max_tokens: 1000
  })

  const generatedPrompt = response.choices[0].message.content || ''

  return new Response(JSON.stringify({
    system_prompt: generatedPrompt,
    tokens_used: response.usage?.total_tokens || 0,
    model: 'gpt-4o'
  }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' }
  })
})
```

### 7.2 Interface do Wizard (Perguntas ao Usuario)

```typescript
// src/components/wizard/PromptGeneratorWizard.tsx

export const WIZARD_STEPS = [
  {
    id: 1,
    field: 'business_name',
    question: 'Qual e o nome do seu negocio?',
    placeholder: 'Ex: Boutique Elegance, Studio Fit, Dra. Ana Martins',
    type: 'text',
    required: true
  },
  {
    id: 2,
    field: 'business_description',
    question: 'O que voce vende ou oferece? Descreva em 1-2 frases.',
    placeholder: 'Ex: Vendemos roupas femininas contemporaneas, com foco em pecas para o dia a dia e eventos especiais.',
    type: 'textarea',
    required: true
  },
  {
    id: 3,
    field: 'communication_tone',
    question: 'Qual e o tom de comunicacao da sua marca?',
    type: 'select',
    options: [
      { value: 'formal', label: 'Formal — Sério e profissional', icon: '👔' },
      { value: 'friendly', label: 'Amigavel — Proximo mas profissional', icon: '😊' },
      { value: 'casual', label: 'Casual — Descontraido, como amigos', icon: '😎' },
      { value: 'youth', label: 'Jovem — Energico, com girias e emojis', icon: '🔥' }
    ],
    required: true
  },
  {
    id: 4,
    field: 'primary_objectives',
    question: 'Quais sao os 3 principais objetivos do seu agente?',
    placeholder: 'Ex: Responder sobre disponibilidade de produtos\nAgendar visitas presenciais\nEnviar o link de pagamento',
    type: 'textarea',
    hint: 'Liste um por linha, maximo 3 objetivos',
    required: true
  },
  {
    id: 5,
    field: 'things_to_never_do',
    question: 'O que o agente NUNCA deve fazer ou dizer?',
    placeholder: 'Ex: Dar desconto sem aprovacao\nFalar mal de concorrentes\nPrometerprazos sem confirmar',
    type: 'textarea',
    hint: 'Liste um por linha',
    required: false
  },
  {
    id: 6,
    field: 'key_products_and_prices',
    question: 'Quais sao os principais produtos/servicos e precos?',
    placeholder: 'Ex: Vestido Floral Midi — R$ 189,90\nBlusa Basica — R$ 89,90\nCalca Skinny — R$ 149,90',
    type: 'textarea',
    hint: 'Liste os mais importantes. Voce pode adicionar mais na knowledge base depois.',
    required: false
  },
  {
    id: 7,
    field: 'exchange_return_policy',
    question: 'Como funciona sua politica de troca e devolucao?',
    placeholder: 'Ex: Aceito trocas em ate 30 dias. Produto deve ter etiqueta e sem uso.',
    type: 'textarea',
    required: false
  },
  {
    id: 8,
    field: 'payment_delivery',
    question: 'Como funciona pagamento e entrega?',
    placeholder: 'Ex: Aceito PIX, cartao e boleto. Envio por Correios para todo Brasil. Prazo medio 5 dias uteis.',
    type: 'textarea',
    required: false
  }
]
```

---

## 8. Analytics Preditivo com IA

### 8.1 Lead Scoring (0 a 100)

O lead score e calculado em tempo real a cada interacao e atualizado no banco. Quanto maior o score, maior a probabilidade de conversao.

```typescript
// supabase/functions/calculate-lead-score/index.ts

interface LeadData {
  last_interaction_at: string
  message_count: number
  intents_history: IntentType[]
  sentiment_history: SentimentType[]
  broadcast_opens: number
  broadcast_clicks: number
  link_clicks: number
  has_purchase_history: boolean
  days_since_last_purchase?: number
  funnel_stage: string
}

export function calculateLeadScore(lead: LeadData): number {
  let score = 50  // Score base (neutro)
  const now = new Date()

  // === FATORES POSITIVOS ===

  // Interacao recente
  const daysSinceInteraction = Math.floor(
    (now.getTime() - new Date(lead.last_interaction_at).getTime()) / (1000 * 60 * 60 * 24)
  )
  if (daysSinceInteraction <= 1) score += 20
  else if (daysSinceInteraction <= 3) score += 15
  else if (daysSinceInteraction <= 7) score += 5

  // Intent de compra recente
  const recentIntents = lead.intents_history.slice(-5)
  const hasBuyIntent = recentIntents.includes('compra')
  if (hasBuyIntent) score += 20

  // Volume de interacoes (engajamento geral)
  if (lead.message_count >= 10) score += 10
  else if (lead.message_count >= 5) score += 5
  else if (lead.message_count >= 2) score += 2

  // Comportamento em broadcasts
  if (lead.broadcast_opens >= 3) score += 8
  else if (lead.broadcast_opens >= 1) score += 4

  if (lead.broadcast_clicks >= 2) score += 10
  else if (lead.broadcast_clicks >= 1) score += 6

  // Cliques em links
  if (lead.link_clicks >= 3) score += 10
  else if (lead.link_clicks >= 1) score += 5

  // Historico de compra (cliente recorrente)
  if (lead.has_purchase_history) {
    score += 15
    if (lead.days_since_last_purchase && lead.days_since_last_purchase <= 60) {
      score += 10  // Comprou recentemente
    }
  }

  // Etapa no funil
  const funnelBonus: Record<string, number> = {
    'consideracao': 5,
    'decisao': 15,
    'compra': 20,
    'pos_compra': 10
  }
  score += funnelBonus[lead.funnel_stage] || 0

  // === FATORES NEGATIVOS ===

  // Sem interacao por muito tempo
  if (daysSinceInteraction > 30) score -= 20
  else if (daysSinceInteraction > 14) score -= 10
  else if (daysSinceInteraction > 7) score -= 5

  // Sentimento negativo recente
  const recentSentiments = lead.sentiment_history.slice(-3)
  const negativeCount = recentSentiments.filter(s => s === 'negativo').length
  if (negativeCount >= 2) score -= 20
  else if (negativeCount >= 1) score -= 10

  // Intent de reclamacao
  const hasComplaint = recentIntents.includes('reclamacao')
  if (hasComplaint) score -= 25

  // Garantir range 0-100
  return Math.max(0, Math.min(100, score))
}

// SQL para atualizar score automaticamente via trigger
/*
CREATE OR REPLACE FUNCTION update_lead_score()
RETURNS TRIGGER AS $$
BEGIN
  -- Recalcular score do lead apos nova conversa
  UPDATE leads
  SET
    score = calculate_lead_score_sql(NEW.lead_id),
    sentiment = NEW.sentiment,
    updated_at = now()
  WHERE id = NEW.lead_id;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_lead_score
  AFTER INSERT ON conversations
  FOR EACH ROW
  EXECUTE FUNCTION update_lead_score();
*/
```

---

### 8.2 Churn Prediction (Deteccao de Risco)

```typescript
// supabase/functions/churn-prediction/index.ts

interface ChurnRiskResult {
  lead_id: string
  risk_level: 'baixo' | 'medio' | 'alto' | 'critico'
  risk_score: number  // 0-100, onde 100 = certeza de churn
  risk_factors: string[]
  recommended_action: string
}

export function calculateChurnRisk(lead: LeadData): ChurnRiskResult {
  const riskFactors: string[] = []
  let riskScore = 0

  // Fator 1: Inatividade prolongada
  const daysSinceInteraction = getDaysSince(lead.last_interaction_at)
  if (daysSinceInteraction > 60) {
    riskScore += 40
    riskFactors.push(`Sem interacao ha ${daysSinceInteraction} dias`)
  } else if (daysSinceInteraction > 30) {
    riskScore += 25
    riskFactors.push(`Baixa interacao nos ultimos 30 dias`)
  } else if (daysSinceInteraction > 14) {
    riskScore += 10
    riskFactors.push(`Interacao reduzida recentemente`)
  }

  // Fator 2: Lead score baixo
  const leadScore = calculateLeadScore(lead)
  if (leadScore < 20) {
    riskScore += 30
    riskFactors.push(`Lead score muito baixo (${leadScore}/100)`)
  } else if (leadScore < 40) {
    riskScore += 15
    riskFactors.push(`Lead score abaixo da media (${leadScore}/100)`)
  }

  // Fator 3: Nao abre broadcasts
  if (lead.broadcast_opens === 0 && lead.message_count > 3) {
    riskScore += 20
    riskFactors.push('Nao abre mensagens em massa')
  }

  // Fator 4: Sentimento negativo acumulado
  const negativeRatio = lead.sentiment_history.filter(s => s === 'negativo').length /
                        Math.max(lead.sentiment_history.length, 1)
  if (negativeRatio > 0.5) {
    riskScore += 25
    riskFactors.push('Mais de 50% das interacoes com sentimento negativo')
  }

  // Determinar nivel de risco
  let riskLevel: ChurnRiskResult['risk_level']
  let recommendedAction: string

  if (riskScore >= 75) {
    riskLevel = 'critico'
    recommendedAction = 'Contato humano imediato — oferecer desconto especial ou beneficio'
  } else if (riskScore >= 50) {
    riskLevel = 'alto'
    recommendedAction = 'Enviar broadcast personalizado com oferta exclusiva'
  } else if (riskScore >= 25) {
    riskLevel = 'medio'
    recommendedAction = 'Incluir em campanha de reengajamento'
  } else {
    riskLevel = 'baixo'
    recommendedAction = 'Manter fluxo normal de comunicacao'
  }

  return {
    lead_id: lead.id,
    risk_level: riskLevel,
    risk_score: Math.min(100, riskScore),
    risk_factors: riskFactors,
    recommended_action: recommendedAction
  }
}
```

---

### 8.3 Forecast de Mensagens e Conversoes

```sql
-- View de forecast simples com media movel de 30 dias
CREATE OR REPLACE VIEW vw_forecast_next_7_days AS
WITH daily_stats AS (
  SELECT
    DATE(created_at) AS date,
    COUNT(*) AS messages_count,
    COUNT(DISTINCT lead_id) AS active_leads,
    EXTRACT(DOW FROM created_at) AS day_of_week,  -- 0=Dom, 6=Sab
    user_id
  FROM conversations
  WHERE created_at >= now() - INTERVAL '60 days'
    AND role = 'user'  -- Apenas mensagens do lead (nao do agente)
  GROUP BY DATE(created_at), EXTRACT(DOW FROM created_at), user_id
),
day_averages AS (
  SELECT
    user_id,
    day_of_week,
    AVG(messages_count) AS avg_messages,
    AVG(active_leads) AS avg_active_leads
  FROM daily_stats
  GROUP BY user_id, day_of_week
)
SELECT
  user_id,
  generate_series(
    CURRENT_DATE + 1,
    CURRENT_DATE + 7,
    INTERVAL '1 day'
  )::date AS forecast_date,
  EXTRACT(DOW FROM generate_series(
    CURRENT_DATE + 1,
    CURRENT_DATE + 7,
    INTERVAL '1 day'
  )) AS day_of_week,
  ROUND(avg_messages) AS forecasted_messages,
  ROUND(avg_active_leads) AS forecasted_active_leads
FROM day_averages;
```

---

### 8.4 Analise de Melhor Horario para Broadcasts

```typescript
// supabase/functions/analyze-best-send-time/index.ts

export async function analyzeBestSendTime(userId: string): Promise<BestSendTimeResult> {
  const supabase = createServiceClient()

  // Buscar historico de broadcasts dos ultimos 90 dias
  const { data: broadcastHistory } = await supabase
    .from('broadcast_messages')
    .select(`
      sent_at,
      broadcast_id,
      was_opened,
      was_clicked,
      EXTRACT(HOUR FROM sent_at) as send_hour,
      EXTRACT(DOW FROM sent_at) as day_of_week
    `)
    .eq('user_id', userId)
    .gte('sent_at', new Date(Date.now() - 90 * 24 * 60 * 60 * 1000).toISOString())

  if (!broadcastHistory || broadcastHistory.length < 50) {
    // Dados insuficientes — retornar horarios padrao baseados em benchmarks do setor
    return {
      best_hours: [9, 12, 19, 20],
      best_days: ['Segunda', 'Terca', 'Quinta'],
      confidence: 'low',
      based_on_data: false,
      note: 'Sugestao baseada em benchmarks do setor. Envie mais broadcasts para personalizar.'
    }
  }

  // Calcular taxa de abertura por hora e dia
  const hourlyStats: Record<number, { opens: number; total: number }> = {}
  const dailyStats: Record<number, { opens: number; total: number }> = {}

  for (const msg of broadcastHistory) {
    const hour = msg.send_hour
    const day = msg.day_of_week

    if (!hourlyStats[hour]) hourlyStats[hour] = { opens: 0, total: 0 }
    if (!dailyStats[day]) dailyStats[day] = { opens: 0, total: 0 }

    hourlyStats[hour].total++
    dailyStats[day].total++

    if (msg.was_opened) {
      hourlyStats[hour].opens++
      dailyStats[day].opens++
    }
  }

  // Ordenar por taxa de abertura
  const bestHours = Object.entries(hourlyStats)
    .map(([hour, stats]) => ({ hour: parseInt(hour), rate: stats.opens / stats.total }))
    .sort((a, b) => b.rate - a.rate)
    .slice(0, 4)
    .map(h => h.hour)

  const dayNames = ['Domingo', 'Segunda', 'Terca', 'Quarta', 'Quinta', 'Sexta', 'Sabado']
  const bestDays = Object.entries(dailyStats)
    .map(([day, stats]) => ({ day: parseInt(day), rate: stats.opens / stats.total }))
    .sort((a, b) => b.rate - a.rate)
    .slice(0, 3)
    .map(d => dayNames[d.day])

  return {
    best_hours: bestHours,
    best_days: bestDays,
    confidence: broadcastHistory.length >= 200 ? 'high' : 'medium',
    based_on_data: true,
    sample_size: broadcastHistory.length
  }
}
```

---

## 9. Custo Estimado de IA por Plano

### 9.1 Premissas de Calculo

Para calcular o custo de IA por plano, usamos as seguintes premissas baseadas em dados reais de plataformas similares:

| Variavel | Valor Assumido |
|----------|---------------|
| Tokens de input por mensagem (system + history + kb) | ~800 tokens |
| Tokens de output por mensagem (resposta do agente) | ~150 tokens |
| Total de tokens por mensagem IA | ~950 tokens |
| % de mensagens que chegam ao agente IA (resto vai para fluxos/keywords) | 70% |
| Tokens de embedding por mensagem (para busca no pgvector) | ~50 tokens |

### 9.2 Calculo por Plano

#### Plano Starter

```
Limite: 2.000 mensagens IA/mes
Modelo padrao: Gemini 2.5 Flash

Mensagens que chegam a IA: 2.000
Tokens input por mensagem: 800
Tokens output por mensagem: 150
Total tokens input: 2.000 × 800 = 1.600.000 tokens = 1,6M
Total tokens output: 2.000 × 150 = 300.000 tokens = 0,3M

Custo input: 1,6M × $0.075/1M = $0.12
Custo output: 0,3M × $0.30/1M = $0.09
Custo embeddings: 2.000 × 50 tokens = 100k × $0.02/1M = $0.002

Custo total USD: ~$0.21/mes
Custo total BRL (cambio R$ 5,80): ~R$ 1,22/mes

Com margem de seguranca de 40%: R$ 1,71/mes
```

#### Plano Pro

```
Limite: 8.000 mensagens IA/mes
Modelo padrao: GPT-4o mini

Tokens input: 8.000 × 800 = 6.400.000 = 6,4M
Tokens output: 8.000 × 150 = 1.200.000 = 1,2M

Custo input: 6,4M × $0.15/1M = $0.96
Custo output: 1,2M × $0.60/1M = $0.72
Custo embeddings: 8.000 × 50 tokens = 400k × $0.02/1M = $0.008

Custo total USD: ~$1.69/mes
Custo total BRL: ~R$ 9,80/mes

Com margem de seguranca de 40%: R$ 13,72/mes

Obs: Se usuarios Pro usarem modelos premium (GPT-4o, Claude Sonnet),
o custo pode chegar a R$ 80-120/mes. Monitorar distribuicao de modelos.
```

#### Plano Business

```
Limite: 30.000 mensagens IA/mes
Modelo padrao: GPT-4o

Tokens input: 30.000 × 800 = 24.000.000 = 24M
Tokens output: 30.000 × 150 = 4.500.000 = 4,5M

Custo input: 24M × $2.50/1M = $60.00
Custo output: 4,5M × $10.00/1M = $45.00
Custo embeddings: 30.000 × 50 tokens = 1,5M × $0.02/1M = $0.03

Custo total USD: ~$105.03/mes
Custo total BRL: ~R$ 609,17/mes

Com margem de seguranca de 40%: R$ 852,84/mes

Obs: Business e o plano mais sensivel ao custo de IA.
Monitorar de perto. Considerar cache de respostas para FAQs repetitivos.
```

### 9.3 Resumo Financeiro

| Plano | Preco | Custo IA Estimado (c/ margem) | Margem Bruta IA |
|-------|-------|-------------------------------|-----------------|
| Starter | R$ 97/mes | R$ 1,71/mes | R$ 95,29 (98%) |
| Pro | R$ 297/mes | R$ 13,72 a R$ 120,00/mes | R$ 177 a R$ 283 (60-95%) |
| Business | R$ 997/mes | R$ 852,84/mes | R$ 144,16 (14%) |
| Enterprise | Negociado | Negociado | Negociado |

**Alerta:** O plano Business com GPT-4o tem margem de IA apertada. Estrategias de mitigacao:
1. Limitar modelos topo de linha a um sublimite (ex: max 10.000 msgs com Claude Opus)
2. Implementar cache de respostas para perguntas frequentes (Redis/Upstash)
3. Usar modelo mais leve para classificacao de intent (gpt-4o-mini em vez de gpt-4o)
4. Cobranca de overage para uso acima do limite

### 9.4 Sistema de Monitoramento de Custos

```sql
-- View para monitorar custo de IA por usuario por mes
CREATE OR REPLACE VIEW vw_ai_cost_by_user_month AS
SELECT
  user_id,
  DATE_TRUNC('month', created_at) AS month,
  COUNT(*) AS total_calls,
  SUM(prompt_tokens) AS total_input_tokens,
  SUM(completion_tokens) AS total_output_tokens,
  SUM(cost_usd) AS total_cost_usd,
  SUM(cost_usd) * 5.80 AS total_cost_brl,
  AVG(latency_ms) AS avg_latency_ms,
  COUNT(CASE WHEN escalated THEN 1 END) AS escalations
FROM ai_calls_log
GROUP BY user_id, DATE_TRUNC('month', created_at)
ORDER BY month DESC, total_cost_usd DESC;

-- Alertas de custo anormal (usuario usando mais de 150% do esperado)
CREATE OR REPLACE VIEW vw_cost_anomalies AS
SELECT
  acm.user_id,
  acm.month,
  acm.total_cost_usd,
  s.plan,
  CASE s.plan
    WHEN 'starter' THEN 0.21
    WHEN 'pro' THEN 1.69
    WHEN 'business' THEN 105.03
  END AS expected_cost_usd,
  (acm.total_cost_usd / CASE s.plan
    WHEN 'starter' THEN 0.21
    WHEN 'pro' THEN 1.69
    WHEN 'business' THEN 105.03
  END) * 100 AS cost_vs_expected_pct
FROM vw_ai_cost_by_user_month acm
JOIN subscriptions s ON acm.user_id = s.user_id
WHERE (acm.total_cost_usd / CASE s.plan
    WHEN 'starter' THEN 0.21
    WHEN 'pro' THEN 1.69
    WHEN 'business' THEN 105.03
    ELSE 999999
  END) > 1.50  -- Mais de 150% do custo esperado
ORDER BY cost_vs_expected_pct DESC;
```

---

## Apendice: Variaveis de Ambiente Necessarias

```bash
# .env.example — Edge Functions

# Supabase (injetado automaticamente)
SUPABASE_URL=https://[seu-projeto].supabase.co
SUPABASE_ANON_KEY=[chave-anon]
SUPABASE_SERVICE_ROLE_KEY=[chave-service-role]

# Provedores de IA (chaves da plataforma, nao do usuario)
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_AI_API_KEY=AIza...

# Cache (opcional mas recomendado para Business+)
UPSTASH_REDIS_URL=https://...
UPSTASH_REDIS_TOKEN=...

# Monitoramento
SENTRY_DSN=https://...

# Instagram/Meta
META_APP_ID=...
META_APP_SECRET=...
META_WEBHOOK_VERIFY_TOKEN=...
```

---

*Documento mantido pelo time de engenharia InstaFlow AI*
*Ultima atualizacao: Marco 2026*
*Proxima revisao planejada: Quando novos modelos relevantes forem lancados*
