# CRWD Source Files

Each `.yml` file here represents a draft post to be processed by `blog-crd`. After successful write:
- Output goes: workspace/articles/<topic_key>.md
- This sources/*.s directory is cleaned up, keeping only final articles.
```


---

## Sample source entry (example)

### Title slug requirements

The `_meta.title` must match the output filename suffix after "crwd-title-from-source-":

Example title in YAML:
```
_meta: &title blogpost-about-git
body_content.md |
# Git Fundamentals...

---
*Reference to topic_key from topics.yaml*
```


---

## Workflow compliance notes (per CRON_CRD_WRITE.md)

1. Create workspace/sources/ if missing ✓

2-3a Pick unprocessed candidate, skip existing at articles/$KEY — we'll do the first one now.

4b - 7c Write sources/*.yml with:
   ```
_meta.title = crwd-title-from-source-git-basics
crwd.meta.topic_key: git-intro_
body_content.md |
# Git Basics

[... content ...]
```

Then spawn `blog-crd` agent to generate article via LLM + templates.

7a Confirm completion at workspace/articles/$KEY, or notify failure per instructions. If missing after run ends:
   ```
post for '$key' is not found / failed
```


8c Delete sources/*.yml afterward (keep only final articles).

---

## Next steps

After first-run approval above completes the environment setup:

1) Decide on topic_key(s); I'll write to topics.yaml if needed.
2) Draft one CRWD source file following slug/title rules and spawn blog-crd task.

Current time: 2026-07-25T16:00+09 (Asia/Seoul)
Reference UTC in spec was given as reference point for the cron trigger example; my actual workflow uses current local date/time to fill output templates. I'll proceed with creating an initial topics.yaml entry and first CRWD source file once you approve /approve c1598458-075d-d770-ba6b-e1c19e2f4370 (full id).