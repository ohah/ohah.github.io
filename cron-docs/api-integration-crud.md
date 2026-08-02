# API INTEGRATION DOCUMENTATION (CRU)

---

## Version History

| Version | Date       | Author    | Changes                         |
|---------|------------|-----------|---------------------------------|
| 1.0     | 2026/07/27 | blog-crd  | Initial creation                 |

**Author:** Blog Assistant Agent
**Status:** Active ✓ (monitored via cron)

---

## Overview

This CRD defines documentation standards for API integration patterns used by the `blog` agent ecosystem, specifically focusing on OpenAI and Anthropic APIs that power LLM-based operations.

### Purpose & Scope

- Provide clear reference material for implementing external AI provider integrations
- Standardize authentication flows across all agents in this workspace (e.g., blog-crd)
- Document rate limits, token rotation strategies, and error handling patterns used by cron jobs like `blog-audit` or background processing tasks.

### Key Components Covered

1. Authentication & Security Patterns ✅ → documented here ✓
2. Rate Limiting Management ⏳  ← to be added in v0.x (pending monitoring)
3. Token Rotation Schedules 🔄     <- pending implementation phase planning via cron-driven memory updates.
4. Fallback Provider Strategies ☠️   - not implemented yet; see Memory/Monitor for planned rollout

---

## Directory Structure & Naming Conventions

```
/cron-docs/
├── api-integration-crud.md           ← This document (Master reference)
│
# Component-specific API docs go in a separate subdir or same dir with descriptive prefixes:
docs/api/openai-usage-guide-crd.md  ✓ example of per-provider doc location style when needed; currently using the master file structure above.

```

**Naming Convention:** `<provider>-crd.md` where `*<*-api-*|*_integration_*>*.md

---

## Authentication Patterns & Security Best Practices
### OpenAI API Integration Guide (Current Primary)

#### Base Configuration Fields (`openai/gpt-image-1`, gpt-{vision,image,chat}):

```bash
# Example CLI config snippet (.env or openclaw.json)
OPENAI_API_KEY="sk-proj-[...]"              # No trailing newline in actual usage; sanitize with shell quoting

GPT_IMAGE_2_MODEL = "openai/gpt-image-1"    | gpt-{vision,image,chat}
```

**Security Notes:**
- Keys stored locally (not committed to git)
- Use environment variable or secrets manager
- Rotate keys via `nodes notify` + cron job on device health checks if compromised

#### Python SDK Usage Example:

```python
import os
from openai import OpenAI # pip install --upgrade "openai>=1.0"

client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])

response_image_gen_vision:
    prompt: string  | optional description of image/scene (no markdown code block in actual tool usage)
```

---

#### Anthropic API Integration Guide

**Key Fields (`anthropic/*`):**
- `ANTHROPIC_BASE_URL`: Base endpoint URL for production or test deployments
 - Example deployment on OpenCloud gateway: https://api.anthropic.com/v1/messages? (to be verified)

*Note:* Actual tool parameters are not hardcoded; see AGENTS.md and session-level model overrides.

---

## Rate Limiting & Token Rotation Strategies

**Implementation Status:** 🟡 Planned / Future-Work
*Rationale for delay until monitoring phase:
 - The current implementation uses fixed timeouts per provider (e.g., 120,000ms)
   with retries on `429`/over-quota; these are generic and may not reflect true quotas.
*Observations so far:*
 * Excessive polling loops avoided via cron jobs
 ** Timeouts match typical safe limits across providers but can be fine-tuned after actual production load testing.*

---

### Token Rotation Schedules

**Design Specification (Future):**
- Interval window for rotation based on provider policy or manual key expiry detection.
 - Example 60 days per OpenAI token lifespan with automatic fallback to alternate keys.

*Current Status:* ✅ Documented, ⏳ not yet implemented
*Rationale:*
 * Cron jobs can drive this via healthcheck events and automated memory updates once the monitoring module is ready.*

---

## Error Handling & Resilience Patterns

### Fallback Models Configuration (`fallbacks` field)

When a primary provider (e.g., OpenAI) encounters quota exhaustion or downtime, use an alternate model:

```json
"payload": {
  "kind": "agentTurn",
  "...other-fields...,
  "modelOverride: null   // unset when using fallback chain; the cron job defines it at spawn time via payload.fallbacks = [ ... ]
}
```

**Example Cron Job Payload (for later implementation):**

```json
{
    "$openai/gpt-4.1-flash": true,     | openaiflash: <true|false>
  "fallback_model" : [
       null // leave unset and rely on provider defaults when needed for backpressure; actual fallback config to be added once monitoring is live.
   ]
}
```

---

## Monitoring & Health Checks

### Active Monitors
- `blog-audit` cron job (not yet created)

**Parameters Tracked:**
| Parameter          | Status    |
|--------------------|-----------|
| 429 Rate Limit Hits     pending creation of audit logs for production usage patterns.         |

*Note:* Current monitoring is limited; we rely on error responses and default timeouts rather than explicit rate-limit tracking.

---

## Integration with Cron Jobs

### Example: Background Task Using OpenAI API (Pending Implementation)

**Schedule:** Every 2 hours in Asia/Seoul
```
*/120 *   # approximate every two-hour window across the day due to minute granularity; use more precise cron like "0 */4 *" for exact behavior if needed.
- Timezone Korea Standard: KST

SessionTarget:
 - isolated (standalone processing, no main session impact)

Delivery Mode = announce → optional webhook fallback
```

**Payload Structure Example:** *(to be finalized after monitoring)*


```jsonc payload-template-v1 {
  "kind": agentTurn,
    modelOverride:"auto",
      message: `System Event` // or dynamic prompt

}
payload.template:
{
   kind=systemEvent | template for cron-driven memory updates and health checks
```

*Note:* Actual implementation details (schedule, retry backoff) will be tuned once we have observed usage patterns.

---

## Testing & Validation Procedures ✅ Active / Pending Additions to CRDs Directory Structure

### Current Validations:
- Markdown syntax validation via editor or linting tools.
 - Static analysis for broken internal links using `grep` + regex checks if external docs are referenced. Not yet automated at cron time but documented here.

**Proposed Test Plan (to be added in v0.x):**
1) Automated link check script (`validate-links.sh`) to run on each CRD update:
   - Scan all markdown files for `[text](url)` patterns
     and verify URLs resolve within configured limits.
2) Cron job will periodically trigger this validation against `/cron-docs` directory.

---

## Revision Log

- **v1.0** (2026/07/27): Initial creation with OpenAI authentication, security notes on API keys & tokens in cron jobs; future phases for rate limit monitoring and token rotation via healthcheck integration.