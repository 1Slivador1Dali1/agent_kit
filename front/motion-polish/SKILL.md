---
name: motion-polish
description: Add purposeful micro-interactions, transitions and entrance animations that make UI feel alive and responsive, with performance and reduced-motion handled. Use when the user wants the interface to feel polished, smooth, "живой", "анимации", "микроанимации", "hover effects", "transitions", or when a finished UI feels static or flat.
---

# Motion Polish

Motion should explain change (what appeared, moved, or was acted on), confirm actions, and add personality. It should never slow the user down.

## Principles

- **Purpose over decoration**: every animation answers "what changed?" or "what happened?".
- **Fast**: micro-interactions 120-200ms, transitions 200-350ms, large entrances up to ~500ms. Interactive feedback must start instantly.
- **Easing**: ease-out for entering, ease-in for leaving, ease-in-out for moving on screen. Avoid linear except for progress/loops. Use the motion tokens from `design-tokens` if they exist.
- **Animate cheap properties only**: `transform` and `opacity`. Avoid animating width/height/top/left/box-shadow on large areas. Use `will-change` sparingly.

## Where to apply

1. **Controls**: hover lift/shift, pressed scale (~0.97), focus-ring transition, toggle and checkbox state morphs.
2. **Feedback**: success check draw, error shake (small, once), button loading morph, toast slide + fade.
3. **Entrances**: staggered reveal of list/grid items (30-60ms steps, cap total), section fade-up on scroll via IntersectionObserver (once, not repeatedly).
4. **Navigation and overlays**: modal/drawer/popover scale+fade from their trigger origin, tab indicator sliding, accordion height via grid-template-rows or the View Transitions API where supported.
5. **Layout changes**: smooth list reordering / add / remove (Framer Motion `layout`, or FLIP technique).
6. **Skeletons**: subtle shimmer, not flashing.

## Tooling choice

Check what the project already uses. Prefer CSS transitions/keyframes for simple effects. Use Framer Motion (React) or the Motion library when orchestration, layout animation or gestures are needed. Do not add a dependency for a hover effect.

## Non-negotiable

- Respect `prefers-reduced-motion`: remove parallax, large movement and auto-play; keep simple opacity changes or none.
- No animation that blocks interaction or delays content the user is waiting for.
- No infinite decorative loops near text people read.
- Test that animations do not cause layout shift or jank on mid-range devices.

## Output

Implement the motion, keep durations and easings in tokens, include the reduced-motion block, and list in a few lines what was animated and why.
