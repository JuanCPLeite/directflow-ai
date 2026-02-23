# DirectFlow AI — Banco de Dados

## Estrutura de Arquivos

```
database/
├── 001_schema.sql        → Tabelas, indexes e triggers
├── 002_rls_policies.sql  → Políticas de segurança (RLS)
└── README.md             → Este arquivo
```

## Como executar

1. Acesse [supabase.com](https://supabase.com) e abra seu projeto
2. Vá em **SQL Editor** (menu lateral)
3. Execute os arquivos **na ordem numerada**:
   - Primeiro: `001_schema.sql`
   - Depois: `002_rls_policies.sql`

## Tabelas criadas

| # | Tabela | Descrição |
|---|--------|-----------|
| 1 | `profiles` | Perfis de usuário (complementa auth.users) |
| 2 | `agents` | Agentes de IA configurados |
| 3 | `knowledge_base` | Documentos e fontes de conhecimento |
| 4 | `pipeline_stages` | Etapas do funil Kanban |
| 5 | `leads` | Contatos e leads do CRM |
| 6 | `tags` | Etiquetas para organizar leads |
| 7 | `lead_tags` | Relação N:N leads ↔ tags |
| 8 | `flows` | Fluxos de automação visuais |
| 9 | `keywords` | Palavras-chave para auto-respostas |
| 10 | `conversations` | Histórico de conversas |
| 11 | `messages` | Mensagens individuais |
| 12 | `broadcasts` | Campanhas em massa |
| 13 | `integrations` | Integrações externas |
| 14 | `analytics_events` | Eventos para analytics |

## Histórico de Alterações

| Versão | Data | Descrição |
|--------|------|-----------|
| 1.0.0 | 2026-02-23 | Schema inicial com 14 tabelas + RLS |
