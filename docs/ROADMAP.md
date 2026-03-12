# InstaFlow AI — Roadmap Completo de Desenvolvimento

> **Versao:** 1.0.0
> **Data:** Marco 2026
> **Stack:** React + TypeScript + Vite + Supabase + Meta Graph API + OpenAI/Anthropic/Google + Stripe
> **Mercado:** Brasil
> **Modelo:** SaaS multi-usuario para automacao de Instagram com agentes de IA

---

## Como Ler Este Documento

Este roadmap descreve o desenvolvimento completo do InstaFlow AI — nao um MVP, mas o produto inteiro. Cada fase representa um bloco de funcionalidades coesas que podem ser entregues e validadas de forma independente.

O progresso de cada item segue a convencao abaixo:

| Marcador | Significado |
|----------|-------------|
| `[ ]` | Pendente — nao iniciado |
| `[~]` | Em progresso — sendo desenvolvido |
| `[x]` | Concluido — verificado e funcional |

**Leitura sugerida:**

1. Leia a secao de Dependencias Criticas antes de comecar qualquer fase
2. Cada fase lista tarefas e criterios de aceite — nao avance para a proxima fase sem cumprir os criterios
3. A ordem das fases importa: ha dependencias tecnicas entre elas
4. As estimativas de tempo assumem um desenvolvedor solo trabalhando em tempo integral

---

## Dependencias Criticas — Leia Antes de Comecar

Antes de escrever qualquer linha de codigo, estas acoes devem ser iniciadas. Algumas demoram semanas para serem aprovadas.

- **Meta App Review** — Inicie imediatamente. O processo de aprovacao para acesso a Messaging API leva de 2 a 4 semanas. Sem isso, nenhuma integracao com Instagram funciona em producao. Crie o app, configure os webhooks basicos e submeta para revisao enquanto desenvolve as outras fases.

- **Conta Stripe (PJ)** — Crie a conta empresarial antes de comecar. Requer CNPJ e documentacao da empresa. Leva alguns dias uteis para liberacao completa (inclusive para saques).

- **Supabase Pro Plan** — O plano gratuito nao suporta pgvector em producao adequada nem Edge Functions com volume. Assine o Pro antes de iniciar a Fase 4 (Base de Conhecimento).

- **Conta de desenvolvedor Meta** — Necessaria para acessar a Graph API. Configure o Business Manager, crie um App no Meta for Developers e adicione os produtos necessarios: Instagram Graph API, Webhooks, Messenger.

---

## FASE 0 — Preparacao e Setup

**Duracao estimada:** Semana 1
**Objetivo:** Ambiente de desenvolvimento e producao totalmente configurado, app vazio rodando em producao com CI/CD automatico.

### Supabase

- [ ] Criar projeto no Supabase (escolher regiao sa-east-1 para Brasil)
- [ ] Configurar autenticacao: habilitar email/senha, OAuth Google, OAuth Meta
- [ ] Criar bucket no Storage para uploads (documentos, imagens, avatares)
- [ ] Configurar politicas de Storage (public para avatares, private para documentos)
- [ ] Habilitar extensao pgvector no banco
- [ ] Configurar RLS (Row Level Security) como padrao para todas as tabelas
- [ ] Criar migration inicial com tabelas de usuarios e configuracoes de tenant
- [ ] Configurar SMTP customizado no Supabase Auth (usar Resend)
- [ ] Salvar URL do projeto e anon key

### Projeto React

- [ ] Confirmar setup Vite + React + TypeScript existente
- [ ] Instalar dependencias principais:
  - `@supabase/supabase-js` e `@supabase/auth-ui-react`
  - `@tanstack/react-query` (cache e estado de servidor)
  - `react-router-dom` (rotas)
  - `zustand` (estado global)
  - `react-hook-form` + `zod` (formularios e validacao)
  - `date-fns` (datas em pt-BR)
  - `recharts` (graficos)
  - `reactflow` (flow builder — instalar agora, usar na Fase 5)
  - `@stripe/stripe-js` + `@stripe/react-stripe-js`
  - `lucide-react` (icones)
  - `sonner` (toasts)
  - `cmdk` (paleta de comandos)
- [ ] Instalar dependencias de desenvolvimento:
  - `@types/node`, `vitest`, `@testing-library/react`, `playwright`
  - `eslint`, `prettier`, `eslint-plugin-react-hooks`

### Tailwind e shadcn/ui

- [ ] Instalar e configurar Tailwind CSS v3
- [ ] Configurar tema customizado (cores da marca InstaFlow)
- [ ] Instalar shadcn/ui CLI e inicializar
- [ ] Adicionar componentes base: Button, Input, Card, Dialog, Sheet, Tabs, Select, Checkbox, Badge, Avatar, Tooltip, Dropdown, Table, Form

### Qualidade de Codigo

- [ ] Configurar ESLint com regras: `react-hooks`, `@typescript-eslint/recommended`, `jsx-a11y`
- [ ] Configurar Prettier (printWidth: 100, singleQuote: true, semi: true)
- [ ] Habilitar TypeScript strict mode no `tsconfig.json`
- [ ] Configurar lint-staged + husky (lint antes de cada commit)
- [ ] Configurar path aliases no Vite (`@/` aponta para `src/`)

### Variaveis de Ambiente

- [ ] Criar `.env.local` com todas as variaveis necessarias:
  - `VITE_SUPABASE_URL`
  - `VITE_SUPABASE_ANON_KEY`
  - `VITE_STRIPE_PUBLISHABLE_KEY`
  - `VITE_SENTRY_DSN`
  - `VITE_META_APP_ID`
  - `VITE_APP_URL`
- [ ] Criar `.env.example` documentado (sem valores reais)
- [ ] Adicionar `.env.local` ao `.gitignore`
- [ ] Configurar variaveis de ambiente no Vercel

### Stripe

- [ ] Criar conta Stripe (PJ com CNPJ)
- [ ] Criar produtos e precos:
  - Plano Starter (R$97/mes)
  - Plano Growth (R$197/mes)
  - Plano Agency (R$397/mes)
  - Precos anuais com desconto de 20%
- [ ] Configurar webhook endpoint no Stripe Dashboard
- [ ] Criar Edge Function no Supabase para receber webhooks Stripe
- [ ] Configurar Stripe Customer Portal
- [ ] Testar ciclo completo com cartao de teste

### Meta Developer

- [ ] Criar app no Meta for Developers
- [ ] Adicionar produto: Instagram Graph API
- [ ] Adicionar produto: Webhooks
- [ ] Configurar webhooks para receber eventos: messages, mentions, comments, story_insights
- [ ] Solicitar permissoes necessarias: `instagram_basic`, `instagram_manage_messages`, `instagram_manage_comments`, `pages_read_engagement`
- [ ] Submeter para App Review (iniciar o quanto antes)
- [ ] Configurar modo de desenvolvimento para testes iniciais

### Monitoramento e Emails

- [ ] Criar conta Sentry
- [ ] Instalar `@sentry/react` e configurar DSN
- [ ] Configurar alertas de erro por email no Sentry
- [ ] Criar conta Resend
- [ ] Verificar dominio no Resend (configurar DNS)
- [ ] Criar templates de email transacional:
  - Boas-vindas (ativacao da conta)
  - Verificacao de email
  - Recuperacao de senha
  - Trial expirando (D-2: 1 dia antes do fim)
  - Trial expirado (D-0)
  - Novo membro adicionado a equipe
- [ ] Criar Edge Functions no Supabase para envio de emails

### Deploy e CI/CD

- [ ] Criar projeto no Vercel, conectar repositorio GitHub
- [ ] Configurar branch `main` como producao e `develop` como preview
- [ ] Configurar variaveis de ambiente no Vercel
- [ ] Configurar Cloudflare como CDN e DNS (redirecionar dominio)
- [ ] Configurar SSL automatico
- [ ] Testar pipeline completo: push no GitHub → build → deploy

### Criterios de Aceite da Fase 0

- [ ] App React compilando sem erros de TypeScript
- [ ] App acessivel em producao via dominio customizado (mesmo que tela em branco)
- [ ] Supabase conectado — query de teste retorna sem erro
- [ ] Push no `main` dispara deploy automatico no Vercel
- [ ] Emails transacionais chegando (teste manual)
- [ ] Sentry capturando erros (lance um erro de teste)

---

## FASE 1 — Autenticacao e Onboarding

**Duracao estimada:** Semanas 2-3
**Objetivo:** Qualquer pessoa consegue criar conta, verificar email, fazer login e completar o onboarding, incluindo conexao do Instagram Business.

