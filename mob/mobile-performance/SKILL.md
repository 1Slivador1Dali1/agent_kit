---
name: mobile-performance
description: Keep mobile apps fast, smooth and battery-friendly: startup time, 60/120 fps rendering, list virtualization, image loading, memory leaks, main-thread blocking, network and battery cost, and app size. Use when screens lag, lists scroll badly, the app starts slowly, memory or battery is a concern, or the user says "тормозит", "лаги", "производительность", "утечка памяти", "размер приложения", "jank", "FPS", "battery".
---

# Mobile Performance

Measure first with the platform profiler (Xcode Instruments, Android Studio Profiler/Perfetto, Flutter DevTools, React Native Profiler/Flipper, Flashlight). Fix the biggest measured problem; do not guess.

## Budgets

- Cold start to first interactive screen: aim for under ~2 s on a mid-range device; show content before everything is loaded.
- Frame time: 16 ms (60 fps) or 8 ms (120 Hz); no dropped frames while scrolling or animating.
- Test on a low/mid-range physical device and a release build, not only a flagship or debug build.

## Startup

- Defer non-critical SDK init, analytics and prefetching until after the first frame; lazy-load heavy modules.
- Keep the launch path free of synchronous disk/network. Use splash/launch screen that matches the first screen.
- Android: baseline profiles, avoid heavy `Application.onCreate`. iOS: minimize work in `didFinishLaunching`, reduce dynamic frameworks. RN: Hermes, inline requires, lazy screens. Flutter: defer plugin init, avoid heavy `main()`.

## Rendering and lists

- **Virtualize lists**: LazyColumn/RecyclerView, `List`/`LazyVStack`, FlatList/FlashList, `ListView.builder`. Stable keys/ids; no nested scrollables of the same direction.
- Keep row views cheap: no layout thrash, no inline heavy computation, memoize/derive state (`remember`, `useMemo`/`React.memo`, `const` widgets, equatable state) so only changed rows recompose or rebuild.
- Avoid overdraw and deep view hierarchies; avoid animating layout-affecting properties; prefer GPU-friendly transforms/opacity.
- Never block the main/UI thread: parse JSON, decode images, query the DB and compute off the main thread.

## Images and media

- Request correctly sized images (thumbnails, responsive URLs), decode downsampled, use a caching loader (Coil/Glide, Kingfisher/SDWebImage/AsyncImage, FastImage/expo-image, cached_network_image). Prefer WebP/AVIF/HEIC, vector icons for UI.
- Release video/camera/audio resources promptly.

## Memory

- Avoid leaks: no strong references to views/contexts/closures in long-lived objects; unregister listeners, cancel jobs/subscriptions on dispose (`[weak self]`, lifecycle scopes, `dispose()`, effect cleanup).
- Bound caches; handle memory warnings; page large datasets instead of loading all.

## Network and battery

- Batch and debounce requests, use HTTP caching/ETags, compress payloads, prefer push over polling, and avoid wake-ups; limit location accuracy and frequency, and stop updates when not needed.
- Use background scheduling APIs rather than custom timers.

## App size

- Enable R8/ProGuard and resource shrinking, App Bundles / app thinning, remove unused dependencies and assets, compress images, split by ABI/density.

## Output

For each fix: what was measured, the change, and the expected effect. If no profiler is available, list the likely hotspots found by code review and how to verify them.
