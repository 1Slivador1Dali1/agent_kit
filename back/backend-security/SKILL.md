---
name: backend-security
description: Review and harden backend code against common vulnerabilities (OWASP Top 10): authentication, authorization, injection, secrets, input validation, SSRF, rate limiting, file uploads, logging of sensitive data. Use whenever code handles auth, users, permissions, tokens, passwords, payments, uploads, external URLs, or when the user asks for "безопасность", "security review", "уязвимости", "авторизация", "JWT", "CORS", and before finishing any endpoint that reads or writes user data.
---

# Backend Security

Treat all input as hostile and all secrets as radioactive. Review the changed code against this list and fix what fails. Report findings with file and line.

## Authentication

- Passwords hashed with argon2id, scrypt or bcrypt (never MD5/SHA alone); constant-time comparisons.
- Sessions or tokens: short-lived access tokens, rotating refresh tokens, `HttpOnly` + `Secure` + `SameSite` cookies. Validate JWT signature, `alg`, `exp`, `iss`, `aud`; never accept `alg: none`.
- Login, reset and OTP flows: rate limiting, generic error messages (no user enumeration), single-use expiring reset tokens.

## Authorization (most common real-world bug)

- Check permissions on **every** request, server-side, per resource: not just "is logged in" but "may this user touch this object" (prevent IDOR/BOLA).
- Scope queries by owner/tenant (`WHERE tenant_id = :current`). Deny by default.
- Do not trust client-sent roles, user ids or prices. Prevent mass assignment: explicit allow-list of writable fields.

## Input and injection

- Validate type, length, format and range at the boundary. Parameterized queries only. Escape/encode on output context (HTML, shell, LDAP).
- No shell execution with user input; if unavoidable, use argument arrays and allow-lists.
- Deserialization: no untrusted pickle / native object deserialization; limit JSON depth and body size.
- **SSRF**: for any user-supplied URL, allow-list hosts, block private/link-local/metadata IPs, resolve DNS then validate, disable redirects or revalidate.
- **Uploads**: check size, extension and magic bytes, randomize storage names, store outside web root, never execute, scan if needed.
- Path traversal: normalize and confine file paths to a base directory.

## Secrets and config

- No secrets in code, logs, error messages, URLs or git. Load from environment or a secret manager; `.env` in `.gitignore`; provide `.env.example`.
- Different credentials per environment; least-privilege DB and cloud roles.

## Transport and headers

- HTTPS only; HSTS. CORS: explicit origin allow-list, no `*` with credentials. CSRF protection for cookie-based auth. Security headers (CSP, X-Content-Type-Options, frame protections) where responses are rendered by browsers.

## Abuse and data protection

- Rate limit and throttle by IP + account on sensitive and expensive endpoints; cap payload sizes and query complexity (GraphQL depth).
- Never log passwords, tokens, full card numbers or PII; mask in logs and error responses. Return generic 500 messages with a request id; keep stack traces server-side.
- Encrypt sensitive data at rest where required; keep audit logs for privileged actions.
- Dependencies: pin versions, run the ecosystem audit tool (`npm audit`, `pip-audit`, `govulncheck`, etc.), avoid abandoned packages.

## Report format

```
[Severity: critical/high/medium/low] <issue> — <file:line> — <exploit scenario in one line> — <fix>
```
Fix critical and high issues directly. List medium/low with proposed changes.
