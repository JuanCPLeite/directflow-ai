# InstaFlow AI — Arquitetura Técnica Completa

> Versão: 1.0.0
> Data: 2026-03-11
> Status: Living Document

---

## Sumário

1. [Visão Geral da Arquitetura](#1-visão-geral-da-arquitetura)
2. [Stack Completa com Versões](#2-stack-completa-com-versões)
3. [Estrutura de Pastas](#3-estrutura-de-pastas)
4. [Variáveis de Ambiente](#4-variáveis-de-ambiente)
5. [Fluxo de Autenticação](#5-fluxo-de-autenticação)
6. [Meta OAuth e Instagram Business API](#6-meta-oauth-e-instagram-business-api)
7. [Fluxo do Agente de IA](#7-fluxo-do-agente-de-ia)
8. [Sistema de Embeddings e Busca Semântica](#8-sistema-de-embeddings-e-busca-semântica)
9. [Sistema de Realtime](#9-sistema-de-realtime)
10. [Stripe Integration](#10-stripe-integration)
11. [Segurança](#11-segurança)
12. [Deploy e CI/CD](#12-deploy-e-cicd)
13. [Performance](#13-performance)

---

## 1. Visão Geral da Arquitetura

### 1.1 Diagrama do Sistema Completo

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          USUÁRIO FINAL (Brasil)                         │
│                    Chrome / Safari / Mobile Browser                     │
└──────────────────────────────┬──────────────────────────────────────────┘
                               │ HTTPS
                               ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        CLOUDFLARE (CDN + WAF)                           │
│              Rate Limiting · DDoS Protection · Cache de Edge            │
└──────────────────────────────┬──────────────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         VERCEL (Frontend)                               │
│                    React 18 + TypeScript + Vite                         │
│                                                                         │
│  ┌────────────┐  ┌──────────┐  ┌───────────┐  ┌──────────────────┐    │
│  │  Dashboard │  │  Agents  │  │Flow Builder│  │   Inbox / CRM    │    │
│  └────────────┘  └──────────┘  └───────────┘  └──────────────────┘    │
│                                                                         │
│  ┌────────────┐  ┌──────────┐  ┌───────────┐  ┌──────────────────┐    │
│  │ Broadcasts │  │Analytics │  │  Settings  │  │  Knowledge Base  │    │
│  └────────────┘  └──────────┘  └───────────┘  └──────────────────┘    │
└──────────────────────────────┬──────────────────────────────────────────┘
                               │ Supabase JS Client (WSS + HTTPS)
                               ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                       SUPABASE CLOUD (Backend)                          │
│                                                                         │
│  ┌─────────────────┐  ┌──────────────────┐  ┌───────────────────────┐  │
│  │  Supabase Auth  │  │  Supabase Storage│  │  Supabase Realtime    │  │
│  │  (JWT / OAuth)  │  │  (imagens/docs)  │  │  (WS canais/presença) │  │
│  └─────────────────┘  └──────────────────┘  └───────────────────────┘  │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │                   EDGE FUNCTIONS (Deno)                         │    │
│  │                                                                 │    │
│  │  webhook-instagram  │  ai-chat  │  ai-embeddings               │    │
│  │  broadcast-send     │  stripe-webhook  │  cron-trial-check     │    │
│  └─────────────────────────────────────────────────────────────────┘    │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐    │
│  │             PostgreSQL 15 + pgvector 0.5+                       │    │
│  │                                                                 │    │
│  │  profiles · subscriptions · instagram_accounts                 │    │
│  │  agents · knowledge_bases · knowledge_documents                │    │
│  │  leads · conversations · messages                              │    │
│  │  flows · keywords · broadcasts · analytics                     │    │
│  │  team_members · audit_logs                                     │    │
│  └─────────────────────────────────────────────────────────────────┘    │
└──────────┬───────────────────┬──────────────────┬───────────────────────┘
           │                   │                  │
           ▼                   ▼                  ▼
┌──────────────────┐  ┌────────────────┐  ┌─────────────────┐
│  META GRAPH API  │  │   AI PROVIDERS │  │  STRIPE API      │
│  v18+            │  │                │  │                  │
│  - Instagram DM  │  │  OpenAI        │  │  Checkout        │
│  - Comments      │  │  Anthropic     │  │  Subscriptions   │
│  - Webhooks      │  │  Google AI     │  │  Webhooks        │
│  - Stories       │  │  (embeddings)  │  │  Portal          │
└──────────────────┘  └────────────────┘  └─────────────────┘
```

### 1.2 Princípios Arquiteturais

**1. Supabase como Backend Completo (BaaS-First)**

A decisão de usar Supabase elimina a necessidade de um servidor Node.js/Express dedicado. Toda a lógica de negócio fica em Edge Functions (Deno), PostgreSQL Functions/Triggers e RLS Policies. Isso reduz:
- Custo operacional (zero servidor sempre ligado)
- Complexidade de deploy
- Surface de ataque

**2. Multi-tenancy por Design com RLS**

Cada linha de dados é associada ao `user_id` do owner. Row Level Security (RLS) no PostgreSQL garante isolamento total de dados entre usuários. Não é possível acessar dados de outro usuário mesmo com um JWT válido — o banco rejeita na camada de dados.

**3. Edge Functions como Orquestrador**

Toda lógica que requer service_role (acesso irrestrito ao banco), chamadas a APIs externas (Meta, OpenAI, Stripe) ou processamento assíncrono (webhooks) reside em Edge Functions. O frontend nunca tem acesso à service_role_key.

**4. Realtime para Experiência Live**

Supabase Realtime (baseado em Phoenix Channels/Elixir) proporciona:
- Inbox com mensagens em tempo real
- Notificações push sem polling
- Presença de agentes (online/offline/typing)
- Sincronização de estado entre abas

**5. pgvector como Motor Semântico**

Em vez de um serviço externo de busca vetorial (Pinecone, Weaviate), pgvector integrado ao PostgreSQL mantém embeddings e dados transacionais no mesmo banco. Queries semânticas podem fazer JOIN com dados relacionais — essencial para filtrar por `user_id`, `agent_id`, etc.

**6. Sem n8n / Sem Backend Separado**

n8n introduziria uma dependência externa, complexidade de orquestração e potencial ponto único de falha. Toda automação (Keywords → Ação, Fluxos de conversa, Broadcasts agendados) é gerenciada por:
- Triggers e Functions no PostgreSQL
- Edge Functions invocadas por webhooks ou pg_cron
- Supabase Realtime para coordenação de estado

### 1.3 Decisões Técnicas Chave

| Decisão | Alternativa Rejeitada | Motivo da Escolha |
|---|---|---|
| Supabase | Firebase | PostgreSQL + RLS + pgvector + SQL real |
| Zustand | Redux / Jotai | Mínimo boilerplate, TypeScript nativo |
| ReactFlow | custom canvas | Mature, extensível, open source |
| shadcn/ui | MUI / Chakra | Componentes no código, sem dependência de runtime |
| Deno Edge Functions | Node Lambda | Zero cold start, isolamento por request |
| Recharts | Chart.js / Victory | Compatibilidade total com React 18, composable |
| Resend | SendGrid | DX superior, pricing simples, confiável no Brasil |

---

## 2. Stack Completa com Versões

### 2.1 Frontend

```
Framework principal:
  react                    ^18.3.1    — UI declarativa com Concurrent Mode
  react-dom                ^18.3.1
  typescript               ^5.5.3     — Type safety end-to-end
  vite                     ^5.4.2     — Build tool com HMR instantâneo

Roteamento:
  react-router-dom         ^6.26.1    — Rotas declarativas, data loaders

UI e Estilo:
  tailwindcss              ^3.4.10    — Utility-first CSS
  @tailwindcss/typography  ^0.5.15    — Prose styles para markdown
  tailwind-merge           ^2.5.2     — Merge condicional de classes
  tailwind-animate         ^1.0.7     — Animações CSS via Tailwind
  class-variance-authority ^0.7.0     — Variantes de componente type-safe
  clsx                     ^2.1.1     — Utilitário de classnames

Componentes (shadcn/ui — código gerado no projeto):
  @radix-ui/react-*        ^1.x       — Primitivos acessíveis (Dialog, Popover, etc.)
  lucide-react             ^0.441.0   — Ícones SVG

Estado Global:
  zustand                  ^4.5.5     — State management mínimo

Formulários e Validação:
  react-hook-form          ^7.53.0    — Performance-first forms
  @hookform/resolvers      ^3.9.0     — Adaptador Zod
  zod                      ^3.23.8    — Schema validation

Flow Builder:
  @xyflow/react            ^12.3.0    — (ReactFlow v12) Visual flow editor

Gráficos:
  recharts                 ^2.12.7    — Gráficos composable para React

Comunicação com Supabase:
  @supabase/supabase-js    ^2.45.4    — Cliente oficial

Data Fetching / Cache:
  @tanstack/react-query    ^5.56.2    — Server state, caching, invalidation

Animações:
  framer-motion            ^11.7.0    — Animações declarativas

Utilitários de Data:
  date-fns                 ^3.6.0     — Manipulação de datas
  date-fns/locale/pt-BR               — Locale brasileiro

Notificações:
  react-hot-toast          ^2.4.1     — Toast notifications

Markdown:
  react-markdown           ^9.0.1     — Render de markdown na inbox
  remark-gfm               ^4.0.0     — GitHub Flavored Markdown

Upload:
  @uploadthing/react       ^6.7.2     — Upload de arquivos (via Supabase Storage adapter)

Monitoramento:
  @sentry/react            ^8.30.0    — Error tracking no frontend
```

### 2.2 Backend (Supabase)

```
Banco de Dados:
  PostgreSQL               15.x       — Banco relacional principal
  pgvector                 0.7.x      — Extensão de vetores para embeddings
  pg_cron                  1.6.x      — Jobs agendados no banco

Supabase:
  Supabase Auth                       — Autenticação JWT + OAuth
  Supabase Edge Functions  Deno 1.x   — Serverless functions
  Supabase Storage                    — Objeto Storage (S3-compatible)
  Supabase Realtime                   — WebSocket channels (Phoenix)

Runtime Edge Functions:
  deno                     1.46.x
  @supabase/supabase-js    2.x        (via esm.sh CDN)
  std/http                 0.177.0    — Servidor HTTP Deno
```

### 2.3 Infraestrutura

```
Frontend Hosting:
  Vercel                   — CDN global, Preview Deployments, Edge Network

Backend Hosting:
  Supabase Cloud           — Managed PostgreSQL + Edge Runtime

CDN e Segurança:
  Cloudflare               — CDN, WAF, Rate Limiting, Bot Protection
```

### 2.4 APIs Externas

```
Redes Sociais:
  Meta Graph API           v18.0+     — Instagram DM, Comentários, Webhooks

Inteligência Artificial:
  OpenAI API                          — gpt-4o, gpt-4o-mini, o3-mini
                                        text-embedding-3-small (embeddings)
  Anthropic API                       — claude-sonnet-4-6, claude-haiku-4-5, claude-opus-4-6
  Google AI API                       — gemini-2.5-pro, gemini-2.5-flash, gemini-2.0-flash

Pagamentos:
  Stripe API               2024-09-30 — Subscriptions, Checkout, Portal, Webhooks

Email Transacional:
  Resend                   v3         — Emails de boas-vindas, alertas, relatórios

Monitoramento:
  Sentry                   SDK 8.x    — Error tracking, Performance monitoring
```

---

## 3. Estrutura de Pastas

```
instaflow-ai/
│
├── docs/                               ← Documentação do projeto
│   ├── ARCHITECTURE.md                 ← Este arquivo
│   ├── DATABASE.md                     ← Schema completo e relacionamentos
│   ├── API.md                          ← Edge Functions: endpoints e contratos
│   └── ONBOARDING.md                   ← Guia para novos devs
│
├── public/                             ← Assets estáticos (não processados pelo Vite)
│   ├── favicon.ico
│   ├── robots.txt
│   └── og-image.png
│
├── src/
│   │
│   ├── assets/                         ← Assets importados pelo Vite (SVGs, fontes)
│   │   ├── logo.svg
│   │   └── logo-dark.svg
│   │
│   ├── components/
│   │   │
│   │   ├── ui/                         ← Componentes shadcn/ui (gerados + customizados)
│   │   │   ├── button.tsx
│   │   │   ├── card.tsx
│   │   │   ├── dialog.tsx
│   │   │   ├── dropdown-menu.tsx
│   │   │   ├── form.tsx
│   │   │   ├── input.tsx
│   │   │   ├── label.tsx
│   │   │   ├── popover.tsx
│   │   │   ├── select.tsx
│   │   │   ├── separator.tsx
│   │   │   ├── sheet.tsx
│   │   │   ├── skeleton.tsx
│   │   │   ├── switch.tsx
│   │   │   ├── table.tsx
│   │   │   ├── tabs.tsx
│   │   │   ├── textarea.tsx
│   │   │   ├── toast.tsx
│   │   │   └── tooltip.tsx
│   │   │
│   │   ├── layout/                     ← Componentes de estrutura da aplicação
│   │   │   ├── AppLayout.tsx           ← Layout principal (Sidebar + Header + Outlet)
│   │   │   ├── Sidebar.tsx             ← Navegação lateral com itens por plano
│   │   │   ├── Header.tsx              ← Barra superior (breadcrumb, notif, user menu)
│   │   │   ├── MobileNav.tsx           ← Navegação bottom-sheet para mobile
│   │   │   └── ProtectedRoute.tsx      ← HOC de proteção de rota + verificação de plano
│   │   │
│   │   ├── auth/                       ← Componentes de autenticação
│   │   │   ├── LoginForm.tsx           ← Email/senha + Google OAuth
│   │   │   ├── RegisterForm.tsx        ← Cadastro com validação Zod
│   │   │   ├── ForgotPasswordForm.tsx  ← Recuperação de senha
│   │   │   ├── ResetPasswordForm.tsx   ← Redefinição via link de email
│   │   │   ├── OnboardingWizard.tsx    ← Wizard pós-cadastro (5 steps)
│   │   │   │                           ← Step 1: Dados da empresa
│   │   │   │                           ← Step 2: Conectar Instagram
│   │   │   │                           ← Step 3: Criar primeiro agente
│   │   │   │                           ← Step 4: Configurar knowledge base
│   │   │   │                           ← Step 5: Testar conversa demo
│   │   │   └── TrialBanner.tsx         ← Banner de trial expirando (countdown)
│   │   │
│   │   ├── dashboard/
│   │   │   ├── StatsCards.tsx          ← Cards de métricas (mensagens, leads, etc.)
│   │   │   ├── RecentConversations.tsx ← Lista das últimas conversas
│   │   │   ├── AgentStatusWidget.tsx   ← Status dos agentes ativos
│   │   │   ├── RevenueChart.tsx        ← Gráfico de conversões/receita
│   │   │   └── QuickActions.tsx        ← Atalhos rápidos
│   │   │
│   │   ├── agents/
│   │   │   ├── AgentCard.tsx           ← Card de agente com status toggle
│   │   │   ├── AgentForm.tsx           ← Formulário criar/editar agente
│   │   │   ├── AgentModelSelector.tsx  ← Seletor de modelo (OpenAI/Anthropic/Google)
│   │   │   ├── AgentPromptEditor.tsx   ← Editor de system prompt com variáveis
│   │   │   ├── AgentTestChat.tsx       ← Chat de teste sem usar conta Instagram
│   │   │   └── AgentKnowledgeLink.tsx  ← Vincular knowledge bases ao agente
│   │   │
│   │   ├── knowledge-base/
│   │   │   ├── KnowledgeBaseCard.tsx
│   │   │   ├── KnowledgeBaseForm.tsx
│   │   │   ├── DocumentUploader.tsx    ← Upload PDF/TXT/MD com progress
│   │   │   ├── DocumentList.tsx        ← Lista de documentos com status de indexação
│   │   │   ├── UrlScraper.tsx          ← Input de URL para scraping
│   │   │   └── EmbeddingStatus.tsx     ← Indicador de progresso de embeddings
│   │   │
│   │   ├── flows/
│   │   │   ├── FlowCanvas.tsx          ← Canvas ReactFlow principal
│   │   │   ├── FlowSidebar.tsx         ← Painel de nós disponíveis (drag & drop)
│   │   │   ├── FlowToolbar.tsx         ← Ações: salvar, publicar, testar, histórico
│   │   │   ├── nodes/
│   │   │   │   ├── StartNode.tsx       ← Nó inicial (trigger)
│   │   │   │   ├── MessageNode.tsx     ← Enviar mensagem
│   │   │   │   ├── ConditionNode.tsx   ← Bifurcação condicional
│   │   │   │   ├── AINode.tsx          ← Processar com agente de IA
│   │   │   │   ├── DelayNode.tsx       ← Aguardar N minutos/horas
│   │   │   │   ├── TagNode.tsx         ← Adicionar tag ao lead
│   │   │   │   ├── WebhookNode.tsx     ← Disparar webhook externo
│   │   │   │   └── EndNode.tsx         ← Finalizar fluxo
│   │   │   └── FlowVersionHistory.tsx  ← Histórico de versões do fluxo
│   │   │
│   │   ├── keywords/
│   │   │   ├── KeywordRuleCard.tsx
│   │   │   ├── KeywordRuleForm.tsx     ← Keyword + Action + Conditions
│   │   │   └── KeywordTester.tsx       ← Testar regra sem aguardar webhook
│   │   │
│   │   ├── crm/
│   │   │   ├── LeadTable.tsx           ← Tabela com virtual scroll (grande volume)
│   │   │   ├── LeadCard.tsx
│   │   │   ├── LeadDetail.tsx          ← Drawer com histórico completo do lead
│   │   │   ├── LeadFilters.tsx         ← Filtros avançados (tag, status, data)
│   │   │   ├── LeadNotes.tsx           ← Notas internas sobre o lead
│   │   │   └── LeadTimeline.tsx        ← Timeline de interações
│   │   │
│   │   ├── inbox/
│   │   │   ├── ConversationList.tsx    ← Lista de conversas com busca em tempo real
│   │   │   ├── ConversationItem.tsx    ← Preview de conversa na lista
│   │   │   ├── ChatWindow.tsx          ← Janela de chat principal
│   │   │   ├── MessageBubble.tsx       ← Bolha de mensagem (enviada/recebida)
│   │   │   ├── MessageInput.tsx        ← Input com emoji picker e shortcuts
│   │   │   ├── AgentToggle.tsx         ← Toggle: IA ativa / Humano assumiu
│   │   │   ├── TypingIndicator.tsx     ← Indicador de digitação
│   │   │   └── ConversationSidebar.tsx ← Info do lead + tags + histórico
│   │   │
│   │   ├── broadcasts/
│   │   │   ├── BroadcastForm.tsx       ← Criar/editar broadcast
│   │   │   ├── BroadcastList.tsx
│   │   │   ├── BroadcastStats.tsx      ← Entregues, abertos, respondidos
│   │   │   ├── RecipientSelector.tsx   ← Filtro de leads destinatários
│   │   │   └── SchedulePicker.tsx      ← Agendamento com timezone (pt-BR)
│   │   │
│   │   ├── analytics/
│   │   │   ├── OverviewMetrics.tsx     ← KPIs do período selecionado
│   │   │   ├── ConversationVolumeChart.tsx
│   │   │   ├── ResponseTimeChart.tsx
│   │   │   ├── AgentPerformanceTable.tsx
│   │   │   ├── LeadFunnelChart.tsx
│   │   │   └── DateRangePicker.tsx     ← Seletor de período
│   │   │
│   │   ├── posts/
│   │   │   ├── PostGrid.tsx            ← Grid de posts do Instagram (preview)
│   │   │   ├── PostCard.tsx
│   │   │   ├── CommentList.tsx         ← Comentários com resposta automática
│   │   │   └── PostAnalytics.tsx
│   │   │
│   │   ├── team/
│   │   │   ├── TeamMemberCard.tsx
│   │   │   ├── InviteMemberForm.tsx
│   │   │   ├── RoleSelector.tsx        ← admin / agent / viewer
│   │   │   └── PresenceIndicator.tsx   ← Online/offline em tempo real
│   │   │
│   │   ├── settings/
│   │   │   ├── ProfileSettings.tsx     ← Nome, email, foto, senha
│   │   │   ├── PlanSettings.tsx        ← Plano atual + botão upgrade/portal
│   │   │   ├── InstagramSettings.tsx   ← Contas conectadas + reconectar
│   │   │   ├── NotificationSettings.tsx
│   │   │   ├── ApiKeys.tsx             ← Gerenciar chaves de API do usuário
│   │   │   └── DangerZone.tsx          ← Deletar conta
│   │   │
│   │   └── shared/                     ← Componentes reutilizáveis sem domínio fixo
│   │       ├── ConfirmDialog.tsx        ← Dialog de confirmação de ação destrutiva
│   │       ├── EmptyState.tsx           ← Estado vazio com ilustração e CTA
│   │       ├── ErrorBoundary.tsx        ← Captura erros de render + fallback UI
│   │       ├── LoadingSpinner.tsx
│   │       ├── PageHeader.tsx           ← Título de página + breadcrumb + ações
│   │       ├── PlanGate.tsx             ← Trava feature por plano (mostra upgrade)
│   │       ├── StatusBadge.tsx          ← Badge colorida por status
│   │       └── VirtualList.tsx          ← Lista virtualizada para grandes volumes
│   │
│   ├── hooks/                           ← Custom React Hooks
│   │   ├── useAuth.ts                   ← Estado de autenticação (user, session, signOut)
│   │   ├── useProfile.ts                ← Perfil do usuário + update
│   │   ├── useSubscription.ts           ← Plano ativo, limites, trial
│   │   ├── useInstagram.ts              ← Contas conectadas, OAuth flow
│   │   ├── useLeads.ts                  ← CRUD de leads com React Query
│   │   ├── useConversations.ts          ← Lista e detalhes de conversas
│   │   ├── useMessages.ts               ← Mensagens de uma conversa
│   │   ├── useRealtime.ts               ← Subscrição de canais Supabase Realtime
│   │   ├── useAgents.ts                 ← CRUD de agentes
│   │   ├── useKnowledgeBases.ts         ← CRUD de knowledge bases
│   │   ├── useFlows.ts                  ← CRUD de fluxos
│   │   ├── useKeywords.ts               ← CRUD de regras de keyword
│   │   ├── useBroadcasts.ts             ← CRUD e envio de broadcasts
│   │   ├── useAnalytics.ts              ← Métricas e relatórios
│   │   ├── useTeam.ts                   ← Membros da equipe
│   │   ├── usePresence.ts               ← Presença online da equipe
│   │   ├── useTypingIndicator.ts        ← Debounce de typing events
│   │   ├── useInfiniteScroll.ts         ← IntersectionObserver para scroll infinito
│   │   └── useDebounce.ts               ← Debounce genérico para buscas
│   │
│   ├── lib/
│   │   ├── supabase.ts                  ← Cliente Supabase configurado + tipos
│   │   ├── stripe.ts                    ← Utilitários Stripe frontend (loadStripe)
│   │   ├── queryClient.ts               ← Configuração do React Query
│   │   ├── utils.ts                     ← cn(), formatDate(), truncate(), etc.
│   │   ├── constants.ts                 ← PLANS, LIMITS, ROUTES, API_URLS
│   │   └── validators.ts                ← Schemas Zod reutilizáveis
│   │
│   ├── stores/                          ← Zustand stores (estado global de UI)
│   │   ├── authStore.ts                 ← user, session, loading, initialized
│   │   ├── uiStore.ts                   ← sidebarOpen, theme, activeModal
│   │   └── conversationStore.ts         ← conversaAtiva, unreadCount, agentMode
│   │
│   ├── types/
│   │   ├── database.ts                  ← Tipos gerados pelo Supabase CLI
│   │   ├── instagram.ts                 ← Tipos da Meta Graph API
│   │   ├── ai.ts                        ← Tipos de providers de IA
│   │   └── index.ts                     ← Re-exports + tipos de domínio custom
│   │
│   ├── pages/                           ← Componentes de página (lazy-loaded por rota)
│   │   ├── auth/
│   │   │   ├── LoginPage.tsx
│   │   │   ├── RegisterPage.tsx
│   │   │   ├── ForgotPasswordPage.tsx
│   │   │   ├── ResetPasswordPage.tsx
│   │   │   └── OnboardingPage.tsx
│   │   ├── DashboardPage.tsx
│   │   ├── AgentsPage.tsx
│   │   ├── AgentDetailPage.tsx
│   │   ├── KnowledgeBasePage.tsx
│   │   ├── KnowledgeBaseDetailPage.tsx
│   │   ├── FlowsPage.tsx
│   │   ├── FlowEditorPage.tsx
│   │   ├── KeywordsPage.tsx
│   │   ├── CRMPage.tsx
│   │   ├── InboxPage.tsx
│   │   ├── BroadcastsPage.tsx
│   │   ├── AnalyticsPage.tsx
│   │   ├── PostsPage.tsx
│   │   ├── TeamPage.tsx
│   │   ├── SettingsPage.tsx
│   │   └── NotFoundPage.tsx
│   │
│   ├── styles/
│   │   ├── globals.css                  ← Variáveis CSS + Tailwind base
│   │   └── fonts.css                    ← @font-face declarations
│   │
│   ├── App.tsx                          ← Roteador principal + providers
│   └── main.tsx                         ← Ponto de entrada + React.StrictMode
│
├── supabase/
│   ├── config.toml                      ← Configuração do Supabase CLI local
│   │
│   ├── functions/                       ← Edge Functions (Deno)
│   │   ├── _shared/                     ← Código compartilhado entre functions
│   │   │   ├── cors.ts                  ← Headers CORS padrão
│   │   │   ├── auth.ts                  ← Verificação de JWT em Edge Functions
│   │   │   ├── instagram.ts             ← Wrapper Meta Graph API
│   │   │   └── ai-providers.ts          ← Abstração para OpenAI/Anthropic/Google
│   │   │
│   │   ├── webhook-instagram/
│   │   │   └── index.ts                 ← Recebe e processa webhooks da Meta
│   │   │
│   │   ├── ai-chat/
│   │   │   └── index.ts                 ← Orquestra resposta do agente de IA
│   │   │
│   │   ├── ai-embeddings/
│   │   │   └── index.ts                 ← Gera embeddings de documentos
│   │   │
│   │   ├── broadcast-send/
│   │   │   └── index.ts                 ← Envia mensagens em massa
│   │   │
│   │   ├── stripe-webhook/
│   │   │   └── index.ts                 ← Processa eventos do Stripe
│   │   │
│   │   ├── cron-trial-check/
│   │   │   └── index.ts                 ← Verifica trials expirados (diário)
│   │   │
│   │   ├── instagram-oauth-callback/
│   │   │   └── index.ts                 ← Troca code por access_token
│   │   │
│   │   └── refresh-instagram-tokens/
│   │       └── index.ts                 ← Renova tokens Instagram (< 60 dias)
│   │
│   └── migrations/
│       ├── 001_extensions.sql           ← pgvector, pg_cron, uuid-ossp
│       ├── 002_schema.sql               ← Todas as tabelas
│       ├── 003_rls.sql                  ← Row Level Security policies
│       ├── 004_functions.sql            ← Funções PostgreSQL
│       ├── 005_triggers.sql             ← Triggers automáticos
│       └── 006_seed.sql                 ← Dados iniciais (planos, etc.)
│
├── .env.local                           ← Variáveis locais (nunca commitado)
├── .env.example                         ← Template de variáveis (commitado)
├── .gitignore
├── package.json
├── tsconfig.json
├── tsconfig.app.json
├── tsconfig.node.json
├── vite.config.ts
├── tailwind.config.ts
├── postcss.config.js
├── components.json                      ← Configuração shadcn/ui
└── biome.json                           ← Linting + formatting (alternativa ao ESLint)
```

---

## 4. Variáveis de Ambiente

### 4.1 Arquivo `.env.example` (Frontend + Edge Functions)

```env
# ─────────────────────────────────────────────
# SUPABASE
# ─────────────────────────────────────────────
# URL do projeto Supabase (Settings > API)
VITE_SUPABASE_URL=https://xxxxxxxxxxx.supabase.co

# Chave anon/public (segura para expor no frontend com RLS)
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# Chave service_role — APENAS em Edge Functions, NUNCA no frontend
# Tem acesso total ao banco sem RLS
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# JWT secret para verificação manual de tokens em Edge Functions
SUPABASE_JWT_SECRET=seu-jwt-secret-super-secreto

# ─────────────────────────────────────────────
# META / INSTAGRAM
# ─────────────────────────────────────────────
# ID do App no Facebook Developers
META_APP_ID=1234567890123456

# Secret do App (nunca expor no frontend)
META_APP_SECRET=a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4

# Token de verificação do webhook (você define, a Meta valida)
META_WEBHOOK_VERIFY_TOKEN=meu-token-secreto-aleatorio-webhook

# URI de redirecionamento do OAuth (deve estar registrado no App da Meta)
META_REDIRECT_URI=https://xxxxxxxxxxx.supabase.co/functions/v1/instagram-oauth-callback

# Versão da Graph API
META_API_VERSION=v18.0

# ─────────────────────────────────────────────
# OPENAI
# ─────────────────────────────────────────────
# Chave da API OpenAI (sk-...)
OPENAI_API_KEY=sk-proj-...

# ─────────────────────────────────────────────
# ANTHROPIC
# ─────────────────────────────────────────────
# Chave da API Anthropic
ANTHROPIC_API_KEY=sk-ant-...

# ─────────────────────────────────────────────
# GOOGLE AI
# ─────────────────────────────────────────────
# Chave da API Google AI Studio
GOOGLE_AI_API_KEY=AIza...

# ─────────────────────────────────────────────
# STRIPE
# ─────────────────────────────────────────────
# Chave secreta do Stripe (sk_live_... ou sk_test_...)
STRIPE_SECRET_KEY=sk_test_...

# Secret do webhook do Stripe (whsec_...)
STRIPE_WEBHOOK_SECRET=whsec_...

# Chave publicável do Stripe (segura para o frontend)
VITE_STRIPE_PUBLISHABLE_KEY=pk_test_...

# IDs dos produtos/preços no Stripe
STRIPE_PRICE_STARTER=price_xxx
STRIPE_PRICE_PROFESSIONAL=price_xxx
STRIPE_PRICE_BUSINESS=price_xxx

# ─────────────────────────────────────────────
# RESEND (Email Transacional)
# ─────────────────────────────────────────────
# Chave da API Resend
RESEND_API_KEY=re_...

# Domínio de envio verificado no Resend
RESEND_FROM_EMAIL=noreply@instaflow.ai

# ─────────────────────────────────────────────
# SENTRY (Monitoramento de Erros)
# ─────────────────────────────────────────────
# DSN do projeto Sentry (exposto no frontend, é seguro)
VITE_SENTRY_DSN=https://xxx@xxx.ingest.sentry.io/xxx

# ─────────────────────────────────────────────
# APLICAÇÃO
# ─────────────────────────────────────────────
# URL pública da aplicação (sem barra final)
VITE_APP_URL=https://app.instaflow.ai

# Nome da aplicação exibido na UI
VITE_APP_NAME=InstaFlow AI

# Ambiente atual
VITE_APP_ENV=development
```

---

## 5. Fluxo de Autenticação

### 5.1 Login com Email/Senha

```typescript
// src/hooks/useAuth.ts — Fluxo de login
import { supabase } from '@/lib/supabase'

async function signIn(email: string, password: string) {
  // 1. Chama Supabase Auth
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })

  if (error) throw error

  // 2. Supabase retorna: session.access_token (JWT) + session.refresh_token
  // 3. O cliente supabase-js armazena automaticamente no localStorage
  // 4. Todas as chamadas subsequentes incluem o JWT no header Authorization

  return data
}
```

### 5.2 Registro com Trial Automático (7 dias)

```typescript
// src/hooks/useAuth.ts — Fluxo de registro
async function signUp(email: string, password: string, name: string) {
  // 1. Cria usuário no Supabase Auth
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: {
      data: { full_name: name },
      emailRedirectTo: `${import.meta.env.VITE_APP_URL}/auth/callback`,
    },
  })

  if (error) throw error

  // 2. Um trigger no PostgreSQL é disparado automaticamente:
  //    ON INSERT em auth.users → cria linha em public.profiles
  //    → cria subscription com status='trialing', trial_end = NOW() + 7 days
  //
  // Trigger: supabase/migrations/005_triggers.sql
  // CREATE OR REPLACE FUNCTION handle_new_user()
  // RETURNS TRIGGER AS $$
  // BEGIN
  //   INSERT INTO public.profiles (id, email, full_name)
  //   VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  //
  //   INSERT INTO public.subscriptions (user_id, plan, status, trial_end)
  //   VALUES (NEW.id, 'starter', 'trialing', NOW() + INTERVAL '7 days');
  //
  //   RETURN NEW;
  // END;
  // $$ LANGUAGE plpgsql SECURITY DEFINER;

  return data
}
```

### 5.3 Proteção de Rotas no Frontend

```typescript
// src/components/layout/ProtectedRoute.tsx
import { useEffect } from 'react'
import { useNavigate, Outlet } from 'react-router-dom'
import { useAuthStore } from '@/stores/authStore'
import { useSubscription } from '@/hooks/useSubscription'

interface ProtectedRouteProps {
  requiredPlan?: 'starter' | 'professional' | 'business'
}

export function ProtectedRoute({ requiredPlan }: ProtectedRouteProps) {
  const { user, initialized } = useAuthStore()
  const { subscription, isLoading } = useSubscription()
  const navigate = useNavigate()

  useEffect(() => {
    if (!initialized || isLoading) return

    // Não autenticado → redireciona para login
    if (!user) {
      navigate('/login', { replace: true })
      return
    }

    // Trial expirado + sem plano ativo → redireciona para pricing
    if (subscription?.status === 'expired') {
      navigate('/pricing', { replace: true })
      return
    }

    // Feature requer plano superior
    if (requiredPlan && !hasRequiredPlan(subscription?.plan, requiredPlan)) {
      navigate('/settings/plan', { replace: true })
    }
  }, [user, initialized, subscription, isLoading])

  if (!initialized || isLoading) return <LoadingSpinner />
  if (!user) return null

  return <Outlet />
}
```

### 5.4 Refresh Automático de Sessão

```typescript
// src/lib/supabase.ts
import { createClient } from '@supabase/supabase-js'
import type { Database } from '@/types/database'

export const supabase = createClient<Database>(
  import.meta.env.VITE_SUPABASE_URL,
  import.meta.env.VITE_SUPABASE_ANON_KEY,
  {
    auth: {
      // supabase-js renova o token automaticamente antes de expirar
      // O refresh_token tem validade de 7 dias
      // O access_token (JWT) tem validade de 1 hora
      autoRefreshToken: true,
      persistSession: true,
      detectSessionInUrl: true, // Para o callback do OAuth
      storageKey: 'instaflow-auth', // Chave no localStorage
    },
  }
)

// Listener global de mudança de estado de autenticação
supabase.auth.onAuthStateChange((event, session) => {
  // 'SIGNED_IN', 'SIGNED_OUT', 'TOKEN_REFRESHED', 'PASSWORD_RECOVERY'
  useAuthStore.getState().setSession(session)

  if (event === 'SIGNED_OUT') {
    // Limpa todos os caches do React Query
    queryClient.clear()
  }
})
```

---

## 6. Meta OAuth e Instagram Business API

### 6.1 Pré-requisitos e Configuração do App Meta

**Requisitos obrigatórios:**

1. Conta no [Facebook Developers](https://developers.facebook.com)
2. App do tipo **Business** (não Consumer/Gaming)
3. Produto **Instagram** adicionado ao App
4. **Instagram Business Account** ou **Creator Account** (não conta pessoal)
5. A conta Instagram DEVE estar vinculada a uma **Página do Facebook**
6. App aprovado pela Meta para produção (~2-4 semanas de review)

**Permissões obrigatórias (Meta App Review):**

```
instagram_basic              — Info básica da conta (username, bio, seguidores)
instagram_manage_messages    — Enviar e receber DMs
instagram_manage_comments    — Ler e responder comentários
pages_messaging              — Mensagens via Graph API
pages_read_engagement        — Dados de engajamento de posts
instagram_content_publish    — Publicar posts (para agendamento)
```

### 6.2 Fluxo OAuth Passo a Passo

```
USUÁRIO                    FRONTEND                   EDGE FUNCTION           META API
  │                           │                            │                      │
  │ Clica "Conectar"          │                            │                      │
  │ ─────────────────────────▶│                            │                      │
  │                           │                            │                      │
  │                           │ Gera state (CSRF token)    │                      │
  │                           │ Salva no sessionStorage    │                      │
  │                           │                            │                      │
  │                           │ Redireciona para           │                      │
  │                           │ facebook.com/dialog/oauth  │                      │
  │◀──────────────────────────│                            │                      │
  │                           │                            │                      │
  │ (na Meta)                 │                            │                      │
  │ Autoriza permissões       │                            │                      │
  │                           │                            │                      │
  │ Meta redireciona com      │                            │                      │
  │ ?code=XXX&state=YYY       │                            │                      │
  │ ─────────────────────────▶│                            │                      │
  │                           │                            │                      │
  │                           │ Valida state (anti-CSRF)   │                      │
  │                           │ Chama Edge Function        │                      │
  │                           │ ─────────────────────────▶│                      │
  │                           │                            │ POST /oauth/token    │
  │                           │                            │ (code → short token) │
  │                           │                            │ ─────────────────────▶│
  │                           │                            │◀─────────────────────│
  │                           │                            │                      │
  │                           │                            │ GET /oauth/access_token
  │                           │                            │ (short → long token) │
  │                           │                            │ ─────────────────────▶│
  │                           │                            │◀─────────────────────│
  │                           │                            │                      │
  │                           │                            │ GET /me/accounts     │
  │                           │                            │ (busca Páginas FB)   │
  │                           │                            │ ─────────────────────▶│
  │                           │                            │◀─────────────────────│
  │                           │                            │                      │
  │                           │                            │ GET /{page}/instagram_accounts
  │                           │                            │ ─────────────────────▶│
  │                           │                            │◀─────────────────────│
  │                           │                            │                      │
  │                           │                            │ Criptografa e salva  │
  │                           │                            │ token no banco       │
  │                           │                            │                      │
  │                           │                            │ POST /{app}/subscriptions
  │                           │                            │ (registra webhook)   │
  │                           │                            │ ─────────────────────▶│
  │                           │                            │◀─────────────────────│
  │                           │                            │                      │
  │                           │◀─────────────────────────│                      │
  │◀──────────────────────────│                            │                      │
  │ (onboarding step 2 ok)    │                            │                      │
```

### 6.3 Edge Function: instagram-oauth-callback

```typescript
// supabase/functions/instagram-oauth-callback/index.ts
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const META_API = `https://graph.facebook.com/${Deno.env.get('META_API_VERSION') ?? 'v18.0'}`

serve(async (req: Request) => {
  const url = new URL(req.url)
  const code = url.searchParams.get('code')
  const state = url.searchParams.get('state') // contém user_id encodado + CSRF token

  if (!code || !state) {
    return Response.redirect(`${Deno.env.get('VITE_APP_URL')}/onboarding?error=missing_params`)
  }

  // 1. Decodifica state para obter user_id
  const { userId } = JSON.parse(atob(state))

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  try {
    // 2. Troca code por short-lived token (~1h)
    const tokenRes = await fetch(`${META_API}/oauth/access_token`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        client_id: Deno.env.get('META_APP_ID'),
        client_secret: Deno.env.get('META_APP_SECRET'),
        redirect_uri: Deno.env.get('META_REDIRECT_URI'),
        code,
      }),
    })
    const { access_token: shortToken } = await tokenRes.json()

    // 3. Troca por long-lived token (válido 60 dias)
    const longTokenRes = await fetch(
      `${META_API}/oauth/access_token?grant_type=fb_exchange_token` +
      `&client_id=${Deno.env.get('META_APP_ID')}` +
      `&client_secret=${Deno.env.get('META_APP_SECRET')}` +
      `&fb_exchange_token=${shortToken}`
    )
    const { access_token: longToken, expires_in } = await longTokenRes.json()

    // 4. Busca páginas do Facebook vinculadas
    const pagesRes = await fetch(`${META_API}/me/accounts?access_token=${longToken}`)
    const { data: pages } = await pagesRes.json()

    for (const page of pages) {
      // 5. Busca conta Instagram Business vinculada à página
      const igRes = await fetch(
        `${META_API}/${page.id}?fields=instagram_business_account&access_token=${page.access_token}`
      )
      const { instagram_business_account: igAccount } = await igRes.json()
      if (!igAccount) continue

      // 6. Busca detalhes da conta Instagram
      const igDetailsRes = await fetch(
        `${META_API}/${igAccount.id}?fields=id,username,name,biography,followers_count,profile_picture_url&access_token=${longToken}`
      )
      const igDetails = await igDetailsRes.json()

      // 7. Criptografa token antes de salvar
      // Em produção, usar AES-256 com uma chave derivada por usuário
      const encryptedToken = await encrypt(longToken, Deno.env.get('ENCRYPTION_KEY')!)

      // 8. Salva no banco com expiração
      const tokenExpiresAt = new Date(Date.now() + expires_in * 1000).toISOString()

      await supabase.from('instagram_accounts').upsert({
        user_id: userId,
        instagram_user_id: igDetails.id,
        username: igDetails.username,
        name: igDetails.name,
        biography: igDetails.biography,
        followers_count: igDetails.followers_count,
        profile_picture_url: igDetails.profile_picture_url,
        page_id: page.id,
        page_access_token_encrypted: encryptedToken,
        token_expires_at: tokenExpiresAt,
        is_active: true,
        connected_at: new Date().toISOString(),
      })

      // 9. Registra webhook para a conta Instagram
      await registerInstagramWebhook(page.id, page.access_token)
    }

    // 10. Redireciona de volta ao onboarding
    return Response.redirect(`${Deno.env.get('VITE_APP_URL')}/onboarding?step=3&instagram=connected`)

  } catch (error) {
    console.error('Erro no OAuth callback:', error)
    return Response.redirect(`${Deno.env.get('VITE_APP_URL')}/onboarding?error=oauth_failed`)
  }
})

async function registerInstagramWebhook(pageId: string, pageToken: string) {
  const META_API = `https://graph.facebook.com/${Deno.env.get('META_API_VERSION')}`

  await fetch(`${META_API}/${pageId}/subscribed_apps`, {
    method: 'POST',
    body: new URLSearchParams({
      access_token: pageToken,
      subscribed_fields: 'messages,messaging_postbacks,feed,mention,name',
    }),
  })
}
```

### 6.4 Webhook da Meta: Verificação e Processamento

```typescript
// supabase/functions/webhook-instagram/index.ts
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { createHmac } from 'https://deno.land/std@0.177.0/node/crypto.ts'

serve(async (req: Request) => {
  // ── Verificação do Webhook (GET) ──────────────────────────────────────
  if (req.method === 'GET') {
    const url = new URL(req.url)
    const mode = url.searchParams.get('hub.mode')
    const token = url.searchParams.get('hub.verify_token')
    const challenge = url.searchParams.get('hub.challenge')

    if (mode === 'subscribe' && token === Deno.env.get('META_WEBHOOK_VERIFY_TOKEN')) {
      // Meta valida o webhook respondendo com o challenge
      return new Response(challenge, { status: 200 })
    }
    return new Response('Forbidden', { status: 403 })
  }

  // ── Processamento de Eventos (POST) ───────────────────────────────────
  if (req.method === 'POST') {
    const body = await req.text()

    // 1. Verifica assinatura HMAC-SHA256
    const signature = req.headers.get('X-Hub-Signature-256')
    if (!verifySignature(body, signature)) {
      return new Response('Invalid signature', { status: 401 })
    }

    const payload = JSON.parse(body)
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    // 2. Processa cada entrada do webhook
    for (const entry of payload.entry ?? []) {
      for (const change of entry.changes ?? []) {
        await processWebhookChange(supabase, change, entry)
      }

      // Mensagens diretas chegam em entry.messaging
      for (const messaging of entry.messaging ?? []) {
        await processDirectMessage(supabase, messaging, entry.id)
      }
    }

    return new Response('OK', { status: 200 })
  }

  return new Response('Method Not Allowed', { status: 405 })
})

function verifySignature(body: string, signature: string | null): boolean {
  if (!signature) return false
  const appSecret = Deno.env.get('META_APP_SECRET')!
  const expected = 'sha256=' + createHmac('sha256', appSecret).update(body).digest('hex')
  return expected === signature
}

async function processDirectMessage(supabase: any, messaging: any, pageId: string) {
  const { sender, message, timestamp } = messaging
  const senderIgId = sender.id

  // 3. Identifica o usuário pelo page_id (conta Instagram conectada)
  const { data: igAccount } = await supabase
    .from('instagram_accounts')
    .select('user_id, id')
    .eq('page_id', pageId)
    .eq('is_active', true)
    .single()

  if (!igAccount) return // Conta não registrada ou desconectada

  // 4. Verifica se usuário tem assinatura ativa ou trial válido
  const { data: subscription } = await supabase
    .from('subscriptions')
    .select('status, plan, trial_end, messages_used, message_limit')
    .eq('user_id', igAccount.user_id)
    .single()

  if (!isActiveSubscription(subscription)) {
    console.log(`Usuário ${igAccount.user_id} sem plano ativo, mensagem ignorada`)
    return
  }

  // 5. Verifica limite de mensagens do plano
  if (subscription.messages_used >= subscription.message_limit) {
    console.log(`Usuário ${igAccount.user_id} atingiu limite de mensagens`)
    return
  }

  // 6. Upsert do lead (cria se não existir)
  const { data: lead } = await supabase
    .from('leads')
    .upsert({
      user_id: igAccount.user_id,
      instagram_user_id: senderIgId,
      last_interaction: new Date(timestamp).toISOString(),
    }, { onConflict: 'user_id,instagram_user_id' })
    .select()
    .single()

  // 7. Cria/atualiza conversa
  const { data: conversation } = await supabase
    .from('conversations')
    .upsert({
      user_id: igAccount.user_id,
      lead_id: lead.id,
      instagram_account_id: igAccount.id,
      last_message_at: new Date(timestamp).toISOString(),
    }, { onConflict: 'user_id,lead_id' })
    .select()
    .single()

  // 8. Salva mensagem recebida
  await supabase.from('messages').insert({
    conversation_id: conversation.id,
    user_id: igAccount.user_id,
    direction: 'inbound',
    content: message.text,
    instagram_message_id: message.mid,
    sent_at: new Date(timestamp).toISOString(),
  })

  // 9. Verifica keywords ativas
  const keywordMatch = await checkKeywords(supabase, igAccount.user_id, message.text)
  if (keywordMatch) {
    await executeKeywordAction(supabase, keywordMatch, conversation, lead, igAccount)
    return // Keyword action trata a resposta
  }

  // 10. Verifica se conversa está em modo humano (agente desativou IA)
  if (conversation.ai_paused) {
    // Notifica equipe em tempo real mas não responde automaticamente
    await supabase.from('notifications').insert({
      user_id: igAccount.user_id,
      type: 'new_message',
      data: { conversation_id: conversation.id, lead_id: lead.id },
    })
    return
  }

  // 11. Chama Edge Function ai-chat para gerar resposta
  await supabase.functions.invoke('ai-chat', {
    body: {
      conversation_id: conversation.id,
      message: message.text,
      user_id: igAccount.user_id,
      instagram_account_id: igAccount.id,
    },
  })

  // 12. Incrementa contador de mensagens
  await supabase.rpc('increment_messages_used', { p_user_id: igAccount.user_id })
}
```

### 6.5 Renovação Automática de Tokens Instagram

Os tokens de longa duração expiram em 60 dias. A Edge Function `refresh-instagram-tokens` é executada diariamente via `pg_cron`:

```sql
-- supabase/migrations/005_triggers.sql
-- Agenda renovação diária de tokens às 2h da manhã (UTC)
SELECT cron.schedule(
  'refresh-instagram-tokens',
  '0 2 * * *',
  $$
  SELECT net.http_post(
    url := current_setting('app.supabase_url') || '/functions/v1/refresh-instagram-tokens',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || current_setting('app.service_role_key'),
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);
```

```typescript
// supabase/functions/refresh-instagram-tokens/index.ts
// Busca todos os tokens que expiram em menos de 30 dias e renova
serve(async (req: Request) => {
  const supabase = createClient(/* service_role */)

  // Tokens que expiram em menos de 30 dias
  const { data: accounts } = await supabase
    .from('instagram_accounts')
    .select('id, user_id, page_access_token_encrypted, token_expires_at')
    .lt('token_expires_at', new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString())
    .eq('is_active', true)

  for (const account of accounts ?? []) {
    const currentToken = await decrypt(account.page_access_token_encrypted)
    const META_API = `https://graph.facebook.com/${Deno.env.get('META_API_VERSION')}`

    const res = await fetch(
      `${META_API}/oauth/access_token?grant_type=fb_exchange_token` +
      `&client_id=${Deno.env.get('META_APP_ID')}` +
      `&client_secret=${Deno.env.get('META_APP_SECRET')}` +
      `&fb_exchange_token=${currentToken}`
    )

    if (res.ok) {
      const { access_token: newToken, expires_in } = await res.json()
      await supabase.from('instagram_accounts').update({
        page_access_token_encrypted: await encrypt(newToken),
        token_expires_at: new Date(Date.now() + expires_in * 1000).toISOString(),
        token_refreshed_at: new Date().toISOString(),
      }).eq('id', account.id)
    }
  }

  return new Response(JSON.stringify({ refreshed: accounts?.length ?? 0 }))
})
```

---

## 7. Fluxo do Agente de IA

### 7.1 Diagrama do Fluxo Completo

```
Webhook recebe DM
       │
       ▼
Valida assinatura HMAC
       │
       ▼
Identifica usuário (page_id → instagram_account → user_id)
       │
       ▼
Verifica assinatura ativa + limites
       │
       ▼
Upsert Lead + Conversation + Message
       │
       ▼
Verifica Keywords ativas
     ┌─┴─┐
 Match?   No
     │     │
     ▼     ▼
Execute   Conversa em modo humano?
Action   ┌─┴─┐
         Sim  Não
          │    │
          ▼    ▼
      Notifica  Busca agente ativo
      equipe    │
                ▼
              Busca histórico (N=20 mensagens)
                │
                ▼
              Busca knowledge base (pgvector similarity search)
                │
                ▼
              Monta prompt (system + knowledge + histórico + mensagem)
                │
                ▼
              Chama API do modelo (OpenAI/Anthropic/Google)
                │
                ▼
              Analisa resposta (intent, sentiment, confidence)
                │
                ▼
         Escalar para humano?
              ┌─┴─┐
             Sim  Não
              │    │
              ▼    ▼
          Pausa IA  Envia resposta via Instagram API
          Notifica  │
          equipe    ▼
                  Salva mensagem no banco
                    │
                    ▼
                  Atualiza analytics
```

### 7.2 Edge Function: ai-chat

```typescript
// supabase/functions/ai-chat/index.ts
import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import OpenAI from 'https://esm.sh/openai@4'
import Anthropic from 'https://esm.sh/@anthropic-ai/sdk@0.27'

interface AIChatRequest {
  conversation_id: string
  message: string
  user_id: string
  instagram_account_id: string
}

serve(async (req: Request) => {
  const { conversation_id, message, user_id, instagram_account_id }: AIChatRequest =
    await req.json()

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  const startTime = Date.now()

  // 1. Busca configurações do agente ativo para esta conta Instagram
  const { data: agent } = await supabase
    .from('agents')
    .select(`
      id,
      name,
      system_prompt,
      model_provider,
      model_name,
      temperature,
      max_tokens,
      knowledge_base_id,
      escalation_threshold,
      max_history_messages
    `)
    .eq('user_id', user_id)
    .eq('instagram_account_id', instagram_account_id)
    .eq('is_active', true)
    .single()

  if (!agent) {
    console.log(`Nenhum agente ativo para conta ${instagram_account_id}`)
    return new Response('No active agent', { status: 200 })
  }

  // 2. Busca histórico da conversa (últimas N mensagens)
  const { data: history } = await supabase
    .from('messages')
    .select('direction, content, sent_at')
    .eq('conversation_id', conversation_id)
    .order('sent_at', { ascending: false })
    .limit(agent.max_history_messages ?? 20)

  const historyMessages = (history ?? [])
    .reverse()
    .map(msg => ({
      role: msg.direction === 'inbound' ? 'user' as const : 'assistant' as const,
      content: msg.content,
    }))

  // 3. Busca knowledge base relevante via busca semântica
  let knowledgeContext = ''
  if (agent.knowledge_base_id) {
    const queryEmbedding = await generateEmbedding(message)

    const { data: relevantDocs } = await supabase.rpc('match_knowledge_documents', {
      p_knowledge_base_id: agent.knowledge_base_id,
      p_query_embedding: queryEmbedding,
      p_similarity_threshold: 0.75,
      p_match_count: 5,
    })

    if (relevantDocs?.length > 0) {
      knowledgeContext = '\n\n### Informações Relevantes da Base de Conhecimento:\n' +
        relevantDocs.map((doc: any, i: number) =>
          `[${i + 1}] ${doc.content}`
        ).join('\n\n')
    }
  }

  // 4. Monta o prompt final
  const systemPrompt = agent.system_prompt + knowledgeContext +
    `\n\n### Instruções de Comportamento:
- Responda SEMPRE em português do Brasil
- Seja conciso (máximo 3 parágrafos)
- Se não souber a resposta, admita e ofereça alternativas
- Se a pergunta for urgente ou o cliente estiver insatisfeito, indique que um humano pode ajudar`

  // 5. Chama o modelo de IA conforme configuração do agente
  let response: string
  let tokensUsed = 0

  switch (agent.model_provider) {
    case 'openai':
      ;({ response, tokensUsed } = await callOpenAI({
        model: agent.model_name,
        systemPrompt,
        messages: historyMessages,
        currentMessage: message,
        temperature: agent.temperature ?? 0.7,
        maxTokens: agent.max_tokens ?? 500,
      }))
      break

    case 'anthropic':
      ;({ response, tokensUsed } = await callAnthropic({
        model: agent.model_name,
        systemPrompt,
        messages: historyMessages,
        currentMessage: message,
        temperature: agent.temperature ?? 0.7,
        maxTokens: agent.max_tokens ?? 500,
      }))
      break

    case 'google':
      ;({ response, tokensUsed } = await callGoogleAI({
        model: agent.model_name,
        systemPrompt,
        messages: historyMessages,
        currentMessage: message,
        temperature: agent.temperature ?? 0.7,
        maxTokens: agent.max_tokens ?? 500,
      }))
      break

    default:
      throw new Error(`Provider desconhecido: ${agent.model_provider}`)
  }

  const latencyMs = Date.now() - startTime

  // 6. Analisa a resposta para decisão de escalação
  const shouldEscalate = analyzeForEscalation(message, response, agent.escalation_threshold)

  if (shouldEscalate) {
    // Pausa IA e notifica equipe
    await supabase.from('conversations')
      .update({ ai_paused: true, ai_paused_reason: 'auto_escalation' })
      .eq('id', conversation_id)

    await supabase.from('notifications').insert({
      user_id,
      type: 'escalation_needed',
      data: { conversation_id, reason: 'Cliente precisa de atendimento humano' },
    })

    // Envia mensagem de transição para o cliente
    const transitionMessage = 'Vou conectar você com um de nossos atendentes. Aguarde um momento!'
    await sendInstagramMessage(supabase, instagram_account_id, conversation_id, transitionMessage)
    return new Response('Escalated', { status: 200 })
  }

  // 7. Envia a resposta via Instagram API
  const { data: igAccount } = await supabase
    .from('instagram_accounts')
    .select('page_id, page_access_token_encrypted')
    .eq('id', instagram_account_id)
    .single()

  const { data: conversation } = await supabase
    .from('conversations')
    .select('leads(instagram_user_id)')
    .eq('id', conversation_id)
    .single()

  const recipientId = (conversation as any).leads.instagram_user_id
  const pageToken = await decrypt(igAccount.page_access_token_encrypted)

  const META_API = `https://graph.facebook.com/${Deno.env.get('META_API_VERSION')}`
  await fetch(`${META_API}/${igAccount.page_id}/messages`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${pageToken}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      recipient: { id: recipientId },
      message: { text: response },
      messaging_type: 'RESPONSE',
    }),
  })

  // 8. Salva resposta do agente no banco
  await supabase.from('messages').insert({
    conversation_id,
    user_id,
    direction: 'outbound',
    content: response,
    sender_type: 'agent',
    agent_id: agent.id,
    sent_at: new Date().toISOString(),
  })

  // 9. Registra métricas de uso de IA
  await supabase.from('ai_usage_logs').insert({
    user_id,
    agent_id: agent.id,
    model_provider: agent.model_provider,
    model_name: agent.model_name,
    tokens_used: tokensUsed,
    latency_ms: latencyMs,
    conversation_id,
  })

  return new Response(JSON.stringify({ success: true, response }), { status: 200 })
})

// Analisa se deve escalar para humano
function analyzeForEscalation(userMessage: string, aiResponse: string, threshold = 0.7): boolean {
  const urgencyKeywords = ['urgente', 'cancelar', 'reembolso', 'problema grave', 'não funciona', 'fui enganado']
  const dissatisfactionPattern = /não (gostei|resolv|entend|quer)/i

  const hasUrgency = urgencyKeywords.some(k => userMessage.toLowerCase().includes(k))
  const hasDisatisfaction = dissatisfactionPattern.test(userMessage)
  const aiUncertain = aiResponse.toLowerCase().includes('não tenho certeza') ||
                      aiResponse.toLowerCase().includes('não sei')

  // Lógica simples — em produção usar classificador de intenção via LLM
  return hasUrgency || (hasDisatisfaction && aiUncertain)
}
```

### 7.3 Abstração de Providers de IA

```typescript
// supabase/functions/_shared/ai-providers.ts

// ── OpenAI ────────────────────────────────────────────────────────────────
export async function callOpenAI(params: AICallParams): Promise<AICallResult> {
  const openai = new OpenAI({ apiKey: Deno.env.get('OPENAI_API_KEY') })

  const completion = await openai.chat.completions.create({
    model: params.model, // 'gpt-4o', 'gpt-4o-mini', 'o3-mini'
    temperature: params.temperature,
    max_tokens: params.maxTokens,
    messages: [
      { role: 'system', content: params.systemPrompt },
      ...params.messages,
      { role: 'user', content: params.currentMessage },
    ],
  })

  return {
    response: completion.choices[0].message.content ?? '',
    tokensUsed: completion.usage?.total_tokens ?? 0,
  }
}

// ── Anthropic ─────────────────────────────────────────────────────────────
export async function callAnthropic(params: AICallParams): Promise<AICallResult> {
  const anthropic = new Anthropic({ apiKey: Deno.env.get('ANTHROPIC_API_KEY') })

  const message = await anthropic.messages.create({
    model: params.model, // 'claude-sonnet-4-6', 'claude-haiku-4-5', 'claude-opus-4-6'
    system: params.systemPrompt,
    max_tokens: params.maxTokens,
    temperature: params.temperature,
    messages: [
      ...params.messages,
      { role: 'user', content: params.currentMessage },
    ],
  })

  const content = message.content[0]
  return {
    response: content.type === 'text' ? content.text : '',
    tokensUsed: message.usage.input_tokens + message.usage.output_tokens,
  }
}

// ── Google AI ─────────────────────────────────────────────────────────────
export async function callGoogleAI(params: AICallParams): Promise<AICallResult> {
  const apiKey = Deno.env.get('GOOGLE_AI_API_KEY')
  const modelId = params.model // 'gemini-2.5-pro', 'gemini-2.5-flash', 'gemini-2.0-flash'

  const API = `https://generativelanguage.googleapis.com/v1beta/models/${modelId}:generateContent?key=${apiKey}`

  const body = {
    system_instruction: { parts: [{ text: params.systemPrompt }] },
    contents: [
      ...params.messages.map(m => ({
        role: m.role === 'assistant' ? 'model' : 'user',
        parts: [{ text: m.content }],
      })),
      { role: 'user', parts: [{ text: params.currentMessage }] },
    ],
    generationConfig: {
      temperature: params.temperature,
      maxOutputTokens: params.maxTokens,
    },
  }

  const res = await fetch(API, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  })

  const data = await res.json()
  const response = data.candidates?.[0]?.content?.parts?.[0]?.text ?? ''
  const tokensUsed = (data.usageMetadata?.promptTokenCount ?? 0) +
                     (data.usageMetadata?.candidatesTokenCount ?? 0)

  return { response, tokensUsed }
}
```

---

## 8. Sistema de Embeddings e Busca Semântica

### 8.1 Visão Geral

O sistema usa `pgvector` no PostgreSQL para armazenar e consultar embeddings de documentos da knowledge base. Embeddings são vetores de 1536 dimensões (OpenAI text-embedding-3-small) que capturam o significado semântico do texto.

### 8.2 Estratégia de Chunking

```typescript
// supabase/functions/ai-embeddings/index.ts

const CHUNK_SIZE = 800     // caracteres por chunk (≈ 200 tokens)
const CHUNK_OVERLAP = 100  // sobreposição entre chunks para contexto contínuo

function chunkText(text: string): string[] {
  const chunks: string[] = []
  let start = 0

  while (start < text.length) {
    const end = Math.min(start + CHUNK_SIZE, text.length)
    let chunkEnd = end

    // Tenta quebrar no final de uma frase para não cortar no meio
    if (end < text.length) {
      const lastPeriod = text.lastIndexOf('.', end)
      const lastNewline = text.lastIndexOf('\n', end)
      const breakPoint = Math.max(lastPeriod, lastNewline)

      if (breakPoint > start + CHUNK_SIZE * 0.5) {
        chunkEnd = breakPoint + 1
      }
    }

    chunks.push(text.slice(start, chunkEnd).trim())
    start = chunkEnd - CHUNK_OVERLAP
  }

  return chunks.filter(chunk => chunk.length > 50) // Remove chunks muito pequenos
}

// Processamento completo de um documento
export async function processDocument(supabase: any, documentId: string) {
  const { data: doc } = await supabase
    .from('knowledge_documents')
    .select('id, knowledge_base_id, user_id, content, file_type')
    .eq('id', documentId)
    .single()

  // 1. Atualiza status para 'processing'
  await supabase.from('knowledge_documents')
    .update({ embedding_status: 'processing' })
    .eq('id', documentId)

  // 2. Extrai texto puro (PDF → text, HTML → text, MD → text)
  const plainText = await extractText(doc.content, doc.file_type)

  // 3. Divide em chunks
  const chunks = chunkText(plainText)

  // 4. Gera embeddings em batch (OpenAI suporta até 2048 inputs)
  const openai = new OpenAI({ apiKey: Deno.env.get('OPENAI_API_KEY') })

  const BATCH_SIZE = 100
  for (let i = 0; i < chunks.length; i += BATCH_SIZE) {
    const batch = chunks.slice(i, i + BATCH_SIZE)

    const embeddingResponse = await openai.embeddings.create({
      model: 'text-embedding-3-small', // 1536 dimensões, ótimo custo-benefício
      input: batch,
    })

    // 5. Salva chunks com embeddings no banco
    const chunkInserts = batch.map((chunk, j) => ({
      document_id: documentId,
      knowledge_base_id: doc.knowledge_base_id,
      user_id: doc.user_id,
      content: chunk,
      embedding: embeddingResponse.data[j].embedding, // vetor float4[1536]
      chunk_index: i + j,
      token_count: Math.ceil(chunk.length / 4), // estimativa grosseira
    }))

    await supabase.from('document_chunks').insert(chunkInserts)
  }

  // 6. Marca documento como indexado
  await supabase.from('knowledge_documents').update({
    embedding_status: 'indexed',
    chunks_count: chunks.length,
    indexed_at: new Date().toISOString(),
  }).eq('id', documentId)
}
```

### 8.3 Função de Busca Semântica (PostgreSQL)

```sql
-- supabase/migrations/004_functions.sql

-- Extensão necessária
CREATE EXTENSION IF NOT EXISTS vector;

-- Índice IVFFlat para busca vetorial eficiente
-- Reconstruir após inserção em massa de dados iniciais
CREATE INDEX IF NOT EXISTS document_chunks_embedding_idx
  ON document_chunks
  USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);

-- Função de busca semântica por knowledge base
CREATE OR REPLACE FUNCTION match_knowledge_documents(
  p_knowledge_base_id UUID,
  p_query_embedding VECTOR(1536),
  p_similarity_threshold FLOAT DEFAULT 0.75,
  p_match_count INT DEFAULT 5
)
RETURNS TABLE(
  chunk_id UUID,
  document_id UUID,
  content TEXT,
  similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT
    dc.id AS chunk_id,
    dc.document_id,
    dc.content,
    1 - (dc.embedding <=> p_query_embedding) AS similarity
  FROM document_chunks dc
  WHERE
    dc.knowledge_base_id = p_knowledge_base_id
    AND 1 - (dc.embedding <=> p_query_embedding) >= p_similarity_threshold
  ORDER BY dc.embedding <=> p_query_embedding  -- ASC = menor distância = maior similaridade
  LIMIT p_match_count;
END;
$$;
```

### 8.4 Geração de Embedding para Query

```typescript
// supabase/functions/_shared/ai-providers.ts

export async function generateEmbedding(text: string): Promise<number[]> {
  const openai = new OpenAI({ apiKey: Deno.env.get('OPENAI_API_KEY') })

  const response = await openai.embeddings.create({
    model: 'text-embedding-3-small',
    input: text.slice(0, 8192), // Limite de tokens do modelo
  })

  return response.data[0].embedding // number[1536]
}
```

---

## 9. Sistema de Realtime

### 9.1 Canais Supabase Realtime

```typescript
// src/hooks/useRealtime.ts
import { useEffect } from 'react'
import { supabase } from '@/lib/supabase'
import { useConversationStore } from '@/stores/conversationStore'
import { useAuthStore } from '@/stores/authStore'

export function useInboxRealtime() {
  const { user } = useAuthStore()
  const { addMessage, updateConversation, setTyping } = useConversationStore()

  useEffect(() => {
    if (!user) return

    // Canal 1: Novas mensagens em conversas do usuário
    const messagesChannel = supabase
      .channel(`messages:${user.id}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'messages',
          filter: `user_id=eq.${user.id}`,
        },
        (payload) => {
          addMessage(payload.new as Message)
          // Incrementa contador de não lidos se não estiver na conversa
          updateConversation(payload.new.conversation_id, {
            unread_count: (prev) => prev + 1,
            last_message_at: payload.new.sent_at,
          })
        }
      )
      .subscribe()

    // Canal 2: Atualizações de conversas
    const conversationsChannel = supabase
      .channel(`conversations:${user.id}`)
      .on(
        'postgres_changes',
        {
          event: '*', // INSERT, UPDATE, DELETE
          schema: 'public',
          table: 'conversations',
          filter: `user_id=eq.${user.id}`,
        },
        (payload) => {
          updateConversation(payload.new.id, payload.new)
        }
      )
      .subscribe()

    // Canal 3: Notificações do sistema
    const notificationsChannel = supabase
      .channel(`notifications:${user.id}`)
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'notifications',
          filter: `user_id=eq.${user.id}`,
        },
        (payload) => {
          handleNotification(payload.new)
        }
      )
      .subscribe()

    return () => {
      supabase.removeChannel(messagesChannel)
      supabase.removeChannel(conversationsChannel)
      supabase.removeChannel(notificationsChannel)
    }
  }, [user?.id])
}

// Indicador de digitação via Broadcast (não persiste no banco)
export function useTypingIndicator(conversationId: string) {
  const { setTyping } = useConversationStore()

  useEffect(() => {
    const channel = supabase.channel(`typing:${conversationId}`)
      .on('broadcast', { event: 'typing' }, ({ payload }) => {
        setTyping(conversationId, payload.userId, true)

        // Remove indicador após 3 segundos sem atualização
        setTimeout(() => setTyping(conversationId, payload.userId, false), 3000)
      })
      .subscribe()

    return () => supabase.removeChannel(channel)
  }, [conversationId])
}

// Envia evento de digitação (debounced no componente)
export async function broadcastTyping(conversationId: string, userId: string) {
  await supabase.channel(`typing:${conversationId}`).send({
    type: 'broadcast',
    event: 'typing',
    payload: { userId },
  })
}
```

### 9.2 Presença de Equipe Online

```typescript
// src/hooks/usePresence.ts
export function useTeamPresence(teamId: string) {
  const [presenceState, setPresenceState] = useState<Record<string, boolean>>({})
  const { user } = useAuthStore()

  useEffect(() => {
    if (!user) return

    const channel = supabase.channel(`presence:team:${teamId}`, {
      config: { presence: { key: user.id } },
    })

    channel
      .on('presence', { event: 'sync' }, () => {
        const state = channel.presenceState<{ online: boolean }>()
        const onlineMap: Record<string, boolean> = {}

        for (const [userId, presences] of Object.entries(state)) {
          onlineMap[userId] = presences.length > 0
        }

        setPresenceState(onlineMap)
      })
      .on('presence', { event: 'join' }, ({ key }) => {
        setPresenceState(prev => ({ ...prev, [key]: true }))
      })
      .on('presence', { event: 'leave' }, ({ key }) => {
        setPresenceState(prev => ({ ...prev, [key]: false }))
      })
      .subscribe(async (status) => {
        if (status === 'SUBSCRIBED') {
          await channel.track({ online: true, last_seen: new Date().toISOString() })
        }
      })

    return () => supabase.removeChannel(channel)
  }, [teamId, user?.id])

  return presenceState
}
```

---

## 10. Stripe Integration

### 10.1 Produtos e Preços no Stripe

Criar no Dashboard Stripe (ou via API):

```
Produto: InstaFlow AI Starter
  Preço: R$97/mês (recurring, monthly)
  Price ID: price_starter_monthly
  Metadata: { plan: 'starter', message_limit: '1000', agent_limit: '1' }

Produto: InstaFlow AI Professional
  Preço: R$197/mês (recurring, monthly)
  Price ID: price_professional_monthly
  Metadata: { plan: 'professional', message_limit: '5000', agent_limit: '3' }

Produto: InstaFlow AI Business
  Preço: R$397/mês (recurring, monthly)
  Price ID: price_business_monthly
  Metadata: { plan: 'business', message_limit: '20000', agent_limit: '10' }
```

### 10.2 Checkout Session (Nova Assinatura)

```typescript
// supabase/functions/stripe-create-checkout/index.ts
import Stripe from 'https://esm.sh/stripe@16'

serve(async (req: Request) => {
  const { priceId, userId, userEmail } = await req.json()

  const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY')!, {
    apiVersion: '2024-09-30',
  })

  const supabase = createClient(/* service_role */)

  // Busca ou cria Customer no Stripe
  let customerId: string
  const { data: profile } = await supabase
    .from('profiles')
    .select('stripe_customer_id')
    .eq('id', userId)
    .single()

  if (profile?.stripe_customer_id) {
    customerId = profile.stripe_customer_id
  } else {
    const customer = await stripe.customers.create({
      email: userEmail,
      metadata: { supabase_user_id: userId },
    })
    customerId = customer.id

    await supabase.from('profiles')
      .update({ stripe_customer_id: customerId })
      .eq('id', userId)
  }

  // Cria sessão de checkout
  const session = await stripe.checkout.sessions.create({
    customer: customerId,
    mode: 'subscription',
    payment_method_types: ['card'],
    line_items: [{ price: priceId, quantity: 1 }],
    success_url: `${Deno.env.get('VITE_APP_URL')}/settings/plan?success=true`,
    cancel_url: `${Deno.env.get('VITE_APP_URL')}/pricing?canceled=true`,
    locale: 'pt-BR',
    subscription_data: {
      metadata: { supabase_user_id: userId },
      trial_end: 'now', // Remove trial restante ao assinar
    },
    allow_promotion_codes: true,
  })

  return new Response(JSON.stringify({ url: session.url }))
})
```

### 10.3 Webhook do Stripe

```typescript
// supabase/functions/stripe-webhook/index.ts
serve(async (req: Request) => {
  const body = await req.text()
  const signature = req.headers.get('stripe-signature')!

  const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY')!, { apiVersion: '2024-09-30' })

  let event: Stripe.Event
  try {
    event = stripe.webhooks.constructEvent(
      body,
      signature,
      Deno.env.get('STRIPE_WEBHOOK_SECRET')!
    )
  } catch {
    return new Response('Invalid signature', { status: 400 })
  }

  const supabase = createClient(/* service_role */)

  switch (event.type) {
    case 'customer.subscription.created':
    case 'customer.subscription.updated': {
      const sub = event.data.object as Stripe.Subscription
      const userId = sub.metadata.supabase_user_id
      const priceId = sub.items.data[0].price.id
      const plan = getPlanFromPriceId(priceId)

      await supabase.from('subscriptions').upsert({
        user_id: userId,
        stripe_subscription_id: sub.id,
        stripe_customer_id: sub.customer as string,
        plan,
        status: sub.status, // 'active', 'trialing', 'past_due', 'canceled'
        current_period_start: new Date(sub.current_period_start * 1000).toISOString(),
        current_period_end: new Date(sub.current_period_end * 1000).toISOString(),
        cancel_at_period_end: sub.cancel_at_period_end,
        message_limit: PLAN_LIMITS[plan].messages,
        agent_limit: PLAN_LIMITS[plan].agents,
      }, { onConflict: 'user_id' })
      break
    }

    case 'customer.subscription.deleted': {
      const sub = event.data.object as Stripe.Subscription
      const userId = sub.metadata.supabase_user_id

      await supabase.from('subscriptions').update({
        status: 'canceled',
        canceled_at: new Date().toISOString(),
      }).eq('user_id', userId)
      break
    }

    case 'invoice.payment_failed': {
      const invoice = event.data.object as Stripe.Invoice
      const customerId = invoice.customer as string

      const { data: profile } = await supabase
        .from('profiles')
        .select('id')
        .eq('stripe_customer_id', customerId)
        .single()

      if (profile) {
        await supabase.from('subscriptions').update({ status: 'past_due' })
          .eq('user_id', profile.id)

        // Envia email de aviso de pagamento via Resend
        await sendPaymentFailedEmail(profile.id)
      }
      break
    }
  }

  return new Response('OK')
})
```

---

## 11. Segurança

### 11.1 JWT Validation em Edge Functions

```typescript
// supabase/functions/_shared/auth.ts
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

export async function getAuthenticatedUser(req: Request) {
  const authHeader = req.headers.get('Authorization')
  if (!authHeader?.startsWith('Bearer ')) {
    throw new Error('Missing authorization header')
  }

  const token = authHeader.replace('Bearer ', '')

  // Valida o JWT e retorna o usuário
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { global: { headers: { Authorization: `Bearer ${token}` } } }
  )

  const { data: { user }, error } = await supabase.auth.getUser()
  if (error || !user) throw new Error('Invalid or expired token')

  return user
}
```

### 11.2 Row Level Security — Pattern Padrão

```sql
-- supabase/migrations/003_rls.sql

-- Habilita RLS em todas as tabelas de dados de usuário
ALTER TABLE agents ENABLE ROW LEVEL SECURITY;
ALTER TABLE knowledge_bases ENABLE ROW LEVEL SECURITY;
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Pattern padrão para todas as tabelas com user_id
CREATE POLICY "users_own_data" ON agents
  FOR ALL
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Membros da equipe: podem ver conversas do usuário que os convidou
CREATE POLICY "team_members_see_conversations" ON conversations
  FOR SELECT
  USING (
    user_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM team_members
      WHERE team_members.member_user_id = auth.uid()
        AND team_members.owner_user_id = conversations.user_id
        AND team_members.status = 'active'
    )
  );
```

### 11.3 Criptografia de Tokens Instagram

```typescript
// supabase/functions/_shared/crypto.ts
// AES-256-GCM — autenticado, com IV aleatório por operação

export async function encrypt(plaintext: string, keyHex: string): Promise<string> {
  const key = await crypto.subtle.importKey(
    'raw',
    hexToBuffer(keyHex),
    { name: 'AES-GCM' },
    false,
    ['encrypt']
  )

  const iv = crypto.getRandomValues(new Uint8Array(12)) // 96-bit IV
  const encoded = new TextEncoder().encode(plaintext)

  const ciphertext = await crypto.subtle.encrypt(
    { name: 'AES-GCM', iv },
    key,
    encoded
  )

  // Retorna iv:ciphertext em base64 para armazenamento
  return `${bufferToBase64(iv)}:${bufferToBase64(ciphertext)}`
}

export async function decrypt(encryptedData: string, keyHex: string): Promise<string> {
  const [ivBase64, ciphertextBase64] = encryptedData.split(':')
  const iv = base64ToBuffer(ivBase64)
  const ciphertext = base64ToBuffer(ciphertextBase64)

  const key = await crypto.subtle.importKey(
    'raw',
    hexToBuffer(keyHex),
    { name: 'AES-GCM' },
    false,
    ['decrypt']
  )

  const plaintext = await crypto.subtle.decrypt(
    { name: 'AES-GCM', iv },
    key,
    ciphertext
  )

  return new TextDecoder().decode(plaintext)
}
```

### 11.4 Rate Limiting e CORS

```typescript
// supabase/functions/_shared/cors.ts
export const CORS_HEADERS = {
  'Access-Control-Allow-Origin': Deno.env.get('VITE_APP_URL') ?? '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Max-Age': '86400',
}

// Rate limit simples via banco (em produção, usar Redis/Upstash)
export async function checkRateLimit(
  supabase: any,
  userId: string,
  endpoint: string,
  limitPerMinute = 30
): Promise<boolean> {
  const oneMinuteAgo = new Date(Date.now() - 60 * 1000).toISOString()

  const { count } = await supabase
    .from('rate_limit_log')
    .select('*', { count: 'exact', head: true })
    .eq('user_id', userId)
    .eq('endpoint', endpoint)
    .gte('created_at', oneMinuteAgo)

  if ((count ?? 0) >= limitPerMinute) return false

  await supabase.from('rate_limit_log').insert({ user_id: userId, endpoint })
  return true
}
```

---

## 12. Deploy e CI/CD

### 12.1 Deploy do Frontend no Vercel

```
1. Conectar repositório GitHub ao Vercel
2. Build Command: npm run build
3. Output Directory: dist
4. Node.js Version: 20.x
5. Configurar variáveis de ambiente (VITE_*)
6. Domínio customizado: app.instaflow.ai
```

```json
// vercel.json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "X-XSS-Protection", "value": "1; mode=block" },
        { "key": "Referrer-Policy", "value": "strict-origin-when-cross-origin" }
      ]
    }
  ]
}
```

### 12.2 Deploy das Edge Functions

```bash
# Deploy de todas as Edge Functions
npx supabase functions deploy --project-ref <PROJECT_REF>

# Deploy de função específica
npx supabase functions deploy webhook-instagram --project-ref <PROJECT_REF>

# Configurar variáveis de ambiente nas Edge Functions
npx supabase secrets set --env-file .env.production --project-ref <PROJECT_REF>
```

### 12.3 GitHub Actions (CI/CD)

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  # ── Verificação de Qualidade ──────────────────────────────────────────
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Type check
        run: npm run typecheck

      - name: Lint
        run: npm run lint

      - name: Build
        run: npm run build
        env:
          VITE_SUPABASE_URL: ${{ secrets.VITE_SUPABASE_URL }}
          VITE_SUPABASE_ANON_KEY: ${{ secrets.VITE_SUPABASE_ANON_KEY }}
          VITE_STRIPE_PUBLISHABLE_KEY: ${{ secrets.VITE_STRIPE_PUBLISHABLE_KEY }}
          VITE_APP_URL: ${{ secrets.VITE_APP_URL }}

  # ── Deploy Supabase Functions (apenas main) ────────────────────────────
  deploy-functions:
    needs: quality
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4

      - name: Setup Supabase CLI
        uses: supabase/setup-cli@v1
        with:
          version: latest

      - name: Deploy Edge Functions
        run: supabase functions deploy --project-ref ${{ secrets.SUPABASE_PROJECT_REF }}
        env:
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}

  # ── Preview Deployment (PRs) ──────────────────────────────────────────
  preview:
    needs: quality
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    steps:
      - uses: actions/checkout@v4
      - name: Deploy Preview to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
```

---

## 13. Performance

### 13.1 Lazy Loading de Rotas

```typescript
// src/App.tsx — Code splitting automático por rota
import { lazy, Suspense } from 'react'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import { LoadingSpinner } from '@/components/shared/LoadingSpinner'

// Cada página é um chunk separado — carregado sob demanda
const DashboardPage      = lazy(() => import('@/pages/DashboardPage'))
const AgentsPage         = lazy(() => import('@/pages/AgentsPage'))
const FlowEditorPage     = lazy(() => import('@/pages/FlowEditorPage'))
const InboxPage          = lazy(() => import('@/pages/InboxPage'))
const AnalyticsPage      = lazy(() => import('@/pages/AnalyticsPage'))
// ... demais páginas

const router = createBrowserRouter([
  {
    path: '/',
    element: <AppLayout />,
    children: [
      { path: 'dashboard', element: <Suspense fallback={<LoadingSpinner />}><DashboardPage /></Suspense> },
      { path: 'agents', element: <Suspense fallback={<LoadingSpinner />}><AgentsPage /></Suspense> },
      // ...
    ],
  },
])
```

### 13.2 React Query para Cache de Server State

```typescript
// src/lib/queryClient.ts
import { QueryClient } from '@tanstack/react-query'

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 5 * 60 * 1000,      // Dados considerados frescos por 5 minutos
      gcTime: 30 * 60 * 1000,         // Mantém cache por 30 minutos
      retry: 2,
      refetchOnWindowFocus: false,     // Não refetch ao focar janela (Realtime cuida disso)
    },
  },
})

// Exemplo de hook com React Query
// src/hooks/useLeads.ts
export function useLeads(filters?: LeadFilters) {
  return useQuery({
    queryKey: ['leads', filters],
    queryFn: () => fetchLeads(filters),
    placeholderData: keepPreviousData, // Mantém dados anteriores ao mudar filtros
  })
}

// Invalidação otimista ao criar lead
export function useCreateLead() {
  return useMutation({
    mutationFn: createLead,
    onMutate: async (newLead) => {
      // Cancela queries em andamento
      await queryClient.cancelQueries({ queryKey: ['leads'] })

      // Snapshot do estado anterior
      const previousLeads = queryClient.getQueryData(['leads'])

      // Atualiza cache otimisticamente
      queryClient.setQueryData(['leads'], (old: Lead[]) => [
        { ...newLead, id: 'temp-' + Date.now() }, // ID temporário
        ...(old ?? []),
      ])

      return { previousLeads }
    },
    onError: (err, newLead, context) => {
      // Reverte em caso de erro
      queryClient.setQueryData(['leads'], context?.previousLeads)
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['leads'] })
    },
  })
}
```

### 13.3 Índices no Banco para Queries Frequentes

```sql
-- supabase/migrations/002_schema.sql

