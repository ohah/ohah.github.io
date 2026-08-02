# PostgreSQL Performance Tuning Guide for 2026

**Date:** July 31, 2026
**Tags:** postgresql | performance tuning | optimization | database architecture
**Status:** Draft - Ready For Review
---

## Summary

PostgreSQL has evolved significantly since its early days. With modern hardware capabilities and newer features like parallel query execution, materialized views with refresh async policies (REFRESH MATERIALIZED VIEW CONCURRENTLY), pgaudit for security auditing at the SQL level via extensions such as pg_stat_statement / track_activity_query_size > 1024 characters on log_line_prefix config changes when enabling shared_preload_libraries=prometheus and setting appropriate metrics paths, there are new opportunities to squeeze performance out of existing deployments without heavy architectural rewrites. This guide covers practical tuning approaches for PostgreSQL versions released in the past few years.

---

## Key Improvements Since 2024

### Parallel Query Execution
Modern Postgres (15+) supports parallel query execution automatically when queries benefit from it:
- `work_mem` should be larger than typical sort/hash memory requirements per worker.
- Enable via default_transaction_isolation or session settings; plan_cache_mode = force_generic_plan can prevent inappropriate custom plans.

Performance tip: Check with EXPLAIN ANALYZE whether workers are actually being used. If not, consider reducing the complexity of affected queries rather than forcing parallelism aggressively on all workloads (e.g., avoiding overly complex joins that reduce row counts quickly).

### pgaudit
Instead of relying solely on pg_stat_statement and log_line_prefix patterns like `%t [%p]: ` to capture user activity at a high level, enabling shared_preload_libraries=prometheus or similar can provide better metrics. However for SQL-level security auditing (who did what query), enable the extension via CREATE EXTENSION IF NOT EXISTS pgaudit; then configure in postgresql.conf:
- log_min_duration_statement = -1 to capture all statements
shared preload libraries: add `pgaudio` and set shared_preload_libraries accordingly

This ensures every SQL statement logged for audit without needing post-hoc query parsing from pg_stat_statement.

### Prometheus Metrics (via extension)
Enable monitoring via extensions like prometheus. Configure the metrics server path on postgresql.conf:
- When enabling a separate service or port, ensure no unnecessary ports are opened.
Add `shared_preload_libraries` entries that expose standard PostgreSQL statistics for scrapers with appropriate authentication and TLS endpoints.

---

## Memory Tuning

### shared_buffers
Set to 25% of total RAM by default. Modern hardware often benefits from higher values (40-50%) if you have large working sets:
```sql
-- Set at OS level via config or ALTER SYSTEM; reload pg_ctl.
shared_buffers = '32GB'
```
When enabling parallel query, ensure `work_mem` per worker isn't set too high in aggregate across workers.

### work_mem & maintenance_work_mem

- **Work Mem** - Per-worker memory for sorts/hashes. Use a fraction of shared buffers (e.g., 128MB) rather than global.
```sql
-- Example values adjusted to workload and number of concurrent connections/workers:
work_mem = '256MB'
maintenance_work_mem = '2GB' -- Better CREATE INDEX CONCURRENTLY performance in parallel runs or large table scans without saturating I/O for critical queries.

```
Performance tip: For bulk loads, increase `effective_cache_size` (e.g., 64% of RAM) to help the planner estimate better. Do not exceed available system memory and allow room for OS caching; monitor using vmstat/iostat.
  
- **Effective Cache Size** - Planner's assumption about disk cache:
```sql
-- Adjust based on typical database working set size (OS caches included):
effective_cache_size = '96GB'
```

### Temporary Storage For Sorts/Hashes in Parallel Workers

Consider the number of parallel workers spawned by a query and ensure `work_mem` is not oversubscribed. In PostgreSQL 15+ you can use:
```sql
-- Check current setting (per worker) if workload benefits from more or less per-worker memory.
SELECT name,setting FROM pg_settings WHERE name IN ('shared_buffers','effective_cache_size');
```

---

## Indexing Strategies

### Covering indexes for read-heavy workloads:

For queries that filter heavily but also project a subset of columns:
```sql
CREATE INDEX CONCURRENTLY idx_users_covered ON users (email) INCLUDE (id, created_at);
-- Include only necessary projections to avoid index-only scans.
```

Note: `INCLUDE` was added in PostgreSQL 11. Use sparingly as they are larger and slower updates.

### Partial indexes for query-specific optimization:

Filter by commonly applied predicates:
```sql
CREATE INDEX CONCURRENTLY idx_active_users ON users (last_login_at) WHERE is_deleted = false;
-- Reduces index size when combined with frequent scans over active records.
```

---

## Query Analysis Tools

- `EXPLAIN ANALYZE` - Run before changing configs to confirm actual execution plans, identify full table scans vs. bitmap heap scan/parallel seqscan etc.

To see more details including buffers:
```sql
SET log_min_duration_statement = 0;
-- In pg_stat_activity check backend_pid of current session and inspect buffer usage via EXPLAIN (ANALYZE,BUFFERS).
```

- `pg_hint_plan` - Use for temporary query-specific hints when you cannot change indexes or schema.

---

## Maintenance & Monitoring

### Autovacuum tuning
Autovacuum is the primary mechanism to keep performance stable after data churn. Monitor autovacuum activity via pg_stat_user_tables and adjust:
```sql
-- Tune vacuum thresholds if large updates/inserts cause index bloat.
ALTER TABLE your_table SET (autovacuum_vacuum_scale_factor = 0.05, antivaccum_analyze_scale_factor=...);
```

### Table partitioning for time-series data:

Use range or list/partitioned tables to improve maintenance:
```sql
-- Example with monthly partitions on created_at.
CREATE TABLE orders (
    id bigint GENERATED ALWAYS AS IDENTITY,
    order_date date NOT NULL DEFAULT current_DATE(),
...
) PARTITION BY RANGE (order_year, MONTH(order_created_ts));
```

---

## Security & Auditing

### pgaudit for SQL-level audit trails:
1. Install the extension in `shared_preload_libraries` or after server start via CREATE EXTENSION.
2. Configure log levels as needed and ensure query text is logged when security demands.

When using extensions such as prometheus to monitor metrics, restrict access with proper authentication; do not expose internal stats on public networks without TLS/VPN protection for data confidentiality in audit contexts (e.g., compliance scenarios).

---

## Common Pitfalls

- **Overestimating work_mem** - If each worker claims too much memory across many queries concurrently it can cause OOM or swap.
  Test with smaller increments and monitor system load using `top` / `htop`.

### Forcing parallelism aggressively:
Not all plans benefit from workers. In some cases, forcing generic plan caching (plan_cache_mode=force_generic_plan) prevents PostgreSQL from generating poor custom-specific queries that would be slower in the worker configuration than a sequential scan.

---

## References
- Official Postgres documentation for tuning guidance and new features.