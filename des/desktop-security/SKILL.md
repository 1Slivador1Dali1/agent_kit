---
name: desktop-security
description: Secure desktop applications: Electron and Tauri hardening, IPC validation, file system and shell access, secrets storage, auto-update integrity, code signing, protocol handlers, third-party content, installer privileges and dependency safety. Use for any desktop code that opens files, runs commands, loads remote content, handles credentials, registers URL schemes, auto-updates, or before release, or when the user says "безопасность десктопа", "Electron security", "contextIsolation", "подпись кода", "автообновление", "права администратора", "SmartScreen".
---

# Desktop Security

A desktop app runs with the user's full privileges. A bug in it is a bug in the user's whole machine. Assume files, URLs, IPC messages and updates can all be malicious. Review changed code against this list and report findings with file and line.

## Web-based shells

**Electron**
- `contextIsolation: true`, `nodeIntegration: false`, `sandbox: true`, `webSecurity` on, `allowRunningInsecureContent` off; never enable the `remote` module.
- `preload` exposes a narrow, explicit API via `contextBridge`; never expose `ipcRenderer`, `require`, `fs`, `child_process` or generic "invoke any channel" helpers.
- Validate sender (`event.senderFrame`/origin) and arguments for every `ipcMain` handler; use schemas.
- Strict CSP, no `eval`, no inline scripts; block navigation and `window.open` to unexpected origins (`will-navigate`, `setWindowOpenHandler`); open external links via `shell.openExternal` only for allow-listed `https:` URLs.
- Do not load remote content in a privileged window; if you must, use a separate sandboxed window/session with no preload.
- Keep Electron and Chromium updated; use the fuses (disable `RunAsNode`, `NODE_OPTIONS`, enable ASAR integrity where possible).

**Tauri**
- Grant the minimum capabilities/permissions per window; scope file system and shell access to explicit paths and commands; no wildcard allowlists.
- Validate all command arguments in Rust; treat the webview as untrusted. Strict CSP.

## Native stacks (.NET, Qt, etc.)

- No hardcoded secrets; avoid unsafe deserialization (BinaryFormatter, unvalidated JSON polymorphism, pickle-like formats); use memory-safe patterns and bounds-checked parsing for native code.
- Do not load DLLs/plugins from user-writable or current-working directories (DLL hijacking); use absolute, signed paths.

## Files, processes and input

- Path handling: normalize and confine to allowed roots; block traversal (`..`), symlink escapes and zip-slip when extracting archives.
- Never build shell command strings from user input; use argument arrays, no `shell: true`, allow-list executables.
- Treat opened documents as untrusted: size limits, safe parsers, no auto-run macros/scripts.
- Deep links and custom protocols (`myapp://`): parse as untrusted input, require confirmation for sensitive actions, never auto-execute destructive operations. Single-instance forwarding of args must be validated too.
- Clipboard and drag-drop content is untrusted.

## Secrets and data

- Credentials and tokens in the OS store (Credential Manager/DPAPI, Keychain, libsecret), not in plain files, logs or the repo. Encrypt sensitive local data when needed.
- No API secrets embedded in the binary; use short-lived tokens from your backend; OAuth with PKCE via the system browser.
- Redact tokens and PII in logs, crash reports and telemetry; telemetry is opt-in or clearly disclosed.

## Updates and distribution

- Updates served over HTTPS, with signature verification (code signing and/or update-manifest signing); pin the update server identity; protect against downgrade attacks; verify hashes before applying.
- Sign all binaries and installers: Windows Authenticode (EV or Azure Trusted Signing helps with SmartScreen reputation), macOS Developer ID + notarization + hardened runtime, Linux package signatures. Keep signing keys in a hardware module/secure CI secret store, never in the repo.
- Least privilege: install per-user when possible, do not require admin for normal operation, avoid running elevated; request elevation only for the specific task.
- Dependencies: pin and lock versions, run the audit tool (`npm audit`, `cargo audit`, `dotnet list package --vulnerable`), avoid abandoned packages, review postinstall scripts.

## Network

- HTTPS with certificate validation always on (never disable verification "for dev" in shipped code); timeouts; don't trust server data blindly.

## Report format

```
[Severity: critical/high/medium/low] <issue> — <file:line> — <exploit scenario in one line> — <fix>
```
Fix critical and high issues directly; list the rest with proposed changes.
