# How to Optimize Your Cron Jobs in Node.js & TypeScript

**Date:** 31 July 2026
**Tags:** #cron-nodejs-typescript-openclaw-performance-optimization-scheduling-tuning-timeouts-webhooks-delivery-modes-best-practices-production-ready-devops-background-jobs-job-metadata-payloads-retry-strategy-failure-alerting-context-messages-thread-id-channel-target-isolated-current-session-main-agent-turn-systemEvent

## Summary
A practical guide to writing robust cron jobs for Node.js/TypeScript applications using OpenClaw's CRON system, including payload types, delivery modes (announce/webhook), and scheduling strategies.

---

### Context & Background

You're building a modern blog automation agent with multiple background tasks. Your challenge: how do you schedule everything reliably while maintaining clean separation between main session logic isolated cron jobs?

This guide walks through the practical decisions we made when setting up CRON_CRD_WRITE.md itself, which orchestrates periodic content generation.

---

### Core Concepts

#### Job Scheduling Options (schedule.kind)

**1. `at` - One-shot absolute time**
```json
{
  "kind": "at",
  "at": "<ISO-8601 timestamp>"
}
```

Example: Send a reminder at exactly your next birthday:
{ kind=“a”, “t”: ”2027‑08·30T00..02 UTC” }

**2. `every` - Recurring interval**
```json
{
  "kind": "every",
  "anchorMs": <start_timestamp_ms>,
  "everyMs": <interval_in_milliseconds>
}
```

Example: Daily check at the same wall-clock time:
{ kind=“a”, anchorAt=”2026·08.01T00..02+09” }

**3. `cron` - Cron-style (local timezone)**
```json
{
  "kind": "cron",
  "expr": "<standard cron expression>",
  "tz": <IANA time zone>
}
```

Example: Daily at Shanghai local sunset:
{ kind=“c”, expr=”0,30 *..5 ..2 …7″ tz…”Asia/Shanghai” }

Key notes:

- No automatic UTC conversion for `cron`; express times in your selected timezone.
- Omitting the “tz” field uses Gateway host's configured IANA zone.

---

#### Delivery Modes (delivery)

| Mode | Use When |
|------|----------|
| **none** | Internal jobs, no external output required. The gateway discards payload after processing; safe for noisy internal tasks and non‑critical checks that can run silently in the background without human or webhook notification channels involved when delivered as systemEvent.

- `announce` (isolated/current/session)
  - Intended audience is a chat channel: sends to an optional target account, thread/topic.
    Suitable if you want humans notified directly but still inside main session flows and not external webhooks. You can optionally set delivery.channel or .to for specific destinations; the job itself does NOT run further tool calls.

- `webhook`
  - Send a structured event (payload) to an HTTP endpoint (`delivery.to`).
    Use when you need off‑platform notification, CI/CD integration, external monitoring systems like Sentry/Grafana/Datadog that require webhook payloads rather than chat announcements. Webhooks are fire-and-forget with optional bestEffort=true.

- Best practice: Keep delivery.mode="none" for isolated cron tasks unless an explicit human channel is required; keep the rest of your infrastructure independent from a single job’s output mode to avoid dependency on message‑tool channels or webhook providers being up at scheduled times. This aligns well if you want background jobs that run reliably even when Slack/Discord webhooks are temporarily unavailable, by using local chat announcements only where humans need visibility.

---

#### Session Target Modes

| Mode | When To Use |
|------|-------------|
| **main** (requires payload.kind="systemEvent") | System events injected into main conversation. Good for notifications and cross‑agent coordination if all components share a single logical channel flow; requires systemEvent kind, not agentTurn.

- `isolated` / `"current"`: Background job that runs an isolated sub-agent session with its own context window.
  - Requires payload.kind="agentTurn".
    Use when the task needs reasoning but shouldn’t block main conversation or pollute user-visible message history. You can bind to current at creation (`sessionTarget:"current"`) if you need immediate feedback.

- `persistent named` (e.g., `"isolated"`): Run once per scheduler trigger; no sessionKey set by default.
  - Use when a single-shot job doesn’t persist between runs: it starts fresh each time, making cleanup simple. This is the typical pattern for one‑shot checks and reminders where state shouldn't accumulate.

