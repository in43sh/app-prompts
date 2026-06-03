# CLAUDE.md

This repo is a collection of structured AI prompts for kicking off and documenting software projects. There is no application to run — the "product" is the prompt text in `docs/` and the reference outputs in `examples/`.

## Layout

- `docs/NN-<type>-<variant>.md` — the prompts. `docs/` is the source of truth for prompt behavior and required output sections.
- `examples/<NN-name>/` — canonical reference outputs for each prompt. Must stay structurally aligned with the prompt that produces them.
- `scripts/` — validation. `validate.sh` runs `check-examples-headings.sh` (example files exist + have required `## ` headings) then `check-forbidden-patterns.sh`.

## Commands

```bash
./scripts/validate.sh   # run after any change to docs/ or examples/
```

## Conventions

- Prompts ask questions stage-by-stage — never collapse all questions into one block.
- Output document specs must be precise enough for an AI to implement without follow-up questions.
- Naming: `docs/NN-<type>-<variant>.md` (e.g. `00-kickoff-web-app.md`, `01-feature-spec.md`).

## Do not

- Do not change a prompt's output contract (required sections / produced files) without updating the matching `examples/` files in the same change.
- Do not add a prompt without also updating the table in `README.md` and the list in `examples/README.md`.
- Do not let `README.md`, `examples/README.md`, and the actual `docs/`/`examples/` contents drift apart.