### Paginas de Autenticacao

- [ ] Pagina de login
  - Campos: email, senha
  - OAuth Google (botao "Entrar com Google")
  - OAuth Meta/Instagram (botao "Entrar com Instagram")
  - Link "Esqueci minha senha"
  - Link "Criar conta"
  - Redirect automatico se ja autenticado
- [ ] Pagina de registro
  - Campos: nome completo, email, senha, confirmacao de senha
  - Checkbox de aceite dos Termos de Uso e Politica de Privacidade (LGPD)
  - Validacao em tempo real (zod)
  - Mensagem de sucesso + instrucao de verificar email
- [ ] Pagina de verificacao de email
  - Estado de aguardando verificacao
  - Botao "Reenviar email de verificacao"
  - Redirect automatico apos verificar
- [ ] Pagina de recuperacao de senha
  - Campo de email
  - Envio de link por email
  - Mensagem de confirmacao de envio
- [ ] Pagina de reset de senha
  - Recebe token por URL
  - Campos: nova senha, confirmacao
  - Redirect para login apos sucesso

### Onboarding Wizard (5 passos)

Aparece apenas uma vez, apos o primeiro login. Estado salvo no banco para nao repetir.

- [ ] Estrutura do wizard (barra de progresso, navegacao entre passos, botoes Anterior/Proximo/Pular)

- [ ] Passo 1 — Boas-vindas e Segmento
  - Mensagem personalizada com nome do usuario
  - Selecao de segmento de atuacao (cards clicaveis):
    - E-commerce / Loja virtual
    - Infoprodutos / Cursos online
    - Servicos / Consultoria
    - Restaurante / Food Service
    - Moda / Beleza / Estetica
    - Imobiliaria
    - Outro (campo de texto)
  - Segmento salvo no perfil (sera usado para sugerir templates)

- [ ] Passo 2 — Conectar Instagram Business
  - Instrucao clara sobre o que precisa (conta Business ou Creator)
  - Botao "Conectar Instagram" (OAuth Meta)
  - Fluxo OAuth: redireciona para Meta, usuario autoriza, volta ao app
  - Exibe lista de contas Instagram disponiveis (usuario pode ter mais de uma)
  - Usuario seleciona qual conta conectar
  - Salva tokens de acesso no banco (criptografados)
  - Estado de sucesso: foto de perfil + username do Instagram aparece
  - Opcao "Pular por agora" (pode conectar depois em Configuracoes)

- [ ] Passo 3 — Modo de Operacao
  - Explicacao dos tres modos com ilustracao:
    - **Agente de IA**: o bot responde tudo automaticamente
    - **Fluxos**: voce define os caminhos com logica visual
    - **Hibrido**: fluxos + agente + humano conforme necessario (recomendado)
  - Usuario seleciona o modo preferido
  - Salvo no perfil (pode ser alterado depois)

- [ ] Passo 4 — Criar Primeiro Agente
  - Campo: nome do agente (ex: "Assistente da [Marca]")
  - Selecao de template de agente baseado no segmento escolhido no Passo 1
  - Preview do system prompt do template
  - Botao "Criar Agente com Este Template"
  - Agente criado automaticamente no banco

- [ ] Passo 5 — Tutorial Rapido
  - Cards clicaveis explicando os 5 recursos principais:
    1. Agentes de IA
    2. Flow Builder
    3. Palavras-chave
    4. CRM / Leads
    5. Analytics
  - Botao "Ir para o Dashboard"
  - Marca onboarding como concluido no banco

### Sistema de Trial

- [ ] Ao registrar: ativar trial de 3 dias automaticamente (salvar `trial_ends_at` no banco)
- [ ] Criar funcao utilitaria `useTrialStatus()` (dias restantes, expirado ou nao, plano ativo)
- [ ] Banner persistente no topo do app mostrando dias restantes (aparece se trial ativo e nao assinante)
  - "Seu trial expira em X dias — Assine agora e continue sem interrupcoes"
  - CTA "Ver Planos"
  - Botao de fechar (fecha por 24h, volta depois)
- [ ] Email D-2: enviado automaticamente 1 dia antes do trial expirar
  - Assunto: "Seu trial do InstaFlow AI expira amanha"
  - Conteudo: resumo do que foi feito no trial + CTA para assinar
- [ ] Email D-0: enviado quando trial expira
  - Assunto: "Seu trial encerrou — seus dados estao salvos"
  - Conteudo: o que acontece com os dados + CTA urgente
- [ ] Tela de bloqueio apos trial expirado
  - Aparece no lugar do dashboard
  - Exibe o que o usuario criou durante o trial (nao apaga)
  - CTA grande "Assinar agora e retomar"
  - Precos dos planos
- [ ] Opcao de pular o trial e assinar diretamente (link na pagina de registro)
- [ ] Cron job no Supabase (pg_cron) para verificar trials expirados e disparar emails

### Criterios de Aceite da Fase 1

- [ ] Usuario consegue se registrar, verificar email e fazer login
- [ ] OAuth Google funciona (login e registro)
- [ ] OAuth Meta funciona e conecta Instagram Business corretamente
- [ ] Onboarding completo sem bugs, estado salvo corretamente
- [ ] Trial de 3 dias ativado automaticamente ao registrar
- [ ] Email de trial expirando chega 1 dia antes (testar com data simulada)
- [ ] Email de trial expirado chega no dia (testar com data simulada)
- [ ] Tela de bloqueio aparece quando trial expira

---

## FASE 2 — Layout e Dashboard

**Duracao estimada:** Semanas 4-5
**Objetivo:** Layout principal responsivo e funcional, dashboard com dados reais e atualizacao em tempo real.

### Layout Principal

- [ ] Sidebar de navegacao
  - Colapsavel (estado salvo em localStorage)
  - Logo InstaFlow AI (expandido e colapsado)
  - Foto + nome + plano do usuario
  - Itens de navegacao com icones:
    - Dashboard
    - Agentes de IA
    - Base de Conhecimento
    - Flow Builder
    - Palavras-chave
    - CRM / Leads
    - Caixa de Entrada
    - Broadcasts
    - Agendador de Posts
    - Analytics
    - Equipe
    - Integracoes
    - Configuracoes
  - Badges de notificacao nos itens relevantes (ex: Caixa de Entrada)
  - Footer da sidebar: versao do app, link para suporte

- [ ] Header global
  - Nome da pagina atual
  - Indicador de conta Instagram conectada (foto + username)
  - Indicador de plano atual (badge)
  - Icone de notificacoes (dropdown com lista)
  - Avatar do usuario (dropdown: perfil, configuracoes, sair)

- [ ] Mobile
  - Sidebar vira drawer (hamburguer menu no header)
  - Navegacao inferior para acoes frequentes (Dashboard, Inbox, CRM)
  - Gestos de swipe para abrir/fechar o drawer

- [ ] Dark Mode / Light Mode
  - Toggle no header ou em Configuracoes
  - Respeitar preferencia do sistema (`prefers-color-scheme`)
  - Salvar preferencia do usuario no banco

- [ ] Rotas protegidas
  - Redirect para login se nao autenticado
  - Redirect para tela de bloqueio se trial expirado e sem plano
  - Loading skeleton enquanto verifica autenticacao

### Dashboard

- [ ] Cards de metricas (grid 2x2 em mobile, 4x1 em desktop)
  - Total de mensagens recebidas (ultimos 30 dias vs periodo anterior — delta)
  - Novos leads capturados (ultimos 30 dias)
  - Conversoes realizadas (ultimos 30 dias)
  - Receita atribuida ao bot (ultimos 30 dias)
  - Cada card com: valor principal, percentual de variacao, icone, sparkline

- [ ] Grafico de conversoes por dia
  - Biblioteca Recharts (AreaChart)
  - Filtro de periodo: 7 dias, 30 dias, 90 dias
  - Tooltip com detalhes ao hover
  - Responsivo

- [ ] Lista de conversas recentes
  - Ultimas 10 conversas com atividade
  - Para cada conversa: foto, username, ultima mensagem (truncada), tempo relativo, status
  - Atualiza em tempo real (Supabase Realtime)
  - Link para abrir a conversa completa na Caixa de Entrada

- [ ] Funil de vendas resumido
  - Quantidade de leads em cada etapa
  - Barra de progresso visual
  - Link para o CRM completo

- [ ] Feed de atividades em tempo real
  - Lista cronologica de eventos: novo lead, mensagem recebida, conversao, keyword ativada
  - Icone por tipo de evento
  - Atualiza automaticamente (Supabase Realtime)
  - "Ver mais" carrega historico paginado