- Persistent named (`sessionTarget:"current"`): Binds to main at creation; useful only if you need immediate feedback on that trigger.
  - Only use when payload.kind="agentTurn" with an isolated/current/session target—so it doesn’t require systemEvent kind, unlike session.target=main. This binding is for cases where a background job must talk back immediately in the same channel.

---

#### Payload Types (payload)

| Kind | Content |
|------|---------|
| **systemEvent** - System event text injection
  `{ "kind": "agentTurn", ... }` → injects message as system-level note. Use for notifications that should appear without a user sender, and cannot be agent‑turn messages.

- `isolated`: Launch an isolated sub-agent with its own reasoning process.
    ```json {
      kind: “aT”, payload:
        { text:“Check the inbox…” }
     }`
  - This is useful when you want background processing but still keep everything inside OpenClaw’s system event flow rather than a webhook.

- `webhook`: The job POSTs JSON to delivery.to URL, not delivered via chat.
    Useful for CI/CD pipelines and external monitoring. Use only if your intent truly requires HTTP endpoints; otherwise stick with announce or none when using agentTurn/systemEvent inside OpenClaw's orchestration layer (announce is suitable in cases where a human channel needs visibility but you still don't want to route through webhooks).

- Best practice: For most internal jobs, keep delivery.mode="none" and payload.kind either "systemEvent" for pure notifications or skip the top-level “delivery” key entirely. Use announce only when humans must see something in chat (optionally channel/to/threadId). Reserve webhook/HTTP events as a last resort unless you need CI integration.

---

#### Failure Handling

- **failureAlert**
  - `after`: Number of consecutive failures before alerting.
    Default is to fire at the first failure; increase for noisy schedules like every-minute checks. You can also set includeSkipped=true so that skipped runs (e.g., time drift) count toward alerts.

---

#### Best Practices

- Always use ISO‑8601 timestamps in your code and configs—no manual string formatting.
  - Avoid UTC conversion when defining cron times; express wall-clock values directly as requested by the host timezone to avoid double conversions. Use IANA zones explicitly for critical schedules (e.g., Asia/Shanghai).

- Batch multiple checks into one heartbeat or a single scheduled run instead of creating many tiny jobs:
```json
{
  "name": "daily-heartbeat",
  "schedule":
    { kind: “c”, expr:"0 *..5 ..2 …7", tz… },
      payload.kind=“sE”,
        delivery.mode=”none”
}
```
- This reduces scheduler overhead and makes failure tracking simpler.

---

### Example Workflow

Let's walk through how we set up `CRON_CRD_WRITE.md` itself as a background job:

**1. Schedule frequency**
```json
{
  "name": CRON-CRD-WRITE,
    schedule:
      { kind: “c”, expr:"*/30 *..5 ..2 …7", tz… },
        sessionTarget=“isolated”;
          payload.kind="agentTurn";
            message..."Generate ONE blog post using docs/crds/* templates, update today's memory file with key events"
}
```

**Interpretation:**

- This job fires every 30 minutes at the same wall-clock time on our host (e.g., Asia/Seoul).
    - It launches an isolated sub-agent that has no access to prior message history in this channel.
        The agent runs independently, produces content using docs/crds/* templates and local memory files as needed.

**2. What we care about:**

- Reliability over frequency—once every 30 minutes is enough for most blog tasks (emails + calendar updates).
    - Use failureAlert with `after=3` to avoid noise from temporary hiccups.
        This pattern works well when you have a small set of critical checks that can tolerate occasional downtime without overwhelming your monitoring.

---

### Production Checklist

- [ ] Verify IANA timezone for every cron job (especially across servers)
  - Test schedule times against actual execution timestamps in `cron runs` logs; don’t rely on mental UTC calculations.
    Example: For a daily at Shanghai local sunset, test with explicit tz and confirm output timestamp matches expected wall-clock time.

- [ ] Set appropriate failureAlert thresholds
```json {
      after:
        3,
          cooldownMs…
}
```

---

### Links

This document is part of the blog-crd agent's documentation suite. See related docs in `docs/crds/` for specific content examples and templates used by this workflow.
