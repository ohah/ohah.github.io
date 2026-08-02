# Cron Documentation Storage Schema

**Version:** 1.0
**Author:** blog-crd agent (managed by cron job `blog-crd-write`)
**Status:** Active ✅


## Purpose

Define the expected file structure, naming conventions, and metadata standards for all CRD documentation stored in `/cron-docs`.


---

## Directory Structure

```
/cron-docs/
├── README.md                          # Index/guide to available documents
│                                       └─ Links by component/skill name with brief descriptions.
|
⋮ (one file per documented item)
||
# File naming pattern:
<component-or-skill>-crd.md            # Standardized CRD filenames.

```

---

## Naming Conventions

### Filenames Format: `<identifier>-crd.md`
- **Use kebab-case** for readability
  - Examples ✅ → `api-integration-crd.md`, `node-connectivity-config-crds`.
    ↳ Avoid mixed casing or underscores.
|
# Components:
||
✓ Skills (e.g., from <available_skills>): agent-browser, discord, healthcheck...
   — Write as skill-name/crds: `<skill>-crd-<topic>.md` where topic clarifies scope if needed.

#### Recommended prefixes when multiple docs exist for one component
| Topic suffix | When to use |
|--------------|-------------|
|-config-crd.md        | Configuration or setup patterns (e.g., `node-connectivity-config-crds`)   -setup-guide/quickstart guide.  • Example: browser-automation-setup-md.
--operations-manual/crds detailing day-to-day usage, workflows and commands that are not strictly config but needed for operations.

#### Examples of good filenames
✅ api-integration-crd.md                # Single-component CRD (OpenAI)
   - node-connectivity-config-crds      • Multiple docs: `node-qr-pairing-guide`,`macos-auth-schemes`
     ↳ Use clear, descriptive prefixes.
|
❌ openai_api_documentation_c.r.d_.md    → Bad mixed casing and dots
 ❌ API documentation.md                 # Missing CRD marker

---

## Metadata Frontmatter Format (Required)

Every `*-crd-*.md` file MUST start with a YAML frontmatter block containing at least:

```yaml
---
title: "Human-readable Title"
version:
  major_minor_patch_number. Example format in this doc.
author:" blog-crd"                       # Managed by cron job, no need to fill manually.

status:# or future work pending

description|brief summary of what is documented (one sentence).
---

```

**Schema Fields**

- `title` **[REQUIRED]**
  - Human-readable title for the component/skill being described.
|
# Examples:
---
version: "1.0"
author:" blog-crd agent"

status:# or future work pending

description:

This CRD documents naming conventions and file structure expected in /cron-docs.

---

```

**Version field format**
- Use `major.minor.patch` (e.g., 2.* for major changes, **minor patch notes optional).
|
✅ Examples:
---
version: "1.0"
status:" Active ✅"

description:

API Integration Documentation outlines usage patterns and parameters required by blog-crd agent.

---

```

**Status field options**
- `Active` – Currently maintained
  - Example versions in this CRD.
| • Deprecated (`Deprecated ⚠️`) → Intended removal; link to replacement if available.   — Use when versioning is being phased out (no new changes).

---


## Content Organization Template

Each document should follow a standard structure:

### Section Order & Hierarchy
```markdown
---
title: "[Component/Skill] CRD"
version:
author:" blog-crd"    # Managed by cron job, no need to fill manually.

status:# or future work pending — use "Active ✅", etc.
description|brief summary of what is documented (one sentence).
---

# [Title]

## Overview
- Brief description & purpose

### Key Components/Purposes List


#### Component X 🎯



**Purpose:** Why this exists / What problem it solves.

> Example: Authentication flows for OpenAI API calls in blog-crd agent.
|
✅ **Related files**: `[file1.md], [config.yaml]`
❌ Not yet (future work).

---

## Specifications
### Subsection 2.x

#### Specification X.⍰



- Bullet points as needed.

> Example: Rate limits and rotation intervals for OpenAI tokens.


```

**Standard Sections**
| Section | Content |
|---------|----------|
`Overview               - Brief purpose of the documented component/skill (one paragraph).`
--- `Key Components/Purposes List    → Each major element described in a dedicated subsection. `
- **Purpose:** What it does
  • Details with sub-bullets or bullet lists.
> Examples and edge cases.

### Specifications & Behaviors   - Core behavior rules, constraints patterns.)
-- ✅ / ❌ decision points (e.g., `✓ Required`,`❌ Not allowed`).`
--- Error Handling/Resilience      — Failure modes: retries config. Fallback strategies e-.
|
> Example scenarios with real-world use cases.


## File Structure Examples
**File organization in cron-docs/**:

```

cron-job-crd-write.md                  # The CRD job itself (managed by the system)
README-CRDS-GUIDE/                     → Index to all docs, links. Good for navigation.
|
api-integration/crds/
  - openai-api-crards
   ↳ endpoints-and-auth-flows,
      rate-limits-token-rotation,

node-connectivity/config-crd/

