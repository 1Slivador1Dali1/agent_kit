---
name: ui-states-feedback
description: Design and implement every state of an interface (loading, empty, error, success, partial, disabled, offline) plus system feedback and microcopy. Use whenever building forms, lists, tables, async actions, dashboards, or when a UI feels flat, lifeless or "dry". Trigger on "состояния", "загрузка", "пустой экран", "ошибки", "skeleton", "toast", "empty state", "form validation", and on any component that fetches or submits data.
---

# UI States and Feedback

Most "dry" UI is just the happy path with data in it. Real polish lives in the in-between states. Nielsen heuristic #1 (visibility of system status) and #9 (help recover from errors) are implemented here.

## For every data-driven component, deliver ALL of these

| State | Requirement |
|---|---|
| **Loading** | Skeleton that matches final layout (no layout shift). Spinner only for short, unknown-size waits. Show progress for >2s tasks. Delay showing the loader ~150ms to avoid flicker. |
| **Empty** | Explain what belongs here, why it is empty, and give one clear primary action. Add a small illustration or icon. Never a blank area. |
| **Error** | Say what happened in plain language, what the user can do, and offer retry. Keep entered data. Place inline near the source; use page-level only for page-level failures. |
| **Success** | Confirm the result (inline change, toast, or animated check). Offer undo for destructive or reversible actions. |
| **Partial / stale** | Show what loaded, mark what failed, allow refetch. |
| **Disabled** | Visibly different and explain why (tooltip or helper text). |
| **Offline / slow** | Detect when possible and say so. |

## Interactions

- Every control has distinct hover, focus-visible, active/pressed, disabled and loading states.
- Buttons that trigger async work: disable to prevent double submit, show inline spinner, keep the label width stable.
- Optimistic updates where safe, with rollback and an error message on failure.
- Destructive actions: prefer undo toast over confirm modal; use a confirm dialog only for irreversible actions, and name the object ("Delete project Atlas?").

## Forms

- Labels always visible (not placeholder-only); helper text for format; required marked consistently.
- Validate on blur, re-validate on change after the first error; never block typing.
- Error text: specific and constructive ("Password needs 8+ characters", not "Invalid input"). Link errors to fields via `aria-describedby`; move focus to the first error on submit.
- Preserve input on failure; choose proper `type`, `inputmode`, `autocomplete`.

## Microcopy

Match the product tone. Use verbs on buttons ("Create project"), avoid jargon and blame ("Something went wrong" is a last resort), no raw error codes in the UI.

## Output

Implement the components with all states wired up (or a state switcher / story if the project has Storybook). List which states were added.
