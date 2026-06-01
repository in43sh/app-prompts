# Map App Architecture (HTML + JSON)

I have an existing codebase and want two artifacts that map how the whole system fits together:

1. **`ARCHITECTURE.html`** — a single, self-contained interactive page *for humans*. It shows every component grouped by role, and lets me pick a flow to highlight the exact path a request takes through the system, step by step.
2. **`architecture.json`** — the same map as structured data *for the next agent or tool*. It is the machine-readable source the HTML renders from.

The HTML is generated *from* the JSON — they describe the same graph, and the JSON is embedded inside the HTML so the page works offline by double-click.

**If you have access to the codebase, read it first.** Before asking me anything, scan the obvious sources of truth — `package.json` (scripts, dependencies), the schema/migrations, the routes or API folder, `.env.example`, config files, background jobs, and any infra config — and draft the node/flow map yourself. Then use the stages below to *confirm what you found and fill the gaps*.

Accuracy rules:

- Every node must map to a real thing in the repo — a file, folder, table, or named external service. Put the real path in the node where one exists. Never invent a component you haven't seen.
- Flows must trace real call paths. If you are unsure whether a step happens, ask me or mark it in the node `detail` as an assumption — don't draw an edge you can't justify.

## Stage 1 — Components (nodes)

- What are the distinct parts of the system? Group them by role: actors (users, external callers), client surfaces (apps, pages), server code (routes, functions, services), data stores (tables, buckets, caches), background work (jobs, workers, queues), and external services (third-party APIs).
- For each, what is its real path or identifier in the repo (file, folder, table name, package)?

## Stage 2 — Flows

- What are the handful of representative end-to-end flows worth highlighting? (e.g. "user saves a record", "webhook arrives", "scheduled job runs", "new user signs up")
- For each flow, walk me through the ordered steps: which node calls which, what triggers it, and what data is passed at each hop.

## Stage 3 — Confirm

- Did I miss any component or flow that matters?
- Which flow is the most important one to show selected by default?

After I answer, produce the following two files:

---

### 1. `architecture.json`

A structured map of the system. Use exactly this shape:

```json
{
  "name": "string — the project name",
  "description": "string — one or two sentences on what the system is",
  "categories": [
    { "id": "actor", "label": "Actor", "color": "#e879b9" }
  ],
  "nodes": [
    {
      "id": "string — stable slug, referenced by edges/flows",
      "label": "string — short display name",
      "category": "string — a category id",
      "path": "string — real repo path or identifier (optional)",
      "detail": "string — one line on its role (optional)"
    }
  ],
  "edges": [
    { "from": "node id", "to": "node id", "label": "string (optional)" }
  ],
  "flows": [
    {
      "id": "string — stable slug",
      "name": "string — short display name",
      "description": "string — one line on what the flow does",
      "steps": [
        {
          "from": "node id",
          "to": "node id",
          "label": "string — what happens at this hop",
          "detail": "string — payload / method / file (optional)"
        }
      ]
    }
  ],
  "meta": {
    "generatedAt": "ISO date",
    "sourceCommit": "string — git SHA if known (optional)",
    "notes": "string — anything the reader should know, e.g. assumptions (optional)"
  }
}
```

Rules:

- `edges` is the static architecture — every meaningful connection, shown faintly at rest.
- `flows[].steps` are the highlighted paths. Every `from`/`to` must reference a real node `id`.
- Keep node ids stable and slug-like so the map diffs cleanly when regenerated.

### 2. `ARCHITECTURE.html`

A single self-contained HTML file. Requirements:

- **No build step and no network.** Inline all CSS and JS. Do not load anything from a CDN — the file must render by double-clicking it (`file://`).
- **Embed the data.** Include the `architecture.json` contents inline as `const DATA = { ... }` so the page is standalone. (The separate `.json` file is the agent-facing copy.)
- **Layout.** Render nodes in columns grouped by category, in the category order given. Each node is a labeled box; show its `path`/`detail` when present. Include a legend mapping each category to its color.
- **Flows panel.** A list of flows in a side rail (`id="flows"`). Clicking a flow highlights its nodes and draws its `steps` as numbered connectors between the node boxes (compute connector positions from element geometry so they survive resize).
- **Steps panel.** When a flow is selected, show its ordered steps as a numbered list: `from → to`, the step `label`, and `detail`.
- **Clear selection.** A control that resets to the at-rest view (faint static edges, no flow highlighted).
- **Theme.** Dark, high-contrast, readable. Make the selected path obviously brighter than the resting edges.
- Select the flow named in Stage 3 by default.

Format guidelines:

- The two files must agree exactly — same nodes, same ids, same flows.
- Use real, verifiable names everywhere: file paths, table names, route paths, service names.
- Treat both files as generated artifacts: regenerating from the current code refreshes them. Note in `meta.notes` anything you assumed rather than verified.

---

> **Goal:** I open `ARCHITECTURE.html`, click any flow, and immediately see the path through my system and what is passed at each step. The next agent reads `architecture.json` and has a verified component-and-flow map of the codebase without re-deriving it.
