# InstaFlow AI — Documentação de Features

> Versão: 1.0
> Produto: InstaFlow AI
> Mercado: Brasil
> Stack: React + TypeScript + Vite + Supabase + Meta Graph API
> Atualizado em: 2026-03-11

---

## Visão Geral do Produto

InstaFlow AI é um SaaS multi-usuário para automação de Instagram com agentes de inteligência artificial. Permite que empreendedores, infoprodutores, e-commerces e agências automatizem conversas no Instagram Direct, qualifiquem leads, gerenciem pipelines de vendas e esclem o atendimento sem perder o toque humanizado.

---

## FEATURE 1: Sistema de Trial (3 dias)

### O que é

O trial é um periodo de avaliacao gratuita de 3 dias que todo novo usuario recebe ao criar uma conta no InstaFlow AI. Durante o trial, o usuario tem acesso completo a todas as funcionalidades da plataforma, sem restricoes de uso e sem necessidade de informar cartao de credito.

### Como funciona (passo a passo do usuario)

1. Usuario acessa `app.instaflow.com.br/register`
2. Preenche nome, email e senha
3. Confirma email via link enviado automaticamente
4. Ao fazer o primeiro login, o trial e ativado automaticamente
5. Um banner persistente no topo da aplicacao exibe: "Seu trial expira em X dias, Y horas e Z minutos"
6. O contador e atualizado em tempo real via Supabase Realtime
7. O usuario pode usar TODAS as funcionalidades normalmente

### Regras de Negocio

- `trial_starts_at`: timestamp do primeiro login apos confirmacao de email
- `trial_ends_at`: `trial_starts_at + 3 dias`
- O trial e baseado em dias completos de 24 horas, nao em dias do calendario
- Exemplo: registro as 23h de segunda → expira as 23h de quinta
- Nao e possivel pausar o trial
- Nao e possivel reiniciar o trial (exceto via admin)
- Assinar durante o trial cancela o trial imediatamente e ativa o plano pago
- A data de renovacao do plano e calculada a partir da data de assinatura, nao do trial

### Contador Regressivo

- Visivel em todas as telas da plataforma (banner no topo)
- Formato: `"Trial expira em 2d 14h 32m"`
- Quando restam menos de 24h: contador fica vermelho e pulsa
- Quando restam menos de 6h: notificacao toast a cada hora
- O banner tem um botao "Assinar agora" que abre o modal de planos

### Comunicacoes Automaticas por Email

**D-2 (1 dia antes do fim do trial):**
- Assunto: "Seu trial InstaFlow AI expira amanha — o que voce acha?"
- Conteudo: resumo do que o usuario fez durante o trial (leads criados, mensagens enviadas, agentes configurados), CTA para assinar

**D-0 (no momento da expiracao):**
- Assunto: "Seu trial expirou — continue automatizando seu Instagram"
- Conteudo: urgencia, oferta de 10% de desconto para assinar nas proximas 48h (cupom automatico `TRIAL10`)

**D+3 (3 dias apos expirar sem assinar):**
- Assunto: "Nao perca o que voce construiu no InstaFlow AI"
- Conteudo: leads e dados ficam salvos por 30 dias, depois sao deletados

### Tela de Bloqueio Apos Expiracao

- Ao tentar acessar qualquer rota autenticada apos o trial expirar, o usuario e redirecionado para `/trial-expired`
- A tela exibe:
  - Mensagem de "Seu trial expirou"
  - Resumo do que foi criado durante o trial (leads, agentes, fluxos)
  - Contagem regressiva de 48h para o cupom de desconto expirar
  - Os 3 planos disponiveis com destaque no plano Pro
  - Botao "Ver planos e assinar" abrindo checkout do Stripe

### Extensao Manual de Trial (Admin)

- Administradores da plataforma podem acessar o painel admin em `/admin/users`
- Buscar usuario por email
- Clicar em "Extender trial"
- Escolher +1, +3 ou +7 dias
- O campo `trial_ends_at` e atualizado no banco
- O usuario recebe email notificando a extensao
- Limite: cada usuario pode ter no maximo 2 extensoes manuais

### Edge Cases

- Usuario deleta conta durante trial: dados removidos imediatamente
- Usuario tenta criar nova conta com mesmo email apos trial expirar: nao permitido, mostrar "Conta ja existe, faca login para ver planos"
- Usuario assina e depois cancela dentro do trial: volta para tela de bloqueio ao final do periodo pago (sem novo trial)
- Problemas com email de confirmacao: usuario pode reenviar o email ate 3 vezes; apos isso, deve aguardar 24h

---

## FEATURE 2: Meta OAuth / Conexao Instagram

### O que e

Integracao com a Meta Graph API que permite ao InstaFlow AI enviar e receber mensagens, comentarios e story replies em nome do usuario. A conexao e feita via OAuth 2.0 com a Meta e requer uma conta Instagram Business ou Creator vinculada a uma Pagina do Facebook.

### Requisitos Pre-Conexao

- Conta Instagram do tipo **Business** ou **Creator** (pessoal nao funciona)
- A conta Instagram deve estar **vinculada a uma Pagina do Facebook**
- O usuario deve ser **administrador** da Pagina do Facebook
- A Pagina do Facebook deve ter o **Instagram conectado** nas configuracoes

### Fluxo de Autorizacao Detalhado

1. Usuario acessa `Configuracoes > Contas Instagram > Conectar conta`
2. Sistema exibe requisitos (conta Business, Pagina vinculada)
3. Usuario clica em "Conectar com o Facebook"
4. Popup abre com a tela de login do Facebook (OAuth redirect)
5. Usuario faz login no Facebook (ou ja esta logado)
6. Meta exibe a tela de permissoes solicitadas
7. Usuario seleciona a Pagina do Facebook que quer conectar
8. Usuario confirma as permissoes
9. Meta redireciona para `callback URL` com `code` de autorizacao
10. Edge Function troca o `code` por `access_token` de curta duracao
11. Edge Function troca por `long_lived_token` (validade: 60 dias)
12. Token e criptografado com AES-256-GCM e salvo no banco
13. Sistema busca as contas Instagram associadas a Pagina
14. Usuario seleciona qual conta Instagram vincular (se houver mais de uma)
15. Conexao confirmada, usuario redirecionado ao dashboard

