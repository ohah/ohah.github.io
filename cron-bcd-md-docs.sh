#!/bin/bash
# CRON_CRD_WRITE 규칙 구현 스크립트

WORKSPACE="/Users/yoonhb/Projects/openclaw"
echo "=== cron-crd-write job started at $(date -u '+%Y-%m-%d %H:%M:%S UTC') ===" >> /tmp/cron-bcd-activity.log
pushd "$WORKSPACE"/docs > dev/null || exit 1

# 모든 .mdx 파일 목록 얻기 (사이드바 노출용 _meta.json 제외)
find ./posts -name "*.mdm*.json"

popd >/dev/null  
echo "=== cron-crd-write job finished at $(date '+%Y-%m-%dT%H:%M') ===" >> /tmp/cron-bcd-activity.log