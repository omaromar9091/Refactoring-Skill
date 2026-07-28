# Large-Scale / Cross-File Refactoring

When a smell or pattern repeats across many files (the same switch statement copy-pasted in 8 places, the same primitive-obsession pattern across a dozen modules), the mechanics are the same but the sequencing and risk management change.

## Sequencing rules

1. **Fix the pattern in one place first, completely, with full verification** — treat it as a normal Tier 2 refactoring. Don't attempt to change all 8 occurrences simultaneously.
2. **Only after the first instance is verified safe, replicate the same mechanical transformation to the remaining instances one at a time**, re-verifying after each. Resist the urge to batch multiple files into one unverified commit just because the transformation is "the same" each time — subtle differences between instances are exactly where this goes wrong.
3. **If the codebase is large enough that manual replication is impractical**, prefer a scripted/tooling-assisted transformation (see `tooling-vs-manual.md`) with a diff review step before applying broadly — not a manual find-and-replace across dozens of files without individual verification.

## Communication

- **Flag the scope explicitly before starting** — "this pattern appears in 8 files; I'll fix and verify one first, then replicate" — so the person knows this isn't a five-minute task before committing to it.
- **Large-scale refactoring is Tier 3 by definition** (per the main SKILL.md's tiering table) — pause for approval before executing broadly, even if the first instance went smoothly, per `authority-model.md`.

## Parallel work risk

If other people are actively working in the files being touched, a large-scale refactoring increases merge-conflict risk substantially. Mention this if it's a foreseeable issue (e.g., "this touches files in the `payments/` module — worth checking if anyone else has open branches there first") rather than assuming solo ownership of the codebase.
