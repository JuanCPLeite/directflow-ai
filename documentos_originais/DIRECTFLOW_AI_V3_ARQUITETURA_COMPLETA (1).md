# 🚀 DirectFlow AI v3.0 - Plataforma Multiusuário Completa

## 📋 Índice
1. [Visão Geral](#visão-geral)
2. [Funcionalidades Principais](#funcionalidades-principais)
3. [Arquitetura do Sistema](#arquitetura-do-sistema)
4. [Estrutura de Banco de Dados](#estrutura-de-banco-de-dados)
5. [Módulos e Funcionalidades Detalhadas](#módulos-e-funcionalidades-detalhadas)
6. [Fluxo de Automação](#fluxo-de-automação)
7. [Interface do Usuário](#interface-do-usuário)
8. [Segurança e Autenticação](#segurança-e-autenticação)
9. [Integrações](#integrações)
10. [Planos e Monetização](#planos-e-monetização)
11. [Roadmap de Desenvolvimento](#roadmap-de-desenvolvimento)

---

## 🎯 Visão Geral

### O que é o DirectFlow AI v3.0?

DirectFlow AI é uma **plataforma SaaS completa** para automação de atendimento no Instagram usando Inteligência Artificial. A versão 3.0 transforma o sistema atual em uma solução **multiusuário robusta**, escalável e comercialmente viável.

### Diferenciais Competitivos

- ✅ **Dual Mode**: Sistema híbrido que combina Fluxos Visuais (estilo Manychat) + Agentes de IA
- ✅ **Zero Code**: Interface visual para criar automações sem programar
- ✅ **Base de Conhecimento**: Upload de documentos, PDFs, URLs para treinar o agente
- ✅ **CRM Integrado**: Gestão completa de leads com kanban, tags e funil de vendas
- ✅ **Analytics Avançado**: Dashboard com métricas de conversão, ROI e performance
- ✅ **Multi-canais**: Instagram DM, Comentários, Mensagens e futuramente WhatsApp
- ✅ **White Label**: Possibilidade de revenda com marca própria

---

## 🎨 Funcionalidades Principais

### 1. Sistema de Autenticação e Usuários

#### 1.1 Tela de Login Moderna
```
┌─────────────────────────────────────┐
│                                     │
│         🤖 DirectFlow AI            │
│    Automação Inteligente para      │
│           Instagram                 │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Email                         │ │
│  └───────────────────────────────┘ │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ Senha                    👁️   │ │
│  └───────────────────────────────┘ │
│                                     │
│  ☐ Lembrar-me                      │
│                                     │
│  [      ENTRAR      ]              │
│                                     │
│  Esqueceu a senha? | Criar conta   │
│                                     │
│  ─────── ou ───────                │
│                                     │
│  [🔵 Entrar com Facebook]          │
│  [⚪ Entrar com Google]            │
│                                     │
└─────────────────────────────────────┘
```

**Funcionalidades:**
- Login com email/senha
- Integração com OAuth (Facebook, Google)
- Recuperação de senha via email
- Autenticação de 2 fatores (2FA)
- Login social para conectar Instagram Business
- Sessão persistente com refresh token

#### 1.2 Página de Registro
```
Campos obrigatórios:
- Nome completo
- Email
- Senha (com validação de força)
- Telefone/WhatsApp
- Nome da empresa
- Segmento de atuação
- Como conheceu o DirectFlow
```

**Validações:**
- Email único no sistema
- Senha forte (mínimo 8 caracteres, maiúsculas, números, símbolos)
- Verificação de email obrigatória
- Aceite de termos de uso e LGPD

#### 1.3 Onboarding Interativo

**Passo 1: Conectar Instagram**
```
┌─────────────────────────────────────────┐
│  Bem-vindo ao DirectFlow! 🎉            │
│                                         │
│  Conecte sua conta do Instagram         │
│  Business para começar                  │
│                                         │
│  [📱 Conectar Instagram Business]       │
│                                         │
│  ✓ Acesso aos seus DMs                 │
│  ✓ Responder comentários               │
│  ✓ Gerenciar leads                     │
│                                         │
│  Pular por enquanto →                  │
└─────────────────────────────────────────┘
```

**Passo 2: Escolher Modo de Operação**
```
Como você quer operar?

┌──────────────────┐  ┌──────────────────┐
│  🤖 Agente de IA │  │  📊 Fluxos       │
│                  │  │                  │
│  Deixe a IA      │  │  Crie fluxos     │
│  conversar       │  │  personalizados  │
│  naturalmente    │  │  visualmente     │
│                  │  │                  │
│  [Escolher]      │  │  [Escolher]      │
└──────────────────┘  └──────────────────┘

        ┌────────────────────┐
        │  🔀 Modo Híbrido   │
        │                    │
        │  Combine os dois!  │
        │  (Recomendado)     │
        │                    │
        │  [Escolher]        │
        └────────────────────┘
```

**Passo 3: Configuração Inicial**
- Nome do agente
- Personalidade (formal, casual, amigável)
- Horário de atendimento
- Template de mensagem inicial

---

### 2. Dashboard Principal

#### 2.1 Visão Geral Executiva
```
┌──────────────────────────────────────────────────────────────┐
│  DirectFlow AI - Dashboard                     👤 João Silva │
│                                                    ⚙️ | 🔔 | 🚪 │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│  📊 MÉTRICAS DOS ÚLTIMOS 30 DIAS                            │
│                                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ 2,847    │  │ 1,923    │  │ 67.5%    │  │ R$ 12,4k │   │
│  │ Mensagens│  │ Leads    │  │ Taxa Resp│  │ Vendas   │   │
│  │ ↑ +12%   │  │ ↑ +8%    │  │ ↑ +5%    │  │ ↑ +15%   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│                                                              │
│  📈 CONVERSÕES POR DIA (ÚLTIMOS 7 DIAS)                     │
│  ┌────────────────────────────────────────────────────┐    │
│  │     •••                                            │    │
│  │    •   •                                           │    │
│  │   •     •••                                        │    │
│  │  •         •                                       │    │
│  └────────────────────────────────────────────────────┘    │
│   Seg  Ter  Qua  Qui  Sex  Sab  Dom                        │
│                                                              │
│  💬 CONVERSAS RECENTES                🎯 FUNIL DE VENDAS    │
│  ┌──────────────────────┐            ┌─────────────────┐   │
│  │ 👤 Maria Silva       │            │ 🔵 Novo: 245    │   │
│  │    "Olá, gostaria..."│            │ 🟡 Contato: 123 │   │
│  │    ⏱️ 2min atrás     │            │ 🟢 Proposta: 67 │   │
│  ├──────────────────────┤            │ 🟣 Fechado: 34  │   │
│  │ 👤 João Santos       │            └─────────────────┘   │
│  │    "Qual o preço?"   │                                   │
│  │    ⏱️ 5min atrás     │            🏆 TOP PERFORMERS     │
│  ├──────────────────────┤            ┌─────────────────┐   │
│  │ Ver todos (23) →     │            │ Agente Principal│   │
│  └──────────────────────┘            │ 89% sucesso     │   │
│                                       │ 1,234 conversas │   │
│                                       └─────────────────┘   │
└──────────────────────────────────────────────────────────────┘
```

**Widgets do Dashboard:**
1. **Métricas Principais** (Cards)
   - Total de mensagens
   - Novos leads
   - Taxa de resposta
   - Conversões/Vendas
   - Tempo médio de resposta
   - Taxa de satisfação (NPS)

2. **Gráfico de Conversões** (Linha temporal)
   - Mensagens enviadas vs recebidas
   - Leads qualificados
   - Conversões por dia/semana/mês

3. **Conversas Recentes** (Lista em tempo real)
   - Últimas 10 conversas
   - Status (aguardando, respondido, convertido)
   - Quick actions (responder, arquivar, mover no funil)

4. **Funil de Vendas** (Pipeline)
   - Etapas personalizáveis
   - Drag and drop
   - Valor total por etapa

5. **Atividade em Tempo Real**
   - Feed de atividades
   - Notificações importantes
   - Alertas de leads urgentes

---

### 3. Sistema de Agentes de IA

#### 3.1 Configuração do Agente

**Painel de Configuração:**
```
┌─────────────────────────────────────────────────────────────┐
│  🤖 CONFIGURAÇÃO DO AGENTE                                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  INFORMAÇÕES BÁSICAS                                        │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Nome do Agente:  [Assistente Virtual Maria         ] │ │
│  │                                                       │ │
│  │ Descrição:       [Atendente virtual especializada   ] │ │
│  │                  [em produtos de beleza e skincare  ] │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  PERSONALIDADE E TOM                                        │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Tom de voz:      ○ Formal  ● Amigável  ○ Casual      │ │
│  │                                                       │ │
│  │ Personalidade:   [Atenciosa, prestativa e conhece   ] │ │
│  │                  [profundamente sobre skincare.      ] │ │
│  │                  [Faz perguntas para entender o      ] │ │
│  │                  [tipo de pele antes de recomendar.  ] │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  PROMPT DO SISTEMA                                          │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Você é Maria, uma consultora de beleza especializada│ │
│  │ em skincare. Seu objetivo é:                        │ │
│  │ 1. Entender o tipo de pele do cliente              │ │
│  │ 2. Identificar suas necessidades                    │ │
│  │ 3. Recomendar produtos adequados                    │ │
│  │ 4. Fechar a venda de forma consultiva               │ │
│  │                                                       │ │
│  │ Sempre:                                               │ │
│  │ - Seja empática e atenciosa                          │ │
│  │ - Faça perguntas abertas                             │ │
│  │ - Não seja insistente                                │ │
│  │ - Use emojis moderadamente 🌸                        │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  CONFIGURAÇÕES AVANÇADAS                                    │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Modelo de IA:           [▼ GPT-4 Turbo            ]  │ │
│  │ Temperatura:            [========·---] 0.7           │ │
│  │ Tokens máximos:         [500                      ]  │ │
│  │ Tempo de espera (seg):  [5                        ]  │ │
│  │ Máximo de mensagens:    [20                       ]  │ │
│  │                                                       │ │
│  │ ☑ Permitir transferência para humano                │ │
│  │ ☑ Salvar histórico de conversas                     │ │
│  │ ☐ Modo debug (mostrar raciocínio da IA)             │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  [Cancelar]                    [💾 Salvar Configurações]   │
└─────────────────────────────────────────────────────────────┘
```

#### 3.2 Base de Conhecimento

**Gerenciamento de Conhecimento:**
```
┌─────────────────────────────────────────────────────────────┐
│  📚 BASE DE CONHECIMENTO                                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [➕ Adicionar Conhecimento ▼]                              │
│                                                             │
│  FONTES DE CONHECIMENTO ATIVAS                              │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📄 Catálogo de Produtos 2024                        │   │
│  │    Tipo: PDF  |  Tamanho: 2.3MB  |  Status: ✅      │   │
│  │    Páginas indexadas: 45/45                         │   │
│  │    [👁️ Visualizar] [✏️ Editar] [🗑️ Remover]        │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 🌐 Site Institucional                                │   │
│  │    URL: www.meusite.com.br                          │   │
│  │    Páginas rastreadas: 23  |  Status: ✅            │   │
│  │    Última atualização: Hoje, 14:30                  │   │
│  │    [🔄 Atualizar] [✏️ Editar] [🗑️ Remover]          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📝 FAQ Atendimento                                   │   │
│  │    Tipo: Texto  |  Perguntas: 127  |  Status: ✅    │   │
│  │    [👁️ Visualizar] [➕ Adicionar] [🗑️ Remover]      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ 📹 Tutorial em Vídeo                                │   │
│  │    YouTube: Como usar nossos produtos               │   │
│  │    Duração: 15:30  |  Transcrição: ✅  |  Status: ✅ │   │
│  │    [👁️ Assistir] [✏️ Editar] [🗑️ Remover]          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ESTATÍSTICAS                                               │
│  • Total de tokens indexados: 2.4M                         │
│  • Documentos ativos: 4                                    │
│  • Última sincronização: Hoje, 15:45                       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Tipos de Conhecimento Suportados:**
1. **Documentos**
   - PDF (com OCR)
   - Word (DOC, DOCX)
   - Planilhas (Excel, Google Sheets)
   - Apresentações (PPT, PPTX)

2. **Web**
   - URLs individuais
   - Sitemap completo
   - Rastreamento automático
   - Atualização agendada

3. **Texto Direto**
   - FAQ estruturado
   - Perguntas e respostas
   - Scripts de atendimento
   - Políticas e regras

4. **Multimídia**
   - Vídeos (transcrição automática)
   - Áudios
   - Imagens (com descrição)

5. **Integrações**
   - Notion
   - Google Drive
   - Dropbox
   - Confluence

#### 3.3 Treinamento e Testes

**Playground do Agente:**
```
┌─────────────────────────────────────────────────────────────┐
│  🎮 PLAYGROUND - TESTE SEU AGENTE                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Chat de Teste                      │  Insights da IA      │
│  ───────────────────────────────────│─────────────────────│
│                                     │                      │
│  👤 Você                            │  🧠 Análise:         │
│  Olá, quero produtos para pele     │                      │
│  oleosa                             │  Intent: Compra      │
│                                     │  Confiança: 85%     │
│  🤖 Agente                          │                      │
│  Olá! 🌸 Que ótimo que você        │  Conhecimento usado: │
│  procurou a gente! Vou te ajudar   │  • FAQ Tipo de Pele  │
│  a encontrar os produtos perfeitos  │  • Catálogo Q1 2024  │
│  para pele oleosa.                  │                      │
│                                     │  Sentimento: 😊      │
│  Antes, me conta: você costuma      │  Positivo (0.87)     │
│  ter espinhas ou apenas oleosidade? │                      │
│                                     │  Próxima ação:       │
│  👤 Você                            │  Qualificar lead     │
│  Tenho alguns cravos, mas nada     │                      │
│  demais                             │                      │
│                                     │                      │
│  🤖 Agente                          │                      │
│  Entendi! Para pele oleosa com     │                      │
│  tendência a cravos, eu recomendo: │                      │
│                                     │                      │
│  1️⃣ Gel de Limpeza Purificante    │                      │
│  2️⃣ Tônico Adstringente           │                      │
│  3️⃣ Sérum Anti-oleosidade         │                      │
│                                     │                      │
│  Quer saber mais sobre algum       │                      │
│  deles? 💚                          │                      │
│                                     │                      │
│  ┌─────────────────────────────┐   │                      │
│  │ Digite sua mensagem...      │   │  [📊 Ver Métricas]   │
│  └─────────────────────────────┘   │  [💾 Salvar Conversa]│
│                                     │  [🔄 Resetar Chat]   │
└─────────────────────────────────────────────────────────────┘
```

**Funcionalidades do Playground:**
- Teste em tempo real
- Visualização do raciocínio da IA
- Métricas de confiança
- Identificação de gaps de conhecimento
- Exportar conversas de teste
- Modo A/B testing

---

### 4. Sistema de Fluxos Visuais (Estilo Manychat)

#### 4.1 Editor Visual de Fluxos

**Interface do Flow Builder:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  📊 EDITOR DE FLUXOS                                 [Salvar] [Testar]│
├─────────────────────────────────────────────────────────────────────┤
│  Ferramentas                        │  Canvas                        │
│  ──────────────────────────────────│────────────────────────────────│
│                                     │                                │
│  🚀 TRIGGERS                        │     ┌─────────────────┐       │
│  ┌────────────────────┐             │     │  📱 MENSAGEM    │       │
│  │ 📨 Nova Mensagem   │◄────────────┼─────│  RECEBIDA       │       │
│  │ 💬 Comentário      │             │     └────────┬────────┘       │
│  │ 📲 Story Reply     │             │              │                │
│  │ ⚡ Palavra-chave   │             │              ▼                │
│  │ ⏰ Agendamento     │             │     ┌────────────────┐        │
│  └────────────────────┘             │     │  CONTÉM        │        │
│                                     │     │  "preço"?      │        │
│  💬 MENSAGENS                       │     └───┬────────┬───┘        │
│  ┌────────────────────┐             │         │Sim     │Não         │
│  │ ✉️ Texto           │             │         ▼        ▼            │
│  │ 🖼️ Imagem          │             │    ┌────────┐ ┌────────┐     │
│  │ 🎥 Vídeo           │             │    │ ENVIAR │ │ ENVIAR │     │
│  │ 📎 Arquivo         │             │    │ PREÇO  │ │ OPÇÕES │     │
│  │ 🎨 Carrossel       │             │    │ LISTA  │ │ MENU   │     │
│  │ 🔘 Botões          │             │    └────────┘ └────────┘     │
│  └────────────────────┘             │                                │
│                                     │                                │
│  🎯 AÇÕES                           │     [➕ Adicionar Nó]         │
│  ┌────────────────────┐             │                                │
│  │ 🏷️ Adicionar Tag   │             │  Estatísticas do Fluxo:       │
│  │ 📊 Mover no Funil  │             │  • 234 usuários ativos        │
│  │ 📧 Enviar Email    │             │  • 89% taxa de conclusão      │
│  │ 🔔 Notificar       │             │  • Tempo médio: 2m 34s        │
│  │ ⏸️ Pausar          │             │                                │
│  │ 🤖 Chamar IA       │             │                                │
│  └────────────────────┘             │                                │
│                                     │                                │
│  🔧 LÓGICA                          │                                │
│  ┌────────────────────┐             │                                │
│  │ ❓ Condição If     │             │                                │
│  │ 🔀 Dividir A/B     │             │                                │
│  │ 🎲 Randomizar      │             │                                │
│  │ ⏱️ Delay/Esperar   │             │                                │
│  └────────────────────┘             │                                │
└─────────────────────────────────────────────────────────────────────┘
```

**Nós Disponíveis:**

1. **Triggers (Gatilhos)**
   - Nova mensagem recebida
   - Comentário em post
   - Resposta em story
   - Palavra-chave específica
   - Horário agendado
   - Webhook externo
   - Ação do usuário (clique, abertura)

2. **Mensagens**
   - Texto simples
   - Texto com variáveis {{nome}}, {{produto}}
   - Imagem/GIF
   - Vídeo
   - Arquivo
   - Áudio
   - Carrossel de produtos
   - Botões de resposta rápida
   - Lista de opções
   - Template de mensagem

3. **Ações**
   - Adicionar/remover tag
   - Mover no funil/kanban
   - Atualizar campo customizado
   - Enviar email
   - Enviar SMS/WhatsApp
   - Notificar equipe
   - Criar tarefa
   - Chamar agente de IA
   - Fazer HTTP request
   - Integrar com Zapier/Make

4. **Lógica e Controle**
   - Condição IF/ELSE
   - Switch/Case
   - Filtro por atributo
   - Dividir A/B test
   - Randomizar caminho
   - Delay/Esperar X tempo
   - Loop/Repetir
   - Goto (ir para outro fluxo)

5. **Integrações**
   - CRM (atualizar lead)
   - Pagamento (gerar link)
   - Calendário (agendar)
   - E-commerce (consultar estoque)
   - Analytics (enviar evento)

#### 4.2 Templates de Fluxos Prontos

**Biblioteca de Templates:**
```
┌──────────────────────────────────────────────────────────┐
│  📚 TEMPLATES DE FLUXOS                                  │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  🔍 [Buscar templates...]                  [▼ Categoria]│
│                                                          │
│  MAIS POPULARES                                          │
│                                                          │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │
│  │ 🛍️          │ │ 📅          │ │ 💰          │       │
│  │ Venda       │ │ Agendamento │ │ Qualificação│       │
│  │ Produto     │ │ Consulta    │ │ de Leads    │       │
│  │             │ │             │ │             │       │
│  │ ⭐⭐⭐⭐⭐   │ │ ⭐⭐⭐⭐⭐   │ │ ⭐⭐⭐⭐⭐   │       │
│  │ 2.3k usos  │ │ 1.8k usos   │ │ 1.5k usos   │       │
│  └─────────────┘ └─────────────┘ └─────────────┘       │
│                                                          │
│  POR SEGMENTO                                            │
│                                                          │
│  🏥 Saúde e Bem-estar                                   │
│  ┌─────────────┐ ┌─────────────┐                        │
│  │ Agendar     │ │ Resultado   │                        │
│  │ Consulta    │ │ de Exames   │                        │
│  └─────────────┘ └─────────────┘                        │
│                                                          │
│  🎓 Educação                                            │
│  ┌─────────────┐ ┌─────────────┐                        │
│  │ Matrícula   │ │ Suporte     │                        │
│  │ Curso       │ │ Aluno       │                        │
│  └─────────────┘ └─────────────┘                        │
│                                                          │
│  🍔 Delivery                                            │
│  ┌─────────────┐ ┌─────────────┐                        │
│  │ Pedido      │ │ Cardápio    │                        │
│  │ Delivery    │ │ Digital     │                        │
│  └─────────────┘ └─────────────┘                        │
│                                                          │
│  [➕ Criar do Zero]          [📁 Meus Templates]        │
└──────────────────────────────────────────────────────────┘
```

**Templates Inclusos:**
1. Venda de Produto
2. Agendamento de Consulta
3. Qualificação de Leads
4. Suporte ao Cliente
5. Confirmação de Pedido
6. Recuperação de Carrinho
7. Pesquisa de Satisfação (NPS)
8. Programa de Indicação
9. Conteúdo Educacional
10. Campanha Promocional

---

### 5. Sistema de Palavras-Chave e Auto-Input

#### 5.1 Gerenciamento de Palavras-Chave

**Interface de Palavras-Chave:**
```
┌─────────────────────────────────────────────────────────────┐
│  ⚡ PALAVRAS-CHAVE E RESPOSTAS AUTOMÁTICAS                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [➕ Nova Palavra-chave]             🔍 [Buscar...]         │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ ATIVAS (12)                                           │ │
│  ├───────────────────────────────────────────────────────┤ │
│  │                                                       │ │
│  │ 💰 "preço" | "valor" | "quanto custa"                │ │
│  │ ────────────────────────────────────────────────────  │ │
│  │ Tipo: Mensagem Direta                                │ │
│  │ Resposta: Enviar lista de preços                     │ │
│  │ Usado: 2,847 vezes  |  Taxa de conversão: 23%       │ │
│  │                                                       │ │
│  │ [✏️ Editar] [📊 Stats] [🗑️ Excluir] [⏸️ Pausar]      │ │
│  ├───────────────────────────────────────────────────────┤ │
│  │                                                       │ │
│  │ 📦 "envio" | "frete" | "entrega"                     │ │
│  │ ────────────────────────────────────────────────────  │ │
│  │ Tipo: Comentário                                     │ │
│  │ Resposta: Enviar resposta padrão de entrega          │ │
│  │ Usado: 1,234 vezes  |  Taxa de conversão: 45%       │ │
│  │                                                       │ │
│  │ [✏️ Editar] [📊 Stats] [🗑️ Excluir] [⏸️ Pausar]      │ │
│  ├───────────────────────────────────────────────────────┤ │
│  │                                                       │ │
│  │ 🎁 "desconto" | "promoção" | "cupom"                 │ │
│  │ ────────────────────────────────────────────────────  │ │
│  │ Tipo: Story Reply                                    │ │
│  │ Resposta: Enviar cupom especial + Acionar Fluxo      │ │
│  │ Usado: 987 vezes  |  Taxa de conversão: 67%         │ │
│  │                                                       │ │
│  │ [✏️ Editar] [📊 Stats] [🗑️ Excluir] [⏸️ Pausar]      │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ PAUSADAS (3)                                          │ │
│  │ [Expandir ▼]                                          │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

**Configuração de Palavra-Chave:**
```
┌─────────────────────────────────────────────────────────────┐
│  ⚡ NOVA PALAVRA-CHAVE                                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  GATILHO                                                    │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Palavras-chave (separadas por vírgula):              │ │
│  │ [preço, valor, quanto custa, $, $$                  ] │ │
│  │                                                       │ │
│  │ Correspondência:                                      │ │
│  │ ○ Exata    ● Contém    ○ Começa com    ○ Termina com│ │
│  │                                                       │ │
│  │ Aplicar em:                                           │ │
│  │ ☑ Mensagens diretas                                  │ │
│  │ ☑ Comentários                                        │ │
│  │ ☑ Respostas em stories                               │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  AÇÃO                                                       │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Quando detectado, fazer:                              │ │
│  │ [▼ Enviar mensagem automática            ]           │ │
│  │                                                       │ │
│  │ Mensagem:                                             │ │
│  │ ┌─────────────────────────────────────────────────┐  │ │
│  │ │ Olá {{nome}}! 😊                                │  │ │
│  │ │                                                  │  │ │
│  │ │ Vi que você perguntou sobre nossos preços!      │  │ │
│  │ │                                                  │  │ │
│  │ │ Aqui está nossa tabela completa:                │  │ │
│  │ │ 📋 [Link da tabela]                             │  │ │
│  │ │                                                  │  │ │
│  │ │ Alguma dúvida? Estou aqui para ajudar! 💚       │  │ │
│  │ └─────────────────────────────────────────────────┘  │ │
│  │                                                       │ │
│  │ [📎 Anexar arquivo] [🖼️ Imagem] [🔘 Botões]          │ │
│  │                                                       │ │
│  │ Ações adicionais:                                     │ │
│  │ ☑ Adicionar tag "Interessado em Preço"              │ │
│  │ ☑ Mover para coluna "Negociação" no funil           │ │
│  │ ☐ Notificar vendedor responsável                     │ │
│  │ ☑ Acionar fluxo "Qualificação de Vendas"            │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  CONFIGURAÇÕES AVANÇADAS                                    │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Prioridade: [========·---] Alta                      │ │
│  │                                                       │ │
│  │ Aplicar apenas em:                                    │ │
│  │ ○ Todos os leads                                     │ │
│  │ ● Novos leads (primeira interação)                   │ │
│  │ ○ Leads com tag específica: [Selecionar tag...]     │ │
│  │                                                       │ │
│  │ Horário de funcionamento:                             │ │
│  │ ● 24/7  ○ Personalizado                              │ │
│  │                                                       │ │
│  │ Limite de uso:                                        │ │
│  │ ● Ilimitado  ○ [5] vezes por lead                    │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  [Cancelar]                      [💾 Salvar Palavra-chave] │
└─────────────────────────────────────────────────────────────┘
```

#### 5.2 Auto-Input Inteligente

**Sistema de Captura Automática:**
```
Cenário: Lead comenta "QUERO" em post promocional

┌─────────────────────────────────────────────────┐
│  AUTO-INPUT DETECTADO                           │
├─────────────────────────────────────────────────┤
│                                                 │
│  👤 @maria_silva comentou: "QUERO"              │
│  📱 Post: Promoção Lançamento                   │
│                                                 │
│  AÇÃO AUTOMÁTICA EXECUTADA:                     │
│  ✅ Enviou DM com link de compra                │
│  ✅ Adicionou tag "Promoção Lançamento"         │
│  ✅ Moveu para "Interessados" no funil          │
│  ✅ Iniciou fluxo "Venda Expressa"              │
│                                                 │
│  [Ver Conversa] [Desabilitar Auto-input]        │
└─────────────────────────────────────────────────┘
```

**Configurações de Auto-Input:**
- Detectar comentários específicos ("QUERO", "ME MANDA", etc.)
- Auto-envio de DM com conteúdo personalizado
- Captura de leads de posts/stories
- Integração com pixels de conversão
- Respostas automáticas em comentários

---

### 6. CRM e Gestão de Leads

#### 6.1 Visão Kanban

**Pipeline Visual:**
```
┌────────────────────────────────────────────────────────────────────────────┐
│  🎯 PIPELINE DE VENDAS                              [+ Nova Coluna] [⚙️]    │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  🆕 NOVO         📞 CONTATO      💬 NEGOCIAÇÃO    ✅ FECHADO    ❌ PERDIDO │
│  (245)          (123)            (67)             (34)          (12)      │
│  R$ 245k        R$ 369k          R$ 201k          R$ 102k       R$ 36k    │
│  ─────────────  ──────────────   ──────────────   ───────────   ───────── │
│                                                                            │
│  ┌───────────┐  ┌───────────┐   ┌───────────┐    ┌───────────┐           │
│  │👤 Maria S │  │👤 João P  │   │👤 Ana M   │    │👤 Carlos  │           │
│  │@mariasilva│  │@joaop     │   │@anamaria  │    │@carlosr   │           │
│  │           │  │           │   │           │    │           │           │
│  │R$ 1.200   │  │R$ 3.500   │   │R$ 4.800   │    │R$ 2.100   │           │
│  │🏷️ VIP    │  │🏷️ Urgente│   │🏷️ Quente │    │✅ Pago    │           │
│  │⏱️ 2min    │  │⏱️ 1h     │   │⏱️ 3h     │    │📅 Hoje    │           │
│  └───────────┘  └───────────┘   └───────────┘    └───────────┘           │
│                                                                            │
│  ┌───────────┐  ┌───────────┐   ┌───────────┐    ┌───────────┐           │
│  │👤 Pedro L │  │👤 Lucia F │   │👤 Rafael  │    │👤 Beatriz │           │
│  │@pedrolu   │  │@luciaf    │   │@rafaels   │    │@beatrizm  │           │
│  │           │  │           │   │           │    │           │           │
│  │R$ 890     │  │R$ 2.300   │   │R$ 5.200   │    │R$ 3.800   │           │
│  │🏷️ Novo   │  │🏷️ Follow │   │🏷️ VIP    │    │✅ Pago    │           │
│  │⏱️ 5min    │  │⏱️ 2d     │   │⏱️ 1d     │    │📅 Ontem   │           │
│  └───────────┘  └───────────┘   └───────────┘    └───────────┘           │
│                                                                            │
│  [+ Add Lead]   [+ Add Lead]    [+ Add Lead]     [+ Add Lead]             │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

**Funcionalidades do Kanban:**
- Drag & drop entre colunas
- Filtros (tag, valor, data, origem)
- Ordenação personalizada
- Colunas customizáveis
- Cores por status
- Indicadores visuais (urgência, tempo)
- Automações entre colunas
- Notificações de movimentação

#### 6.2 Detalhes do Lead

**Perfil Completo:**
```
┌─────────────────────────────────────────────────────────────────┐
│  PERFIL DO LEAD                                        [✕ Fechar]│
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌────────┐                                                     │
│  │  FOTO  │  Maria Silva                        ⭐⭐⭐⭐⭐      │
│  │        │  @mariasilva · 12.4k seguidores                    │
│  └────────┘  📍 São Paulo, SP                                  │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  INFORMAÇÕES                                                    │
│  📧 maria.silva@email.com                                      │
│  📱 (11) 98765-4321                                            │
│  🎂 28 anos · Mulher                                           │
│  💼 Empresária                                                 │
│                                                                 │
│  TAGS                                                           │
│  [🔴 VIP] [🟢 Ativo] [🟡 Quente] [+ Adicionar]                 │
│                                                                 │
│  VALOR DO NEGÓCIO                                               │
│  R$ 1.200,00                      [✏️ Editar]                   │
│                                                                 │
│  ORIGEM                                                         │
│  📱 Instagram · Story: Promoção de Lançamento                  │
│  📅 Primeira interação: 15/01/2024 às 14:30                    │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  [💬 Histórico] [📊 Atividades] [📝 Notas] [📎 Arquivos]       │
│                                                                 │
│  HISTÓRICO DE CONVERSAS (últimas 5)                            │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ 🤖 Bot · Hoje às 15:45                                    │ │
│  │ Olá Maria! Vi que você se interessou pela promoção...    │ │
│  │                                                           │ │
│  │ 👤 Maria · Hoje às 15:47                                 │ │
│  │ Sim! Quero saber mais sobre os produtos                  │ │
│  │                                                           │ │
│  │ 🤖 Bot · Hoje às 15:47                                    │ │
│  │ Perfeito! Temos 3 kits disponíveis: Básico (R$ 299)... │ │
│  │                                                           │ │
│  │ 👤 Maria · Hoje às 15:50                                 │ │
│  │ Me manda o link do kit Premium                           │ │
│  │                                                           │ │
│  │ 🤖 Bot · Hoje às 15:50                                    │ │
│  │ Aqui está o link do Kit Premium: [link]                 │ │
│  └───────────────────────────────────────────────────────────┘ │
│  [Ver conversa completa]                                        │
│                                                                 │
│  ATIVIDADES RECENTES                                            │
│  • 📧 Email enviado - Kit Premium - Hoje 16:00                 │
│  • 🏷️ Tag adicionada: "Interessado Premium" - Hoje 15:52      │
│  • ➡️ Movido para "Negociação" - Hoje 15:48                    │
│  • 💬 Primeira mensagem - Hoje 15:45                           │
│                                                                 │
│  NOTAS INTERNAS                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ [Adicionar nota...]                                       │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  • 📝 "Cliente VIP, fazer follow-up amanhã" - João (Vendedor)  │
│  • 📝 "Interessada em produtos naturais" - Bot (Análise)       │
│                                                                 │
│  ─────────────────────────────────────────────────────────────  │
│                                                                 │
│  AÇÕES RÁPIDAS                                                  │
│  [💬 Enviar Mensagem] [📧 Enviar Email] [🔔 Criar Tarefa]      │
│  [📅 Agendar Follow-up] [🗑️ Excluir Lead] [📤 Transferir]      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

#### 6.3 Campos Customizados

**Sistema de Customização:**
```
Campos padrão:
- Nome
- Email
- Telefone
- Instagram
- Foto
- Tags
- Valor
- Etapa do funil
- Origem

Campos customizáveis:
- Texto curto
- Texto longo
- Número
- Moeda
- Data
- Hora
- Select (opções)
- Multi-select
- Checkbox
- URL
- CPF/CNPJ
- CEP
- Arquivo
```

---

### 7. Sistema de Tags e Segmentação

#### 7.1 Gerenciamento de Tags

**Interface de Tags:**
```
┌─────────────────────────────────────────────────────────────┐
│  🏷️ TAGS E SEGMENTOS                                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [➕ Nova Tag]                    🔍 [Buscar tags...]       │
│                                                             │
│  TAGS ATIVAS (28)                                           │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ 🔴 VIP                         1,234 leads             │ │
│  │ Leads de alto valor            Cor: Vermelho           │ │
│  │ [✏️] [📊] [🗑️]                                         │ │
│  ├───────────────────────────────────────────────────────┤ │
│  │ 🟢 Ativo                       3,456 leads             │ │
│  │ Interagiu nos últimos 7 dias   Cor: Verde             │ │
│  │ [✏️] [📊] [🗑️]                                         │ │
│  ├───────────────────────────────────────────────────────┤ │
│  │ 🟡 Quente                      567 leads               │ │
│  │ Alta intenção de compra        Cor: Amarelo           │ │
│  │ [✏️] [📊] [🗑️]                                         │ │
│  ├───────────────────────────────────────────────────────┤ │
│  │ 🔵 Recuperação                 890 leads               │ │
│  │ Carrinho abandonado            Cor: Azul              │ │
│  │ [✏️] [📊] [🗑️]                                         │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  AUTOMAÇÕES DE TAGS                                         │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ • Se valor > R$ 1.000 → Adicionar "VIP"              │ │
│  │ • Se não interage há 30 dias → Adicionar "Inativo"   │ │
│  │ • Se comprou → Remover "Lead" + Adicionar "Cliente"  │ │
│  │ • Se palavra "urgente" → Adicionar "Prioridade Alta" │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

#### 7.2 Segmentação Avançada

**Criador de Segmentos:**
```
┌─────────────────────────────────────────────────────────────┐
│  🎯 CRIAR SEGMENTO                                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Nome do segmento: [Leads Quentes do Último Mês         ] │
│                                                             │
│  FILTROS                                                    │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Adicionar condição ▼                                  │ │
│  │                                                       │ │
│  │ ☑ Tag contém:            [🟡 Quente                ] │ │
│  │ ☑ Data de criação:       [Últimos 30 dias          ] │ │
│  │ ☑ Valor do negócio:      [Maior que R$ 500         ] │ │
│  │ ☑ Origem:                [Instagram Story           ] │ │
│  │ ☑ Última interação:      [Últimos 7 dias           ] │ │
│  │ ☐ Etapa do funil:        [Selecionar...            ] │ │
│  │                                                       │ │
│  │ [+ Adicionar condição]                                │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  PRÉVIA DO SEGMENTO                                         │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ 📊 347 leads correspondem a estes critérios          │ │
│  │                                                       │ │
│  │ Valor total: R$ 243.500                              │ │
│  │ Ticket médio: R$ 702                                 │ │
│  │ Taxa de conversão estimada: 23%                      │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  AÇÕES DO SEGMENTO                                          │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ O que fazer com este segmento?                        │ │
│  │                                                       │ │
│  │ ○ Apenas visualizar                                  │ │
│  │ ● Enviar broadcast                                   │ │
│  │ ○ Adicionar a uma automação                          │ │
│  │ ○ Exportar para CSV                                  │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  [Cancelar]                         [💾 Criar Segmento]    │
└─────────────────────────────────────────────────────────────┘
```

---

### 8. Broadcast e Campanhas

#### 8.1 Criador de Broadcast

**Interface de Envio em Massa:**
```
┌─────────────────────────────────────────────────────────────┐
│  📢 NOVA CAMPANHA DE BROADCAST                              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PASSO 1: PÚBLICO-ALVO                                      │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Enviar para:                                          │ │
│  │ ● Segmento específico: [Leads Quentes ▼           ]  │ │
│  │ ○ Todos os leads (3,456 pessoas)                     │ │
│  │ ○ Leads com tags: [Selecionar...               ]     │ │
│  │ ○ Upload de lista (CSV)                              │ │
│  │                                                       │ │
│  │ Excluir:                                              │ │
│  │ ☑ Leads que já compraram                             │ │
│  │ ☑ Leads inativos (30+ dias)                          │ │
│  │ ☐ Leads com tag específica                           │ │
│  │                                                       │ │
│  │ 📊 Total de destinatários: 347 leads                 │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  PASSO 2: MENSAGEM                                          │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Tipo de mensagem:                                     │ │
│  │ ● Texto  ○ Imagem  ○ Vídeo  ○ Carrossel             │ │
│  │                                                       │ │
│  │ Sua mensagem:                                         │ │
│  │ ┌─────────────────────────────────────────────────┐  │ │
│  │ │ Oi {{nome}}! 🎉                                 │  │ │
│  │ │                                                  │  │ │
│  │ │ Temos uma SUPER PROMOÇÃO especial pra você!     │  │ │
│  │ │                                                  │  │ │
│  │ │ 🔥 30% OFF em todos os produtos                 │  │ │
│  │ │ 🎁 Frete GRÁTIS acima de R$ 100                 │  │ │
│  │ │ ⏰ Válido até domingo!                          │  │ │
│  │ │                                                  │  │ │
│  │ │ Aproveita: [link]                               │  │ │
│  │ │                                                  │  │ │
│  │ │ Quer saber mais? É só responder! 😊            │  │ │
│  │ └─────────────────────────────────────────────────┘  │ │
│  │                                                       │ │
│  │ [Variáveis: {{nome}}, {{valor}}, {{produto}}...]     │ │
│  │ [📎 Anexar mídia] [🔘 Adicionar botões]              │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  PASSO 3: AGENDAMENTO                                       │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Quando enviar?                                        │ │
│  │ ● Agora                                               │ │
│  │ ○ Agendar para: [DD/MM/AAAA] às [HH:MM]             │ │
│  │ ○ Melhor horário (IA sugere)                         │ │
│  │                                                       │ │
│  │ Velocidade de envio:                                  │ │
│  │ ○ Rápido (100 msgs/min)                              │ │
│  │ ● Normal (50 msgs/min)                               │ │
│  │ ○ Lento (20 msgs/min) - Recomendado para grandes    │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  PRÉVIA                                                     │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ 📱 Como ficará no Instagram:                          │ │
│  │                                                       │ │
│  │ ┌─────────────────────────────────────┐              │ │
│  │ │ Oi Maria! 🎉                        │              │ │
│  │ │                                      │              │ │
│  │ │ Temos uma SUPER PROMOÇÃO especial    │              │ │
│  │ │ pra você!                            │              │ │
│  │ │                                      │              │ │
│  │ │ 🔥 30% OFF em todos os produtos     │              │ │
│  │ │ 🎁 Frete GRÁTIS acima de R$ 100     │              │ │
│  │ │ ⏰ Válido até domingo!              │              │ │
│  │ │                                      │              │ │
│  │ │ Aproveita: meusite.com.br           │              │ │
│  │ └─────────────────────────────────────┘              │ │
│  │                                                       │ │
│  │ [📤 Enviar Teste] - Envie para si mesmo primeiro     │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  [❌ Cancelar]                      [📤 Enviar Broadcast]  │
└─────────────────────────────────────────────────────────────┘
```

#### 8.2 Análise de Campanhas

**Dashboard de Performance:**
```
┌─────────────────────────────────────────────────────────────┐
│  📊 ANÁLISE DE CAMPANHAS                                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CAMPANHA: Promoção de Verão 2024                          │
│  Status: ✅ Concluída  |  Enviada: 15/01/2024 às 10:00     │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ 347          │  │ 321 (92.5%)  │  │ 287 (82.7%)  │     │
│  │ Enviadas     │  │ Entregues    │  │ Abertas      │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ 156 (44.9%)  │  │ 34 (9.8%)    │  │ R$ 12,400    │     │
│  │ Cliques      │  │ Conversões   │  │ Receita      │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                             │
│  DESEMPENHO POR HORA                                        │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Taxa de abertura:                                     │ │
│  │     •••                                               │ │
│  │    •   •••                                            │ │
│  │   •       •                                           │ │
│  │  •         •                                          │ │
│  └───────────────────────────────────────────────────────┘ │
│   10h  11h  12h  13h  14h  15h  16h  17h                   │
│                                                             │
│  LINKS MAIS CLICADOS                                        │
│  1. Link da promoção (123 cliques)                         │
│  2. Catálogo completo (45 cliques)                         │
│  3. Instagram da marca (32 cliques)                        │
│                                                             │
│  INSIGHTS DA IA                                             │
│  💡 Melhor horário: 14h-16h (taxa de abertura 95%)         │
│  💡 Palavras que geraram mais engajamento: "GRÁTIS", "30%" │
│  💡 Sugestão: Testar emojis diferentes na próxima campanha │
│                                                             │
│  [📥 Exportar Relatório] [🔄 Replicar Campanha]            │
└─────────────────────────────────────────────────────────────┘
```

---

### 9. Analytics e Relatórios

#### 9.1 Dashboard de Analytics

**Métricas Completas:**
```
┌─────────────────────────────────────────────────────────────────────┐
│  📊 ANALYTICS                                     [📅 Últimos 30 dias]│
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  OVERVIEW GERAL                                                     │
│  ┌───────────┐ ┌───────────┐ ┌───────────┐ ┌───────────┐          │
│  │ 12,847    │ │ 3,456     │ │ 2,134     │ │ 456       │          │
│  │ Mensagens │ │ Leads     │ │ Conversas │ │ Conversões│          │
│  │ ↑ +23%    │ │ ↑ +15%    │ │ ↑ +18%    │ │ ↑ +12%    │          │
│  └───────────┘ └───────────┘ └───────────┘ └───────────┘          │
│                                                                     │
│  FUNIL DE CONVERSÃO                                                 │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │ 📱 Mensagens recebidas:     3,456 leads     ───────────────── │ │
│  │ 💬 Respondidas pelo bot:    3,201 (92.6%)  ────────────────   │ │
│  │ 🎯 Qualificadas:             2,134 (61.7%)  ─────────────     │ │
│  │ 💰 Propostas enviadas:       890 (25.7%)    ────────          │ │
│  │ ✅ Conversões:               456 (13.2%)    ─────             │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                                                     │
│  PERFORMANCE DO AGENTE                                              │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │ Tempo médio de resposta:        3.2 segundos                  │ │
│  │ Taxa de satisfação (NPS):       89% (⭐⭐⭐⭐⭐)                │ │
│  │ Conversas finalizadas:          2,134 (92.6%)                 │ │
│  │ Transferidas para humano:       156 (7.4%)                    │ │
│  │ Taxa de resolução:              94.2%                         │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                                                     │
│  ORIGEM DOS LEADS                                                   │
│  ┌─────────────────┐                                               │
│  │ 📱 Direct: 45%  │                                               │
│  │ 💬 Comentário: 30% │                                            │
│  │ 📖 Story: 20%   │                                               │
│  │ 🌐 Site: 5%     │                                               │
│  └─────────────────┘                                               │
│                                                                     │
│  RECEITA                                                            │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │ Total de vendas: R$ 127,400                                   │ │
│  │ Ticket médio: R$ 279                                          │ │
│  │ ROI do bot: 456% (cada R$ 1 investido gerou R$ 4,56)          │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                                                     │
│  [📥 Exportar Relatório Completo] [📊 Relatório Personalizado]     │
└─────────────────────────────────────────────────────────────────────┘
```

#### 9.2 Relatórios Customizados

**Builder de Relatórios:**
- Selecionar métricas específicas
- Escolher período de análise
- Aplicar filtros (tag, origem, etapa)
- Comparar períodos
- Exportar em PDF/Excel/CSV
- Agendar envio automático por email

---

### 10. Configurações da Conta

#### 10.1 Configurações Gerais

```
┌─────────────────────────────────────────────────────────────┐
│  ⚙️ CONFIGURAÇÕES                                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [👤 Perfil] [🔐 Segurança] [💳 Assinatura] [👥 Equipe]     │
│  [🔔 Notificações] [🔌 Integrações] [⚡ Automações]         │
│                                                             │
│  PERFIL DA CONTA                                            │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Foto:  [Upload]                                       │ │
│  │                                                       │ │
│  │ Nome:  [João Silva                               ]   │ │
│  │ Email: [joao@empresa.com.br                      ]   │ │
│  │ Tel:   [(11) 98765-4321                          ]   │ │
│  │                                                       │ │
│  │ Empresa:    [Minha Empresa LTDA                  ]   │ │
│  │ Segmento:   [E-commerce / Varejo              ▼]     │ │
│  │ Fuso:       [GMT-3 São Paulo                   ▼]     │ │
│  │ Idioma:     [Português (Brasil)                ▼]     │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  INSTAGRAM CONECTADO                                        │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ @minha_empresa                                        │ │
│  │ Status: ✅ Conectado                                  │ │
│  │ Permissões: DMs, Comentários, Stories                │ │
│  │                                                       │ │
│  │ [🔄 Reconectar] [🗑️ Desconectar]                     │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  HORÁRIO DE FUNCIONAMENTO                                   │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Segunda a Sexta:  [09:00] às [18:00]                 │ │
│  │ Sábado:           [09:00] às [13:00]                 │ │
│  │ Domingo:          [Fechado                         ]  │ │
│  │                                                       │ │
│  │ Mensagem fora do horário:                             │ │
│  │ [Olá! Nosso horário de atendimento é...]            │ │
│  │                                                       │ │
│  │ ☑ Permitir bot fora do horário                       │ │
│  │ ☐ Pausar completamente                               │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  [Cancelar]                    [💾 Salvar Alterações]      │
└─────────────────────────────────────────────────────────────┘
```

#### 10.2 Gestão de Equipe

```
┌─────────────────────────────────────────────────────────────┐
│  👥 EQUIPE                                                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [➕ Convidar Membro]                                        │
│                                                             │
│  MEMBROS ATIVOS (5)                                         │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ 👤 João Silva (Você)                                  │ │
│  │    joao@empresa.com · Administrador                   │ │
│  │    Último acesso: Agora                               │ │
│  ├───────────────────────────────────────────────────────┤ │
│  │ 👤 Maria Santos                                       │ │
│  │    maria@empresa.com · Gerente                        │ │
│  │    Último acesso: 2 horas atrás                       │ │
│  │    [✏️ Editar] [🚫 Bloquear] [🗑️ Remover]             │ │
│  ├───────────────────────────────────────────────────────┤ │
│  │ 👤 Pedro Costa                                        │ │
│  │    pedro@empresa.com · Atendente                      │ │
│  │    Último acesso: Ontem                               │ │
│  │    [✏️ Editar] [🚫 Bloquear] [🗑️ Remover]             │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
│  PERMISSÕES POR FUNÇÃO                                      │
│  ┌───────────────────────────────────────────────────────┐ │
│  │ Administrador:                                        │ │
│  │ ✅ Todas as permissões                                │ │
│  │                                                       │ │
│  │ Gerente:                                              │ │
│  │ ✅ Ver analytics                                      │ │
│  │ ✅ Gerenciar leads                                    │ │
│  │ ✅ Criar fluxos                                       │ │
│  │ ❌ Gerenciar assinatura                              │ │
│  │ ❌ Gerenciar equipe                                   │ │
│  │                                                       │ │
│  │ Atendente:                                            │ │
│  │ ✅ Ver conversas                                      │ │
│  │ ✅ Responder mensagens                                │ │
│  │ ✅ Atualizar leads                                    │ │
│  │ ❌ Criar fluxos                                       │ │
│  │ ❌ Ver analytics                                      │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## 🗄️ Estrutura de Banco de Dados

### Tabelas Principais

#### 1. users (Usuários)
```sql
CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Autenticação
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  email_verified BOOLEAN DEFAULT FALSE,
  email_verification_token VARCHAR(255),
  
  -- Perfil
  full_name VARCHAR(255),
  phone VARCHAR(50),
  company_name VARCHAR(255),
  industry VARCHAR(100),
  timezone VARCHAR(50) DEFAULT 'America/Sao_Paulo',
  language VARCHAR(10) DEFAULT 'pt-BR',
  
  -- Plano e Status
  plan VARCHAR(50) DEFAULT 'trial', -- trial, basic, pro, enterprise
  plan_status VARCHAR(50) DEFAULT 'active', -- active, canceled, expired
  trial_ends_at TIMESTAMPTZ,
  subscription_id VARCHAR(255),
  
  -- Instagram
  instagram_user_id VARCHAR(255),
  instagram_username VARCHAR(255),
  instagram_access_token TEXT,
  instagram_token_expires_at TIMESTAMPTZ,
  instagram_connected BOOLEAN DEFAULT FALSE,
  
  -- Preferências
  business_hours JSONB, -- horário de funcionamento
  out_of_hours_message TEXT,
  avatar_url TEXT,
  
  -- Controle
  is_active BOOLEAN DEFAULT TRUE,
  last_login_at TIMESTAMPTZ,
  login_count INTEGER DEFAULT 0
);
```

#### 2. agents (Agentes de IA)
```sql
CREATE TABLE agents (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Configuração
  name VARCHAR(255) NOT NULL,
  description TEXT,
  personality TEXT,
  system_prompt TEXT NOT NULL,
  
  -- Modelo IA
  ai_model VARCHAR(100) DEFAULT 'gpt-4-turbo',
  temperature DECIMAL(3,2) DEFAULT 0.7,
  max_tokens INTEGER DEFAULT 500,
  response_delay_seconds INTEGER DEFAULT 5,
  max_messages_per_conversation INTEGER DEFAULT 20,
  
  -- Comportamento
  tone VARCHAR(50), -- formal, friendly, casual
  allow_human_handoff BOOLEAN DEFAULT TRUE,
  save_conversation_history BOOLEAN DEFAULT TRUE,
  debug_mode BOOLEAN DEFAULT FALSE,
  
  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  is_default BOOLEAN DEFAULT FALSE,
  
  -- Estatísticas
  total_conversations INTEGER DEFAULT 0,
  total_messages_sent INTEGER DEFAULT 0,
  average_satisfaction_score DECIMAL(3,2)
);
```

#### 3. knowledge_base (Base de Conhecimento)
```sql
CREATE TABLE knowledge_base (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  agent_id BIGINT REFERENCES agents(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Tipo e Origem
  type VARCHAR(50) NOT NULL, -- pdf, url, text, video, audio, integration
  name VARCHAR(255) NOT NULL,
  description TEXT,
  source_url TEXT,
  
  -- Conteúdo
  raw_content TEXT,
  processed_content TEXT,
  content_metadata JSONB, -- páginas, tamanho, idioma, etc
  
  -- Indexação
  vector_embeddings VECTOR(1536), -- para busca semântica
  tokens_count INTEGER,
  
  -- Status
  status VARCHAR(50) DEFAULT 'pending', -- pending, processing, active, error
  is_active BOOLEAN DEFAULT TRUE,
  
  -- Sincronização (para URLs)
  last_synced_at TIMESTAMPTZ,
  sync_frequency VARCHAR(50), -- daily, weekly, manual
  auto_sync BOOLEAN DEFAULT FALSE
);
```

#### 4. flows (Fluxos Visuais)
```sql
CREATE TABLE flows (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Informações
  name VARCHAR(255) NOT NULL,
  description TEXT,
  category VARCHAR(100), -- sales, support, lead_qualification
  
  -- Estrutura
  flow_data JSONB NOT NULL, -- estrutura completa do fluxo
  trigger_type VARCHAR(50), -- new_message, comment, story_reply, keyword
  trigger_config JSONB,
  
  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  is_template BOOLEAN DEFAULT FALSE,
  
  -- Estatísticas
  total_executions INTEGER DEFAULT 0,
  completion_rate DECIMAL(5,2),
  average_completion_time INTEGER, -- segundos
  
  -- Versioning
  version INTEGER DEFAULT 1,
  parent_flow_id BIGINT REFERENCES flows(id)
);
```

#### 5. leads (CRM)
```sql
CREATE TABLE leads (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Informações Básicas
  name VARCHAR(255),
  email VARCHAR(255),
  phone VARCHAR(50),
  
  -- Instagram
  instagram_id VARCHAR(255),
  instagram_username VARCHAR(255),
  instagram_profile_pic TEXT,
  instagram_follower_count INTEGER,
  is_follower BOOLEAN,
  
  -- Negócio
  deal_value DECIMAL(10,2),
  currency VARCHAR(10) DEFAULT 'BRL',
  pipeline_stage_id BIGINT REFERENCES pipeline_stages(id),
  
  -- Origem
  source VARCHAR(100), -- instagram_dm, comment, story, website
  source_detail TEXT,
  utm_source VARCHAR(255),
  utm_campaign VARCHAR(255),
  
  -- Interações
  last_message TEXT,
  last_response TEXT,
  last_interaction_at TIMESTAMPTZ,
  last_response_at TIMESTAMPTZ,
  interaction_type VARCHAR(50), -- dm, comment, story
  
  -- Status
  is_qualified BOOLEAN DEFAULT FALSE,
  is_customer BOOLEAN DEFAULT FALSE,
  
  -- Campos Customizados
  custom_fields JSONB,
  
  -- Preferências
  preferred_contact_method VARCHAR(50),
  best_time_to_contact VARCHAR(50),
  notes TEXT
);
```

#### 6. tags
```sql
CREATE TABLE tags (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  name VARCHAR(100) NOT NULL,
  color VARCHAR(50),
  is_active BOOLEAN DEFAULT TRUE,
  
  UNIQUE(user_id, name)
);

CREATE TABLE lead_tags (
  lead_id BIGINT REFERENCES leads(id) ON DELETE CASCADE,
  tag_id BIGINT REFERENCES tags(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  PRIMARY KEY(lead_id, tag_id)
);
```

#### 7. pipeline_stages (Etapas do Funil)
```sql
CREATE TABLE pipeline_stages (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  name VARCHAR(100) NOT NULL,
  color VARCHAR(50),
  order_position INTEGER NOT NULL,
  is_won_stage BOOLEAN DEFAULT FALSE,
  is_lost_stage BOOLEAN DEFAULT FALSE,
  
  -- Automações
  automation_on_enter JSONB, -- ações ao entrar na etapa
  automation_on_exit JSONB
);
```

#### 8. keywords (Palavras-Chave)
```sql
CREATE TABLE keywords (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Trigger
  keywords JSONB NOT NULL, -- array de palavras
  match_type VARCHAR(50) DEFAULT 'contains', -- exact, contains, starts_with, ends_with
  
  -- Canais
  apply_to_dm BOOLEAN DEFAULT TRUE,
  apply_to_comments BOOLEAN DEFAULT TRUE,
  apply_to_stories BOOLEAN DEFAULT TRUE,
  
  -- Resposta
  response_type VARCHAR(50), -- message, trigger_flow, webhook
  response_message TEXT,
  response_media_url TEXT,
  response_buttons JSONB,
  flow_id BIGINT REFERENCES flows(id),
  
  -- Ações Adicionais
  add_tags JSONB, -- array de tag_ids
  move_to_stage_id BIGINT REFERENCES pipeline_stages(id),
  notify_user BOOLEAN DEFAULT FALSE,
  
  -- Configurações
  priority INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  
  -- Restrições
  apply_only_to_new_leads BOOLEAN DEFAULT FALSE,
  apply_only_with_tags JSONB,
  max_uses_per_lead INTEGER,
  
  -- Horário
  active_hours JSONB,
  
  -- Estatísticas
  total_triggers INTEGER DEFAULT 0,
  conversion_rate DECIMAL(5,2)
);
```

#### 9. conversations (Histórico de Conversas)
```sql
CREATE TABLE conversations (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  lead_id BIGINT REFERENCES leads(id) ON DELETE CASCADE,
  agent_id BIGINT REFERENCES agents(id),
  flow_id BIGINT REFERENCES flows(id),
  
  started_at TIMESTAMPTZ DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  
  -- Tipo
  type VARCHAR(50), -- agent, flow, human
  channel VARCHAR(50), -- dm, comment, story
  
  -- Status
  status VARCHAR(50) DEFAULT 'active', -- active, resolved, transferred
  transferred_to_human BOOLEAN DEFAULT FALSE,
  transferred_at TIMESTAMPTZ,
  
  -- Qualidade
  satisfaction_score INTEGER, -- 1-5
  resolved BOOLEAN,
  
  -- Métricas
  total_messages INTEGER DEFAULT 0,
  response_time_avg INTEGER, -- segundos
  duration_seconds INTEGER
);

CREATE TABLE messages (
  id BIGSERIAL PRIMARY KEY,
  conversation_id BIGINT REFERENCES conversations(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Remetente
  from_type VARCHAR(50), -- lead, agent, human
  from_user_id BIGINT REFERENCES users(id),
  
  -- Conteúdo
  content TEXT,
  media_type VARCHAR(50), -- text, image, video, audio, file
  media_url TEXT,
  
  -- Metadados
  instagram_message_id VARCHAR(255),
  is_read BOOLEAN DEFAULT FALSE,
  read_at TIMESTAMPTZ,
  
  -- IA
  ai_confidence DECIMAL(5,2),
  intent VARCHAR(100),
  sentiment VARCHAR(50), -- positive, neutral, negative
  entities JSONB
);
```

#### 10. broadcasts (Campanhas)
```sql
CREATE TABLE broadcasts (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  scheduled_at TIMESTAMPTZ,
  sent_at TIMESTAMPTZ,
  
  -- Configuração
  name VARCHAR(255) NOT NULL,
  
  -- Público
  target_type VARCHAR(50), -- all, segment, tags, custom
  target_segment_id BIGINT,
  target_tags JSONB,
  target_custom_filter JSONB,
  exclude_filter JSONB,
  
  -- Mensagem
  message_type VARCHAR(50), -- text, image, video, carousel
  message_content TEXT,
  message_media_url TEXT,
  message_buttons JSONB,
  
  -- Envio
  send_speed VARCHAR(50) DEFAULT 'normal', -- fast, normal, slow
  messages_per_minute INTEGER,
  
  -- Status
  status VARCHAR(50) DEFAULT 'draft', -- draft, scheduled, sending, sent, failed
  
  -- Estatísticas
  total_recipients INTEGER,
  total_sent INTEGER DEFAULT 0,
  total_delivered INTEGER DEFAULT 0,
  total_read INTEGER DEFAULT 0,
  total_clicked INTEGER DEFAULT 0,
  total_replied INTEGER DEFAULT 0,
  total_converted INTEGER DEFAULT 0,
  
  -- Receita
  total_revenue DECIMAL(10,2),
  
  -- Metadados
  ab_test BOOLEAN DEFAULT FALSE,
  ab_test_config JSONB
);
```

#### 11. integrations (Integrações)
```sql
CREATE TABLE integrations (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Tipo
  integration_type VARCHAR(100), -- zapier, make, webhook, google_drive, etc
  name VARCHAR(255),
  
  -- Configuração
  config JSONB NOT NULL,
  credentials JSONB, -- criptografado
  
  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  last_sync_at TIMESTAMPTZ,
  sync_status VARCHAR(50), -- success, error, pending
  error_message TEXT,
  
  -- Uso
  total_calls INTEGER DEFAULT 0,
  successful_calls INTEGER DEFAULT 0,
  failed_calls INTEGER DEFAULT 0
);
```

#### 12. analytics_events (Eventos)
```sql
CREATE TABLE analytics_events (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Evento
  event_type VARCHAR(100) NOT NULL,
  event_name VARCHAR(255),
  
  -- Contexto
  lead_id BIGINT REFERENCES leads(id),
  conversation_id BIGINT REFERENCES conversations(id),
  flow_id BIGINT REFERENCES flows(id),
  broadcast_id BIGINT REFERENCES broadcasts(id),
  
  -- Dados
  event_data JSONB,
  
  -- Métricas
  revenue DECIMAL(10,2),
  
  -- Metadados
  user_agent TEXT,
  ip_address INET,
  session_id VARCHAR(255)
);
```

---

## 🔐 Segurança e Autenticação

### Sistema de Autenticação

#### 1. Multi-fator (2FA)
- SMS
- Aplicativo autenticador (Google Authenticator, Authy)
- Email de confirmação

#### 2. OAuth Social
- Login com Facebook (acesso Instagram)
- Login com Google
- SSO Empresarial (SAML)

#### 3. Permissões e Roles
```
Administrador:
- Acesso total
- Gerenciar usuários
- Configurar integrações
- Ver todos os relatórios

Gerente:
- Gerenciar leads
- Criar/editar fluxos
- Ver analytics
- Enviar broadcasts

Atendente:
- Ver conversas
- Responder mensagens
- Atualizar leads
- Ver dashboard básico

Visualizador:
- Apenas visualizar relatórios
- Sem edição
```

#### 4. Segurança de Dados
- Criptografia em repouso (AES-256)
- Criptografia em trânsito (TLS 1.3)
- Backup automático diário
- LGPD Compliance
- Logs de auditoria
- Rate limiting
- Proteção contra SQL Injection
- XSS Protection
- CSRF Tokens

---

## 🔌 Integrações

### Nativas
1. **Instagram Business API**
   - DMs
   - Comentários
   - Stories
   - Insights

2. **Meta Pixel**
   - Rastreamento de conversões
   - Audiências customizadas
   - Remarketing

3. **Payment Gateways**
   - Stripe
   - Mercado Pago
   - PagSeguro
   - PayPal

4. **CRM**
   - HubSpot
   - Pipedrive
   - RD Station
   - ActiveCampaign

5. **E-commerce**
   - Shopify
   - WooCommerce
   - Nuvemshop
   - Yampi

### Automação
1. **Zapier**
   - 5000+ apps disponíveis
   - Triggers e actions customizadas

2. **Make (Integromat)**
   - Workflows visuais
   - Lógica complexa

3. **Webhooks**
   - Enviar dados para qualquer sistema
   - Receber eventos externos

### Armazenamento
1. **Google Drive**
   - Backup automático
   - Sincronização de documentos

2. **Dropbox**
3. **OneDrive**
4. **Notion** (Base de conhecimento)

### Comunicação
1. **WhatsApp Business API** (futuro)
2. **Telegram**
3. **Email** (SMTP)
4. **SMS** (Twilio)

---

## 💰 Planos e Monetização

### Estrutura de Planos

#### 1. Trial (Gratuito - 14 dias)
- 100 mensagens/mês
- 1 agente de IA
- 1 Instagram conectado
- 3 fluxos básicos
- 50 leads
- Suporte por email

#### 2. Starter ($47/mês)
- 1.000 mensagens/mês
- 1 agente de IA
- 1 Instagram
- 10 fluxos
- 500 leads
- Base de conhecimento (5 documentos)
- Palavras-chave ilimitadas
- Suporte prioritário
- Analytics básico

#### 3. Professional ($147/mês)
- 5.000 mensagens/mês
- 3 agentes de IA
- 3 Instagrams
- Fluxos ilimitados
- 5.000 leads
- Base de conhecimento ilimitada
- 3 usuários na equipe
- Broadcasts ilimitados
- Integrações nativas
- Webhooks
- Analytics avançado
- Suporte via chat

#### 4. Business ($397/mês)
- 20.000 mensagens/mês
- Agentes ilimitados
- 10 Instagrams
- Tudo ilimitado
- 50.000 leads
- 10 usuários
- White label
- API personalizada
- Gerente de sucesso dedicado
- SLA 99.9%

#### 5. Enterprise (Customizado)
- Mensagens ilimitadas
- Tudo ilimitado
- Usuários ilimitados
- Infraestrutura dedicada
- Customizações
- Onboarding personalizado
- Contrato anual

### Upsells e Add-ons
- Mensagens extras: $10/1000 msgs
- Usuários extras: $20/usuário/mês
- Leads extras: $5/1000 leads
- Instagram extra: $30/conta/mês
- Suporte premium: $100/mês
- Consultoria: $150/hora

---

## 🚀 Roadmap de Desenvolvimento

### Fase 1: MVP Core (2-3 meses)
**Prioridade Máxima**

**Semanas 1-2: Infraestrutura**
- [ ] Setup do ambiente (Supabase)
- [ ] Estrutura de banco de dados
- [ ] Sistema de autenticação
- [ ] Deploy inicial (Vercel/Railway)

**Semanas 3-4: Autenticação e Onboarding**
- [ ] Tela de login/registro
- [ ] Recuperação de senha
- [ ] Verificação de email
- [ ] Onboarding inicial
- [ ] Conexão Instagram Business

**Semanas 5-6: Dashboard e CRM Básico**
- [ ] Dashboard com métricas principais
- [ ] Kanban visual de leads
- [ ] CRUD de leads
- [ ] Sistema de tags
- [ ] Filtros básicos

**Semanas 7-8: Agente de IA v1**
- [ ] Configuração de agente
- [ ] Integração OpenAI/Claude
- [ ] Respostas automáticas DM
- [ ] Histórico de conversas
- [ ] Playground de teste

**Semanas 9-10: Palavras-Chave e Auto-Input**
- [ ] CRUD de palavras-chave
- [ ] Detecção em DMs
- [ ] Detecção em comentários
- [ ] Respostas automáticas
- [ ] Estatísticas básicas

**Semanas 11-12: Polish e Launch**
- [ ] Testes de integração
- [ ] Correção de bugs
- [ ] Documentação
- [ ] Landing page
- [ ] Lançamento beta

### Fase 2: Expansão (3-4 meses)
**Features Avançadas**

**Mês 4:**
- [ ] Base de conhecimento
  - Upload de PDFs
  - Indexação de URLs
  - FAQ estruturado
- [ ] Editor visual de fluxos v1
  - Triggers básicos
  - Ações de mensagem
  - Condições IF/ELSE
- [ ] Analytics avançado
  - Funil de conversão
  - Taxa de satisfação
  - ROI

**Mês 5:**
- [ ] Sistema de broadcasts
  - Criador de campanhas
  - Segmentação
  - Agendamento
  - Relatórios
- [ ] Gestão de equipe
  - Múltiplos usuários
  - Permissões
  - Notificações
- [ ] Integrações básicas
  - Zapier
  - Webhooks
  - Google Drive

**Mês 6:**
- [ ] Editor de fluxos v2
  - Mais tipos de nós
  - Templates prontos
  - A/B testing
- [ ] Campos customizados
- [ ] Automações avançadas
- [ ] API pública beta

**Mês 7:**
- [ ] Mobile responsivo completo
- [ ] PWA (instalável)
- [ ] Otimizações de performance
- [ ] Testes de carga

### Fase 3: Escala (3-4 meses)
**Enterprise Ready**

**Mês 8-9:**
- [ ] White label
- [ ] Multi-tenancy robusto
- [ ] Planos empresariais
- [ ] SLA e uptime monitoring
- [ ] Backup e disaster recovery

**Mês 10:**
- [ ] WhatsApp Business API
- [ ] SMS integration
- [ ] Email marketing
- [ ] Telefonia (VoIP)

**Mês 11:**
- [ ] IA Avançada
  - Análise de sentimento
  - Detecção de intenções
  - Previsão de churn
  - Recomendação de ações
- [ ] Marketplace de templates
- [ ] Plugins/extensões

**Mês 12:**
- [ ] Internacionalização (i18n)
- [ ] Múltiplos idiomas
- [ ] Moedas diferentes
- [ ] Compliance global (GDPR, CCPA)

### Fase 4: Inovação (Ongoing)
**Diferenciação**

- [ ] Voice AI (atendimento por voz)
- [ ] Video AI (análise de vídeos)
- [ ] Realidade Aumentada (provador virtual)
- [ ] Blockchain (verificação, NFTs)
- [ ] Metaverso (atendimento em 3D)

---

## 📱 Interface Mobile

### Progressive Web App (PWA)
- Instalável em iOS e Android
- Funciona offline
- Notificações push
- Sincronização em background

### Features Específicas Mobile
- Chat responsivo otimizado
- Gestos (swipe, pull-to-refresh)
- Upload de fotos/vídeos
- Scanner de QR Code
- Geolocalização

---

## 🎨 Design System

### Cores Principais
```
Primary: #667eea (Gradient com #764ba2)
Success: #28a745
Warning: #ffc107
Error: #dc3545
Info: #17a2b8

Neutros:
- Background: #f8f9fa
- Surface: #ffffff
- Text Primary: #333333
- Text Secondary: #666666
- Border: #e0e0e0
```

### Tipografia
```
Font Family: 'Poppins', sans-serif

Headings:
- H1: 32px, Bold
- H2: 24px, SemiBold
- H3: 20px, SemiBold
- H4: 18px, Medium

Body:
- Regular: 15px
- Small: 13px
- Tiny: 11px
```

### Componentes UI
- Buttons (primary, secondary, ghost, danger)
- Cards (shadow, bordered, elevated)
- Forms (inputs, selects, checkboxes, radio)
- Modals (confirmation, form, info)
- Toasts/Notifications
- Badges
- Avatars
- Loading states
- Empty states
- Error states

---

## 🧪 Tecnologias Sugeridas

### Frontend
- **Framework:** React 18 + TypeScript
- **Routing:** React Router v6
- **State:** Zustand ou Jotai (leve)
- **Forms:** React Hook Form + Zod
- **UI:** Tailwind CSS + Headless UI
- **Charts:** Recharts
- **Drag & Drop:** dnd-kit
- **Flow Editor:** React Flow
- **Icons:** Lucide React
- **Animations:** Framer Motion

### Backend
- **Database:** Supabase (PostgreSQL + Auth + Storage + Realtime)
- **API:** Supabase Functions (Edge Functions)
- **IA:** OpenAI API / Anthropic Claude
- **Vector DB:** pgvector (Supabase)
- **File Storage:** Supabase Storage
- **Email:** Resend ou SendGrid
- **SMS:** Twilio
- **Payments:** Stripe

### Infraestrutura
- **Hosting:** Vercel (frontend)
- **Backend:** Supabase Cloud
- **CDN:** Cloudflare
- **Monitoring:** Sentry
- **Analytics:** PostHog ou Mixpanel
- **Logs:** Axiom

### Automação
- **Webhooks:** Svix
- **Jobs:** Inngest ou Trigger.dev
- **Cron:** Vercel Cron Jobs

---

## 📊 Métricas de Sucesso

### KPIs do Produto
- Tempo médio de resposta < 5 segundos
- Taxa de satisfação (NPS) > 80%
- Taxa de conclusão de conversas > 90%
- Uptime > 99.5%
- Tempo de onboarding < 10 minutos

### KPIs de Negócio
- MRR (Monthly Recurring Revenue)
- Churn rate < 5%
- Customer Acquisition Cost (CAC)
- Lifetime Value (LTV)
- LTV/CAC ratio > 3
- Número de usuários ativos
- Número de mensagens processadas
- Taxa de conversão trial → pago > 20%

---

## 🎓 Documentação e Suporte

### Centro de Ajuda
- Tutoriais em vídeo
- Artigos passo a passo
- FAQ interativo
- Glossário de termos
- Use cases por segmento

### Developer Docs
- API Reference
- Webhooks
- SDKs (JavaScript, Python)
- Postman Collection
- Changelog

### Suporte
- Chat ao vivo (Business+)
- Email support (todos)
- Knowledge base
- Status page
- Community forum

---

## 🔒 Compliance e Legal

### LGPD (Brasil)
- Política de privacidade
- Termos de uso
- Consentimento explícito
- Direito ao esquecimento
- Portabilidade de dados
- DPO designado

### Segurança
- Certificado SSL
- Backup diário
- Disaster recovery
- Penetration testing
- Bug bounty program

---

## 💡 Diferenciais Competitivos

### vs Manychat
✅ Agente de IA nativo (não apenas fluxos)
✅ Base de conhecimento integrada
✅ Analytics mais profundo
✅ Melhor UX mobile
✅ Preço mais acessível no Brasil

### vs MobileMonkey
✅ Foco em Instagram (não Facebook)
✅ IA mais avançada
✅ Interface em português
✅ Suporte local

### vs Chatfuel
✅ Modo híbrido (IA + Fluxos)
✅ CRM integrado robusto
✅ Onboarding mais simples
✅ Templates específicos por nicho

---

## 📈 Go-to-Market Strategy

### Canais de Aquisição
1. **Conteúdo**
   - Blog (SEO)
   - YouTube (tutoriais)
   - Podcast
   - E-books

2. **Parcerias**
   - Agências de marketing
   - Consultores
   - Influenciadores
   - Afiliados (20% comissão)

3. **Paid Ads**
   - Meta Ads
   - Google Ads
   - LinkedIn Ads

4. **Community**
   - Grupos no Facebook
   - Discord
   - Telegram
   - Eventos

### Segmentos Prioritários
1. E-commerce (roupas, cosméticos)
2. Infoprodutos (cursos, mentorias)
3. Saúde e bem-estar (clínicas, academias)
4. Beleza (salões, estéticas)
5. Delivery (restaurantes)

---

## 🎯 Próximos Passos Imediatos

### Para começar AGORA:

1. **Validar estrutura de banco de dados**
   - Revisar relacionamentos
   - Adicionar campos faltantes
   - Otimizar indexes

2. **Criar wireframes detalhados**
   - Todas as telas principais
   - Fluxos de usuário
   - Estados de erro/loading

3. **Setup do ambiente**
   - Criar projeto Supabase
   - Configurar tabelas
   - Setup de autenticação
   - Testar integrações básicas

4. **Desenvolver MVP mínimo**
   - Login/registro
   - Dashboard básico
   - Agente de IA simples
   - CRM essencial

5. **Beta testing**
   - 10-20 usuários beta
   - Feedback loop
   - Iterar rapidamente

---

## 📝 Conclusão

Este documento apresenta a visão completa do **DirectFlow AI v3.0** - uma plataforma SaaS robusta, escalável e inovadora para automação de atendimento no Instagram.

O sistema combina o melhor de dois mundos:
- ✨ **Agentes de IA** para conversas naturais e inteligentes
- 🎨 **Fluxos Visuais** para controle total e customização

Com foco em:
- 🚀 **Velocidade** de implementação
- 💰 **Monetização** clara
- 📈 **Escalabilidade** técnica e de negócio
- 🎯 **UX/UI** de classe mundial
- 🔐 **Segurança** e compliance

**O mercado está maduro. A tecnologia está pronta. É hora de construir! 🚀**

---

### Contato para Desenvolvimento

Precisa de ajuda para implementar? Posso auxiliar em:
- Arquitetura técnica detalhada
- Code review
- Setup de infraestrutura
- Integração de APIs
- Otimização de performance
- Mentoria de desenvolvimento

**Let's build something amazing! 💪**
