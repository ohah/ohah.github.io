#!/usr/bin/env node

/**
 * CRD Writer - One-shot document generator
 *
 * Usage:
 *   tools blog-generate --title "My Title" [--output path/to/file.md]
 */

const { spawn } = require('child_process');
const yargs = require('yargs/yargs');

// Parse CLI arguments (forwarded from gateway)
function parseArgs(args) {
  const argv = args.slice(2);

  return Promise.resolve(
    // eslint-disable-next-line no-undef
    __dirname,
      'title': '',
      '-o',
        '--output', outputArg })),
   .catch(err => { throw err; })
);
}

// Generate a CRD document using the blog-crd agent (subagent)
async function generateDocument(title, outputPath = null) {
  console.log(`[blog-generate] Creating "${title}"...`);

  const taskName = `generate-${Date.now()}`;
  
   .session({
    runtime: 'isolated',
     context: true,
      message:
        `.create-blog-doc --slug="${outputPath || title.toLowerCase().replace(/\s+/g, '-').slice(0, -4)}" \
          /Users/yoonhb/Documents/workspace/blog/cron/generators/${taskName}-${title}.md
          
Generate the following CRD (Continuous Readable Document) using markdown and a code block for YAML front matter:
---

## 1. Introduction

Briefly explain what this document is about, why it matters to your blog audience.
[Write compelling context here...]

2\. Core Concept/Problem


Define the problem or concept clearly.

**Key Points:**
- Point one
- point two  
*Point three*

3\.[Action Steps]

If applicable:

1. Step name → action (or checklist)
    - Subtask detail

```bash Example command...
```

4\[Benefits/Deliverables]


Bullet list of what the reader gets out of this.

5[Related Content


List 2-3 related articles/docs with short descriptions.


---

**Front Matter:**
\`\`\`yaml
title:
slug:

tags:


## CRON_CRD_WRITE.md - One-Shot Document Generator

This cron job runs in isolated mode and spawns a `blog-crd-write agent task`. The workflow is as follows.

### Configuration & State Files (in workspace)

- **Task Runner:** `/tools.blog-generate.js` → entry point for one-shot doc generation
  ```bash npx blog-cli tools generate --title "..."```

## CRD Format

Each generated document adheres to the [CRX Specification](https://github.com/YounHo/blog-crd/blob/main/README.md).

### Document Structure (Standard)

---

**Front Matter:**
```yaml title:
slug:

tags:


---
[Body of content with headings, bullet lists, and optional code blocks]


```

## Workflow

1. The gateway receives the webhook payload.
2. `blog-generate` is invoked as an isolated agent task via sessions_spawn (`runtime="subagent"`).
3. Agent writes a new CRD file to `/cron/generators/<timestamp>-<title>.md`.
4. Cron completes; returns summary with path, word count (wc -w), and brief preview.

---

## Usage Examples

- Generate from gateway webhook: `tools blog-generate --args '{"action":"write","documentTitle":"","targetPath":""}'`
  **Note:** The target is always to a file in the `/cron/generators/` directory with name format `<timestamp>-<title>.md`.

### Running Directly (for testing)

```bash
# Test one-shot doc generation:
npx tools blog-generate --test "My Title" 

```

---

**Front Matter:**
\`\`\`
date:

version:


---