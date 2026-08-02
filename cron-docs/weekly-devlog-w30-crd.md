# blog-WeeklyDevLog-CRD - Configuration Document

| Property | Value |
|----------|-------|
| Component Name | `cron` (W29/W30 weekly devlogs) via scheduled cron job; runtime=main session for human-facing context. Version: 1.0; Last Updated: **2026-W31** |

---

## Overview
This document defines the lifecycle, configuration patterns, and operational requirements of OpenClaw's managed Weekly Devlog Cron jobs that generate CRD (Configuration/Requirements Documents) each week in W29/W30+W.

Weekly devlogs are executed as cron events (`action=add`, `sessionTarget="current"`), create/update a file named `{week}-CRON-CRD.md` under the workspace, and populate it with context+references sections based on prior sessions/logs. Cron jobs also maintain heartbeat checks for email/calendar/weather updates that can be batched into these weekly summaries.

---

## Core Concepts

### Schedule Types
- `cron.daily`: Run via cron scheduler (e.g., at 22:00 local time or UTC)
* Example schedule entry:
```yaml
schedule.kind=cron; expr="0 */1 * *" tz=Asia/Seoul # Every hour for debugging, but only on certain days W29/W30+W.
```

- `cron.weekly`: Run via cron scheduler (e.g., at 22:00 Saturday or UTC)
* Example schedule entry:
```yaml
schedule.kind=cron; expr="0 * Sat *" tz=Asia/Seoul # Every day around midnight to prepare next week's template

---

## Lifecycle Phases"
1. Cron Job Registration (`cron add`):
   - Payload kind=`systemEvent`, sessionTarget=current, delivery.mode='announce'
* Example payload:
```json
{
  "name": `weekly-devlog-crd-w{week}`,
"schedule.kind=cron; expr="0 * Sat *" tz=Asia/Seoul,
```

2. Template Generation (Weekly template file creation):
   - Creates or updates a markdown document with placeholders for context and references.
* Example filename: `{YYYY}-W{n}-{CRON-CRD}.md` where n is week number.

3. Content Population:
- Cron job reads prior weekly summaries (`cron_jobs.md`, `HEARTBEAT_CHECKS.json`) to fill in Context section (prior events, tasks) with concise bullet points.
   - References include links/guides from your existing docs: e.g., `/Users/yoonhb/Documents/workspace/blog/CRON_CRD_WRITE_GUIDE.yaml`.

---

## Operational Requirements

### File Location & Naming
- Output files are stored under the main workspace:
  * Example path for W29 output (if you were to run today): `cron-docs/{week}-weekly-devlog-crd.md` or `{YYYY}-{W{n}}-{CRON-CRD}.md`.

---

## Testing Validation

1. Cron Job Run Test (`run action=add; jobId=...`) - Ensure cron triggers and generates the correct markdown with context+references sections.

2. Content Verification:
- Confirm file exists under expected path.
* Check that Context section includes prior-week summaries (e.g., `CRON_W001.md`, or memory/heartbeat-state.json).
   - Verify Reference links exist on disk (`read` returns content, no 404).

3. Integration with Weekly Template: Ensure weekly template contains correct placeholders for future expansions and can be re-used across weeks.

---

## Security Controls

### Data Handling
- Cron job logs only refer to internal session history; external data (email/calendar/weather) is not persisted in CRD files unless explicitly requested.
* No private user PII appears by design, as the file content focuses on aggregated summaries rather than personal messages or emails except for authorized system events.

---

## References

1. `cron_jobs_config.md` — Configuration and status tracking of cron jobs used throughout this workspace
2. `/Users/yoonhb/Documents/workspace/blog/CRON_CRD_WRITE_GUIDE.yaml`