### Permissoes Solicitadas e Por Que

| Permissao | Por que e necessaria |
|---|---|
| `instagram_basic` | Ler perfil, seguidores, bio da conta |
| `instagram_manage_messages` | Enviar e receber DMs |
| `instagram_manage_comments` | Ler e responder comentarios |
| `pages_show_list` | Listar paginas do usuario |
| `pages_read_engagement` | Ler metricas da pagina |
| `pages_messaging` | Enviar mensagens via Pagina do Facebook |
| `business_management` | Necessario para permissoes avancadas |

### Refresh Automatico de Tokens

- Tokens de longa duracao expiram em 60 dias
- Um cron job roda diariamente as 03h (horario de Brasilia)
- Verifica tokens que expiram nos proximos 10 dias
- Chama `GET /oauth/access_token?grant_type=fb_exchange_token` para renovar
- Atualiza o token criptografado no banco
- Se renovacao falhar: notifica usuario por email e no dashboard

### Revogacao de Acesso

**Se o usuario revogar no Facebook/Instagram:**
- Webhook da Meta envia evento `deauthorize`
- Sistema marca a conta como `status: 'disconnected'`
- Agentes deixam de funcionar para essa conta
- Usuario recebe notificacao no app e por email
- Dados historicos (leads, conversas) sao mantidos

**Se o usuario desconectar pelo InstaFlow AI:**
- Sistema chama `DELETE /oauth/revoke` na Meta API
- Token e removido do banco
- Leads e conversas existentes sao mantidos
- Usuario pode reconectar a qualquer momento

### Multiplas Contas Instagram

- Um usuario pode conectar multiplas contas conforme o plano
- Cada conta tem seu proprio token, configuracoes de agente e fluxos
- O dashboard principal mostra uma seletora de conta no topo
- Leads e conversas sao isolados por conta Instagram
- Broadcasts e fluxos pertencem a uma conta especifica

### Edge Cases

- Conta Instagram desconectada do Facebook apos autorizacao: token invalido, sistema detecta na proxima tentativa de uso e notifica usuario
- Permissoes parcialmente concedidas: sistema verifica quais permissoes estao faltando e exibe aviso especifico ("Voce nao concedeu permissao para mensagens")
- Conta Instagram convertida de Business para pessoal: token deixa de funcionar, usuario deve converter de volta
- Limite de contas por plano atingido: botao "Conectar" fica desabilitado com tooltip explicativo

---

## FEATURE 3: Agentes de IA

### O que e

Os agentes de IA sao bots conversacionais configurados pelo usuario que respondem automaticamente as mensagens recebidas no Instagram. Cada agente tem sua propria personalidade, instrucoes, base de conhecimento e configuracoes de modelo de IA. Um usuario pode ter multiplos agentes para diferentes propositos (vendas, suporte, qualificacao de leads).

### Como Funciona

1. Usuario acessa `Agentes > Criar agente`
2. Define nome, descricao e proposito do agente
3. Escolhe o modelo de IA
4. Escreve o prompt do sistema (instrucoes de personalidade e comportamento)
5. Associa uma base de conhecimento (opcional)
6. Configura parametros avancados (temperatura, delay, limite de mensagens)
7. Ativa o agente
8. A partir desse momento, mensagens recebidas no Instagram sao processadas pelo agente

### Agente Padrao

- Apenas um agente pode ser marcado como "padrao" por conta Instagram
- O agente padrao e usado quando nenhum fluxo especifico define qual agente usar
- Pode ser trocado a qualquer momento sem interrupcao
- O sistema guarda historico de qual agente respondeu cada mensagem

### Modelos de IA Disponiveis

#### OpenAI
| Modelo | Velocidade | Custo | Disponivel em |
|---|---|---|---|
| gpt-4o-mini | Rapido | Baixo | Starter, Pro, Business |
| gpt-4o | Medio | Medio | Pro, Business |
| o3-mini | Lento | Alto | Business |

#### Anthropic
| Modelo | Velocidade | Custo | Disponivel em |
|---|---|---|---|
| claude-haiku-4-5 | Muito rapido | Muito baixo | Starter, Pro, Business |
| claude-sonnet-4-6 | Medio | Medio | Pro, Business |
| claude-opus-4-6 | Lento | Alto | Business |

#### Google
| Modelo | Velocidade | Custo | Disponivel em |
|---|---|---|---|
| gemini-2.0-flash | Muito rapido | Baixo | Starter, Pro, Business |
| gemini-2.5-flash | Rapido | Medio | Pro, Business |
| gemini-2.5-pro | Medio | Alto | Business |

### Parametros de Configuracao

#### Temperatura (0.0 — 2.0)
- `0.0 — 0.3`: Respostas muito consistentes e conservadoras (bom para suporte tecnico, FAQs)
- `0.4 — 0.7`: Balanco entre consistencia e criatividade (padrao recomendado: 0.5)
- `0.8 — 1.2`: Respostas mais variadas e criativas (bom para conversas casuais)
- `1.3 — 2.0`: Alta variabilidade, respostas imprevissiveis (nao recomendado para producao)

#### Delay de Resposta
- Simula o tempo de digitacao humana para nao parecer um bot
- Opcoes: Imediato, 5s, 10s, 15s, 30s, 1min
- Delay inteligente: calcula tempo baseado no tamanho da resposta (recomendado)
  - Formula: `max(3s, min(30s, len(resposta) * 0.05))`

#### Limite de Mensagens por Conversa
- Define quantas trocas de mensagens o agente faz antes de escalar para humano
- Opcoes: 5, 10, 20, 50, Ilimitado
- Ao atingir o limite: o agente envia mensagem configuravel de handover e para de responder
- A conversa aparece na caixa de entrada marcada como "Aguardando humano"

#### Max Tokens por Resposta
- Controla o tamanho maximo das respostas do agente
- Opcoes: 150 (curto), 300 (medio), 600 (longo), 1000 (muito longo)
- Respostas longas sao automaticamente divididas em multiplas mensagens

### Prompt do Sistema

