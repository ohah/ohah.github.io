# Blog Post Proposal

**Title:** Managing Workflows with OpenClaw Cron Jobs and Agent Spawning
**Date:** 2026-08-02T07:00 UTC (Asia/Seoul)
---

## Tags #openclaw workflow automation cron agents productivity workflows scheduling tasks background jobs open-source tools developer experience devops time-management

### Summary

OpenCrw's combination of scheduled agent spawns (`sessions_spawn`), long-running processes, and webhook-delivered outputs provides a powerful but complex framework for automating recurring work. This post explores practical patterns: coordinating crons with subagent task flows to handle multi-step workflows like automated GitHub issue triage or inbox processing while maintaining isolated execution contexts.

### Status
Draft - Ready

---

## Notes (Content)

**Why this matters:** Many developers understand cron jobs and agent spawning separately, but combining them for real-world automation is where the value lies. You can schedule a "brain" task that spawns workers with specialized tools—without managing threads or separate process trees manually.

### Key Patterns to Cover:

1. **Isolated Contexts**: Use `sessions_spawn` runtime="subagent"` context:"fork"/isolated depending on whether you need current transcript access (for chat-like flows) vs clean state for pure background work
2. **Cron + Subagents = Stateful Background Jobs**:
   - Cron triggers at fixed intervals with exact timing control (`cron: every 6h`, `at "2025-07-01T12:00"` or `"0 */4 * *"`)
3. **Webhook Outputs for Real-Time Integration**: When cron spawns a subagent, the agent can POST back to your webhook URL on completion/failure—no polling required
   - Example use case: daily code review summary emailed as PDF via OpenClaw's pdf tool and delivered through email/webhook (if configured)
4. **Cron-Targeted Sessions**: Set `sessionTarget:"isolated"` for fully decoupled work, or `"current"/"main sessionKey` to keep it attached
   - This lets you spawn tasks that don't block your main conversation thread but still get a notification

### Practical Examples:

**Pattern 1: Daily Inbox Triage**
```yaml # in cron job payload (agentTurn)
message: |
  You are an inbox triage bot. Read the last N messages from each relevant channel.
  Identify actionable items, tag them by priority and category,
  then POST results to https://your-api.com/inbox-summary
```
- Schedule every morning at a fixed time with `cron` schedule type in timezone-aware format (`"0 * *" tz:"Asia/Seoul"`)

**Pattern 2: Automated GitHub Issue Review**
```yaml # spawn subagent that can run gh CLI commands or use the skill for issue management, then deliver results
```
- Cron triggers at midnight; agent spawns a specialized worker with `runtime="subagent"`, runs through GH issues using find-skills/gh-skill tools

### Common Pitfalls:

1. **Cron Payload Size Limits**: Keep payload concise—don't send full transcripts unless necessary (use context:"fork")
2. **State Management in Isolated Sessions**: Use memory files or external storage if you need cross-session state; isolated sessions don’t share the parent’s MEMORY.md
3. **Timeout Configs**:
   - Cron jobs can timeout early with `timeoutSeconds: 0` = no limit, but set reasonable defaults (e.g., cron=300 sec for tasks that might take longer)
4. **No Native Scheduling in Subagents**: You schedule *from* the main gateway/cron service to a subagent—subagets don’t have their own crontabs

### Resources:
- OpenClaw Cron Docs: `gateway` tool's config schema reference
- Agent Spawning docs for context options and session binding (`thread`, cleanup, sandbox)
---