- [ ] Widget de trial ou plano
  - Se trial ativo: dias restantes + CTA para assinar
  - Se assinante: plano atual + data de renovacao + link para gerenciar

### Criterios de Aceite da Fase 2

- [ ] Layout responsivo funciona em 320px, 768px e 1440px
- [ ] Sidebar colapsavel (estado persiste entre reloads)
- [ ] Dark mode funciona em todos os componentes
- [ ] Dashboard carrega com dados reais do banco (sem hardcode)
- [ ] Realtime: nova conversa aparece na lista sem refresh da pagina
- [ ] Realtime: nova atividade aparece no feed sem refresh
- [ ] Performance: dashboard carrega em menos de 2 segundos (LCP)

---

## FASE 3 — Agentes de IA

**Duracao estimada:** Semanas 6-8
**Objetivo:** Sistema completo de criacao e configuracao de agentes de IA com playground de testes, biblioteca de templates e gerador por IA.

### CRUD de Agentes

- [ ] Pagina de lista de agentes
  - Grid de cards (agente: avatar, nome, modelo, status ativo/inativo, metricas resumidas)
  - Botao "Criar Agente"
  - Filtros: todos, ativos, inativos
  - Busca por nome

- [ ] Criar agente — formulario
  - Nome do agente (obrigatorio)
  - Descricao interna (para sua referencia)
  - Avatar (upload de imagem ou selecionar emoji)
  - Tom de comunicacao (formal, amigavel, direto, descontraido, profissional)
  - Editor de system prompt (textarea com contagem de tokens em tempo real)
  - Seletor de provider de IA:
    - OpenAI (GPT-4o, GPT-4o Mini, GPT-4 Turbo)
    - Anthropic (Claude 3.5 Sonnet, Claude 3 Haiku)
    - Google (Gemini 1.5 Pro, Gemini 1.5 Flash)
  - Configuracoes avancadas (acordeao):
    - Temperatura (slider 0-2, default 0.7)
    - Max tokens de resposta (slider 100-4000, default 500)
    - Delay antes de responder (0-10 segundos, simula digitacao humana)
    - Limite de mensagens por usuario por dia
    - Horario de funcionamento do agente
  - Toggle: permitir handoff para humano (quando agente nao sabe responder)
  - Vincular base de conhecimento (selecao multipla)
  - Botao "Salvar e Testar no Playground"

- [ ] Editar agente (mesmos campos do criar)
- [ ] Duplicar agente (cria copia com "(Copia)" no nome)
- [ ] Deletar agente (soft delete — dados mantidos, agente desativado)
- [ ] Toggle rapido ativar/desativar no card da lista

### Playground de Testes

- [ ] Layout dividido: chat a esquerda, painel de insights a direita
- [ ] Chat com o agente
  - Simula como o lead vera a conversa
  - Input de mensagem + botao enviar (Enter tambem envia)
  - Indicador de "digitando..." durante geracao da resposta
  - Historico de mensagens com timestamps
  - Baloes de mensagem diferenciados (usuario vs agente)
- [ ] Painel de insights (atualiza apos cada resposta)
  - Intencao detectada (ex: "interesse em compra", "duvida sobre preco")
  - Sentimento (positivo, neutro, negativo — com percentual)
  - Score de confianca da resposta (0-100%)
  - Trecho da base de conhecimento usado (se houver)
  - Tokens consumidos nessa mensagem
  - Custo estimado da mensagem (em USD)
- [ ] Botao "Resetar Conversa" (limpa o historico de teste)
- [ ] Botao "Salvar Conversa de Teste" (salva para referencia futura)

### Biblioteca de Prompts

- [ ] Pagina da biblioteca com grid de templates
- [ ] Cada card: nome, descricao, categoria, segmento, preview do prompt (truncado)
- [ ] Filtros:
  - Por categoria (vendas, suporte, qualificacao, agendamento, pos-venda)
  - Por segmento (e-commerce, servicos, infoprodutos, etc.)
  - Busca por palavra-chave
- [ ] Modal de preview: exibe o prompt completo, descricao, casos de uso
- [ ] Botao "Usar Template": fecha o modal e preenche o form do agente com o prompt
- [ ] Botao "Personalizar e Salvar como Meu Template": abre editor, salva na conta do usuario
- [ ] Templates proprios do usuario: secao separada "Meus Templates"
- [ ] Minimo de 15 templates prontos cobrindo os principais segmentos e casos de uso

### Gerador de Prompts por IA

- [ ] Wizard em etapas (progress bar)
- [ ] Pergunta 1: Qual e o segmento do seu negocio? (selecao com opcoes)
- [ ] Pergunta 2: Qual e o objetivo principal deste agente? (selecao: vender, qualificar, suporte, agendar, informar)
- [ ] Pergunta 3: Como deve ser o tom? (escala: formal ate descontraido)
- [ ] Pergunta 4: Quais sao as 3 informacoes mais importantes sobre seu negocio? (textarea)
- [ ] Pergunta 5: Quais sao as perguntas mais frequentes dos seus clientes? (textarea)
- [ ] Botao "Gerar Prompt com IA"
- [ ] Chamada para GPT-4o via Edge Function: gera system prompt completo e profissional
- [ ] Exibe o prompt gerado em um editor de texto
- [ ] Botao "Usar Este Prompt" (transfere para o formulario do agente)
- [ ] Botao "Gerar Novamente" (nova variacao)
- [ ] Botao "Salvar como Template" (salva na biblioteca pessoal)

### Criterios de Aceite da Fase 3

- [ ] Agente criado responde no playground usando o modelo de IA configurado
- [ ] System prompt e temperatura sao respeitados nas respostas
- [ ] Painel de insights exibe dados reais (sentimento, intencao, tokens)
- [ ] Biblioteca tem 15+ templates funcionais, filtros funcionam
- [ ] Gerador de prompts produz prompt de qualidade (avaliar manualmente 3 gerações)
- [ ] Handoff para humano: quando configurado, agente para de responder e notifica equipe

---

## FASE 4 — Base de Conhecimento

**Duracao estimada:** Semanas 9-10
**Objetivo:** Sistema completo de indexacao de documentos e URLs com busca semantica por embeddings, integrado aos agentes.

### Upload de Documentos

- [ ] Upload de PDF
  - Extrair texto usando `pdf-parse` ou similar (via Edge Function)
  - Progresso de upload em tempo real
  - Estado de processamento: aguardando, processando, indexado, erro
- [ ] Upload de DOCX (extrair texto com `mammoth`)
- [ ] Upload de TXT e CSV
- [ ] Upload de XLSX (extrair dados das planilhas com `xlsx`)
- [ ] Suporte a multiplos arquivos em paralelo
- [ ] Limite de tamanho por arquivo (configuravel por plano)

### Adicionar URLs e Sites

- [ ] Campo para adicionar URL individual
  - Scraping do conteudo via Edge Function (usar `cheerio` ou servico headless)
  - Extrai: titulo, descricao, conteudo principal (sem navegacao, rodape, etc.)
- [ ] Rastrear sitemap completo
  - Campo para URL do sitemap (sitemap.xml)
  - Lista todas as paginas encontradas
  - Usuario seleciona quais paginas incluir
  - Rastreamento em batch (Edge Functions com Queue)
- [ ] Sincronizacao automatica de URLs
  - Configurar frequencia: diaria ou semanal
  - Re-indexa automaticamente o conteudo atualizado
  - Notifica se conteudo nao estiver mais acessivel

### FAQ Estruturado

- [ ] Interface para criar pares pergunta/resposta manualmente
- [ ] CRUD de perguntas frequentes
- [ ] Importar FAQ de arquivo CSV (coluna "pergunta", coluna "resposta")
- [ ] Categorias de FAQ

### Processamento e Indexacao

- [ ] Pipeline de indexacao (via Edge Function):
  1. Receber texto extraido
  2. Dividir em chunks (500 tokens, overlap de 50 tokens)
  3. Gerar embedding para cada chunk via OpenAI `text-embedding-3-small`
  4. Salvar chunks + embeddings na tabela `knowledge_chunks` (com pgvector)
- [ ] Status de processamento em tempo real (Supabase Realtime)
  - Progresso de indexacao: "Processando... X de Y chunks"
  - Estado final: "Indexado com sucesso — X chunks, X tokens"
- [ ] Re-indexar documento (quando atualizado)
- [ ] Deletar documento (remove do Storage + remove chunks do banco)

