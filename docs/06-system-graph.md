# Map the System Graph (HTML + JSON)

I have an existing codebase and want two artifacts that map how the whole system fits together:

1. **`SYSTEM_GRAPH.html`** — a single, self-contained interactive page *for humans*. It shows every component grouped by role, and lets me pick a flow to highlight the exact path a request takes through the system, step by step.
2. **`system-graph.json`** — the same map as structured data *for the next agent or tool*. It is the machine-readable source the HTML renders from.

The HTML is generated *from* the JSON — they describe the same graph, and the JSON is embedded inside the HTML so the page works offline by double-click.

**If you have access to the codebase, read it first.** Before asking me anything, scan the obvious sources of truth — `package.json` (scripts, dependencies), the schema/migrations, the routes or API folder, `.env.example`, config files, background jobs, and any infra config — and draft the node/flow map yourself. Then use the stages below to *confirm what you found and fill the gaps*.

**Curate, don't enumerate.** The map is a mental model, not a file listing. Aim for the ~10–18 components that explain how the system works; collapse a folder of similar files into one node (e.g. one "API routes" node, not thirty). Leave out leaf utilities, types, and config that don't shape a flow. The real test: the columns fit on one screen without scrolling. If they don't, you have too many nodes.

Accuracy rules:

- Every node must map to a real thing in the repo — a file, folder, table, or named external service. Put the real path in the node where one exists. Never invent a component you haven't seen.
- Flows must trace real call paths. If you are unsure whether a step happens, ask me or record it — a doubtful hop goes in that step's `detail`, a broader assumption goes in `meta.notes`. Don't draw an edge you can't justify.

Work the stages as a draft-then-confirm loop: if you have the codebase, present what you already found at each stage and ask me to correct it, rather than asking from a blank slate.

## Stage 1 — Components (nodes)

- List the distinct parts you found, grouped by role: actors (users, external callers), client surfaces (apps, pages), server code (routes, functions, services), data stores (tables, buckets, caches), background work (jobs, workers, queues), and external services (third-party APIs).
- Give each node its real path or identifier in the repo (file, folder, table name, package), and assign it one of these category ids: `actor`, `client`, `server`, `data`, `job`, `external`. Flag any you're unsure of so I can correct them.

## Stage 2 — Flows

- Propose the representative end-to-end flows worth highlighting — 4–8 that explain the system, not every endpoint (e.g. "user saves a record", "webhook arrives", "scheduled job runs", "new user signs up").
- For each, lay out the ordered steps you traced: which node calls which, what triggers it, and what data is passed at each hop. Mark any hop you inferred but couldn't verify.

## Stage 3 — Confirm

- Did I miss any component or flow that matters, or get one wrong?
- Which flow is the most important one to show selected by default?

After I answer, produce the following two files:

---

### 1. `system-graph.json`

A structured map of the system. Use exactly this shape:

```json
{
  "name": "string — the project name",
  "description": "string — one or two sentences on what the system is",
  "categories": [
    { "id": "actor",    "label": "Actor",      "color": "#e879f9" },
    { "id": "client",   "label": "Client",     "color": "#38bdf8" },
    { "id": "server",   "label": "Server",     "color": "#4ade80" },
    { "id": "data",     "label": "Data store", "color": "#fbbf24" },
    { "id": "job",      "label": "Background", "color": "#fb923c" },
    { "id": "external", "label": "External",   "color": "#f87171" }
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

- Use the six canonical categories above (`actor`, `client`, `server`, `data`, `job`, `external`) with the given colors — they read on a dark theme and keep maps consistent across runs. Drop a category only if the system has nothing in it; don't invent new ones.
- `edges` is the static architecture, shown faintly at rest. It must include every pair that appears in any flow step, plus the main structural links — so the resting graph already shows the real skeleton before any flow is picked.
- `flows[].steps` are the highlighted paths. Every `from`/`to` must reference a real node `id`. A flow may hit the same pair twice (e.g. request then response) — keep both steps.
- Keep node ids stable and slug-like so the map diffs cleanly when regenerated.
- Fill `meta.sourceCommit` from `git rev-parse --short HEAD` and `meta.generatedAt` with the current date.

### 2. `SYSTEM_GRAPH.html`

A single self-contained HTML file. Requirements:

- **No build step and no network.** Inline all CSS and JS. Do not load anything from a CDN — the file must render by double-clicking it (`file://`).
- **Embed the data.** Include the `system-graph.json` contents inline as `const DATA = { ... }` so the page is standalone. (The separate `.json` file is the agent-facing copy.)
- **Layout.** Render nodes in columns grouped by category, in the category order given. Head each column with its category label (don't rely on color alone to convey role). Each node is a labeled box; show its `path`/`detail` when present. Include a legend mapping each category to its color.
- **Flows panel.** A list of flows in a side rail (`id="flows"`). Clicking a flow highlights its nodes and draws its `steps` as numbered connectors between the node boxes. Dim the nodes and edges not in the selected flow so the path stands out.
- **Connectors.** Draw them as a single SVG overlay sitting above the columns. Compute each line's endpoints from the node boxes' on-screen geometry — anchor on each box's border facing the other box — and redraw on both window `resize` and `scroll` (or anchor the SVG to the scrolling container) so they keep tracking the boxes. Give each connector an arrowhead at the `to` end so direction is visible (a response step points back), and put the step number on a small badge at its midpoint. Colour each connector, its arrowhead, and its badge by the **source** node's category colour, so a step reads as "who is acting"; match the step-number badges in the Steps panel to the same colour.
- **Parallel steps.** When a flow has more than one step between the same pair of nodes (e.g. request then response), offset or curve them so the lines and their badges don't overlap — each step must stay individually readable.
- **Escape text.** Node and flow strings can contain characters like `[`, `]`, or `<` (e.g. `src/app/[id]/route.ts`). Escape them before inserting into the DOM so they can't break layout.
- **Steps panel.** When a flow is selected, show its ordered steps as a numbered list: `from → to`, the step `label`, and `detail`.
- **Clear selection.** A control that resets to the at-rest view (faint static edges, no flow highlighted).
- **Theme.** Dark, high-contrast, readable. Make the selected path obviously brighter than the resting edges.
- Select the flow named in Stage 3 by default.

Format guidelines:

- The two files must agree exactly — same nodes, same ids, same flows. Generate `system-graph.json` first, then embed it verbatim as `DATA` in the HTML; don't hand-edit either copy afterward, or they drift.
- Use real, verifiable names everywhere: file paths, table names, route paths, service names.
- Treat both files as generated artifacts: regenerating from the current code refreshes them. Note in `meta.notes` anything you assumed rather than verified.
- After generating, verify before handing over. If you can drive a browser (e.g. a headless one), open `SYSTEM_GRAPH.html` and confirm it renders, the default flow highlights, and the connectors track the boxes on resize/scroll. If you can't, do a static check: the HTML is well-formed, the inline `DATA` parses as JSON, every `from`/`to` id in `edges` and `flows` resolves to a real node, and every flow-step pair is present in `edges` (the rule above). Fix what's broken before handing it over.

---

> **Goal:** I open `SYSTEM_GRAPH.html`, click any flow, and immediately see the path through my system and what is passed at each step. The next agent reads `system-graph.json` and has a verified component-and-flow map of the codebase without re-deriving it.
