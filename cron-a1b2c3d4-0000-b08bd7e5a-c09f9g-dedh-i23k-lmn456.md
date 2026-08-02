# CRWD Write Workflow — Mock crwdb

This is a minimal workflow for testing the blog post generation without requiring an external `crwd` agent. It uses simple topic selection and creates one article per run.

---

## Purpose:
Test cron-driven content creation with realistic mock data that mimics what would come from "CRWDB".

**Important**: This implementation does NOT depend on crwdb-agent; it implements a lightweight version of the workflow in this file itself, allowing testing without external dependencies. When ready to integrate real DB-backed topics later.

---

## Workflow:

1) Create or read `workspace/crd/topics.yaml` if needed.
2a Choose one topic from mock list (e.g., "git-basics", "markdown-tips").
3b If article already exists at `$KEY.md`, skip and notify as defined in CRON_CRD_WRITE instructions.

Otherwise create source file:
   a) Write `workspace/sources/$FILE.yml` with metadata.
      title = lowercase slug without slashes
         → crwd-title-from-source-${TITLE}
        topics.yaml example keys/topics to pull from

       YAML structure (mirrors real spec):
           _meta.title: <lowercase_slug_without_slashes>
            # CRWD meta for topic_key, value "$TOPIC_KEY"
             body_content.md = full markdown content of final post.

6) Write the workflow file as a reference; blog-crd agent will read sources/ and generate article via LLM + templates. The task parameter to sessions_spawn points here so it can understand what was prepared (though real implementation may use just source YAMLs).

7a Confirm completion: check output at `$KEY.md` in workspace/articles/.
   If missing after run ends, notify incomplete.

8c Delete temporary sources/* files afterward; keep only final articles/.