### Busca Semantica

- [ ] Funcao SQL `match_chunks(query_embedding, threshold, limit)` usando pgvector
- [ ] Busca semantica disponivel no Playground (campo de busca de teste)
- [ ] Integrado automaticamente nos agentes que tem knowledge base vinculada
- [ ] Configurar numero de chunks retornados por consulta (default: 5)
- [ ] Configurar score minimo de similaridade (default: 0.75)

### Painel de Gerenciamento

- [ ] Lista de todos os documentos e URLs indexados
- [ ] Para cada item: nome, tipo, status, data de indexacao, numero de chunks, tokens indexados
- [ ] Estatisticas gerais: total de documentos, total de chunks, total de tokens
- [ ] Vincular knowledge base a agente especifico ou marcar como "global" (todos os agentes usam)

### Criterios de Aceite da Fase 4

- [ ] Upload de PDF de 50 paginas e indexado em menos de 2 minutos
- [ ] URL scraped e indexada com conteudo relevante (sem lixo de navegacao)
- [ ] Agente usa knowledge base para responder no playground (verificar com pergunta especifica)
- [ ] Busca semantica retorna chunks relevantes com score acima do threshold
- [ ] Status de processamento atualiza em tempo real sem refresh

---

## FASE 5 — Flow Builder Visual

**Duracao estimada:** Semanas 11-14
**Objetivo:** Editor visual completo para criar automacoes com logica condicional, integrado com agentes, e engine de execucao em producao.

### Editor Visual (ReactFlow)

- [ ] Canvas de edicao com ReactFlow
  - Zoom in/out (scroll ou botoes)
  - Pan (arrastar o canvas)
  - Mini-map (navegacao em fluxos grandes)
  - Grid de fundo
- [ ] Barra lateral de nos disponiveis (arrastar para o canvas)
- [ ] Conectar nos com setas
- [ ] Selecionar, mover e deletar nos
- [ ] Selecionar multiplos nos (area de selecao)
- [ ] Undo / Redo (Ctrl+Z / Ctrl+Y)
- [ ] Salvamento automatico (debounce de 2 segundos)
- [ ] Indicador de "Salvo" / "Salvando..."

### Tipos de Nos

- [ ] **Trigger** — ponto de entrada do fluxo
  - Nova mensagem direta (DM)
  - Comentario em post
  - Resposta a story
  - Keyword detectada (selecionar keyword cadastrada)
  - Webhook externo
  - Configuracao: para novos leads apenas, ou para todos

- [ ] **Mensagem** — envia mensagem para o lead
  - Texto simples (com suporte a variaveis: `{{first_name}}`, `{{username}}`, etc.)
  - Imagem (upload ou URL)
  - Video (URL)
  - Audio (upload)
  - Carrossel (multiplas imagens com legenda)
  - Botoes de resposta rapida (Quick Replies — max 3)
  - Delay antes de enviar (0-60 segundos)

- [ ] **Condicao IF/ELSE** — divide o fluxo em caminhos
  - Condicoes disponiveis:
    - Lead tem tag X
    - Campo do lead tem valor Y
    - Mensagem contem texto Z
    - Horario atual esta entre HH:MM e HH:MM
    - Numero de interacoes e maior/menor que N
    - Lead esta na etapa X do funil
  - Suporte a multiplas condicoes (AND / OR)
  - Saidas: "Verdadeiro" e "Falso"

- [ ] **Acao** — executa uma acao no sistema
  - Adicionar tag ao lead
  - Remover tag do lead
  - Mover lead para etapa do funil
  - Atualizar campo customizado do lead
  - Notificar membro da equipe (via email + notificacao in-app)
  - Chamar webhook externo (URL + payload)
  - Atribuir conversa para membro da equipe

- [ ] **Delay** — pausa a execucao
  - Aguardar X minutos / horas / dias
  - Aguardar ate proximo dia util
  - Aguardar ate horario especifico

- [ ] **Agente de IA** — transfere a conversa para um agente
  - Selecionar agente configurado
  - Numero maximo de mensagens que o agente vai responder antes de continuar o fluxo
  - Condicao de saida: agente detectou intencao X

- [ ] **A/B Test** — divide trafego entre dois caminhos
  - Percentual de divisao (ex: 50%/50%, 70%/30%)
  - Saidas: "Variante A" e "Variante B"
  - Analytics separado por variante

- [ ] **Randomizar Caminho** — escolhe aleatoriamente entre N saidas

### Gerenciamento de Fluxos

- [ ] Pagina de lista de fluxos (nome, trigger, status, data de criacao, execucoes)
- [ ] Criar novo fluxo (nome + escolher trigger inicial)
- [ ] Editar fluxo (abre editor)
- [ ] Duplicar fluxo
- [ ] Ativar / desativar fluxo (toggle)
- [ ] Deletar fluxo (soft delete)
- [ ] Validacao antes de ativar: alertas para nos desconectados, campos obrigatorios vazios

### Biblioteca de Templates de Fluxos

- [ ] Minimo de 10 templates prontos por categoria:
  - Qualificacao de leads
  - Atendimento inicial e FAQ
  - Recuperacao de carrinho abandonado
  - Pos-venda e fidelizacao
  - Agendamento de reuniao
  - Coleta de depoimento
  - Campanha de lancamento
  - Reengajamento de leads frios
  - Onboarding de novo cliente
  - Suporte tecnico
- [ ] Preview do fluxo antes de importar (visualizacao do grafo)
- [ ] Importar template para o editor (cria copia editavel)

### Analytics de Fluxos

- [ ] Por fluxo: total de execucoes, taxa de conclusao, tempo medio
- [ ] Drop-off por no: quantos leads chegaram vs saíram em cada no
- [ ] Grafico de funil visual
- [ ] Filtro de periodo

### Logs de Execucao

- [ ] Para cada execucao: lead, data/hora, no atual, status, log de acoes executadas
- [ ] Filtrar por fluxo, status (em andamento, concluido, erro), data
- [ ] Detalhe de execucao: timeline completa de cada passo

### Engine de Execucao (Backend)

- [ ] Edge Function para iniciar execucao de fluxo (chamada pelo webhook da Meta)
- [ ] Edge Function para processar cada no e avançar a execucao
- [ ] Fila de execucao para delays (usar pg_cron ou Supabase Queues)
- [ ] Tratamento de erros: retry automatico em falha de envio (max 3 tentativas)
- [ ] Rate limiting para respeitar limites da Meta Graph API

### Criterios de Aceite da Fase 5

- [ ] Flow builder abre, nos sao arrastados, conectados, salvos sem bugs
- [ ] Fluxo simples (trigger DM → mensagem de texto → condicao → acao de tag) funciona em producao com lead real
- [ ] Templates sao importaveis e editaveis
- [ ] Undo/Redo funciona corretamente
- [ ] Analytics de fluxo mostra dados reais
- [ ] Logs de execucao registram cada passo corretamente

---

## FASE 6 — Palavras-chave e Auto-input

**Duracao estimada:** Semanas 15-16
**Objetivo:** Sistema de deteccao de palavras-chave em DM e comentarios, com acoes automatizadas e suporte ao fluxo completo de auto-input.

### CRUD de Palavras-chave

- [ ] Pagina de lista com cards (keyword, canal, acao, status, total de triggers)
- [ ] Formulario de criacao / edicao:
  - Palavras-chave (campo de tags — adicionar multiplas)
  - Tipo de match:
    - Exato (mensagem e exatamente a keyword)
    - Contem (mensagem contem a keyword em qualquer posicao)
    - Comeca com
    - Termina com
    - Regex (para usuarios avancados)
  - Canal de monitoramento: DM, comentarios, story replies, todos
  - Case sensitive? (toggle)
- [ ] Ativar / desativar / pausar keyword
- [ ] Deletar keyword

### Acoes das Keywords

- [ ] Acao principal (selecao exclusiva):
  - Enviar mensagem de texto (com variaveis)
  - Acionar fluxo (selecionar fluxo criado)
  - Chamar agente de IA (selecionar agente)
  - Chamar webhook externo
- [ ] Acoes adicionais (multiplas, em sequencia):
  - Adicionar tag ao lead
  - Remover tag do lead
  - Mover lead para etapa do funil
  - Notificar membro da equipe
  - Atualizar campo customizado

### Restricoes e Condicoes

- [ ] Aplicar apenas para: novos leads, leads com tag X, todos os leads
- [ ] Maximo de X usos por lead (ex: nao disparar mais de 1 vez por semana para o mesmo lead)
- [ ] Horario de funcionamento por keyword (dias da semana + horario)
- [ ] Prioridade (numero — quando multiplas keywords fazem match, a de maior prioridade vence)

