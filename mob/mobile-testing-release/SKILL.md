---
name: mobile-testing-release
description: Test and ship mobile apps reliably: unit, UI and snapshot tests, device/OS matrix, CI/CD, code signing, versioning, crash reporting, analytics, staged rollouts, feature flags and store-review readiness (App Store / Google Play). Use when writing tests for mobile code, preparing a build or release, setting up CI, fixing a crash, or when the user says "тесты", "релиз", "сборка", "подпись", "TestFlight", "Play Console", "crash", "CI/CD", "fastlane", "отклонили в сторе".
---

# Mobile Testing and Release

A shipped bug costs days (store review, slow adoption). Test before release, ship gradually, and be able to roll forward fast.

## Testing

- **Unit tests** for domain logic, ViewModels/stores/blocs, mappers and reducers (fast, JVM/XCTest/Jest/flutter_test). Inject clocks, dispatchers and repositories.
- **Integration tests** for repository + local database + fake API (MockWebServer, URLProtocol stubs, MSW, `http_mock`): include offline, timeout, 401 refresh and malformed responses.
- **UI tests** for critical flows only (login, onboarding, checkout, core task): Espresso/Compose test, XCUITest, Detox/Maestro, Flutter integration_test. Use stable test IDs/accessibility identifiers, not text or coordinates.
- **Snapshot/screenshot tests** for components in light/dark, large text, small/large screens and RTL.
- Bug fix = failing test first, then the fix.
- Run the affected tests before finishing and report the command and result.

## Device matrix

- Test on real devices: one low-end Android, one mid, one recent flagship, small and large iPhones, a tablet if supported. Cover minimum and latest OS versions, different locales/RTL, large fonts, dark mode, slow/offline network (network link conditioner).

## Build and CI/CD

- Reproducible builds in CI on every PR: lint (SwiftLint/ktlint/detekt/ESLint/`dart analyze`), tests, static analysis, build. Release pipeline via fastlane/Gradle/EAS/Codemagic.
- Versioning: semantic marketing version + monotonically increasing build number set by CI.
- Signing: certificates, provisioning profiles and keystores stored in the secret manager, never in the repo; document the recovery process. Use Play App Signing.
- Separate environments/bundle IDs (dev, staging, prod) so builds can coexist.

## Observability

- Crash and ANR reporting (Crashlytics/Sentry) with symbolication/mapping files uploaded in CI, release and build tags, user-id (not PII) and breadcrumbs.
- Analytics events with a documented schema; no PII; consent-gated.
- Remote config/feature flags to dark-launch and kill-switch risky features without a store release.

## Release process

1. Beta: TestFlight / Play internal and closed testing, with release notes and a short checklist for testers.
2. **Staged rollout** (e.g., 1% → 10% → 50% → 100% / phased release); watch crash-free rate, ANR, startup time and key funnels; halt on regression.
3. Support old app versions: backward-compatible API changes, a minimum supported version and a graceful force-update path.
4. Migrations of local data are tested from several previous versions.

## Store-review readiness

- Privacy labels/data safety accurate; permission strings (`NS*UsageDescription`) clear and specific; account deletion available; sign-in with Apple if third-party login is offered (where required); in-app purchases for digital goods; no private APIs or hidden features; demo credentials for reviewers; target the required SDK/API level; screenshots, metadata and age rating correct.

## Output

Tests added with the run command, CI/release changes, a pre-release checklist with items verified vs. not verifiable here, and rollout/rollback plan.
