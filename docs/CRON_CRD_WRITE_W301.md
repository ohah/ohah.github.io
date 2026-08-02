# Cron CRD Write - Week #302 Entry

**Date:** 2026-07-31
---

## Tags: @blog-crd-writes weekly devlog cron task WXXX (#devlogs)

### Summary
A template and framework for the automated blog-CRD write workflow using OpenClaw's `cron` tool. This document defines how periodic content generation tasks are structured, tracked across weeks (W301+), updated in daily memory (`memory/YYYY-MM-DD.md`) after each run.

**Status:** Template | Notes:
1) One cron job per week generates a "Week #XXX" CRD entry.
2) Each weekly log captures context from `CRON_CRD_WRITE_W300` and previous weeks, plus any new tasks or lessons learned during that period (e.g., improved scheduling notes).
3) After writing the W301 document:
   - Create an empty template for next week: rename to `.md.bak`, then start a fresh file.
4) If you hit issues in your first runs—schedule drifts, content formatting mismatches with memory files—you can use this weekly log as place-holders/notes and later clean them up.

---

## Motivation

OpenClaw cron-driven writes should be reliable over multiple weeks. I needed:
- A structured way to iterate on the workflow each week.
- Daily notes in `memory/YYYY-MM-DD.md` for continuity (not raw logs, just key events).
- Clear separation between weekly CRD documents and daily memory updates.

This template supports iterative improvement of OpenClaw cron-driven blog writing without losing context or overwriting previous entries. It also ensures the first actual W301 entry can be written cleanly using this pattern as guidance rather than a separate scratchpad file that doesn't belong to `docs/`.

---

## Workflow Rules (Each Cron Run)

### 1) Determine Which Week's Entry Exists

- Check if `{WXXX}.md` already exists in `/Users/yoonhb/Documents/workspace/blog/docs/crds/CRON_CRD_WRITE_W301.md`.
- If it does, read that file and:
  - Use its content as the base for this week.
  - Update `memory/YYYY-MM-DD.md`: "Updated W[...] with [quick note]" only if something changed (e.g., improved instructions).

### 2) Write/Update One CRD Document

- Template: Start from `/Users/yoonhb/Documents/workspace/blog/docs/crds/CRON_CRD_WRITE_W300.md.bak` as reference for expected fields.
- Format:
  - Title | Date tags summary status notes
    (if no template exists in `docs/(crd|CRON)/`, fall back to standard CRD format)
  
### Update Daily Memory After Each Doc

Capture only key events/decisions; skip filler. Example:

```markdown
## Events & Context Updates on YYYY-MM-DD:
- Updated W301 cron workflow notes.
```

---

## Input Variables (From Cron Payload)

Each run receives a message payload like this example format, but the exact details can vary by scheduler or context.

Example from real-world OpenClaw usage in `/Users/yoonhb/Documents/workspace/blog`:

> Read `CRON_CRD_WRITE.md`, generate ONE content item based on:
>
>> 1) Weekly cron-driven writes for blog CRDs.
>>
>>> - Use templates where available (e.g., existing WXXX documents).
>>>> + Create new weekly entry template if none exists yet.

The agent must adapt to whatever payload is sent and use its own judgment. No two payloads will be identical—the format below provides structure, not a strict schema that cannot change over time.
---

## Lessons Learned / Improvements (W301)

- Initial runs may have drift between the scheduled cron job (`CRON_CRD_WRITE.md` in `/Users/yoonhb/Documents/workspace/blog/`) and what is actually written to `docs/CRON_CRD_WRITE_WXXX`. Use weekly logs as reconciliation checkpoints.

  - Example fix: after writing W300, run a quick sanity check:
    ```bash
      find /path/to/docs/crds | grep "CRON.*W3[01]"
     ```
    
- Keep daily memory updates minimal—only include decisions that matter for future reference (not step-by-step procedural notes).

---

## Related

-