### Auto-input Completo

Fluxo mais poderoso: "comentou em post → DM automatica + tag + funil"

- [ ] Detectar comentario com keyword no post
- [ ] Verificar se lead ja e seguidor (usando Graph API)
- [ ] Enviar DM automatica para o lead
- [ ] Adicionar tag "comentou-post"
- [ ] Mover para etapa "Leads Quentes" no funil
- [ ] Responder o comentario publicamente (opcional, configuravel)
- [ ] Preview de como o fluxo completo funciona (diagrama explicativo na UI)

### Analytics por Keyword

- [ ] Total de vezes que a keyword foi ativada
- [ ] Taxa de conversao (leads que chegaram ao objetivo final)
- [ ] Canais mais ativos (DM vs comentario)
- [ ] Grafico de ativacoes por dia
- [ ] Tabela de leads que ativaram a keyword

### Criterios de Aceite da Fase 6

- [ ] Keyword configurada em DM dispara acao corretamente com lead real
- [ ] Keyword configurada em comentario dispara acao corretamente com lead real
- [ ] Auto-input completo funciona (comentou → DM + tag + funil)
- [ ] Restricao de max usos por lead funciona
- [ ] Analytics exibe dados reais

---

## FASE 7 — CRM e Gestao de Leads

**Duracao estimada:** Semanas 17-19
**Objetivo:** CRM completo com Kanban visual, perfil detalhado de leads, tags, campos customizados, segmentacao avancada e lead scoring.

### Kanban Visual

- [ ] Visualizacao em colunas (etapas do funil)
- [ ] Drag-and-drop de cards entre colunas (usar `@dnd-kit/core`)
- [ ] CRUD de etapas do funil (criar, editar nome e cor, reordenar, deletar)
- [ ] Automacoes por etapa: ao mover um lead para esta etapa → executar acao (adicionar tag, enviar mensagem, notificar equipe)
- [ ] Card do lead no Kanban:
  - Foto de perfil do Instagram
  - Nome / username
  - Valor potencial (se preenchido)
  - Tags (badges coloridos)
  - Tempo na etapa atual (ex: "3 dias")
  - Agente ou humano responsavel (avatar)
- [ ] Contador de leads por coluna
- [ ] Filtros no Kanban: por tag, por responsavel, por valor, por tempo na etapa

### Perfil Completo do Lead

- [ ] Modal ou pagina dedicada com abas:
  - **Resumo**: foto, nome, username Instagram, email, telefone, valor, etapa, responsavel, tags, campos custom
  - **Conversas**: historico completo de todas as mensagens (DM, comentarios)
  - **Fluxos**: quais fluxos este lead ja passou
  - **Atividades**: log de todas as acoes (tags adicionadas, etapas mudadas, notas, etc.)
  - **Notas**: notas internas da equipe (como CRM tradicional)
- [ ] Editar todos os campos do perfil inline
- [ ] Adicionar/remover tags diretamente no perfil
- [ ] Mover de etapa diretamente no perfil

### CRUD de Leads

- [ ] Criar lead manualmente (formulario com campos principais)
- [ ] Editar dados do lead
- [ ] Arquivar lead (remove do Kanban, mantém no banco)
- [ ] Deletar lead (com confirmacao — exclui permanentemente)
- [ ] Importar leads via CSV (mapear colunas para campos)
  - Preview das primeiras 5 linhas antes de importar
  - Relatorio pos-importacao: X importados, Y ignorados (duplicados)
- [ ] Exportar leads filtrados via CSV

### Sistema de Tags

- [ ] Pagina de gerenciamento de tags (CRUD)
- [ ] Cada tag: nome, cor (seletor de cor), descricao
- [ ] Aplicar/remover tag em leads individualmente ou em massa (selecionar multiplos leads)
- [ ] Automacoes de tags: se campo X for maior que Y, adicionar tag Z (regras simples)
- [ ] Filtrar leads por tag no Kanban e na lista

### Campos Customizados

- [ ] Pagina de configuracao de campos customizados (por conta)
- [ ] Tipos de campo: texto simples, numero, data, booleano, selecao unica, selecao multipla, URL
- [ ] Criar campo: nome, tipo, obrigatorio, valor padrao
- [ ] Salvar valor por campo por lead
- [ ] Campos customizados aparecem no perfil do lead e nos filtros de segmentacao

### Segmentacao Avancada

- [ ] Constructor de filtros (drag-and-drop ou formulario dinamico)
  - Filtros disponiveis: tag, etapa do funil, campo customizado, data de criacao, ultima atividade, lead score, origem, username, responsavel
  - Operadores: e igual a, contem, e maior que, e menor que, esta entre, nao tem
  - Combinar com AND / OR
- [ ] Preview do numero de leads no segmento
- [ ] Salvar segmento com nome (para reusar em Broadcasts, Relatorios, etc.)
- [ ] Listar segmentos salvos

### Lead Scoring

- [ ] Pontuacao automatica 0-100 baseada em regras configuradas:
  - +10: engajamento nos ultimos 7 dias
  - +15: respondeu a mensagem do bot
  - +20: clicou em link
  - +25: comprou
  - -5: inativo por 30 dias
- [ ] Pagina de configuracao de regras de scoring
- [ ] Score exibido no card do Kanban e perfil do lead
- [ ] Filtrar leads por faixa de score

### Criterios de Aceite da Fase 7

- [ ] Drag-and-drop entre colunas do Kanban funciona sem bugs
- [ ] Perfil do lead exibe historico real de conversas
- [ ] Importacao de CSV com 1.000 leads funciona corretamente
- [ ] Segmento salvo pode ser selecionado na tela de Broadcast (Fase 9)
- [ ] Lead score e calculado e atualizado automaticamente

---

## FASE 8 — Caixa de Entrada Unificada

**Duracao estimada:** Semanas 20-21
**Objetivo:** Interface de atendimento em tempo real para todas as conversas, com controle humano/bot, atribuicao e ferramentas de produtividade.

### Lista de Conversas

- [ ] Coluna de conversas com scroll infinito
- [ ] Para cada conversa: foto, username, preview da ultima mensagem, timestamp, status, badge de nao lida
- [ ] Filtros por status: todas, nao lidas, aguardando humano, em atendimento, resolvidas, arquivadas
- [ ] Busca por nome ou username do lead
- [ ] Indicador de quem esta atendendo (avatar do atendente)
- [ ] Atualiza em tempo real (Supabase Realtime + Meta webhook)

### Chat em Tempo Real

- [ ] Painel central de chat
- [ ] Historico completo da conversa (carrega mais ao rolar para cima)
- [ ] Baloes diferenciados: lead, bot, humano
- [ ] Indicador visual: "Bot respondendo" vs "Humano respondendo"
- [ ] Typing indicator (aparece quando lead esta digitando — se API suportar)
- [ ] Input de mensagem com formatacao basica (negrito, italico)
- [ ] Envio de arquivo (imagem, PDF)
- [ ] Botao de emoji

### Controle Bot / Humano

- [ ] Botao "Assumir Conversa" (takeover): desativa o bot para este lead, notifica equipe
- [ ] Botao "Devolver para Bot": reativa o agente de IA
- [ ] Indicador visual claro do estado atual
- [ ] Log da acao no historico da conversa ("Atendimento assumido por [nome]")
- [ ] Timeout opcional: se humano nao responder em X minutos, devolver automaticamente para bot

### Ferramentas de Produtividade

- [ ] Canned responses (respostas prontas)
  - Campo de busca: digita "/" para abrir busca
  - Seleciona e insere no input automaticamente
  - CRUD de respostas prontas em Configuracoes
- [ ] Atribuir conversa para membro da equipe (selecao de dropdown)
- [ ] Adicionar nota interna (visivel apenas para equipe, nao para o lead)
- [ ] Marcar como resolvida
- [ ] Arquivar conversa
- [ ] Acao rapida: adicionar tag sem sair do chat
- [ ] Acao rapida: mover no funil sem sair do chat
- [ ] Acao rapida: ver perfil completo do lead (slide-over lateral)

### Painel Lateral do Lead

- [ ] Informacoes do lead em tempo real (puxa do CRM):
  - Foto, nome, username, etapa, responsavel
  - Tags (com possibilidade de adicionar/remover inline)
  - Campos customizados
  - Valor potencial / receita gerada
  - Historico de fluxos executados
