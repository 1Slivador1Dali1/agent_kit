---
name: desktop-architecture
description: Structure desktop apps cleanly: process model, UI thread rules, IPC, MVVM/MVU state management, dependency injection, plugin and module boundaries, background work and configuration, for Electron, Tauri, .NET (WPF/WinUI/MAUI), Qt and other stacks. Use when starting a desktop app, adding features, wiring main/renderer or frontend/backend communication, or when UI code mixes with file/network logic, or the user says "архитектура", "IPC", "main process", "renderer", "MVVM", "UI поток", "зависает окно", "Tauri commands".
---

# Desktop Architecture

Follow the architecture already in the project; do not introduce a second pattern. If starting fresh, use these defaults.

## Process and thread model (know your stack)

- **Electron**: main process owns windows, OS access and files; renderer is untrusted UI; `preload` exposes a minimal typed API via `contextBridge`. Heavy work goes to worker threads, utility processes or child processes, never the main process event loop.
- **Tauri**: Rust core owns OS/file/network logic exposed as typed commands and events; the webview only renders. Keep commands small, async, validated and permission-scoped.
- **.NET (WPF/WinUI/MAUI/WinForms)**: UI thread only touches UI; use `async/await`, `Task.Run` for CPU work, `Dispatcher`/`SynchronizationContext` to return; never `.Result`/`.Wait()` on the UI thread.
- **Qt/GTK/AppKit**: same rule: long work in worker threads with signals/callbacks back to the UI thread.
- The UI thread must never block on disk, network, database or heavy computation.

## Layers

1. **View**: renders state, forwards user intent. No business logic, no direct file/network calls.
2. **Presentation** (ViewModel / Store / Reducer): screen and window state, commands, validation, exposes immutable state or observable properties.
3. **Domain/services**: business rules, use cases, independent of UI framework.
4. **Infrastructure**: file system, database, network, OS integration (clipboard, tray, notifications, protocol handlers), behind interfaces.

## Rules

- **Unidirectional or declarative data flow**; one source of truth per piece of data; derived state computed, not duplicated.
- **IPC contract**: define every channel/command with types and schemas; validate arguments on the receiving side; return typed results and errors; no "execute arbitrary string" channels. Version the contract if plugins or multiple windows depend on it.
- **Dependency injection** via constructors and a composition root; services replaceable in tests (file system, clock, network, OS APIs behind interfaces).
- **Long-running work**: cancellable tasks with progress reporting, a visible cancel button, and clean shutdown. Queue and rate-limit background jobs.
- **Modularity**: feature modules with public interfaces; shared `core` (logging, settings, IPC, design system). Plugin systems run with limited permissions and versioned APIs.
- **Configuration**: separate defaults, user settings and machine/admin policy; settings schema with validation and migration; feature flags for risky changes.
- **Lifecycle**: single-instance lock (second launch focuses the first window and forwards arguments), handle protocol/file association launch args, graceful quit (save, flush, release resources), restore session on restart.
- **Errors**: typed errors from services, central handler that logs with context and shows a human message; global handlers for unhandled exceptions/rejections that never silently swallow.

## Smells to fix

Business logic in click handlers; sync I/O on the UI/main thread; renderer with direct Node/OS access; global mutable singletons; IPC passing raw paths or shell commands from the UI; god service; memory held by event handlers that are never unsubscribed.

## Output

Feature code in the right layers, typed IPC definitions, DI wiring, a short description of threads/processes involved, and what happens on cancel or app close.
