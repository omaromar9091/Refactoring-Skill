# Criticality Calibration (High-Stakes Domains)

The same refactoring mechanic carries different real-world risk depending on what the code controls. A `Long Method` in a hobby project's UI code and a `Long Method` in payment-processing or medical-dosage logic are not the same level of concern, even though the smell and the fix look identical on paper.

## Signals that code is high-stakes

- Financial calculations (payments, billing, interest, balances).
- Medical/health-related logic (dosage calculations, diagnostic logic, patient data handling).
- Safety-critical control logic (industrial control systems, automotive, aviation-adjacent code).
- Security-sensitive code (authentication, authorization, cryptography, access control).
- Code operating on regulated data (financial records subject to audit, health records subject to compliance requirements).

## What changes when code is high-stakes

1. **Raise the bar for test coverage before touching anything.** In `no-tests-scenario.md`'s terms, don't proceed with a thin characterization-test pass here — push for coverage of edge cases specifically (boundary values, error paths, unusual but valid inputs) rather than just the happy path, before refactoring begins.
2. **Prefer smaller, more conservative steps than usual**, even for what would normally be a Tier 1 change elsewhere — the cost of a subtle regression is categorically higher here.
3. **Escalate to Tier 2/3 pause-and-approve treatment** (per `authority-model.md`) even for changes that would otherwise be Tier 0/1, given the stakes.
4. **Say so explicitly** — "this touches payment calculation logic, so I'd like to be more conservative than usual about verification before proceeding" — rather than silently applying extra caution without explaining why the pace is different from other refactoring work.
5. **Don't refuse to refactor high-stakes code** — poorly-structured code in these domains is itself a risk (harder to review, easier to introduce bugs into during *future* changes). The calibration is about *how carefully*, not *whether*.

## Don't assume risk level from file location alone

A file named `payments.js` is a strong signal, but so is logic that computes money/dosage/access decisions regardless of where it lives. Read what the code actually does, not just its file path, before deciding this calibration applies.
