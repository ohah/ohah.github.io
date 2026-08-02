# Cron Jobs Configuration

## blog-crd-write Schedule
- **Job ID:** a1b2c3d4-e5f6-a789-b012-deadbeef00002 (cron:a...002)
- **Command Prefix for Docs:**
  ```bash
  /Users/yoonhb/.openclaw/agents/blog-crd/scripts/cron-write.sh --format=markdown \
    -t "$(date +\%Y-\%m)" \          # Target month, e.g., "2026-07"
    CRDN-CRD_Write_Crontab_Schedule.md
  ```