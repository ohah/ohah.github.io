#!/bin/bash
# ohah blog CRD_WRITE 스크립트

echo "=== cron-write job started at $(date -u '+%Y-%m-%dT%H:%M:00Z') ===" >> /tmp/cron-activity.log 2>&1 || true


popd >/dev/null ||
{
    echo "[FAIL] pop failed"
    exit 100
}

find ./posts/posts/blogs/oh-h-blog-docs/content/archives/daily-commit-archive/_meta-data/metadata/sidebars-meta-listed-crd-write-instructions/meta-json-schematics-v1.json-temp-mockup-folder -name "*.mdm*.json" || echo "[INFO] No .mdx files found"

echo "=== cron-mdocs job finished at $(date '+%Y-%m-%dT%H:%M') ==="