- [ ] Link para abrir perfil completo no CRM

### Criterios de Aceite da Fase 8

- [ ] Nova mensagem de um lead real aparece sem refresh
- [ ] Takeover humano funciona: bot para de responder imediatamente
- [ ] Devolver para bot funciona: agente voltaa responder
- [ ] Atribuicao de conversa notifica o membro atribuido (email + in-app)
- [ ] Canned responses sao buscadas e inseridas corretamente

---

## FASE 9 — Broadcasts e Campanhas

**Duracao estimada:** Semanas 22-23
**Objetivo:** Sistema completo de envio de mensagens em massa para segmentos de leads, com agendamento, A/B test e analytics detalhado.

### Wizard de Criacao

Fluxo guiado em 5 etapas:

- [ ] **Etapa 1 — Publico**
  - Opcoes de audiencia: todos os leads, segmento salvo, por tags (multiplas), filtro personalizado (constructor), upload de CSV com usernames
  - Exclusao de grupos (ex: excluir tag "ja-comprou", excluir etapa "cliente")
  - Preview do numero estimado de destinatarios
  - Aviso sobre limites da Meta (rate limiting)

- [ ] **Etapa 2 — Mensagem**
  - Editor de mensagem (texto com variaveis: `{{first_name}}`, `{{username}}`, etc.)
  - Adicionar imagem ou video
  - Adicionar botoes de resposta rapida
  - Preview da mensagem como sera vista pelo lead
  - A/B Test (toggle):
    - Ativa campos para Variante A e Variante B
    - Configurar percentual de divisao
    - Variante vencedora: qual metrica usar (taxa de resposta, cliques) e apos quanto tempo

- [ ] **Etapa 3 — Agendamento**
  - Enviar agora
  - Agendar para data e hora especifica (date + time picker)
  - Sugestao de melhor horario por IA (analisa historico de engajamento do publico selecionado)
  - Rate limiting: quantas mensagens por minuto (respeitar limites da Meta)

- [ ] **Etapa 4 — Preview e Teste**
  - Resumo completo: publico, mensagem, agendamento
  - Botao "Enviar mensagem de teste para mim" (envia para o Instagram do usuario logado)
  - Confirmacao visual do teste

- [ ] **Etapa 5 — Confirmacao e Envio**
  - Resumo final com numero exato de destinatarios
  - Botao "Confirmar e Agendar" ou "Confirmar e Enviar Agora"
  - Redirecionamento para pagina de status do broadcast

### Gerenciamento de Broadcasts

- [ ] Lista de campanhas (nome, status, data, destinatarios, metricas principais)
- [ ] Status: rascunho, agendado, enviando, pausado, concluido, cancelado
- [ ] Status em tempo real durante envio (barra de progresso, mensagens enviadas/total)
- [ ] Pausar broadcast em andamento
- [ ] Cancelar broadcast em andamento (interrompe envio)
- [ ] Duplicar campanha (criar nova com mesmas configuracoes)

### Analytics de Campanha

- [ ] Metricas por campanha:
  - Total de destinatarios
  - Enviados com sucesso
  - Taxa de entrega (entregues / enviados)
  - Abertos (se disponivel pela API)
  - Respostas recebidas
  - Cliques em botoes
  - Conversoes (leads que chegaram a uma etapa de venda apos a campanha)
  - Receita atribuida
- [ ] Grafico de envios por hora
- [ ] Comparativo A/B (se aplicavel): metricas de cada variante lado a lado
- [ ] Lista de leads que responderam

### Criterios de Aceite da Fase 9

- [ ] Broadcast enviado e entregue para pelo menos 10 leads reais em producao
- [ ] Rate limiting respeitado (nao ultrapassar limite configurado por minuto)
- [ ] Agendamento funciona (mensagem enviada no horario correto)
- [ ] Pausar e continuar broadcast funciona corretamente
- [ ] Analytics atualiza em tempo real durante e apos o envio

---

## FASE 10 — Analytics e Relatorios

**Duracao estimada:** Semanas 24-25
**Objetivo:** Dashboard analitico completo, analytics preditivo por IA, relatorios customizaveis e exportacao.

### Dashboard Analytics

- [ ] Filtro global de periodo (7 dias, 30 dias, 90 dias, customizado)
- [ ] Funil de conversao completo (visualizacao de sankey ou barras empilhadas)
- [ ] Performance de agentes: conversas atendidas, taxa de satisfacao (quando coletada), handoffs para humano, custo estimado em tokens
- [ ] Performance de fluxos: execucoes, taxa de conclusao, drop-off
- [ ] Performance de keywords: ativacoes, taxa de conversao por keyword
- [ ] Origem dos leads: DM organico, comentario, story reply, importado, manual
- [ ] Receita: via Stripe (automatico) + lancamentos manuais
- [ ] ROI do bot: receita atribuida / custo de tokens e operacao

### Analytics Preditivo (IA)

- [ ] Lead scoring em tempo real (0-100 por probabilidade de compra nos proximos 7 dias)
  - Modelo treinado com historico de conversas e conversoes
  - Exibido no CRM e no Kanban
- [ ] Alertas de leads em risco de churn
  - Detecta leads que estao sumindo (inatividade crescente apos engajamento)
  - Notificacao proativa para equipe
- [ ] Forecast de vendas
  - Projecao de conversoes para os proximos 7 e 30 dias
  - Baseado em leads no pipeline e scoring
- [ ] Melhor horario para broadcast
  - Analisa quando cada segmento de lead mais engaja
  - Sugere janela de tempo por dia da semana

### Criador de Relatorios Customizados

- [ ] Interface drag-and-drop para montar relatorio
- [ ] Biblioteca de widgets disponiveis: grafico de linhas, barras, pizza, tabela, numero unico, funil
- [ ] Configurar cada widget: metrica, periodo, filtros
- [ ] Salvar relatorio com nome
- [ ] Templates de relatorios prontos: relatorio de vendas, relatorio de suporte, relatorio de campanhas

### Agendamento e Exportacao

- [ ] Agendar envio de relatorio por email: diario, semanal, mensal
- [ ] Selecionar destinatarios (membros da equipe ou emails externos)
- [ ] Exportar relatorio atual em PDF (captura visual do dashboard)
- [ ] Exportar dados brutos em Excel / CSV

### Criterios de Aceite da Fase 10

- [ ] Dashboard exibe dados reais com todos os filtros de periodo funcionando
- [ ] Lead scoring e calculado e exibido corretamente no CRM
- [ ] Exportacao de PDF gera arquivo visualmente correto
- [ ] Relatorio agendado chega por email no horario configurado

---

## FASE 11 — Agendador de Posts

**Duracao estimada:** Semanas 26-27
**Objetivo:** Planejar, criar e agendar posts no Instagram com sugestoes de IA, e vincular automacoes de engajamento a cada post.

### Criacao de Posts

- [ ] Editor de post:
  - Campo de texto (legenda) com contador de caracteres
  - Opcao de gerar legenda por IA (descreve o produto/servico, IA sugere 3 opcoes de legenda)
  - Upload de imagem (JPG, PNG) ou video (MP4)
  - Preview do post (simulacao visual do feed do Instagram)
- [ ] Sugestao de hashtags por IA: analisa o conteudo da legenda e sugere 15-30 hashtags relevantes
- [ ] Primeiro comentario programado (boa pratica: colocar hashtags no primeiro comentario)

### Agendamento

- [ ] Calendário visual de posts agendados (visao mensal + semanal)
- [ ] Drag-and-drop de posts no calendario (reagendar)
- [ ] Agendar para data e hora especifica
- [ ] "Postar agora" (publicacao imediata via Graph API)
- [ ] Sugestao de melhor horario por IA (baseado no historico de engajamento da conta)
- [ ] Fila automatica: adicionar post a fila semanal (distribui automaticamente nos melhores horarios)

### Automacoes Vinculadas ao Post

- [ ] Ao publicar o post, ativar automacoes:
  - "Quem comentar [PALAVRA] recebe DM automatica" (configurar keyword + mensagem)
  - "Quem curtir e marcado com tag X" (opcional)
- [ ] Configurar automacoes antes de agendar
- [ ] Desativar automacoes automaticamente apos X dias (evitar responder posts antigos)

### Historico

- [ ] Lista de posts publicados com: imagem miniatura, legenda (truncada), data, metricas (curtidas, comentarios, alcance)
- [ ] Re-usar post publicado (cria novo agendamento com o mesmo conteudo)

### Criterios de Aceite da Fase 11