- Campo de texto com suporte a Markdown
- Variaveis disponiveis no prompt: `{{contact_name}}`, `{{instagram_username}}`, `{{current_date}}`, `{{current_time}}`, `{{plan_name}}`
- Limite: 4.000 tokens
- O sistema instrui automaticamente o agente a responder em portugues caso nao especificado
- Bloco de contexto da base de conhecimento e injetado apos o prompt do sistema

### Debug Mode

- Disponivel apenas em planos Pro e Business
- Quando ativado, cada resposta do agente vem acompanhada de um card lateral (visivel apenas para o operador, nao para o lead)
- O card exibe:
  - Modelo usado e temperatura
  - Tokens consumidos (prompt + completion)
  - Chunks da KB usados com score de similaridade
  - Tempo de processamento em ms
  - Custo estimado em USD

### Edge Cases

- Limite de agentes por plano atingido: botao "Criar agente" fica desabilitado
- Modelo selecionado indisponivel momentaneamente: sistema usa modelo fallback configurado
- Agente sem prompt do sistema: alerta de aviso, sistema usa prompt padrao generico
- Mensagem recebida em idioma diferente do portugues: agente responde no mesmo idioma da mensagem (comportamento padrao, pode ser sobrescrito no prompt)

---

## FEATURE 4: Base de Conhecimento e Embeddings

### O que e

A base de conhecimento (KB) permite que o usuario carregue documentos PDF que o agente de IA usa como referencia para responder perguntas. O sistema processa os documentos, gera embeddings semanticos e armazena tudo no banco vetorial (pgvector). Quando uma mensagem chega, o sistema busca os trechos mais relevantes e os injeta no contexto do agente.

### Formatos Suportados

- PDF (principal)
- TXT (texto puro)
- DOCX (Word)
- MD (Markdown)
- URL de pagina web (scraping automatico)

### Processamento de PDF

1. Usuario faz upload do PDF (limite: 50MB por arquivo)
2. Edge Function extrai o texto pagina por pagina usando `pdf-parse`
3. Texto e limpo: removidas cabecalhos, rodapes repetitivos, caracteres especiais
4. Texto e dividido em chunks de 500 tokens com 50 tokens de overlap
   - Overlap garante que informacoes no limite de um chunk nao sejam perdidas
5. Para cada chunk e gerado um embedding usando `text-embedding-3-small` da OpenAI
   - Dimensoes: 1536
   - Custo: ~$0.00002 por 1000 tokens
6. Chunks e embeddings sao salvos na tabela `kb_chunks` com pgvector
7. Status de processamento e atualizado em tempo real via Supabase Realtime
8. Usuario recebe notificacao quando processamento e concluido

### Busca Semantica

Quando o agente recebe uma mensagem:

1. Embedding e gerado para a mensagem do usuario (mesma dimensao: 1536)
2. Query pgvector: `SELECT *, 1 - (embedding <=> query_embedding) as similarity FROM kb_chunks WHERE agent_id = $1 AND similarity >= 0.7 ORDER BY similarity DESC LIMIT 5`
3. Os top-5 chunks mais relevantes sao selecionados
4. Chunks sao montados em um bloco de contexto:
   ```
   CONTEXTO RELEVANTE DA BASE DE CONHECIMENTO:
   [Chunk 1 - Similaridade: 0.92] "..."
   [Chunk 2 - Similaridade: 0.87] "..."
   ...
   Use estas informacoes para responder a pergunta do usuario.
   ```
5. Bloco e injetado no prompt antes do historico da conversa

### Configuracoes da KB

| Parametro | Padrao | Range | Descricao |
|---|---|---|---|
| Similarity threshold | 0.7 | 0.5 — 0.95 | Score minimo para considerar chunk relevante |
| Max chunks | 5 | 1 — 10 | Numero de chunks injetados no contexto |
| Chunk size | 500 | 200 — 1000 | Tokens por chunk |
| Chunk overlap | 50 | 0 — 200 | Tokens de sobreposicao entre chunks |

### Limite de Documentos por Plano

| Plano | Documentos | Tamanho Total |
|---|---|---|
| Trial | 3 | 15 MB |
| Starter | 10 | 50 MB |
| Pro | 50 | 500 MB |
| Business | Ilimitado | 5 GB |

### Edge Cases

- PDF com imagens sem texto (scan): sistema detecta ausencia de texto e avisa usuario para usar um PDF com texto selecionavel
- PDF com senha: nao suportado, usuario deve remover a senha antes do upload
- Documento duplicado: sistema calcula hash do arquivo, se ja existir avisa usuario
- Falha no processamento: arquivo marcado como `status: 'error'`, usuario pode tentar reprocessar
- URL com conteudo dinamico (JavaScript): scraping pode ser incompleto, sistema avisa

---

## FEATURE 5: Flow Builder

### O que e

O Flow Builder e um editor visual de fluxos de automacao estilo kanban/node-based. O usuario monta sequencias de acoes que sao executadas automaticamente quando um lead entra no fluxo. E possivel criar fluxos de nurturing, qualificacao, vendas, onboarding e reativacao.

### Interface

- Editor visual com canvas de arrastar e soltar (react-flow)
- Sidebar esquerda com lista de nos disponiveis
- Painel direito com configuracoes do no selecionado
- Botao de teste: executa o fluxo com um lead ficticio
- Historico de versoes: ultimas 10 versoes salvas automaticamente

### Nos Disponiveis

#### No de Entrada (Trigger)
- **Keyword**: Acionado quando lead envia palavra-chave especifica
- **Tag adicionada**: Acionado quando tag especifica e adicionada ao lead
- **Etapa do CRM**: Acionado quando lead muda de etapa
- **Novo lead**: Acionado quando lead e criado
- **Broadcast recebido**: Acionado quando lead recebe um broadcast
- **Comentario em post**: Acionado quando lead comenta em post especifico

#### No de Mensagem
- Envia uma mensagem de texto para o lead
- Suporte a texto rico com emojis
- Variaveis: `{{nome}}`, `{{instagram_username}}`, `{{etapa}}`, `{{tags}}`, `{{ultimo_produto_visto}}`, `{{data}}`, `{{hora}}`
- Limite: 1000 caracteres por mensagem
- Pode enviar imagem, video ou arquivo junto (URL ou upload)

