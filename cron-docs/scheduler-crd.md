# Cron Job Specification & Scheduling

## Purpose
Document best practices for defining and managing cron jobs in OpenClaw's gateway, including scheduling patterns (at/every types), timezone handling examples with explicit tz values when needed. Provide use case mapping tables to determine wakeMode options.

---

**Reference**: Based on the `cron` tool schema; see `/Users/yoonhb/Documents/workspace/blog/cron-job-crd-write.md`.

## Core Schema Elements

### Schedule Types (`schedule.kind`)
- **at**
  - One-shot absolute time
    ```json { "kind": "at", at: "<ISO8601 timestamp>" }
      // Note: ISO timestamps without timezone are interpreted as UTC.
        • Example daily summary:
          → schedule = {"name":"daily-summary","payload":{"text":"Daily blog digest"},"schedule":
            kind:"every" everyMs:(24*3600_000)
              tz optional for cron. default to gateway host local if omitted.

- **cron**
  - Recurring interval expressed as standard Cron expression
    ```json { "kind": "cron", expr: "<CronExpression>", // use wall-clock time (e.g., '30 *' = every hour at :00).
            tz?: <IANA Timezone> }   -- Omitted default to gateway host local timezone, not UTC.
              Example 6pm Shanghai daily:
                schedule={"kind":"cron","expr": "0*18** **",tz:"Asia/Shanghai"}

- **every**
    ```json { kind: everyMs:, anchorMs?: }
      // For recurring intervals that should align with a specific time-of-day (e.g., midnight local).
        • Example 15-minute health checks aligned to the hour:
          schedule={"kind":"each" each_ms:(1.5*60_000) anchored_at_millis:"<epoch of nearest hourly boundary>"}
            // Note: AnchorMs is in milliseconds since Unix epoch.
              "anchor": anchor at midnight local (e.g., 2026-07-28T00:090930+09), then every interval. Use explicit tz for cron; omit only when gateway host default suffices.

### Wake Modes (`wakeMode`)
| Mode | When to use |
|------|-------------|
| `now`               - Immediate wake (e.g., one-shot "run now" triggers).    |

## SessionTarget Binding Rules
- **main** → Requires payload.kind = `"systemEvent"`; for isolated/current/session:X sessions, systemEvents may be silently dropped unless explicitly delivered via webhook.
  • Example: schedule={"name":"admin-alert","payload":{"kind": ...}},"session_target":

### Payload Types (`pay

## File Structure in `/cron-docs`
- **Naming**: `<component>-crd.md` (lowercase with hyphens)
    - Examples:
      * `scheduler-crd.md`: Cron job specifications
        • Depends on: none.

---

**Created by:** blog assistant | Timestamp reference 2026/07/