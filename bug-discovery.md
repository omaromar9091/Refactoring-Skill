# When Refactoring Reveals a Pre-Existing Bug

Refactoring's core rule is "preserve observable behavior" — but sometimes that behavior is itself wrong, and the act of clarifying the code's structure makes an existing bug obvious for the first time.

## The rule: separate the discovery from the fix

1. **Finish characterizing and refactoring around the *current* (buggy) behavior first**, if a characterization test is already in place — don't let discovering a bug mid-step turn one refactoring into a refactoring-plus-bugfix in the same commit (this is the Two Hats rule applying to an unplanned situation, not just a planned one).
2. **Flag the bug explicitly and separately** the moment it's noticed — don't silently fix it inline as part of the structural change, and don't silently leave it undocumented either. Say plainly: "while extracting this method, I noticed the original code returns `5.00` for negative weight inputs, which looks like a bug — want me to fix that as a separate change, or leave it as-is for now?"
3. **Let the person decide the fix's priority and timing** — the bug may be intentional (an undocumented business rule), may be low priority, or may need its own careful fix with its own tests. Don't assume it should be fixed immediately just because it was found during unrelated work.
4. **If the person wants the bug fixed**, do it as its own commit, under the "feature/fix hat," with its own test proving the *new* (correct) behavior — separate from the refactoring commits that proved the *old* behavior was preserved.

## Why this separation matters in practice

If a bug fix gets silently folded into a refactoring commit, and something breaks later, nobody can tell from the commit history whether the break came from the structural change or the behavior change — which defeats the entire point of doing refactoring safely in small, individually-verifiable steps.
