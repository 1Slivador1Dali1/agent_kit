---
name: errors-observability
description: Implement consistent error handling, structured logging, request tracing, metrics and health checks so failures are diagnosable in production. Use when adding services, middleware, background jobs, integrations, or when the user mentions "логи", "ошибки", "exception", "мониторинг", "метрики", "tracing", "healthcheck", "debug in prod", or when code swallows exceptions or uses print/console.log.
---

# Errors and Observability

If it fails in production at 3am, the logs must say what, where, for whom and why, without exposing secrets.

## Error handling

- Define a small error taxonomy: validation, authentication, authorization, not-found, conflict, rate-limit, upstream/dependency failure, internal. Map each to one HTTP status and one stable error `code`.
- Throw domain errors in business code; translate to HTTP in **one** central handler/middleware. Handlers do not hand-build error responses.
- Never swallow exceptions (`catch {}`), never log-and-rethrow at every layer (log once, at the boundary that handles it). Preserve the cause chain.
- Distinguish expected errors (4xx, no alert) from unexpected ones (5xx, alert).
- Wrap external calls: translate vendor errors into your own, add context (which call, which id).
- Catch at process level: unhandled rejection/panic handlers that log and exit cleanly for the supervisor to restart.

## Logging

- Structured JSON logs with a real logger (not print/console.log): `timestamp`, `level`, `message`, `service`, `env`, `request_id`/`trace_id`, `user_id` (not PII), `duration_ms`, error `code`, `stack` for 5xx.
- Levels: ERROR = needs a human; WARN = degraded but handled; INFO = business events and request summaries; DEBUG = off in prod by default.
- One access log line per request (method, route template not raw path, status, duration).
- Redact secrets and PII by default (authorization headers, passwords, tokens, card data).
- Propagate a correlation id: accept `X-Request-Id` or generate one, attach to every log line, outgoing call and error response.

## Metrics and tracing

- Track the RED set per endpoint: Rate, Errors, Duration (histograms with p50/p95/p99). Add queue depth, job failures, DB pool usage, cache hit rate, external call latency.
- Use OpenTelemetry (or the project's existing stack) for traces across services and DB calls. Avoid high-cardinality labels (user ids, raw URLs) in metrics.

## Health and lifecycle

- `/healthz` (liveness: process is up) and `/readyz` (readiness: DB, cache, critical deps reachable) kept separate and cheap.
- Graceful shutdown: stop accepting requests, finish in-flight work, close pools, then exit.

## Output

Central error handler, logger setup, request-id middleware, metrics hooks, health endpoints, and a short list of what to alert on.