-- Queries mais comuns na inbox
CREATE INDEX idx_messages_conversation_sent
  ON messages(conversation_id, sent_at DESC);

CREATE INDEX idx_conversations_user_updated
  ON conversations(user_id, last_message_at DESC);

-- Busca de leads por instagram_user_id (webhook recebe com frequência)
CREATE INDEX idx_leads_user_instagram
  ON leads(user_id, instagram_user_id);

-- Busca de agentes ativos por conta Instagram
CREATE INDEX idx_agents_instagram_active
  ON agents(instagram_account_id, is_active)
  WHERE is_active = true; -- Índice parcial: só indexa registros ativos

-- Busca de keywords ativas
CREATE INDEX idx_keywords_user_active
  ON keywords(user_id, is_active)
  WHERE is_active = true;

-- Analytics: queries por período
CREATE INDEX idx_analytics_user_date
  ON analytics_events(user_id, created_at DESC);

-- Tokens de Instagram próximos da expiração (cron job)
CREATE INDEX idx_instagram_token_expires
  ON instagram_accounts(token_expires_at)
  WHERE is_active = true;
```

### 13.4 Debounce em Buscas e Scroll Infinito

```typescript
// src/hooks/useDebounce.ts
export function useDebounce<T>(value: T, delayMs = 300): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value)

  useEffect(() => {
    const timer = setTimeout(() => setDebouncedValue(value), delayMs)
    return () => clearTimeout(timer)
  }, [value, delayMs])

  return debouncedValue
}

