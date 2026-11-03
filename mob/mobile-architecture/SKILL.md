---
name: mobile-architecture
description: Structure a mobile app cleanly: layers, state management, dependency injection, navigation, lifecycle handling, modularization and data flow, for native (SwiftUI/UIKit, Kotlin/Compose) and cross-platform (React Native, Flutter) projects. Use when starting an app, adding a feature module, introducing state management, or when code mixes UI with networking and storage, or the user says "архитектура", "MVVM", "state management", "структура проекта", "рефакторинг", "Redux", "Riverpod", "Bloc".
---

# Mobile Architecture

Follow the architecture already in the project; do not introduce a second pattern. If starting fresh, use the defaults below.

## Layers (dependencies point inward)

1. **UI** (screens, components): renders state, sends user events. No business logic, no direct network or database calls.
2. **Presentation** (ViewModel / Store / Bloc / Notifier): holds screen state, handles events, calls use cases. Exposes immutable UI state.
3. **Domain** (use cases, entities, repository interfaces): pure business rules, platform-independent, easily testable.
4. **Data** (repository implementations, API client, local DB, cache): maps DTOs to domain models; decides network vs cache.

## Rules

- **Unidirectional data flow**: state flows down, events flow up. Single source of truth per piece of data (usually the local database or repository).
- **Screen state as a sealed type**: `Loading | Content(data) | Empty | Error(cause)` rather than several booleans. Immutable models.
- **Dependency injection**: constructor injection via the platform's idiom (Hilt/Koin, Swift protocols + a container, Provider/Riverpod/get_it, tsyringe/context). No singletons that hide dependencies; everything replaceable in tests.
- **Navigation**: centralized and typed (route definitions, coordinators, NavGraph, React Navigation, go_router). Screens do not know about each other's internals; pass IDs, not whole objects.
- **Lifecycle awareness**: cancel work when screens leave; survive configuration changes and process death (save minimal restorable state); never hold references to views/contexts in long-lived objects; no work in the wrong thread.
- **Concurrency**: structured concurrency (coroutines + scopes, Swift async/await + Task cancellation, Dart isolates/async, JS promises with abort). UI work on main thread, I/O off it. Make cancellation and error propagation explicit.
- **Modularization**: group by feature (`feature/login`, `feature/orders`) with shared `core` modules (network, storage, design system, analytics). Keep module boundaries enforced by public interfaces.
- **Configuration**: environments (dev/stage/prod), feature flags and API base URLs through build configuration, not hardcoded.
- **Errors**: map technical exceptions to typed domain errors at the data layer; present user-readable messages at the UI layer.

## Smells to fix

Networking in a view; business rules in UI callbacks; god ViewModel; global mutable state; passing Context/Activity into repositories; duplicated DTO/domain/UI models without reason; navigation logic scattered across screens.

## Output

Feature code placed in the right layers, interfaces for testability, DI wiring, and a one-paragraph description of the data flow for the new feature.
