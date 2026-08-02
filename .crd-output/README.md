# CRD Output Directory

This is where processed and formatted documentation files end up.

---

## Workflow (from cron-crd-write)

1. **Source**: Read incoming documents from a configured source
2. **Validate**: Ensure required structure exists (`title`, `category` tags)
3. **Parse/Format**: Apply schema rules for consistent formatting across all CRDs

This directory contains the final, polished versions of your content.