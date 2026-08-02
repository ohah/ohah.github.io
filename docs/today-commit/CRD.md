# CRON_CRID_WRITE — Daily Blog Document Updates

## Purpose
This cron job (`blog-crd-write`) ensures that a daily summary document is written to the blog repository. It runs every 30 minutes (Asia/Seoul timezone) and creates/updating commit logs for each day.

**Cron Schedule:** `*/30 * * * *` in Asia/Seoul

## Workflow
1. Update today's metadata file (`docs/today-commit/_meta.json`)
2. Generate a daily summary document from git log commits logged on that date (if not already present)
3. Add the updated _meta to Git and commit with an appropriate message for docs.

**Last Successful Execution:** 2025-07-14 at ~1:51 AM KST

## Files Involved
| File | Purpose |
|------|---------|
| `docs/today-commit/_meta.json` | Daily metadata (author, active status) that is committed each day automatically. Updated by this script via meta-updater.zsh (`./scripts/meta-update.sh ohah`). |

**Note:** The commit log summary document itself currently **is not yet automated**, and must be generated manually when needed.

## Environment
- Workspace: `/Users/yoonhb/Documents/workspace/blog`
- Author/Owner of logs logged by this cron job is set to `ohah`

---

_This file was created automatically via blog-crd-write. Edit with caution._