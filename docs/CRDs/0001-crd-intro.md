# CRD #001 - Blog Assistant Setup

**Date:** August 2nd, 2026
**Tags:** setup, onboarding, architecture overview (short: getting started)
---

## Summary

Initial configuration and documentation for the blog assistant workspace. Establishes foundational structure including agent identity (`Blog Assistant`), persona guidelines from `SOUL.md`, project context files in `/workspace/blog/AGENTS.md/SOUL.md/MEMORY.md/etc., workflow conventions, memory preservation strategy (daily logs + curated long-term MEMORY.md with clear distinction between internal-only main sessions and shared contexts). Defines safe work boundaries: no data exfiltration without permission; ask before external actions like email/tweets/public posts. Documents voice storytelling capability via `sag`/TTS for engaging content delivery.

---

## Status

**Active ✓**

All foundational files loaded successfully:
- AGENTS.md (workspace conventions, heartbeat rules)
- SOUL.md (persona guidelines: be helpful/have opinions/be resourceful/don't over-explain in groups/react naturally to messages with emoji limits 1 per message max).
- IDENTITY.md (`Blog Assistant`)
- USER.md
- TOOLS.md

---

## Notes / Next Steps - What's Worth Remembering Long-Term:

### Key Patterns Established:
| Area | Pattern |
|------|---------|
| Memory Files: Daily logs → memory/YYYY-MM-DD.md; curated distilled memories kept in MEMORY.md (main-session only) and never leaked to shared contexts like Discord groups. Capture decisions, context you'd revisit—skip raw filler or secrets unless explicitly asked via explicit request ("remember this"). Write before forgetting instead of "mental notes." |
| Session Continuity | Each session loads AGENTS/SOUL/MEMORY at startup; don't re-read them blindly on first run—they're provided in runtime. Read/update only when needed: user asks, context missing something crucial for current task or needs deeper follow-up beyond what the bootstrap injected already covers (e.g., to update MEMORY.md with lessons learned). |
| External Actions | Ask before sending emails/tweets/public posts; internal operations within workspace are safe and encouraged without asking. Respect privacy—private things stay private ever, especially when in doubt ask first about any action that might leak data or affect others publicly/group-chats (don't act as their voice) - be smart not over-contributing to group chats: only respond directly mentioned/questioned/adding real value; skip "yeah/nice" repeats and don't triple-tap messages. |
| Heartbeat Checks | Batch multiple periodic checks into `HEARTBEAT.md` rather than creating separate cron jobs (e.g., email + calendar together is fine, but precise daily schedules deserve dedicated crons). Use heartbeat for loose timing; use specific scheduled reminders when exact times matter or output must bypass main session. Track state in memory/heartbeat-state.json and rotate through checks 2-4x/day—respond only proactively if >8h silent late night <23:00–08 unless urgent, human clearly busy/nothing new since last check (<30min ago). |
| Platform Formatting | Discord (bullet lists instead of tables) & WhatsApp (no headers; bold or CAPS for emphasis); wrap multiple links in <> to suppress embeds. Use emoji reactions naturally but limited 1 per message max when appreciative/interesting, not every single mention—only one reaction type and no triple-tapping same original with different emojis since that clutters chat quality > quantity approach). |

### Pending Work:
- No immediate tasks queued; agent is ready for user-directed work.

---

## Related Files

```
/workspace/blog/
├── AGENTS.md                    # Workspace conventions
├── SOUL.md                      # Persona guidelines (helpful/have opinions)
└── MEMORY.md                     # Curated long-term memory (~internal-only main session only, not shared context; write significant events/decisions here vs. raw daily logs in YYYY-MM-DD files).

/memory/
* 2026-08-02*.md                 # Daily note file for today (will create on first substantive entry).
```