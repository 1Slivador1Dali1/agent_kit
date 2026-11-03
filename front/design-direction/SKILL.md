---
name: design-direction
description: Choose a deliberate visual direction BEFORE writing any UI code, so the result is distinctive and not a dry, generic template. Use whenever the user asks to build, redesign or "make nicer" any page, screen, landing, dashboard, form or component, and there is no Figma or reference design. Trigger on "сделай интерфейс", "красиво", "не сухой UI", "redesign", "new page", "landing", "dashboard", even if the user does not mention design explicitly.
---

# Design Direction

There is no Figma. You are the designer. Generic output happens when you start coding with default choices (white bg, gray cards, blue button, system font). Fix this by committing to a direction first.

## Step 1: Write a 5-line design brief (in your reply, before code)

1. **Audience and job**: who uses this, what is the one primary action.
2. **Tone**: pick ONE strong word (editorial, playful, brutalist, calm-clinical, luxury-minimal, retro-tech, warm-organic, dense-pro-tool). Not "modern and clean".
3. **Signature move**: one memorable thing (oversized type, unusual grid, strong color block, texture, distinctive illustration style, asymmetric layout).
4. **Palette logic**: 1 dominant, 1 accent, neutrals tinted toward the dominant. Never pure #000 / #fff / #808080.
5. **Type pairing**: one display + one text face, with a reason.

If the project already has a design system, tokens, or an existing look, follow it and skip the invention. Ask at most one clarifying question; otherwise state assumptions and proceed.

## Step 2: Apply these rules while building

- **Hierarchy first**: one clear focal point per screen. Size, weight and color contrast should make the primary action obvious in under 2 seconds.
- **Type**: use a modular scale (1.2-1.333). Display text gets tight tracking and line-height 1.05-1.2; body 1.5-1.7. Avoid Inter/Roboto/Arial as the *only* font; choose a characterful pair (e.g. a serif or grotesk display + neutral text face).
- **Space**: generous, consistent rhythm on a 4/8px base. Dry UI is usually cramped or uniformly spaced. Vary density deliberately: tight inside groups, loose between sections.
- **Color**: dominant color with sharp accent beats an evenly distributed palette. Use tinted neutrals, subtle gradients or grain for depth. Dark and light themes are designed separately, not inverted.
- **Layout**: break the box where it helps: asymmetry, overlap, full-bleed sections, sticky side columns. Avoid the default "centered hero + three equal cards + footer".
- **Depth and surface**: layered shadows (soft ambient + tight contact), 1px borders at low contrast, radius consistent across the app. Pick a surface style and keep it.
- **Imagery**: use real SVG shapes, gradients, patterns, or CSS-drawn illustration instead of empty gray placeholders. Never leave "Lorem ipsum" or blank boxes.
- **Copy**: write real, specific microcopy that matches the tone. "Save changes" beats "Submit".

## Step 3: Anti-slop checklist (fail = revise)

- Purple-to-blue gradient on white with a centered hero
- Every card identical with the same shadow and radius
- Emoji used as icons in place of an icon set
- Default Tailwind blue-500 as the brand color
- Placeholder text or gray boxes in the final result
- Everything centered, nothing aligned to a grid

## Output

Brief first (short), then code. After coding, list in 2-3 lines which choices carry the direction, so the user can steer ("more playful", "less contrast").
