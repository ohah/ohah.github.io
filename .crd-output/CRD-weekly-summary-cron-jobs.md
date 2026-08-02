---
title: Using Cron Jobs for Scheduled Tasks in OpenClaw
slug: 2026-07-27-using cron jobs scheduled tasks openclaw-gateway-timers-periodic-execution-delivery-modes-at-every-schedule-types-webhook-nothing-none-or-push-to-chat-with-threading-and-targets-for-isolated-current-session-main-agent-turn-mode-systemEvent--webhooks
date: 2026-07-27T21:00Z

category:
 - getting-started tutorials intro beginner guide quickstart overview onboarding walkthrough setup process architecture concepts principles how-to faq troubleshooting common issues mistakes best practices tips tricks gotchas patterns anti-patterns examples demos use-cases scenarios workflows automation scripts commands terminal shell bash zsh fish powershell cmd windows mac linux tools utilities devops scheduling cron jobs reminders wake events heartbeat tasks background workers openclaw gateway
tags:
 - ollama llama glm gpt gemma anthropic google aws bedrock ai large language models machine learning data processing pipeline orchestration workflow automation task management scheduler time-based triggers periodic execution batch job event-driven architecture scheduled maintenance cleanup notifications alerts monitoring observability logging debugging development productivity efficiency operations system administration cron schedule at every
description: Learn how to use the gateway's built-in CRON tool for creating one-shot and recurring tasks with precise timing. Understand scheduling options (at, e.g., ISO timestamp; 'every' interval milliseconds from anchorMs or run); Cron expressions in wall-clock timezone-aware times—omit tz = host local time.

---

# Using cron jobs scheduled timers periodic execution delivery modes at every schedule types webhook nothing none push to chat threading targets for isolated current session main agent turn mode systemEvent webhooks

## What Are They?

Cron tasks are scheduler handlers that can run on-demand or by clock: one-shot reminders (at), recurring wall-clock schedules using expressions with timezone awareness, and interval-based "every" runs starting from anchorMs. Delivery modes push to announce for chat threads/targets; webhook mode posts finished-run events via delivery.to URL.

## Core Concepts

### Schedule Types
| Type | When It Runs |
------ ------------|
**at:** One-shot absolute timestamp in ISO format (UTC or with explicit tz). No repeat unless you make recurring using `every` anchorMs. Example: {"kind":"at","tz":null,"expr":"","staggerMs":{"default"}, "anchor Ms", etc; see doc for schema details.) |
| **cron** | Wall-clock cron expressions, timezone-aware (`0 */6 * *" = every 2h in the specified tz). You specify `zone` to target a specific IANA zone (e.g., Asia/Shanghai) and omit it defaults host's local time. Expressions use wall clock; do not convert from UTC first for scheduling logic |
| **every** | Interval-based recurring runs: define an interval (`kind="every"`, `"intervalMs"`), optionally anchor to a start timestamp via `anchor Ms` or let them run as soon-to-fire loops like "run every 30 minutes starting now". Use this when you need continuous periodic tasks (cleanup, background jobs) rather than one-off timing constraints |

### Delivery Modes
| Mode | Where It Goes |
------ ------------|
**none:** No push—job executes in the scheduler pipeline; not intended for async notifications or webhook integrations. Omit `delivery` to rely on default behavior without extra routing setup if no announce/webhook is needed (default local execution only) |

```
announce
Main session with systemEvent text + optional channel/to/threadId targeting isolated/current/session targets, respecting defaults like "isolated agentTurn" when not explicitly overridden in schema. Useful for human-readable output: send to chat channels and/or threads

webhook:
POST finished-run event via delivery.to URL (Slack webhook or HTTP endpoint). Set `delivery.mode="webhook"` + specify target; job fires asynchronously without blocking OpenClaw runtime
```

## Typical Use Cases, with Concrete Examples per Mode/Schedule Type:

- One-shot reminders: "remind me at 9am tomorrow" — schedule a cron task where payload.kind = systemEvent (text describing the reminder). For chat delivery set `delivery.mode="announce"` + optional channel/to/threadId; if you want silent execution and no output elsewhere, omit or use mode=none. Optionally also call wake now to trigger immediate next-run scheduling.

- Recurring tasks: "run this cleanup job every 30 minutes" — either schedule kind=cron (e.g., expr="*/15 * *" for hourly halves) with a tz of your preference; start it from an anchorMs or let the scheduler pick its first run. For more flexible interval control, use `kind=every` + "interval ms"; optionally set `"anchor Ms"` to specify when counting begins.

- Heartbeat-bound tasks: Use mode="announce" and scheduleTarget=current (or main/session) if you need chat updates as they fire; otherwise keep it isolated+mode=None for silent background runs that only trigger the agentTurn loop. The cron job itself can also send wake events back via `wake` with "next-heartbeat"/now.

## Example: Weekly Summary Cron Job
{
```

-- This section is cut off from original source due to length constraints.
```