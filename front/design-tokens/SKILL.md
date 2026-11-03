---
name: design-tokens
description: Create or extend a design-token system (colors, type scale, spacing, radius, shadows, motion) as CSS variables or Tailwind theme, so every component stays consistent without a Figma file. Use at the start of any new UI project, when styles look inconsistent, when hardcoded hex/px values appear, or when the user asks for a theme, dark mode, "design system", "токены", "единый стиль".
---

# Design Tokens

Without Figma, tokens are the single source of design truth. Consistency is what makes UI feel designed instead of assembled. Check first whether tokens already exist (`:root` variables, `tailwind.config`, `theme.ts`, `globals.css`); extend them, don't duplicate.

## Create tokens in this order

1. **Color (semantic, not literal)**
   - Brand scale (50-900) from one dominant hue; neutral scale tinted toward it.
   - Semantic roles: `--bg`, `--surface`, `--surface-raised`, `--border`, `--text`, `--text-muted`, `--accent`, `--accent-contrast`, `--success`, `--warning`, `--danger`, `--focus-ring`.
   - Define light and dark values for every role. Components use only roles, never raw hex.
   - Text/background pairs must reach WCAG AA (4.5:1 body, 3:1 large text and UI).
2. **Type**: font families (display, text, mono), modular scale `--text-xs` ... `--text-4xl`, line-heights, weights, tracking. Use `clamp()` for fluid headings.
3. **Space**: 4px base scale (`--space-1` = 4px ... up to 96px+). Section spacing separate from component spacing.
4. **Shape**: 2-3 radii (`--radius-sm/md/lg`) plus a pill. Pick one and keep it across components.
5. **Elevation**: 3-4 layered shadow levels, tuned for both themes (dark theme relies more on borders and surface lightness than shadow).
6. **Motion**: durations (`--dur-fast` 120ms, `--dur-base` 200ms, `--dur-slow` 360ms) and easings (`--ease-out`, `--ease-in-out`, a gentle spring-like cubic-bezier).
7. **Z-index and breakpoints**: named layers (`--z-dropdown`, `--z-modal`, `--z-toast`) and a breakpoint list.

## Rules

- Prefer CSS variables as the base; map them into Tailwind (`theme.extend`) or the CSS-in-JS theme if used.
- Name by purpose (`--text-muted`), not by value (`--gray-500`) at the component layer.
- After creating tokens, grep the code for hardcoded colors, px font sizes and magic numbers, and replace them with tokens.
- Document the system in a short `DESIGN.md` (palette, fonts, spacing, radius, do/don't) so future prompts stay consistent.

## Output

Token file(s), the dark-mode override block, a mapping to the existing styling approach, and the short `DESIGN.md`.
