# InstaFlow AI

## What This Is

InstaFlow AI is a Brazilian multi-tenant SaaS for Instagram automation with AI agents, visual flows, lead management, analytics, and billing. It targets solo entrepreneurs, clinics, ecommerce brands, and agencies that need to respond faster, capture leads, and convert conversations without building a 24/7 support team.

## Core Value

A business owner can connect an Instagram account and reliably automate lead capture and conversational sales with AI, without needing technical setup or constant human intervention.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Deliver a greenfield rebuild based on the new March 2026 product definition in `docs/`.
- [ ] Support Instagram-first onboarding, account connection, and tenant-safe authentication.
- [ ] Let users configure AI agents, knowledge bases, and automations without code.
- [ ] Give teams a usable operational workspace: dashboard, inbox, CRM, broadcasts, and analytics.
- [ ] Ship commercial foundations: trial, plans, billing, limits, auditability, and LGPD-aware settings.

### Out of Scope

- Native mobile apps — web-first delivery keeps scope focused on shipping the SaaS core.
- Reusing the current frontend architecture as a constraint — existing code is treated as disposable legacy unless explicitly reused.
- Shipping every future idea from V2/V3/V4 during this milestone — only the v1 product scope from `docs/` is in execution.

## Context

The source of truth for this rebuild lives in `docs/PRODUTO.md`, `docs/FEATURES.md`, `docs/ARCHITECTURE.md`, `docs/SCHEMA.md`, `docs/AI_MODELS.md`, and `docs/ROADMAP.md`. Those files define a full product, not a thin MVP: onboarding, Instagram/Meta integration, AI multi-provider support, embeddings, flow builder, CRM, inbox, campaigns, analytics, post scheduling, team collaboration, integrations, subscription management, and launch readiness.

There is existing React/Vite code in `src/`, but the user explicitly reframed the product yesterday and wants execution to begin from the new design. The current codebase should therefore be evaluated phase-by-phase as reusable or removable rather than treated as the target architecture.

The product is Brazil-first: pt-BR copy, BRL pricing, LGPD constraints, Meta app review, Stripe operations, and Supabase deployment in a Brazil-friendly region are all part of the definition.

## Constraints

- **Tech stack**: React + TypeScript + Vite on the frontend, Supabase for auth/database/storage/edge functions — this is already defined in `docs/ARCHITECTURE.md`.
- **Domain dependency**: Meta Instagram Graph API and webhook approval are critical path dependencies — production messaging depends on them.
- **Data architecture**: PostgreSQL with RLS and pgvector is mandatory — schema and multi-tenancy rules are already specified in `docs/SCHEMA.md`.
- **Commercial**: Trial, paid plans, usage limits, and Stripe lifecycle must exist early enough to avoid rebuilding entitlement logic later.
- **Execution style**: Build from the documented design first, then delete or rewrite obsolete files instead of forcing compatibility with the old app structure.
- **Compliance**: LGPD, audit logging, token security, and tenant isolation cannot be postponed to a final cleanup phase.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Use `docs/` as the canonical product definition for the rebuild | The product was redesigned and documented in depth before implementation started | — Pending |
| Treat current `src/` code as legacy, not as architecture to preserve | The user wants a fresh build from the new concept, and the existing app only partially overlaps | — Pending |
| Initialize the project in GSD as a greenfield build with planning docs committed | Execution needs a durable roadmap and per-phase workflow before code work begins | — Pending |
| Keep the product split into operational phases that mirror the documented modules | The source docs are already organized by coherent platform capabilities and dependencies | — Pending |

---
*Last updated: 2026-03-12 after GSD initialization from `docs/`*
