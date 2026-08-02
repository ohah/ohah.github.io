# Cloudflare R2 vs AWS S3: Performance Comparison

**Date:** August 1, 2026
**Tags:** #cloud-storage #r2-aws-comparison #performance-benchmarking #devops-cost-analysis

## Summary

When choosing between object storage providers for application workloads with strict latency requirements and tight budget constraints (especially when data ingress/egress costs don't apply), there are meaningful performance differences. This post benchmarks Cloudflare R2 against AWS S3 using real-world scenarios: cold reads, warm cache hits at different geographic regions.

## Status

**In Progress**
- Drafting started
- Needs actual benchmark testing with realistic payloads and multiple runs (to capture variance)

---

### Notes for Testing Phase:
1) Use consistent file sizes across providers to avoid noise.
2) Test from varied locations: Korea + US-West, EU if possible—each provider's regional proximity changes results dramatically.

## Next Steps

Run a proper measurement phase:

```bash
# Pseudocode idea (actual tooling TBD)
for region in korea us-west eu:
  for size in small medium large files up to ~50MB each do run multiple fetch attempts measure median latency and p95; log location-specific DNS resolution time + TCP connection handshakes if possible.
```

Capture raw results, then summarize trends (R2 tends closer-to-Amazon but with lower cost structure once egress costs are eliminated).