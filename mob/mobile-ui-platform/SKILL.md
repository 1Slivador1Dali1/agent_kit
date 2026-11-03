---
name: mobile-ui-platform
description: Build mobile screens that feel native and polished on iOS and Android: platform conventions (HIG / Material 3), navigation patterns, touch targets, safe areas, keyboard handling, gestures, dark mode, dynamic type, haptics and accessibility (VoiceOver/TalkBack). Use whenever creating or changing any mobile screen, component or navigation flow in SwiftUI, UIKit, Jetpack Compose, XML, React Native, Flutter or Expo, or when the user says "мобильный экран", "приложение", "нативный вид", "UI для телефона", "навигация", "адаптив под планшет".
---

# Mobile UI and Platform Feel

Mobile UI is judged by thumb, not mouse. Before building, check the project's existing theme, components and navigation, and reuse them. If there is no design reference, write a short design brief first (tone, accent color, type pairing, signature element) so the app does not look like a default template.

## Platform conventions

- Respect the platform: iOS follows Human Interface Guidelines (large titles, swipe-back, bottom tab bar, sheets, system controls); Android follows Material 3 (top app bar, navigation bar/rail, FAB, back gesture, dynamic color). In cross-platform code (React Native, Flutter) adapt where it matters: back behavior, dialogs, pickers, haptics, scroll physics.
- Navigation: tab bar for 3-5 top-level destinations, stack for drill-down, modal/sheet for focused tasks. Never hide primary navigation behind a hamburger by default. Back always works and preserves state.
- Handle the system back gesture and hardware back button on Android; never trap the user.

## Touch and ergonomics

- Touch targets at least 44x44 pt (iOS) / 48x48 dp (Android), with spacing between adjacent targets.
- Place primary actions within thumb reach (bottom of the screen); avoid tiny controls in top corners.
- Support one-handed use; avoid gestures as the only way to do something (swipe actions need a visible alternative).

## Layout

- Use safe areas and insets everywhere (notch, Dynamic Island, home indicator, status bar, navigation bar, cutouts). Edge-to-edge content with correct padding.
- Keyboard: inputs stay visible when the keyboard opens, scroll to the focused field, correct `keyboardType`, `returnKeyType`, `autofill`/`textContentType`, dismiss on tap outside or scroll.
- Adaptive layout: handle small phones (SE, 360dp), large phones, foldables and tablets (use size classes / window size classes, two-pane where it helps). Support portrait and, where sensible, landscape.
- Text uses scalable units: Dynamic Type (iOS) and `sp` (Android); layouts must survive 200% text without clipping.

## Visual quality

- Semantic color tokens with light and dark variants (follow system theme); verified contrast. No pure black/white defaults and no hardcoded hex in components.
- Typographic scale, 4/8 spacing grid, consistent corner radius and elevation. Real icons from the platform set (SF Symbols / Material Symbols), not emoji.
- Micro-feedback: pressed states, haptics for confirmations (sparingly), smooth transitions. Respect "reduce motion".

## Accessibility (required)

- Every interactive element has an accessibility label, role and state (`accessibilityLabel`, `contentDescription`, `semantics`, `accessibilityRole`). Decorative images hidden from screen readers.
- Logical focus order; group related elements; announce dynamic changes.
- Do not rely on color alone; minimum contrast 4.5:1 for text.
- Test mentally (or with tools) with VoiceOver / TalkBack and the largest text size.

## Output

Screens/components with all states (see mobile-states-offline), tokens used, platform differences noted, and a short list of accessibility labels added.
