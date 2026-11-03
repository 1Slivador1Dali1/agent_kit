---
name: mobile-states-offline
description: Handle every screen state and unreliable mobile conditions: loading skeletons, empty, error and retry, pull-to-refresh, optimistic updates, offline-first caching, sync and conflict handling, connectivity changes, permission denial and background/foreground transitions. Use when building any screen that loads or submits data, lists, forms, or uploads, or when the user mentions "оффлайн", "кэш", "нет интернета", "синхронизация", "загрузка", "пустое состояние", "retry", "permissions".
---

# Mobile States and Offline

Phones lose signal in elevators, switch from Wi-Fi to LTE mid-request, get killed in the background and have permissions revoked. Design for it from the start (Nielsen: visibility of status, error recovery).

## Every data screen has these states

- **Loading**: skeleton matching final layout; show cached content immediately if available and refresh in the background (stale-while-revalidate).
- **Empty**: explain why and give a primary action; illustration or icon.
- **Error**: plain-language message, retry button, keep previous content visible when a refresh fails. Distinguish "no connection", "server problem", "not allowed" and "not found".
- **Content with partial failure**: show what loaded, mark what failed.
- **Pull-to-refresh** on lists; **pagination** (infinite scroll with a footer loader and an error row with retry).
- **Submitting**: disable to prevent double-tap, show inline progress, keep user input on failure.

## Offline-first design

- Local database (Room, Core Data/SwiftData, SQLite, Realm, Drift, WatermelonDB, MMKV for small data) as the single source of truth; UI observes it; network syncs into it.
- Read path: serve from local, refresh from network, update local, UI updates automatically.
- Write path: optimistic update locally, enqueue the change (outbox), sync when online, retry with exponential backoff, roll back with a message on permanent failure.
- Every queued write has a **client-generated id** and idempotency key so retries never duplicate.
- Define conflict strategy per entity (last-write-wins, server-wins, merge, or ask the user) and a `updated_at` / version field for detection.
- Background sync through the platform scheduler (WorkManager, BGTaskScheduler, background fetch), respecting battery and network constraints.
- Observe connectivity (reachability API) and show a subtle offline banner; do not rely on "is connected" as a guarantee, always handle failures.

## Network behavior

- Timeouts on all requests; cancel requests when the screen is left; retry only safe/idempotent calls.
- Handle 401 by refreshing the token once (single-flight) and replaying; on failure route to login without losing user data.
- Cache images and responses with sensible TTLs; support resumable uploads for large files and show progress with cancel.

## System-level states

- **Permissions**: ask in context with a rationale before the system prompt; handle denied, "ask next time", and permanently denied (explain, deep-link to settings); the feature degrades gracefully.
- **Lifecycle**: save drafts and scroll/form state; restore after process death; pause work when backgrounded.
- **Version and maintenance**: handle force-update and server-maintenance responses gracefully.

## Output

Screens wired with all states, repository with cache/sync logic, a defined conflict policy, and a note describing what happens in airplane mode.