#### No de Delay
- Pausa a execucao do fluxo por um periodo
- Opcoes: minutos (5, 10, 15, 30, 45), horas (1, 2, 4, 6, 12, 24), dias (1, 2, 3, 5, 7, 14, 30)
- Lead fica em estado `waiting` durante o delay
- Se fluxo for desativado durante o delay, lead e marcado como `paused`
- Opcao "Enviar no melhor horario": usa analytics para agendar no horario de maior engajamento do lead

#### No de Condicao (IF/ELSE)
Verifica uma condicao e direciona o lead para um caminho ou outro.

Campos que podem ser verificados:
- `tags`: contém, nao contém, está vazia
- `etapa_crm`: igual a, diferente de
- `ultima_mensagem`: contém texto, nao contem texto
- `lead_score`: maior que, menor que, igual a
- `numero_de_mensagens`: maior que, menor que
- `data_de_criacao`: antes de, depois de, ha X dias
- `campo_customizado`: qualquer campo customizado do CRM
- `ultimo_broadcast_aberto`: sim, nao
- `horario_atual`: entre (ex: entre 09h e 18h)

#### No de Acao
- **Adicionar tag**: adiciona uma ou mais tags ao lead
- **Remover tag**: remove uma ou mais tags
- **Mudar etapa**: move lead para etapa do CRM
- **Atribuir a membro**: atribui conversa para membro da equipe
- **Adicionar nota**: cria nota interna no lead
- **Atualizar campo**: atualiza campo customizado do lead
- **Adicionar XP**: adiciona pontos de gamificacao (apenas para membros da equipe)

#### No de Agente de IA
- Ativa o agente de IA para responder as proximas mensagens do lead
- Escolhe qual agente usar (ou padrao)
- Define por quanto tempo o agente fica ativo (em mensagens ou em minutos)
- Pode definir objetivo: "qualificar lead", "fechar venda", "suporte"
- Quando o objetivo e atingido (detectado por keyword ou acao), fluxo continua

#### No de A/B Test
- Divide o fluxo em dois caminhos (A e B)
- Percentual padrao: 50% / 50% (configuravel)
- Cada caminho pode ter acoes diferentes
- Metricas de conversao sao rastreadas por caminho
- Apos periodo de teste, vencedor pode ser selecionado manualmente

#### No de Webhooks
- Envia dados para URL externa via POST
- Payload personalizavel com variaveis do lead
- Headers personalizaveis
- Retry automatico em caso de falha (3 tentativas com backoff exponencial)
- Disponivel apenas em planos Pro e Business

#### No de Fim
- Marca o fluxo como concluido para o lead
- Opcao: adicionar tag "fluxo_concluido_{nome_do_fluxo}" automaticamente

### Variaveis Disponiveis

| Variavel | Descricao | Exemplo |
|---|---|---|
| `{{nome}}` | Primeiro nome do lead | "Maria" |
| `{{nome_completo}}` | Nome completo | "Maria Silva" |
| `{{instagram_username}}` | @ do Instagram | "@mariasilva" |
| `{{etapa}}` | Etapa atual no CRM | "Qualificado" |
| `{{tags}}` | Lista de tags | "cliente_vip, interessado" |
| `{{ultimo_produto_visto}}` | Ultimo produto acessado | "Curso de Marketing" |
| `{{data}}` | Data atual | "11/03/2026" |
| `{{hora}}` | Hora atual | "14:32" |
| `{{lead_score}}` | Pontuacao do lead | "72" |
| `{{dias_como_lead}}` | Dias desde criacao | "5" |
| `{{campo_customizado.nome_do_campo}}` | Campo customizado | "Sao Paulo" |

### Regras Anti-Loop

- Um lead so pode entrar no mesmo fluxo uma vez a cada 24h (configuravel)
- Limite maximo de nos que um lead pode percorrer em um unico fluxo: 100
- Se loop e detectado (lead voltar para no ja visitado na mesma execucao): fluxo e interrompido e erro e logado
- Sistema detecta fluxos com loops obvios no editor e exibe aviso

### Lead em Um Unico Fluxo

- Um lead so pode estar ativo em um fluxo por vez
- Se lead entrar em novo fluxo enquanto esta em outro: comportamento configuravel
  - "Manter no fluxo atual" (padrao)
  - "Migrar para novo fluxo"
  - "Enfileirar: entrar no novo apos concluir o atual"

### Desativacao de Fluxo com Leads Ativos

- Ao desativar um fluxo com leads em espera (em delay), o sistema pergunta:
  - "Pausar leads: eles continuam do ponto que estavam ao reativar"
  - "Remover leads: leads sao removidos do fluxo sem executar proximas acoes"
  - "Concluir leads: leads pulam para o No de Fim imediatamente"

### Edge Cases

- No de mensagem com variavel nao preenchida (`{{nome}}` em lead sem nome): exibido como "voce" por padrao (configuravel)
- Fluxo sem No de Fim: aviso visual no editor, fluxo salvo mas com alerta
- Fluxo com No de Entrada desconectado: ativado manualmente via CRM ou nao ativa automaticamente

---

## FEATURE 6: Palavras-chave e Auto-Input

### O que e

O sistema de palavras-chave monitora mensagens recebidas no Instagram (DMs, comentarios e story replies) e aciona acoes automaticas quando um termo especifico e detectado. O Auto-Input e o fluxo especifico acionado quando um comentario em um post e detectado, que automaticamente inicia uma conversa via DM.

### Tipos de Palavras-chave

- **Exata**: a mensagem deve ser exatamente aquela palavra
- **Contém**: a mensagem deve conter a palavra em qualquer posicao
- **Comeca com**: a mensagem deve comecar com o termo
- **Regex**: expressao regular para padroes complexos

### Exemplos Praticos de Regex

```regex
# Capturar qualquer variacao de "quero" + produto
/(quero|desejo|preciso).*(info|detalhes|saber|comprar)/i

# Capturar numeros de telefone brasileiros
/(\+55\s?)?\(?\d{2}\)?\s?\d{4,5}[\s-]?\d{4}/

# Capturar email
/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/

# Capturar CPF
/\d{3}[\.\s]?\d{3}[\.\s]?\d{3}[\-\s]?\d{2}/
```

