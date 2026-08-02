# blog-session-management - Configuration/Requirements Document

| Property | Value |
|----------|-------|
| Component Name | `sessions_*` tooling suite (runtime=subagent, mode="run" vs "session") with optional context=fork for transcript retention. Version: 1.0; Last Updated: **2026-07-28** |

---

## Overview
This document defines the lifecycle and operational requirements for OpenClaw sessions used by this workspace's agents—specifically focused on session spawning (`runtime=subagent`, `mode="run"` vs `"session"`) with optional forked context (transcript), termination policies, cleanup behaviors after completion/timeout/cancellation.

---

## Core Concepts

### Session Types
- **Main**: Primary human-facing agent interaction in this workspace.
  - Binds to current session via runtime (`agent=blog-crd | host=YoonHB Mac Studio`) and optionally `mode="session"` if thread support is required. Not a subtype of "main/sub"—just the primary channel context.

*Note: The cron job's `"target":` values (like “current” or explicit ID) are scheduling identifiers, not runtime subtypes.*

- **Subagents**: Child sessions spawned for isolated task execution.
  - Default `runtime=subagent`
    *(Not an override of host/agent; inherits them from the caller context.)*

### Modes & Behavior
| Mode | Binding |
|------|---------|
| `"run"` (default) — one-shot, no persistent thread binding unless explicit via target or mode="session". Returns results on completion only.* |

- **Context Options**:
  * `context=isolated` → clean slate; default for non-fork tasks.
    *(No transcript inheritance.)*

* Note:* When fork is needed to retain the current call’s history, set context=`"fork"` explicitly (e.g., debugging or resuming). Omit otherwise.*

---

## Lifecycle Phases
- **Spawn & Bootstrapping** (`sessions_spawn`):
  - Context: `isolated`(default) vs `"fork"`
    *(No dedicated "parent_id"; the caller's environment is inherited at tool level.)*

* Note:* Subagents inherit allowed tools from current session (no separate inheritance mechanism). Use runtime/host/agent as configured in context.*

### Execution
- Tool Inheritance: Child inherits parent’s permitted `toolsAllow` list.
  *(No dedicated "parent_id"; the caller's environment is inherited at tool level.)*

* Note:* Subagents inherit allowed tools from current session (no separate inheritance mechanism). Use runtime/host/agent as configured in context.*

---

## Termination Policies
- Normal completion (`mode="run"`): Caller controls cleanup.
  - Default: process/system handles termination; caller can request explicit deletion via tool actions.

### Error Handling & Recovery

| Scenario | Behavior |
|----------|---------|
| Timeouts and retries |

* Note:* Subagents inherit allowed tools from current session (no separate inheritance mechanism). Use runtime/host/agent as configured in context.*

---

## Security Controls
- No long-lived persistent state beyond process lifecycles.
  *(No dedicated "parent_id"; the caller's environment is inherited at tool level.)*

### Context Isolation:
| Mode | Inheritance |
|------|-------------|
| `"isolated"` → clean slate, no transcript (transient). |

---

## Testing & Validation
- Confirm successful spawn: `subagents list action=list` with recentMinutes=10.
  *(Wait for tool completion event; do not poll indefinitely.)*

* Note:* Avoid infinite loops on subagent status polls—use sessions_yield once and rely on push completions.*

---