- [ ] Post agendado e publicado no Instagram no horario correto
- [ ] Geracao de legenda por IA funciona com qualidade aceitavel
- [ ] Automacao de "comenta [PALAVRA] → recebe DM" funciona apos publicacao do post

---

## FASE 12 — Equipe e Colaboracao

**Duracao estimada:** Semanas 28-29
**Objetivo:** Sistema de multi-usuario com papeis e permissoes, colaboracao em tempo real, gamificacao para engajamento da equipe.

### Gerenciamento de Membros

- [ ] Pagina "Equipe" com lista de membros ativos e convites pendentes
- [ ] Convidar membro por email
  - Email de convite enviado via Resend
  - Link de convite com token seguro (expira em 7 dias)
  - Pagina de aceitar convite (novo usuario cria conta ou faz login)
- [ ] Papeis disponiveis:
  - **Admin**: acesso total (menos billing do dono)
  - **Gerente**: acesso a CRM, analytics, equipe (sem configuracoes de billing)
  - **Atendente**: acesso apenas a Caixa de Entrada e CRM
  - **Visualizador**: apenas leitura (analytics e relatorios)
- [ ] Permissoes granulares configuradas por papel (tabela de permissoes)
- [ ] Remover membro (conversas atribuidas sao desatribuidas)
- [ ] Suspender membro temporariamente

### Colaboracao em Tempo Real

- [ ] Presenca online: indicador de quem esta online (Supabase Realtime Presence)
- [ ] Awareness colaborativo: "Joao esta vendo este lead" (evitar conflito de edicao)
- [ ] Chat interno da equipe:
  - Canais de chat (criados livremente)
  - Mensagens diretas entre membros
  - @mencoes (notifica o membro mencionado)
  - Historico persistente
- [ ] Notificacoes de atividade da equipe (in-app):
  - Lead atribuido para voce
  - @mencao no chat
  - Conversa aguardando atendimento urgente

### Gamificacao

- [ ] Sistema de XP (pontos de experiencia) por acoes:
  - +10 XP: responder mensagem de lead
  - +25 XP: fechar venda (mover lead para etapa "Fechado")
  - +15 XP: criar agente
  - +20 XP: criar fluxo ativo
  - +5 XP: adicionar nota a um lead
  - +50 XP: campanha com taxa de resposta > 20%
- [ ] Niveis de 1 a 20 com nomes criativos (ex: Nivel 1: "Semente", Nivel 10: "Mestre do Inbox", Nivel 20: "Lenda do Engajamento")
- [ ] Conquistas (badges) — 30+ exemplos:
  - "Primeiros Passos": criar o primeiro agente
  - "Maquina de Engajamento": 1.000 mensagens enviadas pelo bot
  - "Vendedor Estrela": 100 conversoes registradas
  - "Workaholic": 7 dias consecutivos de atividade
  - "Campanhas PRO": 5 broadcasts com mais de 500 leads
- [ ] Desafios semanais (renovam toda segunda):
  - Ex: "Responda 50 leads esta semana" → recompensa: 500 XP
- [ ] Ranking mensal da equipe (quem tem mais XP no mes)
- [ ] Painel de gamificacao no perfil de cada membro

### Criterios de Aceite da Fase 12

- [ ] Membro convidado acessa a conta com permissoes do papel correto (testar todas as restricoes)
- [ ] Presenca online funciona em tempo real (aparecer e desaparecer ao abrir/fechar o app)
- [ ] Chat interno funciona em tempo real
- [ ] XP e ganho e exibido corretamente apos acoes que geram pontos
- [ ] Nivel sobe quando threshold de XP e atingido
- [ ] Ranking exibe a classificacao correta

---

## FASE 13 — Integracoes

**Duracao estimada:** Semanas 30-31
**Objetivo:** Conectar o InstaFlow AI com ferramentas externas via webhooks, Zapier, Make e integracao de pagamento Stripe via DM.

### Webhooks de Saida

- [ ] Pagina de gerenciamento de webhooks
- [ ] CRUD de webhooks (URL de destino, eventos monitorados, ativo/inativo)
- [ ] Eventos disponiveis:
  - `lead.created` — novo lead capturado
  - `lead.updated` — campo ou etapa do lead alterado
  - `lead.tag_added` — tag adicionada
  - `message.received` — mensagem recebida de lead
  - `message.sent` — mensagem enviada ao lead (bot ou humano)
  - `flow.started` — fluxo iniciado para lead
  - `flow.completed` — fluxo concluido
  - `keyword.triggered` — keyword detectada
  - `payment.received` — pagamento confirmado (via Stripe)
- [ ] Payload em JSON (com exemplo exibido na UI)
- [ ] Retry automatico em falha (3 tentativas, backoff exponencial)
- [ ] Logs de entrega: data, status HTTP, response, proxima tentativa
- [ ] Testar webhook (botao "Enviar evento de teste")

### Zapier e Make

- [ ] Criar integracao Zapier:
  - Triggers: todos os eventos de webhook acima
  - Actions: criar lead, adicionar tag, mover no funil, enviar mensagem
  - Publicar no Zapier App Directory (ou link privado)
- [ ] Criar integracao Make (Integromat):
  - Mesmos triggers e actions
  - Modulo customizado Make

### Pagamento via DM com Stripe

- [ ] Agente detecta intencao de compra no contexto da conversa
- [ ] Gera link de pagamento Stripe (Stripe Payment Links API) com produto e preco pre-configurados
- [ ] Envia o link via DM automaticamente
- [ ] Webhook Stripe `payment_intent.succeeded` recebido via Edge Function:
  - Atualiza status do lead (mover para etapa "Cliente")
  - Adiciona tag "comprou"
  - Registra receita no CRM
  - Inicia fluxo de pos-venda configurado
- [ ] Configurar produtos Stripe na conta do usuario (via Stripe Connect ou API keys proprias)

### Base de Conhecimento — Integracoes

- [ ] Google Drive: conectar via OAuth, selecionar pasta, sincronizar documentos automaticamente
- [ ] Notion: conectar via OAuth, selecionar paginas ou databases, sincronizar conteudo

### Criterios de Aceite da Fase 13

- [ ] Webhook dispara corretamente com payload correto ao criar lead (verificar via webhook.site)
- [ ] Retry funciona: simular falha de endpoint e verificar reenvio
- [ ] Link de pagamento Stripe e gerado e enviado via DM corretamente
- [ ] Webhook de confirmacao de pagamento Stripe atualiza o lead no CRM

---

## FASE 14 — Configuracoes e Assinatura

**Duracao estimada:** Semanas 32-33
**Objetivo:** Pagina de configuracoes completa, gerenciamento de assinatura via Stripe, LGPD e API Keys para integradores avancados.

### Perfil do Usuario

- [ ] Foto de perfil (upload para Supabase Storage)
- [ ] Nome completo, nome da empresa, segmento de atuacao
- [ ] Fuso horario (afeta agendamentos e relatorios)
- [ ] Idioma (pt-BR para agora, estrutura para expansao)
- [ ] Alterar senha (requer senha atual)
- [ ] Autenticacao de dois fatores (2FA — TOTP via Authenticator app)
  - Gerar QR Code
  - Verificar codigo para ativar
  - Codigo de backup (gerar e salvar)
  - Desativar 2FA (requer codigo)

### Configuracoes do Bot

- [ ] Horario de funcionamento global (por dia da semana + horario de inicio/fim)
- [ ] Mensagem automatica fora do horario (o bot envia quando recebe mensagem fora do horario)
- [ ] Configuracoes de resposta: delay padrao, estilo de linguagem global

### Notificacoes

- [ ] Configurar quais eventos geram notificacao por email
- [ ] Configurar quais eventos geram notificacao in-app
- [ ] Frequencia de digest (imediato, a cada hora, diario)

### Assinatura (Stripe Customer Portal)

- [ ] Ver plano atual (nome, preco, data de renovacao, proxima cobranca)
- [ ] Botao "Fazer Upgrade" (abre comparativo de planos com CTA por plano)
- [ ] Botao "Gerenciar Assinatura" (abre Stripe Customer Portal no lugar)
  - No Stripe Portal: trocar plano, cancelar, atualizar cartao, ver faturas, baixar notas fiscais
- [ ] Logica de upgrade/downgrade:
  - Upgrade: libera features imediatamente (webhook Stripe `customer.subscription.updated`)
  - Downgrade: aplica ao proximo ciclo, features mantidas ate o fim do ciclo
  - Cancelamento: assinatura ativa ate o fim do periodo pago, depois bloqueia como trial expirado

### LGPD

