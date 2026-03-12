# Roadmap: InstaFlow AI

## Overview

This roadmap translates the full March 2026 product definition into an executable greenfield build sequence for GSD. The order follows the technical dependencies from platform setup through onboarding, operational modules, monetization, governance, and launch hardening, while preserving the broad scope already specified in `docs/ROADMAP.md`.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions if needed later

- [ ] **Phase 1: Foundation and Platform Setup** - Establish project, Supabase, schema workflow, shared UI foundation, and delivery tooling.
- [ ] **Phase 2: Authentication and Instagram Onboarding** - Deliver account lifecycle, trial activation, and Instagram connection.
- [ ] **Phase 3: Layout and Operational Dashboard** - Create the authenticated shell and first usable operator workspace.
- [ ] **Phase 4: AI Agents and Prompting** - Ship agent CRUD, model selection, testing, and prompt scaffolding.
- [ ] **Phase 5: Knowledge Base and Retrieval** - Add ingestion, embeddings, indexing, and semantic management.
- [ ] **Phase 6: Visual Flow Builder** - Deliver flow authoring, templates, and execution architecture.
- [ ] **Phase 7: Keywords and Auto-Input Automation** - Add trigger rules, restrictions, and automated lead capture actions.
- [ ] **Phase 8: CRM and Lead Operations** - Build kanban CRM, lead data model, segmentation, and lifecycle tools.
- [ ] **Phase 9: Unified Inbox and Real-Time Collaboration** - Centralize conversations with bot/human controls and assignment.
- [ ] **Phase 10: Broadcasts and Campaigns** - Enable campaign authoring, audience targeting, and tracking.
- [ ] **Phase 11: Analytics and Predictive Reporting** - Expose operational, funnel, and predictive decision support.
- [ ] **Phase 12: Post Scheduling and Content Operations** - Add planning and scheduling for Instagram posts tied to automation.
- [ ] **Phase 13: Team and Collaboration Features** - Support multi-user work, permissions, collaboration, and gamification.
- [ ] **Phase 14: Integrations, Settings, Billing, and Governance** - Finish external connectivity, account controls, commercial foundations, and compliance surfaces.
- [ ] **Phase 15: Polish, Testing, and Launch** - Harden quality, performance, security, docs, and release readiness.

## Phase Details

### Phase 1: Foundation and Platform Setup
**Goal**: Establish the greenfield technical base, quality guardrails, Supabase workflow, and reusable app shell primitives needed for the rest of the platform.
**Depends on**: Nothing (first phase)
**Requirements**: [FND-01, FND-02]
**Success Criteria** (what must be TRUE):
  1. Frontend foundation, shared styling, routing baseline, and developer tooling are in place and compile cleanly.
  2. Supabase connectivity, environment handling, and migration conventions are established for a multi-tenant app.
  3. The repository is ready to start building product modules without depending on legacy structure.
**Plans**: 3 plans

Plans:
- [ ] 01-01: Reset project structure and shared frontend foundation
- [ ] 01-02: Establish Supabase client, env contracts, and schema/migration workflow
- [ ] 01-03: Add quality tooling, app shell primitives, and baseline documentation

### Phase 2: Authentication and Instagram Onboarding
**Goal**: Deliver secure user entry, trial activation, and guided onboarding including Instagram Business connection.
**Depends on**: Phase 1
**Requirements**: [AUTH-01, AUTH-02, AUTH-03, ONBD-01, ONBD-02, ONBD-03]
**Success Criteria** (what must be TRUE):
  1. A new user can register, verify email, recover password, and access protected routes.
  2. Trial state is activated and visible with correct expiration behavior.
  3. The onboarding flow captures business context and supports Meta OAuth account connection.
**Plans**: 3 plans

Plans:
- [ ] 02-01: Build auth flows and protected session lifecycle
- [ ] 02-02: Implement onboarding wizard and profile bootstrap
- [ ] 02-03: Integrate trial state and Instagram OAuth connection flow

### Phase 3: Layout and Operational Dashboard
**Goal**: Create the primary authenticated workspace, navigation model, and first operational dashboard experience.
**Depends on**: Phase 2
**Requirements**: [DASH-01, LAY-01]
**Success Criteria** (what must be TRUE):
  1. Authenticated users can navigate the product through a responsive layout and module structure.
  2. Dashboard surfaces trial state, recent activity, core metrics, and operational entry points.
  3. The workspace establishes reusable patterns for later modules.
**Plans**: 2 plans

Plans:
- [ ] 03-01: Build the authenticated layout, navigation, and state framing
- [ ] 03-02: Implement dashboard metrics, summaries, and activity surfaces

### Phase 4: AI Agents and Prompting
**Goal**: Ship the agent management module, model configuration, prompt templates, and a test/playground experience.
**Depends on**: Phase 3
**Requirements**: [AGNT-01, AGNT-02, AGNT-03, PRMT-01]
**Success Criteria** (what must be TRUE):
  1. Users can manage multiple agents with persona, model, and behavior settings.
  2. Users can test an agent and inspect useful debug feedback.
  3. Prompt templates and assisted prompt creation are available as part of agent setup.
