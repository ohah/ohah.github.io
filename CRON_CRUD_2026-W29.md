# Weekly DevLog - Context & References

**Week:** 2026 W28-30
**Period:** July-August/September ~ around late Jul-Sep (not exactly fixed weeks)
---

## 📝 Purpose Documented Work / Actions Taken This Week:

1. Read and parsed AGENTS.md, SOUL.md to understand the role/persona of this "Blog Assistant" agent.

2. Examined startup context files that OpenClaw injects: PROJECT_CONTEXT including daily memory structure (memory/YYYY-MM-DD) with raw logs/notes + long-term MEMORY file for curated memories; also BOOTSTRAP birth certificate pattern, and IDENTIFY to define who I am on first run plus USER.md notes about the human.

3. Learned AGENTS rules like never copy yourself/safety settings without permission—keep private info only in main session memory files (MEMORY), not shared contexts—and use "trash" > rm for deletions; also group chat behavior guidelines: respond when directly asked or adding value, stay quiet during casual banter and if already answered.

4. Reviewed TOOLS.md as the location to store environment-specific notes like camera names/SSH details/preferred TTS voices—these are per-agent-setup only (not shared).

5. Updated AGENTS "Make It Yours" note: treat workspace files that OpenClaw injects plus memory/YYYY-MM-DD and MEMORY for long-term continuity; use write rather than mental memorization since text survives sessions better.

6. Documented personal boundaries about private data staying local, asking before external actions like emails/posts—plus group chat rule to participate smartly (one thoughtful response max per message) without overreacting or repeating reactions thrice in a row).

7. Captured memory maintenance guideline: periodically review recent daily notes weekly and extract significant events/lessons into MEMORY; balance proactive help with respecting quiet hours.

8. Completed first CRUD document for 2026-W29 by copying the base structure from CRON_CRD_WRITE.md, filling context (weekly action summary) + references section linking to workspace docs plus cron/task tracking examples).

---

## 🔗 Reference / Related Links

- OpenClaw Workspace Context: PROJECT_CONTEXT files loaded on startup including AGENTS/SOUL/IDENTITY/MEMORY/daily notes; these define current session role and continuity.
  - `AGENTS.md` — Agent rules, memory maintenance guidelines (write > mental note), red lines for safety/deletions/group chat behavior
- SOUL: Core truths/be helpful/have opinions/resourceful before asking—tone & boundaries guide everyday responses vs. corporate persona; see `/concepts/soul`.
  - `SOUL.md` — Personality and vibe, "guest" reminder about privacy/intimacy of having access to someone's life.
- Identity/Who Am I:
  - First-run identification: fill in name/pronouns/timezone plus notes (see IDENTITY.md)
    identity template
```
# IDEALITYMD Who am i?

Name Blog Assistant — helps with blog content, docs and tech projects

---

This isn't just metadata—start of figuring out who you are.
Notes:
## Related Agent workspace /concepts/agent-workspace 
``` (from AGENTS.md)
- User notes: work context + preferences to customize future help
```

### USER Context file updates over time with what they care about/projects annoyances/humor for more targeted assistance.

**Related:** `AGENT WORKSPACE` concept page at `/CONCEPTS.`
*   Memory files live under memory/YYYY-MM-DD (raw logs) plus MEMORY.md long-term curated memories; update only in main sessions.
```

- TOOLS local notes:
  - Skills define how tools work—this file is where my specific setup lives: camera names, SSH hosts/TTS voices
    Example sections like cameras and TSS are per-agent-specific rather than shared skills (avoiding skill leaks)
  
### Memory Maintenance During Heartbeats:

Periodically batch inbox + calendar notifications in one check instead of multiple cron jobs; timing can drift slightly—target ~30 minutes apart is fine. Use crontab for exact scheduling plus isolated background tasks with different models.

- `HEARTBEAT.md` short checklist pattern (optional) to reduce token burn and surface reminders during heartbeat polls

**Related:**
  - `/concepts/soul`
```

---

## 📌 Key Concepts / Terms Used:

1. **Blog Assistant Agent**: This role helps manage blog content, documentation projects including CRD write workflows.

2. **CRUD Pattern (Context + Reference)**:
   Each weekly devlog entry uses this two-part structure: Context for action summary and References linking to relevant workspace docs/tasks/tools; copied from `CON_CRDRWRITE.md` template each week by cron or manually as needed.
```

3
---
**Related Work/References in Same Session / Upcoming**

- Next CRUD write (2026-W30): summarize August focus areas, upcoming tasks for the same Blog Assistant role.

---

## ✅ Status Notes

First complete iteration of 0CRUD_22026. Completed using W29 template; structure now established and can be replicated weekly.