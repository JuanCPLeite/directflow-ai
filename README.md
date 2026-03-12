# InstaFlow AI

Rebuild greenfield da plataforma SaaS de automação de Instagram com agentes de IA, CRM, inbox, analytics, flows e billing. A implementação atual segue os artefatos em `docs/` e o workflow em `.planning/`, não a shell antiga do projeto.

## Fonte de verdade

- Produto: `docs/PRODUTO.md`
- Features: `docs/FEATURES.md`
- Arquitetura: `docs/ARCHITECTURE.md`
- Banco: `docs/SCHEMA.md`
- Roadmap de execução: `.planning/ROADMAP.md`

## Estado atual

O repositório está em **Phase 1: Foundation and Platform Setup**. Nesta etapa a base antiga está sendo removida para abrir caminho a uma estrutura nova, alinhada ao roadmap completo.

## Stack base

- Frontend: React + TypeScript + Vite + Tailwind CSS
- Backend: Supabase (Auth, Postgres, Storage, Realtime, Edge Functions)
- Estado local: Zustand
- Rotas: React Router
- Formulários: React Hook Form + Zod

## Rodando localmente

```bash
npm install
npm run dev -- --port 8081
```

App local: `http://localhost:8081`

## Variáveis de ambiente

Use `.env.example` como contrato inicial e copie para `.env.local`.

Frontend:

- `VITE_APP_NAME`
- `VITE_APP_URL`
- `VITE_SUPABASE_URL`
- `VITE_SUPABASE_ANON_KEY`
- `VITE_META_APP_ID`
- `VITE_STRIPE_PUBLISHABLE_KEY`
- `VITE_SENTRY_DSN`

Secrets server-side ficam fora do frontend e serão usados nas fases de Edge Functions e integrações.

## Pastas preservadas

- `docs/` mantém o desenho original e detalhado do produto
- `documentos_originais/` permanece intacta
- `.planning/` guarda o fluxo GSD, requisitos e roadmap executável
- `database/` e `src/types/database.ts` ficam como referência de domínio/Supabase

## GitHub

Remote atual:

- `origin` → `https://github.com/JuanCPLeite/directflow-ai.git`
