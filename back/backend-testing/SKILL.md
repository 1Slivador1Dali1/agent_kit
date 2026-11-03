---
name: backend-testing
description: Write meaningful backend tests: unit tests for business logic, integration tests against a real database, API contract tests, and edge/failure cases. Use whenever implementing a feature, fixing a bug, or refactoring backend code, or when the user says "тесты", "покрой тестами", "test", "TDD", "regression", "integration test", "mock".
---

# Backend Testing

Tests give the agent and the human a verifiable definition of done. Write or update tests with every behavior change, and run them before declaring the task complete.

## What to test (the practical pyramid)

1. **Unit**: pure business logic, calculations, validators, state machines. Fast, no I/O.
2. **Integration (most valuable)**: handler → service → real database in a container or test schema. Verifies SQL, constraints, transactions and serialization actually work.
3. **Contract/API**: request and response shapes, status codes, error format, auth rules, against the OpenAPI schema if available.
4. **A few end-to-end flows** for critical paths (signup, checkout, payment webhook).

## Rules

- **Bug fix = failing test first**, then the fix. Keeps the regression from returning.
- Test behavior, not implementation. Assert on outputs, status codes, persisted state, emitted events, not on which private function was called.
- Mock only at the boundaries you do not own (payment provider, email, third-party HTTP). Do not mock the database for logic that depends on SQL. Prefer fakes or recorded stubs for external APIs.
- Each test is independent and deterministic: own data (factories/builders), transaction rollback or truncation between tests, injected clock and random seed, no order dependence, no real network.
- Naming: `test_<unit>_<scenario>_<expected>` or the framework's describe/it style, readable as a spec.

## Cases that are almost always missing (cover them)

- Validation failures and boundary values (empty, max length, negative, unicode, null).
- **Authorization**: user A cannot read/modify user B's resource; unauthenticated → 401; wrong role → 403.
- Not found, duplicate/conflict, idempotent retry.
- Concurrency: two simultaneous updates; double submit.
- Pagination edges: empty page, last page, invalid cursor.
- Dependency failure: timeout, 5xx from upstream, DB unavailable → correct error, no partial writes.
- Migrations: apply and rollback on a fresh database.

## Process

1. Detect the project's test framework and conventions; follow them.
2. Write tests for the happy path and the missing cases above.
3. Run the suite (or the affected subset). If anything fails, fix the cause, not the assertion.
4. Report: tests added, command to run them, and any area left untested with the reason.
