---
name: desktop-ui-platform
description: Build desktop interfaces that feel native and efficient on Windows, macOS and Linux: window management, menus, keyboard shortcuts, context menus, drag and drop, DPI scaling, multi-monitor, resizing, dark mode, tray, notifications and accessibility. Use whenever creating or changing windows, dialogs, layouts or controls in Electron, Tauri, WPF, WinUI, .NET MAUI, WinForms, Qt, GTK, SwiftUI/AppKit or Flutter desktop, or when the user says "десктоп", "окно", "горячие клавиши", "меню", "трей", "как нативное", "DPI", "тёмная тема".
---

# Desktop UI and Platform Feel

Desktop users have a mouse, a keyboard, big screens, many windows and high expectations for speed. Check the project's existing theme, components and window setup first and reuse them. If there is no reference design, write a short design brief (tone, accent, type pairing, density) so the app does not look like a default template.

## Platform conventions

- Follow the host OS: Windows (Fluent / WinUI: Mica or acrylic where appropriate, title bar, snap layouts), macOS (HIG: unified toolbar, menu bar, sidebar, traffic lights, Cmd shortcuts), Linux (GNOME HIG / KDE HIG per toolkit). In cross-platform code adapt: modifier keys (Ctrl vs Cmd), menu placement, window controls, file dialogs, fonts, scrollbars.
- Use the native or standard menu bar with all commands and their shortcuts listed. A custom title bar must keep drag area, snap/resize behavior, double-click maximize and system buttons working.
- Respect system theme (light/dark/high contrast), accent color, reduced motion, and font scaling.

## Keyboard-first

- Every action reachable by keyboard; shortcuts for frequent actions follow platform standards (Ctrl/Cmd+C, V, Z, S, F, N, W, comma for preferences on macOS). Show shortcuts in menus and tooltips.
- Logical Tab order, visible focus, Esc closes dialogs/popovers, Enter confirms, arrow keys navigate lists and trees, type-to-search where it fits.
- Provide a command palette (Ctrl/Cmd+K) for apps with many commands.
- Avoid shortcut collisions with the OS and with text-editing keys.

## Mouse and pointer

- Hover states, right-click context menus (with the same actions as menus), double-click to open/edit, drag and drop (files in, items reordering, drag out), multi-select with Shift/Ctrl/Cmd, resize handles on splitters and panels.
- Targets can be smaller than on mobile but keep at least ~24 px hit areas; support touch and pen on Windows touchscreens.

## Windows and layout

- Remember window size, position, maximized state and monitor; restore sensibly when a monitor disappears. Enforce a sensible minimum size; layout must reflow instead of clipping.
- **DPI and scaling**: per-monitor DPI awareness, vector or multi-resolution assets, test at 100%, 150%, 200% and when dragging between monitors with different scale.
- Use resizable split panes, collapsible sidebars, dockable/tabbed areas for dense tools. Modal dialogs only for blocking decisions; prefer inline editing and non-modal panels.
- Multi-window: new windows via Ctrl/Cmd+N or "open in new window"; state per window.
- Tray/menu-bar icon only when the app really runs in the background; offer "quit" explicitly and a setting to start at login (off by default).
- Native notifications with actions; do not spam. Handle focus: do not steal focus from other apps.

## Visual quality

- Semantic tokens for color, spacing, radius, type; light and dark variants; no hardcoded colors in components. Density options (compact/comfortable) for data-heavy apps.
- Real icon set, consistent stroke and size; crisp at all DPIs. Clear hierarchy: toolbar, primary content, secondary panels, status bar.
- Subtle, quick transitions (100-200 ms); no animation that delays a frequent action.

## Accessibility

- Expose roles, names, states and relationships to the platform API (UI Automation on Windows, NSAccessibility, AT-SPI; ARIA in web-based shells). Test with Narrator/NVDA, VoiceOver, Orca, keyboard only, high contrast, and 200% text/zoom.
- Contrast 4.5:1 for text; no color-only meaning; captions and labels for icon-only buttons.

## Output

Windows/screens with all states (loading, empty, error, disabled), shortcuts and menu entries added, DPI and theme handling noted, and a list of accessibility names/roles added.
