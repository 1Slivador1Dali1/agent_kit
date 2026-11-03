---
name: reliability-performance
description: Make backend code resilient and fast: timeouts, retries with backoff, idempotency, queues and background jobs, caching, rate limiting, concurrency, connection pools, and resource limits. Use when integrating external services, adding webhooks, jobs, heavy queries, file processing, or when the user mentions "производительность", "медленно", "кэш", "очередь", "retry", "таймаут", "нагрузка", "scalability", "webhook".
---

# Reliability and Performance

Assume every dependency will be slow, fail, or return the same message twice. Design for that up front.

## Calls to other systems

- **Timeouts everywhere**: connect and read timeouts on every outbound HTTP, DB and cache call. No default-infinite.
- **Retries**: only for idempotent or idempotency-keyed operations and only on transient errors (network, 429, 502/503/504). Exponential backoff with jitter, capped attempts, respect `Retry-After`.
- **Circuit breaker / bulkhead** for flaky dependencies; degrade gracefully (cached or partial data) instead of cascading failure.
- **Idempotency**: store processed event/idempotency keys with a unique constraint so duplicate deliveries do nothing. Required for webhooks, queue consumers and payment flows.

## Background work

- Do slow or unreliable work (email, exports, media processing, third-party sync) off the request path via a queue/job runner. Return 202 with a status resource if the client needs the result.
- Jobs must be idempotent, have retry limits, a dead-letter path, and observable status. Use the **outbox pattern** when a DB write and a message publish must stay consistent.
- Scheduled jobs: guard against overlapping runs (lock) and multiple instances.

## Performance

- Measure before optimizing: profile, `EXPLAIN`, and p95/p99 latency, not guesses. Fix the biggest bottleneck first (usually N+1 queries, missing indexes, serial I/O).
- Run independent I/O concurrently (async gather, worker pools) with a concurrency cap.
- Stream large responses and files; never load unbounded data into memory. Paginate and set max limits.
- Reuse connections: sized DB pool, HTTP keep-alive/client reuse; don't create a client per request.
- Compress responses; use conditional requests (ETag) for cacheable GETs.

## Caching

- Cache only what is read-heavy and tolerates staleness. Define key, TTL, and invalidation rule at the time you add the cache.
- Namespace keys (including tenant/version), prevent stampedes (single-flight, jitter on TTL), never cache user-specific data in a shared key, and make cache failure non-fatal.

## Protection

- Rate limit per client/account/IP, with `429` + `Retry-After`. Cap request size, query cost and concurrent heavy operations.
- Back-pressure: bounded queues and load shedding rather than unbounded growth.
- Config for limits and timeouts via environment, with safe defaults.

## Output

Implementation plus a short note on failure modes handled (what happens when X is down/slow/duplicated), the limits chosen, and what to monitor.
