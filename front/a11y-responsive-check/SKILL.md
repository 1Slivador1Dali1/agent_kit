---
name: a11y-responsive-check
description: Verify and fix accessibility (WCAG 2.2 AA) and responsive behavior of a UI: contrast, keyboard, focus, semantics, ARIA, touch targets, breakpoints, text scaling. Use before finishing any UI task, when the user mentions "адаптив", "мобильная версия", "доступность", "a11y", "responsive", "mobile", "contrast", or when building navigation, modals, forms, menus and tabs.
---

# Accessibility and Responsive Check

Accessible and responsive is the baseline of quality design, and it is also what Nielsen's heuristics assume in practice. Run this pass after the visual work is done, and fix what you find.

## Accessibility

- **Semantics first**: real `button`, `a`, `nav`, `main`, `header`, `ul`, `label`, headings in logical order (one `h1`). No clickable `div`s. Use ARIA only when native HTML cannot express it.
- **Keyboard**: every interactive element reachable and operable (Tab, Shift+Tab, Enter, Space, Esc, arrows in menus/tabs). Logical tab order. No keyboard traps.
- **Focus**: always visible `:focus-visible` ring with 3:1 contrast, never `outline: none` without a replacement. Modals trap focus, return it to the trigger on close, and close on Esc. Skip-to-content link on multi-page layouts.
- **Contrast**: text 4.5:1 (3:1 for large text), UI components and icons 3:1, in both light and dark themes. Do not convey meaning by color alone.
- **Names and labels**: all inputs have labels; icon-only buttons have `aria-label`; images have meaningful `alt` (or `alt=""` if decorative); link text makes sense out of context.
- **Dynamic content**: announce toasts and async errors with `aria-live` (polite/assertive as appropriate); `aria-expanded`, `aria-current`, `aria-invalid`, `aria-describedby` where relevant.
- **Targets**: minimum 24x24 CSS px (aim for 44x44 on touch), with spacing between targets.
- **Motion**: honor `prefers-reduced-motion`; respect `prefers-color-scheme` and, where possible, `prefers-contrast`.

## Responsive

- Mobile-first CSS; verify at 360, 390, 768, 1024, 1280, 1536 px widths. No horizontal scroll (except intentional containers).
- Fluid type and spacing with `clamp()`; layouts via grid/flex with `minmax`, `auto-fit`, container queries for components.
- Navigation collapses sensibly; primary action stays reachable with a thumb on mobile.
- Tables: scroll container or card transformation; images responsive with `max-width: 100%` and set dimensions to prevent layout shift.
- Page works at 200% browser zoom and larger system text; no truncation of essential content.
- Use `dvh`/`svh` for full-height mobile layouts; add safe-area insets for notched devices.
- Inputs at 16px+ on mobile to avoid iOS zoom.

## Process

1. Read the code for the issues above.
2. If a browser or dev server tool is available, check rendered widths and tab through the page.
3. Fix issues directly, grouped by severity.
4. Report: what failed, what was fixed, what needs a design decision.