// src/hooks/useInfiniteScroll.ts
export function useInfiniteScroll(callback: () => void, options?: IntersectionObserverInit) {
  const ref = useRef<HTMLDivElement>(null)

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        if (entries[0].isIntersecting) callback()
      },
      { threshold: 0.1, ...options }
    )

    if (ref.current) observer.observe(ref.current)
    return () => observer.disconnect()
  }, [callback])

  return ref
}

// Uso no CRMPage.tsx
function CRMPage() {
  const [search, setSearch] = useState('')
  const debouncedSearch = useDebounce(search, 400)

  const { data, fetchNextPage, hasNextPage, isFetchingNextPage } = useInfiniteQuery({
    queryKey: ['leads', debouncedSearch],
    queryFn: ({ pageParam = 0 }) => fetchLeadsPage(debouncedSearch, pageParam),
    getNextPageParam: (lastPage) => lastPage.nextCursor,
    initialPageParam: 0,
  })

  const sentinelRef = useInfiniteScroll(() => {
    if (hasNextPage && !isFetchingNextPage) fetchNextPage()
  })

  return (
    <div>
      <input value={search} onChange={(e) => setSearch(e.target.value)} />
      {data?.pages.flatMap(p => p.leads).map(lead => <LeadCard key={lead.id} lead={lead} />)}
      <div ref={sentinelRef} />
      {isFetchingNextPage && <LoadingSpinner />}
    </div>
  )
}
```

---

## Apêndice A: Tabelas do Banco de Dados (Resumo)

```sql
profiles             — Dados do usuário (nome, empresa, avatar, stripe_customer_id)
subscriptions        — Plano, status, limites, datas de trial/renovação
instagram_accounts   — Contas Instagram conectadas + tokens criptografados
agents               — Configurações dos agentes de IA (prompt, modelo, temperature)
knowledge_bases      — Agrupamentos de documentos por agente
knowledge_documents  — Documentos individuais (PDF, URL, texto)
document_chunks      — Chunks indexados com vetor embedding (pgvector)
leads                — Contatos do Instagram com dados e tags
conversations        — Conversas (1 por lead por conta Instagram)
messages             — Mensagens individuais (inbound/outbound)
flows                — Fluxos de automação (JSON do canvas ReactFlow)
keywords             — Regras de palavra-chave + ação
broadcasts           — Mensagens em massa agendadas
broadcast_recipients — Destinatários de cada broadcast
analytics_events     — Eventos de analytics (page views, conversões)
team_members         — Membros da equipe com roles
notifications        — Notificações em tempo real
ai_usage_logs        — Logs de uso de IA (tokens, latência, custo estimado)
rate_limit_log       — Controle de rate limiting por usuário + endpoint
audit_logs           — Auditoria de ações sensíveis
```

---

> Documento mantido pela equipe de engenharia do InstaFlow AI.
> Para dúvidas sobre decisões arquiteturais, consulte o `docs/architecture/` ou abra uma issue no repositório.