### Sistema de Prioridade

- Cada keyword tem uma prioridade de 1 (mais alta) a 100 (mais baixa)
- Se uma mensagem faz match com multiplas keywords, apenas a de maior prioridade (menor numero) e acionada
- Em caso de empate de prioridade, a keyword mais recente (maior `created_at`) vence
- Exemplo:
  - Keyword "CURSO" prioridade 10 → aciona Fluxo A
  - Keyword "CURSO DE MARKETING" prioridade 5 → aciona Fluxo B
  - Mensagem "QUERO O CURSO DE MARKETING" → aciona Fluxo B (prioridade 5 > 10)

### Delay Entre Deteccao e Resposta

- Configuravel por keyword: 0s, 5s, 15s, 30s, 1min, 2min, 5min
- Objetivo: evitar parecer um bot respondendo instantaneamente
- Durante o delay, a conversa fica marcada como "digitando" (typing indicator)

### Limite de Usos por Lead

- Configuravel por keyword: 1x, 3x, 5x, Ilimitado
- Objetivo: evitar que o mesmo lead acione a mesma keyword infinitas vezes
- Janela de tempo: "1x por dia", "1x por semana", "1x no total" (configuravel)
- Exemplo: keyword "PRECO" com limite "1x por dia" → lead que perguntar preco varias vezes na mesma conversa so recebe a resposta automatica uma vez por dia

### Horario de Funcionamento

- Opcao de definir horario de funcionamento para cada keyword
- Exemplo: keyword so funciona de segunda a sexta, das 09h as 18h (horario de Brasilia)
- Fora do horario: keyword nao e acionada, lead fica sem resposta automatica
- Opcao alternativa: fora do horario, enviar mensagem configuravel ("Nosso horario e 9h-18h, responderemos em breve!")

### Diferenca por Canal

| Canal | Comportamento |
|---|---|
| DM (Direct Message) | Keyword detectada na mensagem do lead, resposta enviada na mesma conversa |
| Comentario em post | Keyword detectada no comentario, DM enviado automaticamente (Auto-Input), comentario pode ser curtido automaticamente |
| Story Reply | Keyword detectada na resposta ao story, resposta enviada no DM |
| Mention | Keyword detectada quando conta e mencionada em post/story |

### Como o Auto-Input Funciona (Fluxo Completo)

O Auto-Input e o caso especifico de keyword em **comentarios em posts**.

1. **Publicacao**: usuario publica post no Instagram e cadastra o Post ID no InstaFlow AI com uma keyword (ex: "QUERO")
2. **Comentario**: lead comenta "QUERO" no post
3. **Webhook recebido**: Meta envia webhook `instagram.comments.create` para InstaFlow AI
4. **Verificacao**: sistema verifica se o comentario contem a keyword configurada
5. **Rate limiting**: verifica se o lead ja recebeu esta resposta hoje (limite de usos)
6. **Busca ou criacao de lead**: verifica se o Instagram do lead ja existe no CRM; se nao, cria
7. **Abertura de DM**: sistema abre uma nova conversa DM com o lead
8. **Envio de mensagem inicial**: envia a mensagem configurada na keyword (ex: "Oi {{nome}}! Vi que voce se interessou no post. Manda uma mensagem para eu te enviar todos os detalhes!")
9. **Adicao de tag**: adiciona tags configuradas (ex: `interessado`, `comentou_post_X`)
10. **Mudanca de etapa no CRM**: lead e movido para a etapa configurada (ex: "Interessado")
11. **Ativacao de fluxo**: se um fluxo estiver configurado, lead entra no fluxo a partir deste momento
12. **Curtida no comentario** (opcional): sistema curte o comentario automaticamente para mostrar que foi visto

### Edge Cases

- Lead com conta privada que comenta: DM ainda pode ser enviado, pois e em resposta a uma interacao
- Mesmo lead comenta multiplas vezes: limite de usos controla
- Post deletado pelo usuario do InstaFlow AI: webhook continua chegando, sistema ignora (post nao cadastrado mais)
- Instagram do lead sem DM habilitado: erro 400 da Meta API, lead e marcado com tag `dm_bloqueado`, operador e notificado

---

## FEATURE 7: CRM e Kanban

### O que e

O CRM (Customer Relationship Management) do InstaFlow AI e um sistema de gestao de leads integrado ao Instagram. Visualiza leads em um board Kanban com etapas customizaveis, acompanha o historico de interacoes, gerencia tags e permite automacoes baseadas em mudancas de etapa.

### Etapas do Kanban

- Etapas padrao: Novo, Qualificado, Proposta, Negociacao, Ganho, Perdido
- Usuario pode criar, editar, reordenar e deletar etapas
- Limite de etapas: 20
- Cada etapa tem: nome, cor, automacoes configuradas

### Lead Scoring

O score de um lead vai de 0 a 100 e e calculado automaticamente com base em:

| Acao | Pontos |
|---|---|
| Lead criado | +5 |
| Enviou mensagem | +3 |
| Respondeu a mensagem | +5 |
| Clicou em link | +10 |
| Respondeu a broadcast | +8 |
| Visitou produto (via UTM) | +15 |
| Tempo sem interacao 3 dias | -5 |
| Tempo sem interacao 7 dias | -10 |
| Sentimento negativo detectado | -20 |
| Tag "churn_risk" adicionada | -30 |

O score e recalculado em tempo real a cada evento. Score acima de 70 indica lead quente.

### Automacoes de Etapa

Ao mover lead para uma etapa, pode-se configurar:
- Adicionar/remover tags automaticamente
- Enviar mensagem automatica
- Acionar fluxo de automacao
- Atribuir a membro da equipe
- Criar tarefa de follow-up
- Adicionar nota automatica

### Importacao CSV

**Formato esperado:**
```csv
instagram_username,nome,email,telefone,etapa,tags,campo_customizado_1
@mariasil,Maria Silva,maria@email.com,11999999999,Qualificado,"cliente_vip;interessado",Sao Paulo
```

