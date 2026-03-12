# Phase 1: Foundation and Platform Setup - Research

**Date:** 2026-03-12
**Phase:** 01
**Status:** Ready for planning

## What This Phase Must Establish

Phase 1 is a greenfield reset, not an incremental polish of the existing UI shell. The documented product architecture already fixes the major decisions:

- Frontend: React + TypeScript + Vite
- Backend platform: Supabase-first
- Data isolation: PostgreSQL + RLS
- Future modules depend on a reusable shell, typed environment contracts, and a cleaner source tree than the current prototype

This means the right move is to preserve only generic assets and reference materials, then rebuild the frontend foundation around the new roadmap.

## Recommended Build Order

1. Remove obsolete starter and mock-heavy shell files.
2. Rebuild `src/` around a small, intentional foundation:
   - `App.tsx`
   - `config/env.ts`
   - `lib/supabase.ts`
   - `features/foundation/*`
3. Keep generic utilities and theme tokens where they are still useful.
4. Update environment contracts so the app can compile without production secrets.
5. Refresh README and planning docs to reflect the restart.
6. Validate `build`, `lint`, and local dev server.

## Current Codebase Assessment

### Safe to Remove

- Vite starter leftovers: `public/vite.svg`, `src/assets/react.svg`, `src/App.css`
- Legacy shell and placeholder routes: `src/components/layout/*`, `src/pages/dashboard/*`
- Old auth flow code that reflects the previous product shell rather than the new onboarding-first architecture: `src/pages/auth/*`, `src/hooks/useAuth.ts`, `src/store/authStore.ts`
- Empty or placeholder module directories under `src/pages/*`, `src/components/ui`, `src/services`, `src/utils`

### Worth Keeping or Refactoring

- `src/index.css` has usable Tailwind token groundwork, but the color system should be updated away from the old identity.
- `src/lib/utils.ts` is generic enough to keep as the shared utility entry point.
- `src/lib/supabase.ts` is the right place for a typed client, but it should not hard-crash the app when env vars are missing in Phase 1.
- `src/types/database.ts` and `database/*.sql` remain valuable as domain references for Supabase and schema planning.
- `main.tsx` is already minimal and can stay with a small modernization pass.

## Architectural Guidance

### Frontend Foundation

- Use a feature-led `src/` structure rather than route-placeholder sprawl.
- Start with a single high-signal foundation page that shows project status, phase map, and environment readiness.
- Keep routing minimal in Phase 1; full auth and module routing belongs to Phase 2+.

### Supabase and Environment Contracts

- Model envs as optional-but-validated values for Phase 1 so the app still boots without secrets.
- Export a nullable or lazy Supabase client to avoid blocking local UI development before credentials exist.
- Keep all service-role or provider secrets out of the frontend env contract.

### Quality and Risks

- The current repo can build only if esbuild is allowed to spawn; sandboxed runs may fail with `spawn EPERM`.
- Because the legacy app includes old assumptions and mock data, partial reuse is more dangerous than replacement.
- The biggest Phase 1 risk is leaving “temporary” prototype modules in place and then building later phases on top of them.

## Recommended Outcome for This Phase

- A cleaned repository with only relevant frontend foundation files
- A coherent visual and structural baseline for the product
- Safe env and Supabase contracts
- Updated docs so future phases execute against the new structure instead of the prototype

---
*Research complete: 2026-03-12*