**Plans**: 3 plans

Plans:
- [ ] 04-01: Implement agent data model, CRUD flows, and configuration UI
- [ ] 04-02: Add provider/model settings, safeguards, and prompt management
- [ ] 04-03: Build agent playground and prompt generation utilities

### Phase 5: Knowledge Base and Retrieval
**Goal**: Enable document and URL ingestion, vector indexing, and semantic retrieval management for agents and tenants.
**Depends on**: Phase 4
**Requirements**: [KB-01, KB-02, KB-03]
**Success Criteria** (what must be TRUE):
  1. Users can upload or register knowledge sources and track their processing lifecycle.
  2. The platform can chunk, embed, store, and query knowledge assets safely per tenant.
  3. Indexed knowledge can be managed and searched from the application.
**Plans**: 3 plans

Plans:
- [ ] 05-01: Implement knowledge source CRUD, uploads, and status tracking
- [ ] 05-02: Add processing pipeline, chunk/index workflow, and vector retrieval contracts
- [ ] 05-03: Build management UI and semantic search/operator views

### Phase 6: Visual Flow Builder
**Goal**: Deliver a visual automation authoring experience and the backend contracts for flow execution.
**Depends on**: Phase 5
**Requirements**: [FLOW-01, FLOW-02]
**Success Criteria** (what must be TRUE):
  1. Users can build, save, and manage flow graphs with supported node types.
  2. Flow definitions capture the execution data required for runtime processing.
  3. Templates and analytics hooks are prepared for operational use.
**Plans**: 3 plans

Plans:
- [ ] 06-01: Build the flow editor canvas, node system, and persistence model
- [ ] 06-02: Implement flow runtime contracts and execution logging foundations
- [ ] 06-03: Add templates, management views, and flow analytics surfaces

### Phase 7: Keywords and Auto-Input Automation
**Goal**: Add keyword-driven automations, rule restrictions, and auto-input behaviors that feed flows, agents, and lead capture.
**Depends on**: Phase 6
**Requirements**: [KEYW-01]
**Success Criteria** (what must be TRUE):
  1. Users can define keyword rules with matching modes, channels, priorities, and restrictions.
  2. Matching rules can trigger downstream actions such as messaging, flow starts, and tags.
  3. Auto-input behavior is configurable and measurable.
**Plans**: 2 plans

Plans:
- [ ] 07-01: Build keyword rule CRUD, matching options, and restrictions
- [ ] 07-02: Integrate keyword triggers with automation actions and analytics

### Phase 8: CRM and Lead Operations
**Goal**: Deliver lead management, pipeline customization, segmentation, and operational CRM workflows.
**Depends on**: Phase 7
**Requirements**: [CRM-01, CRM-02]
**Success Criteria** (what must be TRUE):
  1. Teams can manage leads in a customizable kanban pipeline with tags, notes, and fields.
  2. Leads can be filtered, segmented, imported, exported, and searched reliably.
  3. The CRM reflects automation outcomes and prepares campaign targeting data.
**Plans**: 3 plans

Plans:
- [ ] 08-01: Implement lead, stage, tag, and custom-field data flows
- [ ] 08-02: Build kanban CRM experience and lead detail workflows
- [ ] 08-03: Add import/export, search, filters, and saved segmentation

### Phase 9: Unified Inbox and Real-Time Collaboration
**Goal**: Centralize conversations into an inbox with real-time updates, assignments, and bot/human control.
**Depends on**: Phase 8
**Requirements**: [INBX-01]
**Success Criteria** (what must be TRUE):
  1. Operators can view and work conversations in a unified inbox with live updates.
  2. Teams can assign conversations and switch between bot and human handling intentionally.
  3. Productivity tools such as canned responses and lead context are available in the inbox.
**Plans**: 3 plans

Plans:
- [ ] 09-01: Implement conversation/message model and real-time list/chat experience
- [ ] 09-02: Add assignment, takeover controls, and collaboration states
- [ ] 09-03: Integrate canned responses, lead side panel, and operator tooling

### Phase 10: Broadcasts and Campaigns
**Goal**: Enable compliant audience messaging campaigns with targeting, scheduling, and performance tracking.
**Depends on**: Phase 9
**Requirements**: [BCST-01]
**Success Criteria** (what must be TRUE):
  1. Users can define a campaign audience, message content, and send/schedule behavior.
  2. Campaign execution respects platform constraints and captures recipient-level status.
  3. Operators can review delivery and conversion signals after send.
**Plans**: 2 plans

Plans:
- [ ] 10-01: Build broadcast creation flow, audience selection, and scheduling rules
- [ ] 10-02: Implement send tracking, recipient states, and campaign analytics views