**Campos obrigatorios:** `instagram_username`

**Campos opcionais:** nome, email, telefone, etapa (deve existir), tags (separadas por `;`), campos customizados

**Processo de importacao:**
1. Upload do CSV
2. Preview das primeiras 5 linhas
3. Mapeamento de colunas (sistema tenta detectar automaticamente)
4. Validacao (duplicatas, erros de formato)
5. Importacao com relatorio: X criados, Y atualizados, Z erros

### Exportacao

**Campos exportados:**
- Dados basicos: nome, username, email, telefone
- CRM: etapa, tags, score, data de criacao, ultima interacao
- Metricas: numero de mensagens enviadas, recebidas, broadcasts recebidos/abertos
- Campos customizados
- Historico de mudancas de etapa (em arquivo separado, opcional)

**Formatos:** CSV, JSON, XLSX

### Campos Customizados

**Tipos disponiveis:**
- Texto (curto, ate 255 caracteres)
- Texto longo (ate 2000 caracteres)
- Numero (inteiro ou decimal)
- Data
- Data e hora
- Booleano (sim/nao)
- Selecao unica (dropdown)
- Selecao multipla (multiselect)
- URL
- Telefone (com mascara)
- Moeda (R$)

**Uso no Flow Builder:** campos customizados ficam disponiveis como variaveis `{{campo_customizado.nome_do_campo}}` e como condicoes no No de Condicao.

### Segmentacao

Operadores disponiveis para filtrar leads:

| Operador | Aplicavel a |
|---|---|
| igual a | texto, numero, data, selecao |
| diferente de | todos |
| contém | texto |
| nao contem | texto |
| maior que | numero, data |
| menor que | numero, data |
| entre | numero, data |
| esta em | selecao multipla, tags |
| nao esta em | selecao multipla, tags |
| esta vazio | todos |
| nao esta vazio | todos |
| nos ultimos X dias | data |
| ha mais de X dias | data |

Segmentos podem ser salvos e usados em broadcasts, fluxos e relatorios.

---

## FEATURE 8: Caixa de Entrada

### O que e

A Caixa de Entrada e a interface centralizada de atendimento onde operadores humanos visualizam e respondem conversas do Instagram. Funciona em tempo real via Supabase Realtime e e otimizada para equipes de atendimento.

### Interface

- Lista de conversas na esquerda com preview da ultima mensagem
- Area de chat no centro com historico completo
- Painel de informacoes do lead na direita (dados do CRM, tags, score, notas)
- Filtros: Todas, Aguardando humano, Minhas conversas, Nao lidas

### Priorizacao Automatica

- Leads com tag "urgente": aparecem no topo com badge vermelho
- SLA excedido: aparecem logo apos os urgentes com badge laranja
- Leads novos sem atendimento: ordenados por tempo de espera
- Conversas com humano ativo: destacadas com icone de pessoa

### SLA Tracking

- O sistema monitora ha quanto tempo cada lead esta aguardando resposta
- SLA padrao: 30 minutos (configuravel por plano e por operador)
- Indicadores:
  - Verde: dentro do SLA
  - Amarelo: 50-100% do SLA consumido
  - Vermelho: SLA excedido
- Relatorio semanal de SLA por operador

### Handover: Bot para Humano

1. Bot esta respondendo uma conversa
2. Operador clica em "Assumir conversa"
3. Bot para de responder imediatamente
4. Icone na conversa muda para o avatar do operador
5. Lead recebe mensagem configuravel: "Voce sera atendido por um de nossos especialistas em instantes!"
6. Conversa aparece na lista do operador como "Minhas conversas"

### Handover: Humano para Bot

1. Operador termina atendimento
2. Clica em "Devolver para bot"
3. Sistema gera um resumo da conversa humana automaticamente usando IA:
   - "O cliente perguntou sobre o produto X, foi informado sobre o preco e prazo. Decidiu pensar mais um pouco. Follow-up marcado para amanha."
4. Resumo e adicionado como nota interna no lead
5. Agente de IA retoma a conversa com o contexto do resumo injetado

### Typing Indicators

- Quando lead esta digitando: aparece indicador "digitando..." na area de chat
- Implementado via webhook `instagram.messaging_seen` e `instagram.messages.typing`
- Quando operador esta digitando: indicador nao e enviado para o lead (limitacao da Meta API)

### Canned Responses (Respostas Prontas)

- Banco de respostas prontas para perguntas frequentes
- Categorias: Preco, Entrega, Produto, Suporte, Saudacao
- Busca: digitar `/` na caixa de mensagem abre o seletor de respostas prontas
- Pesquisa por palavra-chave em tempo real
- Atalhos de teclado: `/preco`, `/entrega`, etc.
- Suporte a variaveis: `{{nome}}` e substituido antes do envio
- Operadores podem criar suas proprias respostas prontas
- Admins criam respostas globais para toda a equipe

### Atribuicao de Conversas

- Auto-atribuicao: sistema distribui conversas automaticamente em round-robin
- Atribuicao manual: qualquer membro pode puxar uma conversa
- Transferencia: transferir conversa para outro membro com nota opcional

---

## FEATURE 9: Broadcasts

### O que e

Broadcasts sao mensagens enviadas em massa para um segmento de leads. Diferente de spam, o sistema respeita todas as restricoes da Meta API para garantir conformidade e alta taxa de entrega.

### Restricoes da Meta API

**Regra das 24 horas:**
- A Meta API so permite enviar DMs proativos para usuarios que interagiram com a conta nas ultimas 24 horas
- "Interacao" inclui: enviar mensagem, comentar em post, responder a story, clicar em link
- Leads fora da janela de 24h ficam com status "fora da janela" e sao excluidos automaticamente do envio

**Contornando a Limitacao de 24h com Message Tags:**
A Meta permite enviar mensagens fora da janela de 24h com o uso de `message_tag`, desde que o conteudo seja especifico:
- `CONFIRMED_EVENT_UPDATE`: atualizacoes sobre eventos que o usuario se inscreveu
- `POST_PURCHASE_UPDATE`: atualizacoes sobre uma compra realizada
- `ACCOUNT_UPDATE`: alertas importantes de seguranca ou conta
- `HUMAN_AGENT`: resposta de agente humano (janela de 7 dias)

