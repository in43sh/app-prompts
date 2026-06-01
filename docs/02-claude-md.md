# Generate CLAUDE.md

I have an existing codebase and want to create a `CLAUDE.md` file — a quick-reference document that helps an AI coding assistant (like Claude Code) orient itself fast without reading every file.

**If you have access to the codebase, read it first.** Scan the obvious sources of truth — `package.json` (scripts, dependencies), config files, the folder structure, `.env.example`, and CI config — and draft the factual sections yourself. Then ask me in stages only to confirm what you found and fill the gaps the code can't reveal: conventions, gotchas, and what an AI should never do here. Wait for my answers before moving on.

Do not invent. Verify every command, path, and env var against the actual repo; if something is unverified, mark it an assumption rather than stating it as fact.

Output quality bar:

- Use concrete defaults and explicit values wherever possible.
- Do not use vague phrases like "as needed", "etc.", or generic advice when a repo-specific detail can be stated.
- Use tables, bullet lists, and annotated trees whenever they make the quick-reference easier to scan.

## Stage 1 — Project Overview

- What does this project do, in 1–2 sentences?
- Who uses it? (end users, developers, internal team, etc.)
- What is the current state? (early prototype, production app, actively developed, maintenance mode)

## Stage 2 — Tech Stack

- What languages and runtimes are used?
- What frameworks and major libraries? (frontend, backend, testing, etc.)
- What database or data storage? (name, hosted where)
- What hosting/deployment platform?
- What third-party services are integrated? (auth, email, payments, storage, analytics, etc.)

## Stage 3 — Codebase Structure

- Describe the top-level folder structure. What lives where?
- Where is the main entry point? (e.g. `src/main.tsx`, `app/page.tsx`, `server.js`)
- Where are the key config files? (e.g. `vite.config.js`, `next.config.ts`, `.env.example`)
- Are there multiple apps or packages in a monorepo? If so, what does each do?
- What does the API layer look like? (REST, GraphQL, serverless functions, tRPC — where do files live?)

## Stage 4 — Dev Workflow

- What commands are used for: install, dev server, build, test, lint?
- How do environment variables work? (`.env`, `.env.local`, injected by CI, etc.)
- Are there any non-obvious setup steps a new developer needs to know?
- What must pass before a PR can merge? (required CI checks, test coverage thresholds, linting gates)

## Stage 5 — Architecture & Conventions

- What patterns govern state management? (Context API, Zustand, Redux, server state only, etc.)
- What are the naming conventions? (files, components, functions, database fields)
- Are there rules about what goes client-side vs. server-side?
- What are the most important files an AI should read first to understand the codebase?
- Are there any "gotchas" — non-obvious things that bite people who are new to the project?
- What should an AI assistant NEVER do in this codebase? (e.g. never edit generated files, never commit secrets, always use X pattern instead of Y)

After I answer, produce the following document:

---

### `CLAUDE.md`

A concise, scannable quick-reference for an AI coding assistant. It should be **short enough to read in under two minutes** and precise enough to avoid basic mistakes. Structure it as follows:

- **What this is** — 2–3 sentences: what the project does, who it's for, current state
- **Tech stack** — bulleted list: language/runtime, framework, database, hosting, key third-party services
- **Key commands** — code block with the essential dev commands (install, dev, build, test, lint); include any CI check commands that must pass before merging
- **Project structure** — annotated folder tree (top 2 levels, with one-line comments on each folder's purpose)
- **Architecture notes** — 3–8 bullet points on patterns that aren't obvious from the file tree (e.g. "API routes in `/api` are Vercel serverless functions, not Express middleware", "All DB access goes through the server-side client in `api/_lib/supabase.js`, never the browser client")
- **Conventions** — bullet list of naming, styling, and structural rules the AI should follow
- **Environment variables** — table of all env vars: name, where it's used (client/server), what it's for, whether it's secret
- **Do not** — short list of things an AI should never do in this repo (avoid generating, deleting, or overwriting these; never commit X; always use Y instead of Z)
- **Where to start** — 3–5 most important files to read first to understand the codebase

Format guidelines:

- Use headers and bullets, not paragraphs
- Prefer specifics over generalities ("use `src/lib/supabaseClient.ts` for all DB queries" not "use the database client")
- Keep the total length under 150 lines
- Include actual file paths, not vague descriptions

---

> **Goal:** An AI assistant reading only `CLAUDE.md` should be able to make correct edits to the codebase without asking where things live, how to run it, or what patterns to follow.
