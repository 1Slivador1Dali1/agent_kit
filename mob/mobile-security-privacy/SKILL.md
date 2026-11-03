---
name: mobile-security-privacy
description: Secure a mobile app and protect user privacy: secure token/credential storage, network security, certificate pinning, biometrics, deep link and intent validation, permissions, logging, code obfuscation, third-party SDKs and store privacy declarations. Use when handling login, tokens, payments, personal data, deep links, analytics, or before release, or when the user says "безопасность приложения", "токены", "keychain", "keystore", "deep link", "приватность", "GDPR", "App Store review".
---

# Mobile Security and Privacy

Assume the device can be rooted, the network can be hostile, and the APK/IPA will be reverse-engineered. Never trust the client for authorization.

## Secrets and storage

- Store tokens and credentials in the **iOS Keychain** or **Android Keystore / EncryptedSharedPreferences / DataStore with encryption**; in RN/Flutter use secure-storage libraries backed by those. Never in plain SharedPreferences, UserDefaults, AsyncStorage, logs or the app bundle.
- No API secrets, private keys or admin credentials in the app: anything shipped in the binary is public. Use short-lived tokens issued by your backend.
- Encrypt sensitive local databases; exclude sensitive data from backups where appropriate; clear data on logout.

## Auth

- OAuth 2.1 / OIDC with PKCE through the system browser (ASWebAuthenticationSession, Custom Tabs); no embedded-webview login.
- Short-lived access tokens + rotating refresh tokens; single-flight refresh; revoke on logout.
- Biometrics (Face ID/Touch ID/BiometricPrompt) gate access to keys in Keychain/Keystore, with a device-credential fallback; do not use a boolean flag as the only check.

## Network

- HTTPS only (ATS on iOS, `cleartextTrafficPermitted=false` on Android); validate certificates; consider certificate/public-key pinning for high-risk apps with a rotation plan and backup pins.
- No sensitive data in query strings. Validate all server responses; handle malformed data without crashing.

## Entry points

- **Deep links / Universal Links / App Links / intents**: verify domain association; treat all parameters as untrusted input; require authentication for sensitive actions; never auto-execute destructive actions from a link.
- Android components: `exported=false` unless needed, permission-protect exported ones, use `PendingIntent.FLAG_IMMUTABLE`. WebViews: disable file access and JS bridges unless required, allow-list URLs.
- Clipboard, screenshots and app switcher: mask sensitive screens (`FLAG_SECURE`, blur on background).

## Permissions and privacy

- Request the minimum permissions, at the moment of need, with a clear rationale. Prefer approximate location, photo picker and one-time permissions.
- Collect the minimum data; document each SDK's data use; provide account deletion and data export where required (App Store and Google Play require in-app account deletion).
- Complete the **App Privacy labels (iOS)** and **Data safety form (Android)** accurately; handle ATT only if tracking; respect consent (GDPR/CCPA) before analytics/ads SDKs initialize.
- Never log tokens, PII, or full request bodies in release builds; redact in crash reports and analytics.

## Hardening

- Release builds: obfuscation/minification (R8, Swift symbol stripping), no debug flags, no debuggable builds, optional root/jailbreak and tamper detection for high-risk apps (defense in depth, not a replacement for server checks).
- Keep dependencies updated; audit SDKs; lock versions; check for known vulnerabilities.
- Server must independently enforce authorization, rate limits and receipt validation (in-app purchases) for every client action.

## Report format

```
[Severity] <issue> — <file/line> — <risk in one line> — <fix>
```
Fix critical and high directly; list the rest with proposed changes.