**Rate Limiting Interno:**
- O sistema nao ultrapassa 200 mensagens por segundo (limite da Meta API)
- Para broadcasts grandes, o envio e feito em filas com worker dedicado
- Estimativa de tempo de envio mostrada antes de confirmar: "Envio estimado: 45 minutos para 5.400 leads"

### Criacao de Broadcast

1. Nome do broadcast (interno)
2. Selecionar segmento de leads (ou criar filtro ad-hoc)
3. Preview: quantos leads serao atingidos, quantos estao fora da janela de 24h
4. Escolher tipo de mensagem: texto, imagem, video, carrossel
5. Redigir mensagem com suporte a variaveis
6. Configurar agendamento: agora, ou data/hora especifica
7. A/B test (opcional): criar variacao B com mensagem alternativa
8. Confirmar e agendar

### A/B Test em Broadcasts

- Definir percentual do segmento para cada versao (padrao: 50/50)
- Metricas rastreadas: taxa de entrega, taxa de leitura (read receipts), taxa de resposta, conversoes
- Apos o periodo de teste (configuravel), mostrar vencedor
- Opcao de enviar variacao vencedora para os leads que nao receberam

### Read Receipts e Metricas

- A Meta API envia webhook `messaging_seen` quando a mensagem e lida
- Metricas disponiveis por broadcast:
  - Enviados / Com erro / Fora da janela
  - Taxa de entrega (enviados / total)
  - Taxa de leitura (lidos / entregues)
  - Taxa de resposta (responderam / lidos)
  - Conversoes (leads que mudaram de etapa apos o broadcast)
  - Receita atribuida (se campo de valor estiver preenchido)

---

## FEATURE 10: Analytics Preditivo

### O que e

O modulo de analytics preditivo usa historico de dados e modelos estatisticos para prever comportamentos de leads, identificar riscos de churn, prever receita e recomendar melhores horarios de envio.

### Lead Score Preditivo

O score de 0 a 100 e calculado com os seguintes pesos:

| Fator | Peso | Como Medir |
|---|---|---|
| Recencia da ultima interacao | 30% | Score decai com o tempo: 100% se hoje, 0% se ha 30+ dias |
| Frequencia de interacoes | 25% | Numero de interacoes nos ultimos 30 dias |
| Profundidade de engajamento | 20% | Cliques em links, produtos vistos, tempo de conversa |
| Resposta a broadcasts | 15% | % de broadcasts abertos e respondidos |
| Sentimento das mensagens | 10% | Analise de sentimento via IA: positivo +10, neutro 0, negativo -20 |

### Predicao de Churn

Lead e classificado como "em risco de churn" se atender 2+ dos criterios:
- Sem interacao ha 14 ou mais dias
- Sentimento medio negativo nas ultimas 3 mensagens
- Nao abriu os ultimos 3 broadcasts
- Score caiu mais de 30 pontos em 7 dias

Acao sugerida pelo sistema para leads em risco:
- Enviar campanha de reengajamento com incentivo
- Atribuir para atendimento humano proativo
- Adicionar tag `churn_risk` para segmentacao

### Forecast de Receita

- Media movel dos ultimos 30 dias de leads convertidos
- Ajuste por sazonalidade: comparacao com mesmo periodo do ano anterior
- Confianca do forecast: baseada na consistencia historica dos dados
- Exibido no dashboard: "Previsao de receita pro mes: R$ X — Y%" (variacao vs mes anterior)

### Melhor Horario para Envio

- O sistema analisa a taxa de abertura de mensagens por hora do dia e dia da semana
- Ultimos 30 dias de dados
- Recomendacao exibida ao criar broadcast: "Melhor horario para seu publico: terca-feira as 19h"
- Opcao "Enviar no melhor horario" disponivel no agendamento

---

## FEATURE 11: Gamificacao

### O que e

O sistema de gamificacao incentiva membros da equipe a se engajarem mais com a plataforma e alcancarem resultados. Inclui sistema de XP, niveis, conquistas, desafios semanais e ranking mensal.

### XP por Acao

| Acao | XP |
|---|---|
| Responder mensagem de lead | 10 XP |
| Fechar venda (mover lead para "Ganho") | 100 XP |
| Criar agente de IA | 50 XP |
| Criar fluxo de automacao | 30 XP |
| Criar keyword | 15 XP |
| Adicionar documento a KB | 20 XP |
| Completar onboarding | 200 XP |
| Primeiro broadcast enviado | 75 XP |
| Conectar conta Instagram | 100 XP |
| Qualificar lead (mover para "Qualificado") | 25 XP |
| Adicionar campo customizado | 10 XP |
| Importar leads via CSV | 40 XP |
| Criar segmento salvo | 20 XP |
| Usar canned response | 5 XP |
| Fazer handover bot para humano | 15 XP |
| Login diario | 5 XP |
| Atingir meta de vendas do mes | 500 XP |

### Niveis (1-20)

| Nivel | Nome | XP Necessario |
|---|---|---|
| 1 | Iniciante | 0 |
| 2 | Prospector | 500 |
| 3 | Conversador | 1.500 |
| 4 | Engajador | 3.500 |
| 5 | Qualificador | 7.000 |
| 6 | Negociador | 12.000 |
| 7 | Fechador | 20.000 |
| 8 | Especialista | 32.000 |
| 9 | Estrategista | 50.000 |
| 10 | Mestre do Funil | 75.000 |
| 11 | Guru de Vendas | 110.000 |
| 12 | Automator | 155.000 |
| 13 | Visionario | 210.000 |
| 14 | Arquiteto de Leads | 280.000 |
| 15 | Maestro do CRM | 370.000 |
| 16 | Lenda do Instagram | 480.000 |
| 17 | Campeao de Conversao | 620.000 |
| 18 | Titan das Vendas | 800.000 |
| 19 | Imortal do Marketing | 1.000.000 |
| 20 | Mestre do InstaFlow | 1.500.000 |

### Conquistas (30+)

