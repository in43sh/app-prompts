# Project Kickoff

I want to start a new software project. Help me think through it from scratch — the goal is to produce a complete, AI-ready spec that I can hand to an AI coding assistant to build from.

Ask me questions in stages — don't dump everything at once. Start with vision and goals, then dig into users, then requirements, then tech stack, then structure. Wait for my answers before moving to the next stage.

If I do not know a materially important detail, help me choose by presenting a small set of sensible options and recommending one with brief reasoning. Do not present a recommendation as a confirmed requirement unless I explicitly accept it. If an important detail remains unresolved, mark it as an explicit assumption or include it in `OPEN_QUESTIONS.md` instead of inventing it.

Output quality bar:

- Use concrete defaults and explicit values wherever possible.
- Do not use vague phrases like "as needed", "etc.", "TBD" in final specs unless the item is truly unresolved and is clearly labeled as an assumption or open question.
- Use tables, bullet lists, and numbered flows whenever they make the spec easier to implement unambiguously.

## Stage 1 — Vision

- What problem does this solve?
- Who is it for? (end users, internal team, developers, etc.)
- What does success look like at launch?
- Is there an existing solution I'm replacing or extending?
- Is there a Figma design or other visual reference?

## Stage 2 — Users & Flows

- Who are the primary users?
- What are the core user flows? (what does a user actually *do*?)
- What are the non-negotiable requirements vs. nice-to-haves?
- Is there an admin or moderation workflow? Who manages the data, and how?

## Stage 3 — Scope & Constraints

- What is explicitly out of scope for v1?
- Does this need to integrate with anything existing?
- Any compliance, security, or privacy requirements? (auth, GDPR, HIPAA, etc.)
- What third-party services will be used? (forms, payments, email, analytics, etc.)

## Stage 4 — Tech Stack

- What platforms? (web, mobile, desktop)
- Any language/framework preferences or existing expertise?
- What kind of data storage is needed? (relational, document, file, none)
- Do I need real-time features, background jobs, file uploads, payments, auth?
- Hosting preferences? (self-hosted, Vercel, AWS, etc.)
- What's the design system? (colors, fonts — or should we define one?)

## Stage 5 — Project Structure & Testing

- Monorepo or separate repos?
- What's the testing strategy? (unit, component, e2e)

After I answer, produce the following three documents:

---

### 1. `MVP_DOCUMENT.md`

A complete, self-contained implementation spec. Include every section below:

- **Project Overview** — one-paragraph brief and tech stack table
- **Design System** — colors (name, hex, usage), typography (font family, weights), effects (shadows, borders)
- **Pages & Features** — each page/screen with all UI elements, component variants, and behavior described precisely enough to build from
- **Data Architecture** — full database schema (field name, type, notes for every field), all API endpoints (method, path, purpose, query params, response shape)
- **Permissions & Access Control** — user roles, protected routes/pages, role-specific UI states, and how access is enforced in the app and backend. Omit only if the project is fully public and has no privileged actions.
- **Admin Workflow** — step-by-step process for any manual data management tasks
- **User Flows** — numbered step-by-step flows for each primary use case
- **Empty States** — what to show when there is no data, for each relevant section
- **Responsive Breakpoints** — breakpoint table with layout behavior per screen size
- **Error Handling** — error response format, user-facing error messages, logging strategy, failure modes for key flows
- **Security** — API key protection strategy, XSS prevention, input validation, external link handling
- **Project Structure** — full folder/file tree with inline comments explaining each file's role
- **Environment Variables** — client-side vs server-side split, `.env.example` with placeholder values, critical rules (e.g. what to never commit)
- **Testing Strategy** — what to test at each level (unit, component, e2e), key flows to cover, recommended tools
- **Implementation Order** — numbered build steps in the correct sequence

### 2. `DECISIONS.md`

An architectural decisions record (ADR) for every major technical choice (database, hosting, forms, image storage, repo structure, etc.). For each decision:

- **Decision:** What was chosen and when
- **Alternatives considered:** Comparison table (option, pros, cons, complexity/cost)
- **Why this choice:** 3–5 specific bullet reasons
- **When to reconsider:** Concrete triggers for revisiting (e.g. "if we exceed X records" or "if we add auth")

End with a summary table of all decisions.

### 3. `OPEN_QUESTIONS.md`

- Unresolved decisions that must be answered before build starts (placeholders, unknowns, TBDs)
- Edge cases and spec gaps that weren't covered
- Conflicts between requirements or design and spec
- Post-MVP improvement ideas to revisit later

---

> **Goal:** The documents should be precise enough for an AI coding assistant to implement the entire project from scratch without asking clarifying questions.