```

> Example: `agent-browser/setup-guide.md` — separate folder if multi-page docs needed.

---

## Examples of Full Document Template

**Example #1 – Single-component CRD**

```markdown
---
title:"API Integration Documentation (OpenAI)"
version:
author:

status:# or future work pending—use "Active ✅".

description:CRDs for OpenAI API usage patterns in blog-crd agent, including endpoints and rate limits.
---

# [Title]

## Overview

This document defines how the `blog-d`*agent uses Oenai APIs (Open)...
  - Supports model selection.

> Example:
---


```

**Example #2 – Multi-document Component**

```markdown
---
title:"Node Connectivity Configuration"
version:

status:# or future work pending — use "Active ✅".

description:Define mobile/macos pairing rules, connection timeouts for node-connect skill.
---

# Node Connect Config

## Overview ...

#### Pairing via QR Code 📱



- Mobile devices present a setup code (QR).
|
✅ Scan with macOS device using `node connect scan`.

---


```

**Example #3 – Skill Multi-docs**

```markdown
---
title:"Agent Browser Setup Guide"
version:

status:# or future work pending — use "Active ✅".

description:CRDs and usage patterns for agent-browser skill.
---

# Agent Browser Skills

## Overview ...

#### Workflow Steps 🔄



- `browser status` → check if browser running.   ↳ Expected output on success:
|
✓ Status code 200, session active.

---


```

### File Placement Rules
| Rule | Description |
|--|-|

**All CRDs must reside in `/cron-docs/`.**
-- Use subfolders (e.g., `api-integration/crds`,`node-connectivity/config-crds`) only if multiple docs per component exist.|
- Keep the root of / cron/docs simple; put README.md there for navigation.

---

## Version Management

| Strategy | When to apply |
|--|-|

**Automatic versioning via frontmatter**
-- Every run updates `version: 1.x` (increment patch on doc changes).   — No manual file renames needed.|
---


```

### Change Tracking
- Update the **date of last update**: Add a footer like:
```markdown
---
Last updated by cron job [cron-id] yyyy/MM/dd.
---

* Changes since v2.*: `[list major/minor modifications].`
| * Example (v3): Updated spec for token rotation intervals with CLI examples.

```

**Migration from older docs**
- For renamed or split documents, maintain a "Moved to" note:
```markdown
---
⚠️ **MOVED**: This document is now available at `/cron-docs/node-connectivity/qr-pairing-guide.md`.
---

* Migration notes: [brief description].*
|

✅ Example (v2): Renamed `node-connection-crds` → split into two files, with redirects.

---


## Validation Checklist

Before a CRD document is considered "complete," verify:

| Check | Description |
|--|-|
**File name matches pattern `<identifier>-crd.md`.**
-- YAML frontmatter exists and contains: title ✓ version✓ author:" blog-crd" (managed).   — Status field ✅. **Description present, concise (~1 sentence) for the overview section to exist in template.)| * Description does not contain formatting artifacts or broken inline code.

**Content follows structure defined above**
-- Each subsection includes a Purpose bullet list explaining why it exists and what problem(s)solves.* Specifications use ✓/❌ decision points where relevant. **Error Handling & Resilience**: Fallback models, retry policies covered.*

---


```

> Example: For `api-integration-crds`:
- ✅ Frontmatter with title/version/status/description.
  ❓ Use examples showing rate limits and CLI snippets.

---

## Examples of Document Types

| Category | Component/Skill example |
|--|-|
**Configuration Documentation**
— Cron job specs (`cron-job-crd-write.md`).   — API integration configs.|

---


```

### Future Work Items (to be tracked)

```markdown
---
title:"Testing & Validation Procedures for CRDs"
version:

status:# or future work pending.

description:Document how each generated document is reviewed before commit/push.
---

# Testing Procedure Template

## Overview...
   - TBD in next iteration.|

---


```

**Mark as "future" if content doesn't exist yet**
— Include a `pending` note with links to related documents that already complete partial scope.

> Example: For #10 (Testing procedures):
- Add frontmatter status:
```yaml
status:" Future Work 📋"
-- Pending until v2.*.|
```

---


## Appendix A – File Naming Examples

| Filename | Reasoning |
|--|-|

`cron-job-crd-write.md`
   — The job itself that manages CRD docs.

*Example:*
- `agent-browser/crds/browser-command-reference-crards
  - node-connectivity/qr-pairing-guide`

---

## Appendix B – Metadata Schema Reference

| Field | Required? |
|--|-|

**title**
-- Yes (human-readable title).|
--- **version**: format `<major>.<minor>.*`.   — Example: `1.0`,`2.*
- Status options:
  - ✓ Active ✅
    • Deprecated ⚠️ (`Deprecated`) – not for new work.
| * description*: ~one sentence describing the CRD's purpose.

---


```

---

**References**
* AGENTS.md → Red lines, tool usage guidelines (skills).
   — [Default `AGENTS.default`](/reference_AGENTS_default).

---
Last updated by cron job `[blog-crd-write]` on 2026-07-31.