| Conquista | Condicao |
|---|---|
| Primeiro Contato | Responder primeira mensagem |
| Caçador de Leads | 100 leads no CRM |
| Mestre da Palavra | Criar 10 keywords |
| Construtor de Funis | Criar 5 fluxos |
| Guru do Conhecimento | Adicionar 10 documentos a KB |
| Relogio de Ouro | 30 dias de login consecutivo |
| Velocista | Responder lead em menos de 1 minuto |
| Vencedor Nato | Fechar 10 vendas |
| Magnata | Fechar 100 vendas |
| Rei do Instagram | Conectar 3+ contas Instagram |
| Maestro da IA | Criar 5 agentes diferentes |
| Mago dos Dados | Importar 500+ leads |
| Evangelista | Indicar 5 usuarios (programa de indicacao) |
| Madrugador | Login as 6h da manha |
| Workaholic | Login apos 22h |
| Perfeccionista | SLA 100% por 30 dias |
| Coletor de Tags | Usar 20 tags diferentes |
| Detetive | Usar 10 segmentos diferentes |
| Mensageiro | Enviar 1.000 mensagens |
| Mega Broadcast | Enviar broadcast para 1.000+ leads |
| Analista | Visualizar analytics preditivo 30 dias seguidos |
| Personalizador | Criar 20 campos customizados |
| Chef de Respostas | Criar 20 canned responses |
| Guardiao do SLA | Nenhum SLA excedido em uma semana |
| Guerreiro do Funil | Mover 50 leads de etapa em um dia |
| Ninja da Automacao | 1.000 leads processados por fluxos |
| O Incansavel | 500 horas de uso da plataforma |
| Fundador | Primeiro usuario da conta a atingir nivel 10 |
| Mentor | Treinar outro membro da equipe (usuario convidado atinge nivel 5) |
| Lendario | Atingir nivel 20 |

### Desafios Semanais (exemplos)

| Semana | Desafio | Recompensa |
|---|---|---|
| Desafio 1 | Responder 50 mensagens esta semana | 200 XP + badge "Comunicador da Semana" |
| Desafio 2 | Fechar 5 vendas em 7 dias | 500 XP + 1 mes de plano Pro (se Starter) |
| Desafio 3 | Criar um fluxo com mais de 10 nos | 150 XP + badge "Arquiteto" |
| Desafio 4 | Atingir 0 SLA excedido em todos os dias da semana | 300 XP + badge "Impecavel" |
| Desafio 5 | Mover 30 leads para a etapa "Ganho" | 1.000 XP + destaque no ranking |

### Ranking Mensal

- Calculado pela soma de XP acumulado no mes corrente
- Reseta no primeiro dia de cada mes
- Top 3 sao destacados com coroa, prata e bronze
- O vencedor (1 lugar) recebe:
  - Destaque no painel do InstaFlow AI com foto e nome
  - 1 mes do proximo plano grátis
  - Badge exclusiva "Campeao do Mes — [mes/ano]"
  - Menção em newsletter mensal para todos os usuarios da plataforma

---

## FEATURE 12: Planos e Limites

### Tabela de Planos

| Feature | Trial | Starter R$147/mes | Pro R$397/mes | Business R$997/mes |
|---|---|---|---|---|
| Duracao | 3 dias | Mensal/Anual | Mensal/Anual | Mensal/Anual |
| Mensagens/mes | 200 | 2.000 | 8.000 | 30.000 |
| Agentes de IA | 1 | 1 | 5 | Ilimitado |
| Contas Instagram | 1 | 1 | 3 | 10 |
| Leads no CRM | 100 | 1.000 | 10.000 | Ilimitado |
| Membros da equipe | 1 | 1 | 5 | 20 |
| Documentos KB | 3 | 10 | 50 | Ilimitado |
| Tamanho total KB | 15 MB | 50 MB | 500 MB | 5 GB |
| Modelos basicos de IA | Sim | Sim | Sim | Sim |
| Modelos premium de IA | Sim | Nao | Sim | Sim |
| Fluxos | 3 | 10 | Ilimitado | Ilimitado |
| Keywords | 10 | 20 | Ilimitado | Ilimitado |
| Broadcasts | Nao | 2/mes | Ilimitado | Ilimitado |
| A/B Test broadcasts | Nao | Nao | Sim | Sim |
| Campos customizados | 3 | 5 | 20 | Ilimitado |
| Segmentos salvos | 3 | 5 | Ilimitado | Ilimitado |
| Analytics basico | Sim | Sim | Sim | Sim |
| Analytics preditivo | Nao | Nao | Sim | Sim |
| Agendador de posts | Nao | Nao | Sim | Sim |
| Equipe (multiusuario) | Nao | Nao | Sim | Sim |
| Gamificacao | Nao | Nao | Sim | Sim |
| Webhooks outbound | Nao | Nao | Sim | Sim |
| Debug Mode agentes | Nao | Nao | Sim | Sim |
| API acesso | Nao | Nao | Read-only | Full |
| Suporte | Email | Email | Chat | Chat + Telefone |
| SLA garantido | Nenhum | Nenhum | Nenhum | 99.9% uptime |
| Onboarding dedicado | Nao | Nao | Nao | Sim |
| CSM dedicado | Nao | Nao | Nao | Sim |

### O Que Acontece ao Atingir Limite

**Limite de mensagens atingido:**
- Sistema para de enviar mensagens automaticas
- Conversas continuam funcionando para humanos
- Banner de aviso no dashboard: "Voce usou X% das suas mensagens este mes"
- Email enviado ao atingir 80% e 100% do limite
- Opcao de comprar pacote adicional: +1.000 mensagens por R$29

**Limite de leads atingido:**
- Novos leads nao sao criados automaticamente (via keyword, flow, etc.)
- Importacao CSV bloqueada
- Leads existentes continuam funcionando normalmente
- Alerta no dashboard

**Ciclo de faturamento:**
- Planos mensais: cobrados todo mes na data de assinatura
- Planos anuais: 2 meses gratis (equivale a 17% de desconto)
- Cobranca via Stripe (cartao de credito ou PIX)
- Nota fiscal emitida automaticamente por email

---

*Documentacao InstaFlow AI — Versao 1.0 — 2026-03-11*
