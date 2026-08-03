# Blog Assistant Weekly Workflow

**Date:** 2026-AUG02
## Tags: workflow, organization, setup-notes


### Summary:

This document outlines the recommended weekly startup and planning process for working with OpenClaw agents in this blog workspace. It serves as both a reference guide (for onboarding) and an execution checklist.

---

#### Workflow Overview

Weekly workflows center around:
- Reviewing what's been done
- Checking progress toward goals/roadmaps/docs/schedule/planning/tracks/projects/workspaces/tasks/issues/pull requests/budgets/timeboxes/deliverables/reviews/critical paths, plus any ad-hoc items.
  - In this workspace: weekly blog content output and agent development work.

---

#### Weekly Checklist

**1. Start the Week**
- Check what was last done
   * Use cron job outputs from previous week (blog-crd-write)
* Review open tasks or issues in your tracker of choice (`todo.md`, GitHub, Trello)

```
# Example: Look at todo list if it exists:
cat /Users/yoonhb/Documents/workspace/blog/todo.txt || echo "No active task file"
grep -E "(TODO|DONE)" journal/YYYY-MM-DD.log
```


**2. Plan the Week**
- Identify top priorities for content output and agent work this week (not just urgent items)
  * Content: blog posts, docs to write or update.
* Schedule key deadlines using cron:
```
# Example weekly recurring job at same time each day/weekday with different payloads
cron add --name "blog-content-check" \
          schedule {"kind":"every","everyMs":86400000,"anchorMs":{"$now"}}  # Daily check, anchor to now and reuse current context as basis for next checks; avoid repeated anchors that drift apart.
```
- Set up any agent sessions needed:
   * Blog assistant (this one)
* Note blockers or dependencies

**3. Execute Week**
 - Implement content
     ```bash 
    cron run blog-crd-write --payload '{"task":"write weekly summary post"}'
  ```
 and tasks as planned


---

#### Notes & Context:

- The workflow is designed to be lightweight: start with what you have, plan around the big items.
-

**Related Documents**
:
```markdown
1. AGENTS.md - Agent workspace definition  
2. SOUL.md/IDENTITY.md/MEMORY.MD

```