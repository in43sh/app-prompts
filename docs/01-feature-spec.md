# Feature Spec

I want to plan a new feature for an existing project. Help me think it through carefully — the goal is to produce a spec precise enough for an AI coding assistant to implement the feature without asking clarifying questions.

**If you have access to the codebase, read it first.** Before asking me anything, find the parts this feature touches — the relevant routes/screens/components, the data model, and the existing patterns (naming, folder structure, state management, API style) — and draft the spec to fit what is actually there. Use the stages below to confirm what you found and fill the gaps the code can't reveal: intent, scope, and the calls only I can make.

Verify every file path, endpoint, table, column, and pattern you reference against the actual code — never carry over a name you haven't seen in the repo. If something is unverified, mark it an explicit assumption rather than stating it as fact.

Ask me questions in stages — don't dump everything at once. Start with what the feature is and why, then dig into user flows, then edge cases, then implementation details.

If I do not know a materially important detail, help me choose by presenting a small set of sensible options and recommending one with brief reasoning. Do not present a recommendation as a confirmed requirement unless I explicitly accept it. If an important detail remains unresolved, mark it as an explicit assumption or include it in `OPEN_QUESTIONS.md` instead of inventing it.

Output quality bar:

- Use concrete defaults and explicit values wherever possible.
- Do not use vague phrases like "as needed", "etc.", "TBD" in final specs unless the item is truly unresolved and is clearly labeled as an assumption or open question.
- Use tables, bullet lists, and numbered flows whenever they make the spec easier to implement unambiguously.

## Stage 1 — What & Why

- What is the feature, in one sentence?
- What problem does it solve? What happens today without it?
- What does success look like once it's shipped?
- Is there a related design (Figma, sketch, mockup)?

## Stage 2 — Users & Flows

- Who uses this feature? (all users, specific roles, admins, etc.)
- Walk me through the primary happy-path flow step by step.
- Are there secondary flows? (e.g. edit, delete, retry, cancel)
- What triggers the flow? (button click, scheduled event, webhook, etc.)
- What feedback does the user get at each step? (loading states, success, error)

## Stage 3 — Scope & Edge Cases

- What is explicitly out of scope for v1 of this feature?
- What are the known edge cases? (empty state, invalid input, concurrent edits, rate limits, etc.)
- What happens when something goes wrong? (network failure, validation error, third-party down)
- Are there permission or access control rules? (who can see or use this feature?)
- Does this feature affect any existing flows? (what breaks or changes?)

## Stage 4 — Implementation Details

- Confirm the stack you found (language, framework, database, component library, auth), and flag anything you couldn't determine from the code.
- Which existing patterns should this feature follow? (naming conventions, folder structure, state management, API style — confirm what you saw, or ask if it's ambiguous)
- Does this need new API endpoints, or does it extend existing ones?
- Does this touch the database? (new table, new columns, migrations, indexes)
- If this changes existing data, are migrations, backfills, or compatibility rules needed for existing records?
- Are there third-party services involved? (storage, email, payments, etc.)

## Stage 5 — Integration & Rollout

- Does this need a feature flag? (gradual rollout, A/B test, admin-only first)
- What needs to change in documentation, onboarding, or help content?
- How will you know it's working in production? (metrics, alerts, logs)
- Is there a rollback plan if something goes wrong?

After I answer, produce the following two documents:

---

### 1. `FEATURE_SPEC.md`

A complete, self-contained spec for the feature. Include every section below:

- **Feature Overview** — one-paragraph summary: what it is, who it's for, why it matters
- **User Flows** — numbered step-by-step flows for every path (happy path, secondary flows, error paths). Include what the user sees and what the system does at each step.
- **UI & Components** — every screen, modal, or state this feature introduces. For each: layout, all UI elements, copy, loading/empty/error states, responsive behavior.
- **API Changes** — every new or modified endpoint (method, path, request shape, response shape, error cases). If none, omit.
- **Data Changes** — new tables, new columns, migrations, indexes. Include field name, type, constraints, purpose, any required backfill or migration steps, and compatibility rules for existing records. If none, omit.
- **Permissions & Access Control** — who can access what, and how it's enforced (middleware, RLS, UI hiding, etc.)
- **Edge Cases & Error Handling** — exhaustive list of edge cases and how each is handled
- **Existing Flow Impact** — which current screens, APIs, jobs, or workflows change because of this feature, what behavior changes for existing users, and any backward-compatibility concerns
- **Regression Risks** — the highest-risk areas this feature could break, why they are risky, and what safeguards or tests are required before shipping
- **Third-Party Services** — any external APIs or services involved, what they do, failure behavior
- **Feature Flag** — whether one is needed, how to enable/disable, what state to show when disabled. Omit if not applicable.
- **Rollout & Rollback** — rollout sequence (dark launch, internal, % of users, full), how to verify it's working, and step-by-step rollback plan if something goes wrong. Omit if not applicable.
- **Testing** — key test cases to write (unit, integration, e2e as appropriate), critical paths to cover, and any edge cases that must have test coverage before shipping.
- **Observability** — what to log, what metrics to track, what alerts to set up
- **Implementation Order** — numbered build steps in the correct sequence (backend before frontend where applicable)
- **Open Questions** — unresolved decisions, unknowns, or items to confirm before starting

### 2. `IMPLEMENTATION_PLAN.md`

A concrete task breakdown for building the feature. For each task:

- **Task name** — short, action-oriented (e.g. "Add `image_url` column to `users` table")
- **What it involves** — 2–3 sentences describing the work
- **Files to create or modify** — specific file paths where known
- **Acceptance criteria** — how to know when this task is done
- **Regression considerations** — existing behavior that must still work after this task lands
- **Depends on** — which other tasks must be completed first (if any)

End with a **risk table**: task, risk level (low/medium/high), mitigation.

---

> **Goal:** The documents should be precise enough for an AI coding assistant to implement the feature from scratch without asking clarifying questions.