### Phase 11: Analytics and Predictive Reporting
**Goal**: Expose business and operational analytics with predictive signals that inform sales and retention actions.
**Depends on**: Phase 10
**Requirements**: [ANLT-01]
**Success Criteria** (what must be TRUE):
  1. Users can review actionable metrics across conversations, leads, funnels, and campaigns.
  2. Predictive outputs such as lead scoring or churn risk are visible and grounded in platform data.
  3. Reporting views support decision-making without leaving the product.
**Plans**: 2 plans

Plans:
- [ ] 11-01: Build analytics aggregation model and operational reporting UI
- [ ] 11-02: Add predictive insight pipelines and decision-support surfaces

### Phase 12: Post Scheduling and Content Operations
**Goal**: Support Instagram content scheduling tied to posting history and automation-adjacent workflows.
**Depends on**: Phase 11
**Requirements**: [POST-01]
**Success Criteria** (what must be TRUE):
  1. Users can draft and schedule posts with media and metadata.
  2. Scheduled items are visible with status/history and can support related automations.
  3. Content operations fit the same tenant and permission model as the rest of the platform.
**Plans**: 2 plans

Plans:
- [ ] 12-01: Build post scheduling model, creation flow, and calendar/list views
- [ ] 12-02: Add history, status tracking, and automation link points

### Phase 13: Team and Collaboration Features
**Goal**: Introduce team membership, access control, and collaborative working patterns across the product.
**Depends on**: Phase 12
**Requirements**: [TEAM-01, GAME-01]
**Success Criteria** (what must be TRUE):
  1. Owners can invite and manage teammates with clear role boundaries.
  2. Shared workflows in inbox, CRM, and operations reflect collaborative ownership correctly.
  3. Gamification features such as XP, achievements, or rankings reinforce documented team usage patterns.
**Plans**: 2 plans

Plans:
- [ ] 13-01: Implement team membership, roles, and invitation flows
- [ ] 13-02: Apply collaboration and gamification behavior across shared operational modules

### Phase 14: Integrations, Settings, Billing, and Governance
**Goal**: Finalize monetization, external integrations, account settings, limits, security, and compliance features needed for real operation.
**Depends on**: Phase 13
**Requirements**: [FND-03, INTG-01, BILL-01, SETT-01, GOV-01]
**Success Criteria** (what must be TRUE):
  1. Users can manage subscriptions and plan changes through Stripe-backed flows.
  2. Outbound integrations, webhooks, and platform limits operate consistently.
  3. Users can manage account, security, notification, operating-hours, and API-access settings from the product.
  4. Audit, LGPD-sensitive settings, token protection, and governance controls are present.
**Plans**: 3 plans

Plans:
- [ ] 14-01: Implement billing lifecycle, entitlements, and customer portal flows
- [ ] 14-02: Build outbound integration/webhook management plus settings control surfaces
- [ ] 14-03: Add governance, audit, privacy, security, and entitlement enforcement surfaces

### Phase 15: Polish, Testing, and Launch
**Goal**: Harden the product for release with comprehensive testing, performance work, security review, and launch assets.
**Depends on**: Phase 14
**Requirements**: [QLTY-01]
**Success Criteria** (what must be TRUE):
  1. Critical flows are covered by automated and manual verification suitable for launch.
  2. Performance, reliability, and security issues are addressed to a release-ready level.
  3. Launch assets such as landing, docs, and rollout checklist are complete.
**Plans**: 3 plans

Plans:
- [ ] 15-01: Add end-to-end quality coverage and fix launch-blocking defects
- [ ] 15-02: Execute performance, reliability, and security hardening
- [ ] 15-03: Finish launch collateral, user documentation, and release readiness

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 9 → 10 → 11 → 12 → 13 → 14 → 15

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation and Platform Setup | 0/3 | Not started | - |
| 2. Authentication and Instagram Onboarding | 0/3 | Not started | - |
| 3. Layout and Operational Dashboard | 0/2 | Not started | - |
| 4. AI Agents and Prompting | 0/3 | Not started | - |
| 5. Knowledge Base and Retrieval | 0/3 | Not started | - |
| 6. Visual Flow Builder | 0/3 | Not started | - |
| 7. Keywords and Auto-Input Automation | 0/2 | Not started | - |
| 8. CRM and Lead Operations | 0/3 | Not started | - |
| 9. Unified Inbox and Real-Time Collaboration | 0/3 | Not started | - |
| 10. Broadcasts and Campaigns | 0/2 | Not started | - |
| 11. Analytics and Predictive Reporting | 0/2 | Not started | - |
| 12. Post Scheduling and Content Operations | 0/2 | Not started | - |
| 13. Team and Collaboration Features | 0/2 | Not started | - |
| 14. Integrations, Settings, Billing, and Governance | 0/3 | Not started | - |
| 15. Polish, Testing, and Launch | 0/3 | Not started | - |
