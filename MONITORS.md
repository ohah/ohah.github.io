# Monitors - Heartbeat Checklist

Run periodically (every few hours):

- [ ] Check email for urgent messages
  ```bash
  # Add your mail command here, e.g.:
  mutt -f inbox +NEEDSATTENTION FOLDER="Inbox" SEARCH=UNSEEN FLAGGED LIMITER=""
  ```
  
 or check notifications from configured services

---

## Quick Checks (rotate through these)

1️⃣ **Email** — Any unread/flagged?

2️⃣ **Calendar** — Upcoming events (<48h)?

3️⃣ **Weather** — Anything relevant for going out today?
   ```bash
   curl wttr.in/"your-location"
  ```

4. 📋 Write to `memory/YYYY-MM-DD.md` what happened

5-8: Repeat above cycle (rotate each time)

---

## Timezone Note  
Current timezone is Asia/Seoul.

If you haven't said anything in >24h, reach out and check on things.