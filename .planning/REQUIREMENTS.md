# Requirements: InstaFlow AI

**Defined:** 2026-03-12
**Core Value:** A business owner can connect an Instagram account and reliably automate lead capture and conversational sales with AI, without needing technical setup or constant human intervention.

## v1 Requirements

### Foundation

- [ ] **FND-01**: Team can bootstrap the project with a production-ready frontend baseline, shared design system, strict TypeScript, and CI-ready quality tooling.
- [ ] **FND-02**: Platform can connect to Supabase with tenant-safe auth, storage, environment configuration, and migration workflow.
- [ ] **FND-03**: Platform can enforce subscription limits, feature flags, and plan entitlements consistently across UI, database, and server logic.

### Authentication & Onboarding

- [ ] **AUTH-01**: User can create an account with email and password and accept legal terms.
- [ ] **AUTH-02**: User receives verification and password recovery flows by email.
- [ ] **AUTH-03**: User can log in, maintain session state, and access protected routes securely.
- [ ] **ONBD-01**: New user completes a guided onboarding that captures business segment and operating mode.
- [ ] **ONBD-02**: New user can connect an Instagram Business account through Meta OAuth during onboarding or later in settings.
- [ ] **ONBD-03**: New user gets a trial activated automatically with visible remaining time and expiration behavior.

### Dashboard & Workspace

- [ ] **DASH-01**: User can land on a main workspace with key metrics, recent activity, funnel summary, and trial/banner state.
- [ ] **LAY-01**: User can navigate the application through a responsive authenticated layout with clear module entry points.

### AI Agents & Prompts

- [ ] **AGNT-01**: User can create, edit, duplicate, activate, and archive AI agents with persona and behavior settings.
- [ ] **AGNT-02**: User can select AI providers/models and tune advanced response settings safely.
- [ ] **AGNT-03**: User can test an agent in a playground with debug signals such as intent, sentiment, and confidence.
- [ ] **PRMT-01**: User can start from prompt templates by segment and generate prompt drafts with AI assistance.

### Knowledge Base

- [ ] **KB-01**: User can ingest documents, URLs, and FAQ entries into a knowledge base tied to a tenant or specific agent.
- [ ] **KB-02**: Platform can process, chunk, embed, index, and monitor knowledge content for semantic retrieval.
- [ ] **KB-03**: User can search and manage indexed knowledge assets with processing status and usage stats.

### Flow Builder & Automation

- [ ] **FLOW-01**: User can create and edit visual automation flows with node-based logic and reusable templates.
- [ ] **FLOW-02**: Platform can execute flow logic with triggers, conditions, actions, delays, AI steps, and loop protection.
- [ ] **KEYW-01**: User can configure keyword and auto-input rules with priority, channel restrictions, and downstream actions.

### CRM & Inbox

- [ ] **CRM-01**: User can manage leads in a kanban CRM with custom stages, tags, notes, and custom fields.
- [ ] **CRM-02**: User can import, export, search, filter, and segment leads for operations and campaigns.
- [ ] **INBX-01**: Team can work conversations in a unified real-time inbox with bot/human takeover, assignment, and canned responses.

### Campaigns & Analytics

- [ ] **BCST-01**: User can create broadcasts/campaigns with audience selection, scheduling constraints, and delivery tracking.
- [ ] **ANLT-01**: User can view operational analytics, campaign metrics, and predictive insights relevant to conversions and churn.
- [ ] **POST-01**: User can schedule Instagram posts and associate them with automation behaviors and history.

### Team, Integrations & Governance

- [ ] **TEAM-01**: Account owner can invite team members, control roles/access, and collaborate in shared workflows.
- [ ] **GAME-01**: Team members can participate in gamification systems such as XP, achievements, challenges, and rankings tied to platform activity.
- [ ] **INTG-01**: User can connect outbound integrations such as webhooks and external automation platforms.
- [ ] **BILL-01**: User can subscribe, upgrade, downgrade, and manage billing through Stripe-backed plan flows.
- [ ] **SETT-01**: User can manage account, security, notification, operating-hours, and API-access settings from a dedicated settings workspace.
- [ ] **GOV-01**: Platform records audit events, supports LGPD-sensitive account settings, and protects tokens/secrets appropriately.

### Quality & Launch

- [ ] **QLTY-01**: Platform is launch-ready with automated coverage for critical journeys plus production baselines for performance, accessibility, security, and supportability.

## v2 Requirements

### Advanced AI

- **AI-ADV-01**: Platform can offer deeper predictive automation and optimization loops beyond initial lead scoring and forecasts.
- **AI-ADV-02**: Platform can expand the prompt/template library into more verticalized operating packs.

### Expansion

- **EXP-01**: Platform can expand beyond the core Instagram workflow into additional acquisition and support channels.
- **EXP-02**: Platform can ship deeper gamification and retention systems beyond the first milestone baseline.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Native iOS/Android applications | Web delivery is enough for initial commercial validation and reduces execution drag |
| Rebuilding around the current partial UI as a fixed constraint | The documented architecture is the source of truth, so legacy UI can be replaced |
| Future-marketplace or multi-channel expansions beyond Instagram-first workflows | The first milestone is focused on winning one operational wedge well |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| FND-01 | Phase 1 | Pending |
| FND-02 | Phase 1 | Pending |
| FND-03 | Phase 14 | Pending |
| AUTH-01 | Phase 2 | Pending |
| AUTH-02 | Phase 2 | Pending |
| AUTH-03 | Phase 2 | Pending |
| ONBD-01 | Phase 2 | Pending |
| ONBD-02 | Phase 2 | Pending |
| ONBD-03 | Phase 2 | Pending |
| DASH-01 | Phase 3 | Pending |
| LAY-01 | Phase 3 | Pending |
| AGNT-01 | Phase 4 | Pending |
| AGNT-02 | Phase 4 | Pending |
| AGNT-03 | Phase 4 | Pending |
| PRMT-01 | Phase 4 | Pending |
| KB-01 | Phase 5 | Pending |
| KB-02 | Phase 5 | Pending |
| KB-03 | Phase 5 | Pending |
| FLOW-01 | Phase 6 | Pending |
| FLOW-02 | Phase 6 | Pending |
| KEYW-01 | Phase 7 | Pending |
| CRM-01 | Phase 8 | Pending |
| CRM-02 | Phase 8 | Pending |
| INBX-01 | Phase 9 | Pending |
| BCST-01 | Phase 10 | Pending |
| ANLT-01 | Phase 11 | Pending |
| POST-01 | Phase 12 | Pending |
| TEAM-01 | Phase 13 | Pending |
| GAME-01 | Phase 13 | Pending |
| INTG-01 | Phase 14 | Pending |
| BILL-01 | Phase 14 | Pending |
| SETT-01 | Phase 14 | Pending |
| GOV-01 | Phase 14 | Pending |
| QLTY-01 | Phase 15 | Pending |

**Coverage:**
- v1 requirements: 34 total
- Mapped to phases: 34
- Unmapped: 0

---
*Requirements defined: 2026-03-12*
*Last updated: 2026-03-12 after initialization from `docs/`*
