# DirectFlow AI v3.0

Plataforma SaaS completa para automação de atendimento no Instagram usando Inteligência Artificial.

## Stack

- **Frontend:** React 18 + TypeScript + Vite + Tailwind CSS + shadcn/ui
- **Backend:** Supabase (PostgreSQL + Auth + Edge Functions + Storage + pgvector)
- **Estado:** Zustand
- **Rotas:** React Router v6
- **Formulários:** React Hook Form + Zod
- **Gráficos:** Recharts
- **Animações:** Framer Motion

## Pré-requisitos

- Node.js 18+
- Conta no [Supabase](https://supabase.com)

## Instalação

```bash
# Clonar o repositório
git clone https://github.com/JuanCPLeite/directflow-ai.git
cd directflow-ai

# Instalar dependências
npm install

# Configurar variáveis de ambiente
cp .env.example .env
# Edite o .env com suas credenciais do Supabase

# Configurar banco de dados
# Execute os arquivos em /database na ordem:
# 1. database/001_schema.sql
# 2. database/002_rls_policies.sql

# Iniciar servidor de desenvolvimento
npm run dev
```

## Banco de Dados

Arquivos em `/database/`:

| Arquivo | Descrição |
|---------|-----------|
| `001_schema.sql` | Tabelas, indexes, triggers |
| `002_rls_policies.sql` | Políticas de segurança (RLS) |

## Módulos

| # | Módulo | Status |
|---|--------|--------|
| 1 | Autenticação (login, registro) | ✅ Implementado |
| 2 | Dashboard com métricas | 🔄 Em desenvolvimento |
| 3 | Agentes de IA + Base de Conhecimento | 📋 Planejado |
| 4 | CRM + Kanban + Tags | 📋 Planejado |
| 5 | Keywords + Auto-input | 📋 Planejado |
| 6 | Editor Visual de Fluxos | 📋 Planejado |
| 7 | Broadcasts e Campanhas | 📋 Planejado |
| 8 | Analytics e Relatórios | 📋 Planejado |
| 9 | Live Chat + Caixa de Entrada | 📋 Planejado |
| 10 | Pagamentos + Integrações | 📋 Planejado |
| 11 | Equipe + Gamificação | 📋 Planejado |

## Histórico de Versões

| Versão | Data | Descrição |
|--------|------|-----------|
| 0.1.0 | 2026-02-23 | Setup inicial: React + TypeScript + Supabase + Auth |
