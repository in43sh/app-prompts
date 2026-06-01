# Generate a Technical Guide

I have an existing codebase and want to produce a `TECHNICAL_GUIDE.md` — a deep, self-contained reference that explains how the whole system fits together. This is longer and more thorough than a `CLAUDE.md`: it is the document a new engineer (or an AI assistant doing non-trivial work) reads to understand the architecture, data model, subsystems, and the non-obvious decisions behind them.

**If you have access to the codebase, read it first.** Before asking me anything, scan the obvious sources of truth — `package.json` (scripts, dependencies), the schema/migrations, the routes or API folder, `.env.example`, config files, and the test folder — and draft the factual sections yourself. Then use the stages below to *confirm what you found and fill the gaps*, not to interview me for facts that are already in the repo.

Focus your questions on what the code cannot tell you: intent, rationale, history, gotchas, and what is deliberately not done. The repo reveals *what* the system does; I reveal *why* it is built this way and what bites people.

Ask in stages — don't dump everything at once. Go in this order: what the project is, architecture & data, subsystems, operations (testing, local dev, deployment), then patterns & gotchas. Wait for my answers before moving to the next stage.

Accuracy rules:

- Verify every file path, table, column, endpoint, env var, and command against the actual code. Never carry over a name you haven't seen in the repo.
- Do not invent. If something is unverified, or I don't know it, mark it an explicit assumption rather than stating it as fact.

Output quality bar:

- Use concrete defaults and explicit values wherever possible — real file paths, real table and column names, real command lines.
- Do not use vague phrases like "as needed", "etc.", or "TBD" in the final guide unless the item is genuinely unresolved and clearly labeled.
- Use tables, annotated trees, numbered flows, and Mermaid diagrams whenever they make the system easier to understand unambiguously.

## Stage 1 — What This Is

- What does this project do, in 1–2 sentences? What is the one-line mission?
- Who uses it, and in what roles? (end users, admins, internal services, etc.)
- What is the current state? (prototype, actively developed, production, maintenance)
- What are the major moving parts at the highest level? (e.g. web app + API + worker, mobile app + backend, single-page client-only app)

## Stage 2 — Architecture & Data

- What is the high-level request/data flow? Walk me through one representative end-to-end path (e.g. "user submits X → route does Y → writes Z → triggers W").
- What are the top-level folders, and what lives in each? Is it a monorepo with multiple apps/packages?
- What is the data store, and what are the main tables/collections? For the core ones, what are the key fields and the relationships between them?
- Are there important state machines or lifecycles? (e.g. a status field that moves `draft → pending → live`)

## Stage 3 — Subsystems

For each subsystem you found in the code (or that I name), confirm how it works and ask me only what the code leaves ambiguous. Cover the ones that apply:

- Authentication & authorization — how sessions/roles work, how protected routes are guarded
- API surface — REST/GraphQL/RPC, where handlers live, the main endpoints
- Frontend — pages/screens/routes, navigation, state management (server state vs. local state)
- Background work — jobs, schedulers, queues, event handlers, webhooks
- External integrations — payments, email, SMS, storage, AI, third-party APIs
- Domain-specific logic — anything central to this product that doesn't fit the buckets above

## Stage 4 — Operations

- How is the project tested? (frameworks, where tests live, roughly how many, what's covered — and honestly, what is *not* tested)
- How does a developer run it locally? (prerequisites, setup steps, the exact commands, common first-run issues)
- What environment variables exist? Which are required vs. optional, which are secret, and what each is for.
- How is it deployed? (platform, build command, branch flow, crons, anything non-obvious)

## Stage 5 — Patterns, Gotchas & Gaps

- What conventions and recurring patterns should someone follow to match the existing code?
- What are the non-obvious gotchas — things that bite newcomers, or decisions that look wrong until you know why?
- What domain terms deserve a glossary entry? (project-specific words, ambiguous field names, internal jargon)
- What is known future work, or open questions worth flagging for later?

After I answer, produce the following document:

---

### `TECHNICAL_GUIDE.md`

A thorough, self-contained technical reference. Number the sections. Include every section below that applies — **omit a section only if it genuinely does not exist for this project** (e.g. no API section for a client-only app), and say nothing rather than padding.

- **What This Is** — what the project does, the one-line mission, the roles it serves, and the major moving parts at a glance
- **Architecture** — a Mermaid diagram of the high-level components, followed by a numbered walkthrough of one representative end-to-end request/data flow
- **Repository Structure** — an annotated folder tree with a one-line comment on each significant folder/file's role
- **Tech Stack** — a table with columns: Layer, Technology, Why (the specific reason it was chosen for this project)
- **Data Architecture** — for each core table/collection: a field table (name, type, purpose) plus relationships; document any status lifecycle as a small state diagram or arrow flow
- **Core Subsystems** — one subsection per subsystem that applies (auth, payments, background jobs, integrations, domain logic). For each: what it is, how it works, the files it lives in, and the key behaviors. Use code snippets only where a short one clarifies a real pattern in the codebase
- **API Reference** — tables of endpoints grouped by access level (public / authenticated / admin / webhooks): Method, Path, Purpose. Omit if there is no API
- **Frontend** — tables of pages/screens/routes with their component file and notable behavior; note navigation and state-management approach. Omit if there is no frontend
- **Testing** — what is tested at each level, where tests live, roughly how many, and an explicit "What is not tested" list
- **Local Development** — prerequisites, setup steps, the exact commands (install, dev, build, test, db, etc.), and a "Common issues" list with fixes
- **Environment Variables** — a table: name, required vs. optional, secret vs. safe-to-commit, purpose
- **Deployment** — platform, build command, branch/preview/production flow, crons, and any deploy-time gotchas. Omit if not deployed anywhere
- **Security Model** — auth/authorization boundaries, sensitive-data handling, input validation, and any headers/token/secret practices. Omit if there is genuinely nothing to say
- **Key Patterns** — the recurring conventions and non-obvious decisions someone must understand to work in this codebase, each with the reasoning behind it
- **Glossary** — alphabetical-ish list of project-specific terms, ambiguous field names, and internal jargon, each defined precisely
- **File-by-File Reference** — the most important files grouped by concern (infrastructure, business logic, key routes, schema, etc.), each with a one-line description
- **Future Work** — a numbered list of known gaps, deferred features, and open questions, each with enough context to act on later

Format guidelines:

- Prefer tables and annotated trees over prose wherever they carry the information more clearly.
- Use real, verifiable names — file paths, table/column names, endpoint paths, env var names, commands.
- Keep diagrams in Mermaid so they render in the repo. Use a `flowchart` for the architecture diagram, a `stateDiagram` (or arrow flow) for status lifecycles, and a `sequenceDiagram` for any flow with several back-and-forth steps.
- It is fine for this document to be long. Completeness and precision matter more than brevity — but every line should earn its place.

---

> **Goal:** A new engineer or AI assistant reading only `TECHNICAL_GUIDE.md` should understand how the system is built, where everything lives, how to run and deploy it, and which non-obvious decisions to respect — without spelunking the whole codebase first.
