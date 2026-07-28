# Version Control Discipline During Refactoring

## Commit granularity

Each individually-verified mechanical step should be its own commit, not batched with other steps or with any feature work. This is what makes `git bisect` and rollback actually useful later — a commit that mixes three refactoring mechanics together is as hard to reason about as no commits at all.

## Commit message convention

Prefix refactoring commits distinctly from feature/fix commits so history stays scannable:

```
refactor: extract calculateTotal from printInvoice

- Long Method smell: printInvoice mixed total calculation with printing
- Extracted pure calculation into calculateTotal()
- No behavior change — InvoiceTest suite passes unchanged (4/4)
```

Keep the "no behavior change" confirmation in the commit message itself — it's the receipt that this step honored the Two Hats rule, and it's useful to future readers deciding whether a commit is safe to revert in isolation.

## Never mix refactoring commits with feature commits

If a feature request naturally surfaces a needed refactoring first (e.g., "add cancellation" requires extracting a method that will be shared), do the refactoring as its own preceding commit with its own verification, *then* add the feature in a separate commit on top. This lets either be reverted independently if something goes wrong.

## Before starting multi-step Tier 2/3 work

Confirm the working tree is clean (no uncommitted unrelated changes) before beginning, so that if a step needs to be rolled back, `git diff`/`git stash` isn't tangled with unrelated work. If it's not clean, say so and ask whether to proceed anyway or handle the existing changes first.
