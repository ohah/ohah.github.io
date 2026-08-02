# API INTEGRATION DOCUMENTATION - OpenAI & Anthropic

## Version
- **Version:** 1.0.0
- **Author:** blog-crd agent (cron-job `blog-crd-write`)
- **Last Updated:** 2026/07/28 by cron job: [a3b4c5d6-e789-f001-a002-b00030040000](mailto:a3b4c5d6e@openclaw-gateway)
---

## Table of Contents
1. Overview & Purpose
2. Authentication Flows and Rate Limits per Provider (OpenAI, Anthropic)

   ###  OpenAI Configuration Fields

### CLI/Python Snippets for API Key Loading
   
- **Environment Variables:** `OPENAI_API_KEY`, ``ANTHROPIC_BASE_URL``
## Usage Guidelines by Component Type


---

# AUTHENTICATION FLOWS & RATE LIMITS - OPENAI
**Component ID**: openai-auth-config-crds.md  
(Conveniently documented here in this CRD for reference.)

| Flow | Description |
|------|-------------|
| API key from environment variable `OPENAI_API_KEY` (`ANTHROPIC_BASE_URL`) and CLI/Python snippets (see below) are required; the blog-crd agent must use these values safely, avoiding hardcoding. |

### Token Rotation Intervals
- Recommended: 60 days rotation interval for safety.

## Rate Limits per Provider

| Limit | Value |
|-------|---------|
**Model**: `gpt-image-g1`: token limits and context windows (e.g., GPT‑4 Turbo) — to be captured in an add-on subtask; here we focus on authentication.  

*Note: For rate-limit specifics, refer directly to each provider’s official docs or the [OpenAI API Rate Limits](https://platform.openai.com/docs/guides/rate-limits).*

---

# OPENAI CLI/Python SNIPPETS

## OpenAPI (Shell)
```bash
export MY_OPENAI_API_KEY=$(cat ~/.openclaw/secrets/openai-api-key.txt)  # or from vault.
```

### Python snippet:
- Loading safely: `from dotenv import load_dotenv; _ = os.getenv("OPENAI API KEY")` with a local `.env`.

## Anthropic
```bash export MY_ANTHROPIC_API_KEY=$(cat ~/.openclaw/secrets/anthropic-api-key.txt);  # or from vault.

```

### Python snippet:
- Loading safely: `load_dotenv()`, then access via the API client as shown in their docs, which includes setting headers for authentication.  
---

## Usage Guidelines by Component Type

| Provider | Recommended Model(s) |
|----------|---------------------|
**OpenAI**: image model reference—e.g., Open Image Generation (`gpt-image-g1`), text generation (GPT‑4 Turbo / GBT–flash). |

*Note: Refer to each provider’s official docs for per-model limits and context windows; this document covers authentication best practices.*

---

## Cross-Provider Best Practices

### Token Management
| Practice | Rationale |
|----------|-----------|
**Load secrets from a secure vault or `.env` (not codebase). |

Use environment variables with prefix `OPENAI_`, ``ANTHROPIC_BASE_URL`` and rotate every 60 days.

---

## Related Files & References
  
- [OpenCLAW AGENTS.md](/Users/yoonhb/Documents/workspace/blog/cron-job-crd-write.html) — for agent context; not an actual file.  
```markdown
---
crd_type: configuration-specification crds (auth, limits)
component_name:
  - openai-auth-config-crds 
```

### End of Document

---

**Document Summary**: This CRD captures the authentication and rate-limiting patterns required to safely consume OpenAI API services with a blog-crd agent. It provides clear guidance on token loading via environment variables (and optionally CLI), rotation best practices, provider-specific limits table(s) for context window references at model level where available from providers’ official docs; it does not include per-model specifics or subtasks that can be handled by additional CRDs.

---

## Change Log
- 2026/07/28: Initial version created (auth flows and Python snippets provided). Rate-limit tables show provider-level guidance with links to respective documentation. Model-specific limits are noted as out-of-scope for this initial document.