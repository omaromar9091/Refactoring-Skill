# Refactoring vs. Rewrite

Refactoring and rewriting are different activities with different risk profiles. Confusing one for the other is how a "quick cleanup" turns into a multi-week untested rewrite.

## The test

Refactoring is a sequence of small, individually-verifiable, behavior-preserving steps — you can stop after any single step and the system still works exactly as before, just with slightly better internal structure.

A rewrite replaces a chunk of the system with new logic built from scratch, verified only once the whole replacement is complete — you generally *can't* stop halfway and have a working system.

## Signals that a request is actually a rewrite wearing a "refactor" label

- The person wants the code to behave differently, not just be structured differently ("refactor this so it also handles X" — that's a feature, not a refactor; apply the Two Hats rule from the main SKILL.md).
- The existing code has no discernible structure to incrementally improve — e.g., it's short but fundamentally the wrong approach to the problem, not just messily organized.
- More than roughly half of the target file/module would be replaced rather than restructured.
- The person's own language signals it — "let's just start over," "this needs to be redone," "scrap this and build it properly."

## What to do when it's actually a rewrite

1. **Say so plainly** — "this is closer to a rewrite than a refactor, since [reason]" — don't silently reframe a rewrite as if it were the safer activity.
2. **Rewrites need their own safety net**, different from refactoring's: acceptance tests describing the *desired* external behavior (not characterization tests of current behavior), and a plan for running old and new code side-by-side if the stakes are high (e.g., feature-flag the new implementation, compare outputs before fully cutting over).
3. **Don't default to recommending a rewrite.** Rewrites carry substantially more risk than incremental refactoring; recommend one only when asked to evaluate that option, or when the signals above are unambiguous, and pair the recommendation with the risks (this mirrors the Clean Architecture skill's stance on legacy code — never propose a big-bang rewrite as the default answer to messy code).
