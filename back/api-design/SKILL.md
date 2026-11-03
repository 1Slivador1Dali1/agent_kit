---
name: api-design
description: Design and implement HTTP/JSON APIs with consistent contracts: resources, status codes, error format, validation, pagination, filtering, idempotency, versioning, and OpenAPI docs. Use whenever adding or changing an endpoint, controller, route, handler, DTO or schema, or when the user says "API", "эндпоинт", "ручка", "REST", "контракт", "swagger", "openapi".
---

# API Design

Before writing a handler, check how existing endpoints in this project look (naming, error shape, auth, pagination) and match them. Consistency beats personal preference. If nothing exists yet, use the defaults below.

## Contract first

State the contract before code: method, path, auth requirement, request schema, response schema, error cases. Keep it in the OpenAPI spec or schema types the project already uses (zod, pydantic, DTOs, struct tags) so docs and validation come from one source.

## Rules

- **Resources and naming**: plural nouns (`/orders/{id}`), no verbs in paths except for true actions (`POST /orders/{id}/cancel`). One naming convention for JSON fields (project's choice, usually snake_case or camelCase).
- **Methods**: GET safe and cacheable, POST create/action, PUT full replace, PATCH partial update, DELETE idempotent.
- **Status codes**: 200 OK, 201 Created (+ `Location`), 202 Accepted for async work, 204 No Content, 400 malformed, 401 unauthenticated, 403 unauthorized, 404 not found, 409 conflict, 422 validation failed, 429 rate limited, 5xx server fault. Never return 200 with an error inside.
- **Error format**: one shape everywhere, e.g. `{ "error": { "code": "ORDER_NOT_FOUND", "message": "...", "details": [...], "request_id": "..." } }`. Machine-readable `code`, human `message`, field-level `details` for validation. Follow RFC 9457 problem+json if the project uses it.
- **Validation**: validate and parse all input at the boundary (body, query, path, headers). Reject unknown or oversized input. Return all field errors at once.
- **Pagination**: cursor-based for large or changing lists, offset only for small stable ones. Enforce a max page size. Return `next_cursor` / total only when cheap.
- **Filtering and sorting**: whitelist allowed fields; never pass raw query fields into the DB.
- **Idempotency**: `Idempotency-Key` header for POSTs that create money-, order- or message-like side effects; PUT/DELETE naturally idempotent.
- **Concurrency**: ETag / `If-Match` or a `version` field for update conflicts (409 on mismatch).
- **Versioning**: additive changes are non-breaking; breaking changes get a new version (`/v2`) or a deprecation window. Never silently rename or remove fields.
- **Responses**: do not leak internal fields (password hashes, internal IDs, stack traces). Use explicit response schemas, not raw DB models. ISO 8601 UTC timestamps, string decimals for money or integer minor units.
- **Docs**: every endpoint has a summary, schema, example request/response and error list.

## Output

Contract summary (short), implementation, validation schemas, updated OpenAPI/docs, and a list of any breaking changes.
