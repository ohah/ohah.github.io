# Cron Job Documentation

## Name: blog-crwd-update-docs (cron:a1b2c3d4-0000a001-b002-a005)

**Purpose:** Process one CRD documentation file from a configured source, write to workspace.

---

### Workflow Steps


#### 1. Define Source Configuration
Define the location(s) of incoming "CRDs" and an output directory in this repo.


## Example Implementation

If you have cron jobs that pull documents into `incoming/`:

- **Source:** `/Users/yoonhb/Documents/workspace/blog/incoming/crd/*.md`
- **Output Directory:** `.crd-output/parsed`

For each source file:
1. Read the incoming CRD document
2. Validate it has required structure (title, category tags)
3. Parse/format according to schema rules from `CRDS_SCHEMA.md`
4. Write processed version to output directory with stable filename


## Notes

- Use cron for one-shot runs: read a single file → process once.