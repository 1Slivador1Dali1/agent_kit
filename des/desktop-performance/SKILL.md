---
name: desktop-performance
description: Keep desktop apps fast and light: startup time, memory, idle CPU, UI responsiveness, large lists and tables, rendering, file and network I/O, and bundle size, with extra care for Electron/web-based shells. Use when the app is slow to start, freezes, uses too much RAM or CPU, handles big files or datasets, or the user says "тормозит", "жрёт память", "зависает", "долго запускается", "размер сборки", "Electron тяжёлый", "утечка памяти".
---

# Desktop Performance

Measure first, with the platform tools: Windows Performance Recorder/Analyzer, PerfView/dotTrace, Visual Studio profiler, Instruments, perf/valgrind, Chrome DevTools and `--inspect` for Electron, `tracing`/`cargo flamegraph` for Rust. Fix the biggest measured bottleneck, on a release build and on a modest machine (HDD or slow SSD, 8 GB RAM), not only a developer workstation.

## Startup

- Show the window and a usable shell quickly; load heavy data, plugins and network calls after first paint. Splash only if load is unavoidably long, with real progress.
- Lazy-load modules and windows; avoid synchronous disk and network in startup. Cache expensive initialization (compiled templates, indexes).
- Electron: V8 snapshot or bundling (esbuild/Vite), avoid giant `require` trees, defer hidden windows, create windows only when needed. .NET: ReadyToRun/NativeAOT where suitable, avoid reflection-heavy startup. Tauri: keep the Rust core lean and the frontend bundle small.

## Responsiveness

- UI thread is sacred: no blocking I/O, parsing, compression, image decoding or heavy loops on it. Move to workers/tasks and deliver results in batches. Target input-to-response under ~100 ms; frames under 16 ms during scrolling and resizing.
- Debounce/throttle search-as-you-type, resize handlers and file watcher events. Cancel obsolete work.
- Show progress and keep the app interactive during long operations.

## Large data

- Virtualize lists, tables, trees and canvases (render only visible rows); stable keys; fixed or estimated row heights.
- Stream and page big files; memory-map or chunk; avoid loading entire files into memory. Index data (SQLite, in-memory maps) instead of rescanning.
- Batch UI updates; avoid per-item re-render of the whole collection; use change notifications of the finest granularity.

## Memory and CPU at idle

- Hunt leaks: unsubscribed event handlers, forgotten timers, listeners on closed windows, detached DOM nodes, caches without limits, large closures. Use heap snapshots and compare over time.
- Bound every cache (size and TTL); release resources when windows close or minimize; free large buffers promptly.
- Idle CPU should be near zero: no busy polling, no always-running animations, no hidden-window rendering; throttle timers when the window is hidden. Respect battery saver on laptops.
- Electron: reduce renderer count, disable unused features (spellcheck, GPU if not needed), avoid heavy preloaded frameworks in every window, consider a utility process for CPU work.

## I/O and network

- Async I/O, buffered reads, avoid scanning huge directory trees on the UI thread; incremental and cancellable file indexing with throttling; ignore irrelevant folders.
- HTTP: connection reuse, timeouts, caching, compression; offline tolerance.

## Size

- Tree-shake and minify, drop unused dependencies and locales, compress assets, ship only needed native modules, split optional features into downloadable components; prefer system WebView (Tauri/WebView2) over bundling a full browser when acceptable.

## Output

For each fix: what was measured (metric before), the change, and the expected result. If profiling tools are not available, list likely hotspots from code review and how to verify them.