- [ ] "Exportar meus dados": gera arquivo ZIP com todos os dados da conta (usuarios, leads, conversas, configuracoes) em JSON
  - Processo assincrono, notifica por email quando pronto
- [ ] "Deletar minha conta": confirmacao em duas etapas, envia email de confirmacao, deleta todos os dados em cascata (ou anonimiza conforme politica)

### Audit Log

- [ ] Lista de acoes realizadas na conta (ultimos 90 dias):
  - Login, logout, alteracao de senha
  - Membro adicionado/removido
  - Agente criado/editado/deletado
  - Assinatura alterada
  - Dados exportados
- [ ] Filtros: por usuario, por tipo de acao, por data
- [ ] Exportar audit log em CSV

### API Keys

- [ ] Gerar API Key (para integradores avancados usarem a API diretamente)
- [ ] Nomear cada key
- [ ] Ver data de criacao e ultimo uso
- [ ] Revogar key

### Criterios de Aceite da Fase 14

- [ ] Stripe Customer Portal abre e funciona corretamente
- [ ] Upgrade de plano libera features imediatamente (verificar com plano que tem limite de agentes)
- [ ] Cancelamento bloqueia features na data correta (simular com data)
- [ ] Exportar dados gera ZIP completo e correto
- [ ] 2FA funciona: configurar, fazer login com codigo, desativar

---

## FASE 15 — Polish, Testes e Launch

**Duracao estimada:** Semanas 34-36
**Objetivo:** Produto pronto para lancamento com qualidade de producao: testes, performance, acessibilidade, documentacao e feedback de beta.

### Testes

- [ ] Testes unitarios (Vitest + Testing Library)
  - Cobertura minima: 60% do codigo
  - Focar em: logica de negocios, hooks, funcoes utilitarias, componentes de formulario
- [ ] Testes de integracao
  - Edge Functions do Supabase (autenticacao, webhooks Stripe, webhooks Meta)
  - Fluxo de autenticacao completo
  - Fluxo de pagamento completo
- [ ] Testes E2E (Playwright)
  - Fluxo critico 1: registro → onboarding → criar agente → testar no playground
  - Fluxo critico 2: configurar keyword → enviar mensagem no Instagram → verificar acao
  - Fluxo critico 3: criar lead → broadcast → verificar entrega
  - Fluxo critico 4: assinar plano → verificar features desbloqueadas
- [ ] Load testing
  - Simular 100 usuarios simultaneos na Caixa de Entrada
  - Simular broadcast de 10.000 mensagens
  - Verificar Edge Functions sob carga

### Performance e Qualidade

- [ ] Lighthouse score > 90 em Performance, Accessibility, Best Practices, SEO
- [ ] Core Web Vitals no verde (LCP < 2.5s, FID < 100ms, CLS < 0.1)
- [ ] Code splitting por rota (React.lazy + Suspense) — bundle inicial < 200KB
- [ ] Lazy loading de imagens
- [ ] Otimizacao de imagens (usar WebP, tamanhos responsivos)
- [ ] Acessibilidade WCAG 2.1 AA: navegacao por teclado, screen reader, contraste de cores

### Security Audit

- [ ] RLS do Supabase: testar que usuario A nao acessa dados do usuario B
- [ ] Validacao de inputs em todos os formularios (XSS, SQL injection via Supabase)
- [ ] Rate limiting nas Edge Functions (prevenir abuso)
- [ ] Tokens de acesso Meta armazenados criptografados
- [ ] Revisao das permissoes de API Keys
- [ ] Headers de segurança configurados no Vercel (CSP, X-Frame-Options, etc.)

### Landing Page

- [ ] Landing page de vendas (pagina separada do app)
  - Hero com CTA para trial gratuito
  - Secoes: funcionalidades, depoimentos, comparativo de planos, FAQ
  - Totalmente responsiva e otimizada para SEO
  - Meta tags e Open Graph configurados
  - Google Analytics / Plausible configurado

### Documentacao para Usuarios

- [ ] Central de ajuda (pode usar Intercom, Notion publico, ou pagina propria)
  - Artigos por categoria: autenticacao, agentes, flow builder, CRM, billing
  - Minimo de 30 artigos cobrindo as principais funcionalidades
  - Videos curtos demonstrativos (screen recording)
- [ ] Tour interativo in-app (onboarding tour):
  - Usando biblioteca como `driver.js` ou `react-joyride`
  - Tour do Dashboard, Agentes, Caixa de Entrada e CRM
  - Pode ser revisitado em "Ajuda → Refazer tour"

### Beta e Launch

- [ ] Recrutamento de 50 beta testers (preferencialmente do segmento-alvo: e-commerce e infoprodutos)
- [ ] Onboarding dos beta testers (chamada de video ou material de instrucao)
- [ ] Coleta de feedback estruturado (formulario Typeform ou nativo)
- [ ] Priorizacao e implementacao dos ajustes criticos com base no feedback
- [ ] Definir data de launch oficial
- [ ] Preparar campanhas de lancamento (email list, Instagram, grupos de nicho)
- [ ] **Launch oficial** — InstaFlow AI disponivel para o mercado brasileiro

### Criterios de Aceite da Fase 15

- [ ] Cobertura de testes >= 60%
- [ ] Todos os testes E2E passando
- [ ] Lighthouse > 90 em todas as categorias
- [ ] Nenhuma vulnerabilidade critica no security audit
- [ ] Beta com 50 usuarios completado com feedback coletado
- [ ] Launch realizado com sucesso

---

## Estimativa de Tempo

| Cenario | Tempo Estimado |
|---------|---------------|
| Desenvolvedor solo, tempo integral | ~36 semanas (9 meses) |
| Equipe de 2-3 devs, tempo integral | ~20-24 semanas (5-6 meses) |
| MVP para beta (Fases 0-8) — solo | ~21 semanas |

**Nota sobre o MVP para beta:** As Fases 0 a 8 cobrem os recursos essenciais — autenticacao, agentes de IA, base de conhecimento, flow builder, palavras-chave, CRM e caixa de entrada. Isso e suficiente para validar o produto com usuarios reais antes de construir o restante.

---

## Features Futuras (V2)

Funcionalidades planejadas para a versao 2.0, apos o lancamento e validacao do produto base:

- [ ] **WhatsApp Business API** — atendimento e automacao via WhatsApp, mesmo sistema de agentes e fluxos
- [ ] **White Label** — revender o InstaFlow AI com marca propria (para agencias)
- [ ] **App Mobile React Native** — gerenciar leads e caixa de entrada pelo celular
- [ ] **Integracao Shopify / WooCommerce / Nuvemshop** — sincronizar produtos e pedidos automaticamente
- [ ] **Marketplace de Templates** — comprar e vender templates de agentes e fluxos (comunidade)
- [ ] **Geracao de Imagens por IA** — criar imagens para posts diretamente no agendador
- [ ] **Analise de Sentimento de Posts** — monitorar sentimento dos comentarios em posts organicos
- [ ] **Suporte a Multiplos Idiomas** — espanhol (LATAM), ingles
- [ ] **TikTok e YouTube** — expandir automacoes para outras redes sociais

---

## Convencoes Tecnicas

### Estrutura de Pastas

```
src/
  components/       # Componentes reutilizaveis
    ui/             # shadcn/ui e componentes base
    [feature]/      # Componentes por funcionalidade
  pages/            # Paginas (uma por rota)
  hooks/            # Custom hooks
  store/            # Estado global (Zustand)
  lib/              # Utilitarios, clientes de API
  types/            # Tipos TypeScript compartilhados

supabase/
  migrations/       # Migrations SQL (uma por alteracao)
  functions/        # Edge Functions (uma pasta por funcao)
```

### Convencoes de Nomenclatura

- Componentes React: PascalCase (`AgentCard.tsx`)
- Hooks: camelCase com prefixo `use` (`useAgents.ts`)
- Stores Zustand: camelCase com sufixo `Store` (`agentStore.ts`)
- Migrations: prefixo com timestamp (`20260101_create_agents.sql`)
- Edge Functions: kebab-case (`send-email`, `stripe-webhook`)

### Supabase — Padroes

- RLS habilitado em TODAS as tabelas
- Cada tabela tem `created_at`, `updated_at` (automaticos via trigger)
- Soft delete com coluna `deleted_at` (nullable)
- Multi-tenancy via coluna `account_id` em todas as tabelas de dados

---

*Documento mantido em: `docs/ROADMAP.md`*
*Ultima atualizacao: Marco 2026*
*Versao: 1.0.0*
