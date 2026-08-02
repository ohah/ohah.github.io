# Cron: Blog-CRD Write

## Purpose
Periodically process and generate/write content using blog-crd agent.

## Task Format (one per run)
- Read this file to understand the task.
- Generate ONE complete CRD-style document based on current context/requests below:
  - Use [docs/crds/*.md](./crd) templates where available, or write standalone markdown docs with clear structure: title | date tags summary status notes
    (if no template exists in ./CRON_CRDS/, fall back to standard CRD format)
- Update `memory/YYYY-MM-DD.md` after each doc if it contains useful updates.
  - Capture only key events/decisions; skip filler.

## Input Context Variables

Each cron run receives a message payload like:
> "Read this file and follow instructions. Create one content item based on: [details here]."

For scheduling without direct context, the agent will use its own judgment to produce relevant documents (e.g., blog posts in progress).

---

Last updated by scheduler at 2026-07-30T15:27 UTC.