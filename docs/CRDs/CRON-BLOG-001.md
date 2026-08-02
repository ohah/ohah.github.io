# Cron Job Setup for Blog Automation

**Date:** 2026-August-01
**Tags:** #blogautomation, #cronjobs, #workflowoptimization, #productivitytools,
        opensourceopenclawselfhostedpersonalprojectsetupdiarylearningcurvefirststepsfoundationspracticalimplementationgettingstartedwithstructuredworkflowsrecurringtasksautomatedreminderschorelistmaintenancecontentcreation

## Summary
This CRD documents the implementation and refinement of a structured cron-based workflow system for managing blog content creation, daily maintenance tasks (heartbeat checks), weekly summaries, and periodic automated operations. The goal is to reduce manual overhead while maintaining flexible control over recurring responsibilities.

The setup uses OpenClaw's built-in `cron` tool with configurable schedules (`at`, `everyMs/anchor.ms.evt.cron.tz.timezone`) targeting different agents or isolated sessions based on payload types (systemEvent vs agentTurn). It supports delivery modes like announce and webhook, failure alerting after multiple failures/cooldown periods per run.

## Status
✅ **Completed** - Production system deployed with weekly summaries enabled. Ongoing maintenance for task selection tuning as content priorities evolve across weeks/mo/year cycles; new CRDs added when expanding capabilities or refactoring schedules (see docs/crds/CRON-BLOG-00x.md).

---

### Notes

#### Context
After bootstrapping blog-crd agent with AGENTS-DAILY-CRON, subsequent runs accumulated files: WORKING/DAY/WEEKLY summaries in cron logs and CRD-style documents. Last updated by scheduler 2026-July30T15h27 UTC.

CRDS.md references this as a foundational reference document; each week adds new entries for expanded features (e.g., task triage, PR follow-ups). A separate entry at docs/crds/README-crdblog-setup-indexed-by-date-utc.yaml tracks the weekly sequence by date and tag categories. The CRON-BLOG category is further indexed in index.md under "CRD - Cron Job" → blog-crd-write cron tasks.

#### Implementation Details

**Tool Configuration (OpenClaw gateway + agent workspace):**
```
# Example job config structure:
{
  name: string,
  schedule.kind = at|everyMs/anchor.ms.evt.cron.tz.timezone
    or { kind, expr?, tz? }, // timezone omitted → Gateway host local; cron uses wall-clock time fields (no conversion to UTC)
  
}
```

**Schedules Used**
- At start of day: `kind="at"` with anchorMs = 6h Asia/Seoul ≈ +21k sec from now, delivering systemEvent heartbeats via announce for main session.
`deliver.mode=announce.channel/to/threadId/bestEffort.account.id`; note that thread-scoped chats rejected by sessions_send; target parent channel/session.

- Heartbeat checks: `kind="every"`, every 1.5 hours with anchorMs = now, delivering systemEvent heartbeats via announce for main session.
`deliver.mode=announce.channel/to/threadId/bestEffort.account.id`.

**Delivery & Targeting Rules**
SystemEvents bind to "main"; agentTurns default isolated unless overridden; payloads specify `sessionTarget`. Delivery modes include none/announce/webhook. Announces send message in chat channel when using announce delivery for systemEvent payload and target is main/session.

For announcements: optional threadId, bestEffort (default false), account.id overrides accountId if provided.
Failure destinations per-run or default via failureAlert with after/cooldownMs/includeSkipped/mode/channel/to/accountid. Example job config shows `failureDestination.channel` + `/to`.

#### Key Learnings
- Use explicit timezones when cron expr depends on wall-clock values; omit tz to rely on host local timezone (Gateway) instead of UTC conversion.
- Schedule anchor points must be expressed in milliseconds from now for everyMs/anchor.ms.evt.cron.tz.timezone, not static timestamps unless using "at".
- When scheduling recurring checks at the same time weekly/daily/hourly boundaries with jitter ("stagger" ms), consider edge cases on clock drift: a 1.5h periodic may slightly miss exact hourly alignment across weeks.
- SystemEvent payloads target main; agentTurn default to isolated but can override via sessionTarget=current/session:<id>.
`sessionKey="current"` for current-session binding in jobs that rely on the spawning request's active context (e.g., cron add during this turn).
Heartbeat vs Cron: Use heartbeat when multiple checks batch together and timing drift is acceptable; use exact-time schedules with per-run execution via `mode=due/force`.
- Delivery modes affect where outputs go. announce delivers to chat channel if configured, webhook hits external endpoints.
Failure alerting requires configuring account.id/channel/to/mode/cooldownMs after includeSkipped before run.

#### Files Created
This CRD and its related entries are tracked in docs/crds/. Example file sequence:
- /Users/yoonhb/Documents/workspace/blog/CRON_CRDS.md (index)
  - points to this doc via "Blog automation cron jobs" → "/docs/CRONS/BLOG-CRD-WRITE/indexed-by-date"
    where the index includes weekly entries linked by date and tag categories.
`Docs/crds.index.mda:0-50`.
CRON_CRD_WRITE.md at root defines a high-level task format with input context variables; subsequent CRDs follow that pattern.

#### Future Work
Tune heartbeat timing intervals based on actual inbox volume to avoid duplicate checks within ~30 minutes and minimize noise. Expand cron jobs for more complex flows (e.g., PR review triage, content drafts). Use webhook delivery or failure alerts when integrating with external project management tools.