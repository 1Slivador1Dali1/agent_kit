---
name: nielsen-review
description: Audit any UI (code, screenshot, or description) against Nielsen's 10 usability heuristics, score each 0-4, and apply concrete fixes. Use after building or changing a screen, when the user asks for a UX review, usability check, "эвристики Нильсена", "проверь UX", "что не так с интерфейсом", or before declaring a UI task finished.
---

# Nielsen Heuristics Review

Run this as a review pass after generation. Inspect the actual code and, if a dev server or browser tool is available, the rendered result. Be specific: cite the file, component or element for every finding.

## Method

1. Identify the primary user task(s) on this screen.
2. Walk the flow step by step as a first-time user.
3. Score each heuristic 0-4 (0 = fine, 1 = cosmetic, 2 = minor, 3 = major, 4 = blocker) based on severity of problems found.
4. Fix everything scored 2+ in code unless the user asked for report-only. Re-check afterwards.

## The 10 heuristics and what to check

1. **Visibility of system status**: loading, progress, saved/synced indicators, current location (active nav item, breadcrumbs, step indicator), upload/submit feedback.
2. **Match between system and real world**: user language not developer language; familiar icons with labels; logical ordering; sensible units and date formats.
3. **User control and freedom**: undo, cancel, back, close; escape from modals; no dead ends; drafts preserved; easy exit from flows.
4. **Consistency and standards**: same action = same look and wording everywhere; platform conventions (logo links home, underlined links, standard form controls); tokens used, not one-off styles.
5. **Error prevention**: constraints, sensible defaults, input masks, confirmations for irreversible actions, disabled-with-reason, double-submit protection.
6. **Recognition rather than recall**: visible options, recent items, autocomplete, persistent labels, contextual hints, no need to remember info across screens.
7. **Flexibility and efficiency of use**: keyboard shortcuts, tab order, bulk actions, saved filters, sensible defaults, search/command palette for dense apps.
8. **Aesthetic and minimalist design**: one focal point, no competing CTAs, remove irrelevant info, clear grouping, contrast and spacing carry hierarchy.
9. **Help users recognize, diagnose, recover from errors**: plain-language messages, say the cause and the fix, inline placement, keep user input, offer retry.
10. **Help and documentation**: onboarding for first run, empty states that teach, tooltips for non-obvious items, searchable help where complexity warrants.

## Report format

```
Task reviewed: <primary task>
Scores: H1 _ | H2 _ | H3 _ | H4 _ | H5 _ | H6 _ | H7 _ | H8 _ | H9 _ | H10 _
Top issues (by severity):
1. [H#, severity] <what> — <where: file/component> — <fix>
...
Fixes applied: <list>
Remaining / needs product decision: <list>
```

Keep it tight: findings and fixes, no generic advice. If a heuristic does not apply, mark N/A with a short reason.
