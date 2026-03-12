# Phase 1: Foundation and Platform Setup - Context

**Gathered:** 2026-03-12
**Status:** Ready for planning

<domain>
## Phase Boundary

This phase establishes the greenfield base for InstaFlow AI so later modules are built on the documented architecture instead of the legacy app skeleton. It covers repository reset decisions, frontend foundation, Supabase setup conventions, environment contracts, schema/migration strategy, shared UI/system primitives, and baseline quality tooling.

</domain>

<decisions>
## Implementation Decisions

### Greenfield baseline
- Build against the new March 2026 documentation in `docs/`, not against the current `src/` structure.
- Existing code can be reused selectively, but Phase 1 should optimize for a clean foundation rather than preserving old abstractions.
- Files and folders proven obsolete may be deleted as part of the foundation reset once replacements exist.

### Core stack
- Frontend stack remains React + TypeScript + Vite.
- Backend platform remains Supabase-first: Auth, Postgres, Storage, Realtime, and Edge Functions.
- Multi-tenancy must be enforced through PostgreSQL + RLS from the beginning.

### Frontend architecture expectations
- Create a reusable authenticated app shell and a design-system baseline suitable for all later modules.
- Keep path aliases and strict TypeScript enabled.
- Prefer modern form/state/query patterns already documented: React Router, Zustand, React Hook Form, Zod, React Query, and a shared component layer.

### Database and platform setup
- Supabase region should target Brazil-friendly latency (`sa-east-1` in docs).
- Establish migration workflow, env variable contracts, storage buckets, and base tenant/user tables first.
- pgvector and RLS are not optional because later phases depend on them directly.

### Quality and delivery
- Configure linting, formatting, and test scaffolding early enough to avoid retrofitting quality later.
- The repository should be ready for CI/CD, even if production credentials are not yet connected.
- Observability hooks for Sentry and transactional email setup should be prepared in the foundation, even if full flows land in later phases.

### Claude's Discretion
- Exact folder structure inside `src/` as long as it stays aligned with the documented architecture.
- Which legacy files to keep temporarily versus replace immediately.
- The specific sequence for introducing shared UI primitives versus application wiring.

</decisions>

<specifics>
## Specific Ideas

- Source material for this phase is concentrated in `docs/ROADMAP.md` under `FASE 0 — Preparacao e Setup`.
- `docs/ARCHITECTURE.md` defines the target stack, folder conventions, environment variables, security posture, and deployment model.
- The user explicitly said the idea was redone and execution should start from zero using the new project details in `docs/`.

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- `package.json`: useful as a starting inventory of installed dependencies, but not authoritative for the new architecture.
- `src/lib/supabase.ts` and auth/layout code: may provide temporary reference patterns, but should not constrain the rebuild.

### Established Patterns
- Current app is a Vite/React TypeScript project, which matches the target foundation.
- Existing modules already hint at route-based organization, but the module layout likely needs restructuring to match the new roadmap.

### Integration Points
- `.env.example`, `database/`, and existing `src/` modules should be reviewed during execution to decide what is migrated, rewritten, or removed.
- Future phases depend on solid Phase 1 outputs, so this phase should leave behind stable app, data, and tooling entry points.

</code_context>

<deferred>
## Deferred Ideas

- Authentication UX and onboarding flow details belong to Phase 2.
- Dashboard experience belongs to Phase 3.
- AI providers, embeddings, flows, CRM, inbox, broadcasts, analytics, billing details, and launch hardening all belong to later phases.

</deferred>

---

*Phase: 01-foundation-and-platform-setup*
*Context gathered: 2026-03-12*
