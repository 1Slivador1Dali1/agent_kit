---
name: desktop-data-persistence
description: Handle local data in desktop apps: user data directories, settings, databases, file formats, autosave, undo/redo, crash recovery, file open/save, import/export, schema migrations, backups and optional sync. Use when the app stores documents, settings or caches, opens files, needs undo/redo or autosave, or when the user says "сохранение", "настройки", "файлы", "undo", "восстановление после падения", "SQLite", "AppData", "миграция данных", "экспорт".
---

# Desktop Data and Persistence

Desktop apps are trusted with the user's files. Data loss is the worst bug. Check what storage and file formats the project already uses and follow them.

## Where data lives

- Use OS-standard locations: Windows `%APPDATA%` (roaming settings) / `%LOCALAPPDATA%` (cache, large local data); macOS `~/Library/Application Support` and `Caches`; Linux XDG (`~/.config`, `~/.local/share`, `~/.cache`). Never write into the install directory or the working directory.
- Separate: user documents (the user's files, in places they choose), app data (database, settings), cache (safe to delete), logs (rotating, size-capped).
- Secrets go to the OS credential store (Windows Credential Manager/DPAPI, macOS Keychain, libsecret), not in settings files.

## Storage choices

- Structured/queryable data: SQLite (WAL mode, foreign keys on, parameterized queries, short transactions). Settings: a small validated JSON/TOML file or the platform store. Documents: an open, versioned format (JSON, SQLite file, zip container) with a documented schema and a `format_version` field.
- Do not use unbounded in-memory structures as storage for large datasets; stream, page and index.

## Safe writes (never corrupt a file)

- Write to a temp file in the same directory, flush/fsync, then atomically rename over the original. Keep a `.bak` of the previous version for risky operations.
- Handle: disk full, permission denied, file locked by another process, path too long, network drive disappearing, case-insensitive name collisions, invalid characters and reserved names (Windows `CON`, `NUL`), Unicode normalization.
- File watchers: debounce events, handle external modification ("file changed on disk: reload or keep mine?").

## Documents, autosave, undo

- **Autosave** to a recovery location at an interval and on idle, separate from the user's file; **crash recovery** offers to restore on next launch.
- **Undo/redo**: command pattern or immutable snapshots with a bounded history; group rapid edits; every user-visible mutation is undoable; undo survives save but not necessarily restart.
- Show dirty state (title marker, "unsaved changes" prompt on close with Save / Don't save / Cancel).
- Recent files list, drag-and-drop open, file associations, "open with" arguments, and a clear Save As / Export path.

## Migrations and compatibility

- Every persisted schema/format is versioned. Write forward migrations that run on startup, are tested from every previous version, back up the data first, and never silently drop fields. Refuse to open data from a newer incompatible version with a clear message instead of corrupting it.
- Import/export with validation of untrusted files: size limits, schema checks, safe parsing (no arbitrary code execution, zip-slip protection).

## Sync and backup (only if the product needs it)

- Local-first: local DB is the source of truth; background sync with an outbox, retries, idempotency keys, and a defined conflict policy (last-write-wins, merge, or ask the user).
- Offer manual export/backup and a way to reset settings and clear caches.

## Output

Storage layer with atomic writes, migration code and tests, autosave/recovery flow, undo/redo design, and a note describing what happens on crash, disk full and app update.
