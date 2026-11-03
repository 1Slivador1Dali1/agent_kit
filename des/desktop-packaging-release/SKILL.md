---
name: desktop-packaging-release
description: Test, package and ship desktop apps: unit/integration/UI tests, installers (MSI, MSIX, NSIS, Squirrel, dmg, AppImage, deb/rpm), code signing and notarization, auto-update, versioning, CI/CD, crash reporting, telemetry, staged rollout and uninstall behavior. Use when writing tests for desktop code, building installers, setting up updates or CI, diagnosing a crash from users, or when the user says "установщик", "сборка", "подпись", "автообновление", "релиз", "electron-builder", "Tauri bundle", "MSIX", "notarization", "тесты десктопа".
---

# Desktop Testing, Packaging and Release

Users cannot "refresh" a broken desktop app, and every bad release lives on machines you do not control. Test first, ship gradually, and keep the ability to roll forward quickly.

## Testing

- **Unit tests** for domain logic, ViewModels/stores, parsers, migrations and path handling. Inject clock, file system and OS services.
- **Integration tests** with a temporary directory/database: file save/open, atomic write failure, migration from every previous data version, import of malformed files, locked files and read-only locations.
- **UI/E2E tests** for critical flows (first run, open/edit/save, settings, update prompt): Playwright for Electron, WebdriverIO/tauri-driver for Tauri, FlaUI/WinAppDriver for Windows apps, Qt Test, XCUITest on macOS. Use stable automation IDs, not coordinates or text.
- **Visual/regression**: screenshots in light/dark, 100% and 200% DPI, small windows.
- Bug fix = failing test first, then the fix. Run affected tests before finishing and report the command and result.

## Test matrix

- Windows 10/11 (x64 and ARM64 if supported), recent macOS (Apple Silicon and Intel if supported), main Linux distros/desktop environments if supported. Test clean install, upgrade from previous versions, non-ASCII/space-containing user names and paths, non-admin accounts, high-DPI multi-monitor, offline mode, restricted/corporate environments (proxy, locked-down policies) and low disk space.

## Packaging

- Choose per platform and target audience: Windows MSIX / MSI (enterprise, silent install) / NSIS or Squirrel (per-user, simple auto-update); macOS signed and notarized `.dmg`/`.pkg`; Linux AppImage, deb/rpm, Flatpak/Snap.
- Prefer **per-user install** without admin rights; support silent install flags and a documented MSI/pkg for IT.
- Register file associations, protocol handlers, shortcuts and autostart only with user consent; **uninstall cleanly** (remove app, shortcuts, registry entries; ask before deleting user data).
- Reproducible builds in CI; lock the toolchain; embed version, commit and build number; produce checksums and SBOM.

## Signing and trust

- Windows: sign executables and installers (Authenticode, timestamped); build SmartScreen reputation. macOS: Developer ID, hardened runtime, entitlements minimal, notarize and staple. Linux: signed repos/packages. Store keys/certs in a hardware module or CI secret store with restricted access, and document the renewal and recovery process.

## Auto-update

- Use a proven updater (electron-updater, Squirrel, Tauri updater, Sparkle, WinSparkle, MSIX/App Installer, Velopack) rather than a homemade one.
- Updates over HTTPS with signature verification, downgrade protection, delta updates where useful, background download, "restart to update" prompt that never interrupts unsaved work, and rollback if the new version fails to start.
- Channels (stable/beta), **staged rollout** (e.g., 5% → 25% → 100%) with a kill switch; support a minimum supported version and migration of local data between versions.

## Observability

- Crash reporting (Sentry, Crashpad/Breakpad, Windows Error Reporting) with symbols/source maps uploaded in CI and release/version tags; capture native and renderer/JS crashes; redact PII and file paths.
- Structured local logs with rotation and a "Copy diagnostics"/"Export logs" command for support. Telemetry is minimal, documented and opt-in or clearly disclosed (GDPR/CCPA).
- Watch crash-free sessions, startup time and update success rate after each rollout; halt on regression.

## Release checklist

Version bumped; changelog; migrations tested from N-2; signed and notarized artifacts verified on clean machines (install, launch, update, uninstall); SmartScreen/Gatekeeper behavior checked; licenses and third-party notices updated; rollback plan ready.

## Output

Tests added with the run command, packaging/CI/update configuration changes, and a pre-release checklist marking items verified here vs. needing a real machine.
