---
name: refactoring
description: Apply Martin Fowler's Refactoring methodology (Refactoring: Improving the Design of Existing Code) to detect code smells, plan safe restructuring, and execute mechanical refactoring steps without changing observable behavior — calibrated to task size and risk, with real code examples. Use this whenever the user asks to refactor code, clean up or restructure existing code, identify code smells, extract a method/class, simplify a conditional, reduce duplication, improve naming, or explicitly mentions "refactor", "code smell", "technical debt cleanup", "clean up this function/class", or "this code is hard to maintain". Also trigger when reviewing code and the user wants restructuring recommendations, or when deciding whether to refactor now vs. defer it.
---

# Refactoring Engine

A calibrated skill for applying Martin Fowler's Refactoring methodology — scaled to task size and risk, grounded in real code, and honest about the situations that don't fit the textbook case (no tests, shared APIs, deadline pressure, bugs discovered mid-refactor).

**Read `references/` files as needed — don't load all of them up front.** Each is pointed to below with a note on when it's relevant.

---

## 0. The Four Golden Rules (never violated, regardless of tier)

1. **The Two Hats.** Never add a new feature and refactor at the same time. Pick one hat: "refactoring hat" (restructure, behavior unchanged) or "feature hat" (add behavior, structure unchanged for now). If a request mixes both, say so and propose doing them as separate steps.
2. **Preserve observable behavior.** Refactoring changes *how* the code works, never *what* it does from the outside — same inputs produce the same outputs, same side effects, same errors. If behavior needs to change, that's not refactoring; say so explicitly (see `references/bug-discovery.md` for the one legitimate exception: a bug the refactoring incidentally reveals).
3. **Small, safe steps.** Move through tiny mechanical steps: change → verify → next change. Never batch multiple unrelated transformations into one unverified leap.
1. Actually 4: **Tests are the safety net.** Never refactor code with no automated coverage over the code being touched — either find existing tests or write characterization tests first (`references/no-tests-scenario.md`).

---

## 1. Classify the task first (always do this before anything else)

| Tier | Example | What to apply |
|---|---|---|
| **Tier 0 — Trivial** | Rename a local variable, remove a stray comment, delete obviously dead code with a clear diff | Just do it. No smell report, no plan, no verification table. |
| **Tier 1 — Localized** | Extract one method, simplify one conditional, remove duplication inside one function | Identify the smell, apply one Fowler mechanic (Section 3), confirm tests pass. No multi-step plan needed. |
| **Tier 2 — Structural** | Split a large class, replace a type-code conditional with polymorphism, restructure one module | Full smell diagnostic + step-by-step plan (Section 4) + verification (`references/verification.md`). |
| **Tier 3 — Cross-cutting** | Refactor a pattern that repeats across many files, change a widely-used method's signature, restructure a subsystem boundary | Everything in Tier 2, plus `references/large-scale-refactoring.md` and `references/shared-api-refactoring.md`. Pause for explicit approval before executing (see `references/authority-model.md`). |

If unsure which tier applies, default one tier lower than your first instinct — the failure mode this prevents is producing a five-phase migration plan for what was actually a five-minute `Extract Method`.

**Before applying anything else, also check Section 7 ("When NOT to refactor")** — some code genuinely isn't worth the effort right now. Say so plainly if that's the case.

---

## 2. Operating modes (inferred from context, not from flags)

Real Skills infer intent from what's actually being asked — they don't wait for a `--flag`. Read the request and pick the mode:

- **Diagnose-only mode** — the person wants an assessment ("what's wrong with this code", "is this worth refactoring", "review this for smells") without wanting the code rewritten yet. Produce the smell diagnostic + plan (Section 4) and stop there — don't touch the code.
- **Execute mode** — the person has a specific, already-agreed change in mind ("extract this into its own method", "replace this switch with polymorphism"). Apply the one mechanic, show the result, confirm safety (Section 5).
- **Full-cycle mode** — an open-ended "refactor this" with no plan yet. Diagnose first, **pause and show the plan before executing** (this is not optional for Tier 2/3 — see `references/authority-model.md`), then execute step by step once confirmed.

If the request is ambiguous about which mode is wanted, default to **diagnose-only** and ask before executing — showing a plan costs little; executing an unwanted rewrite costs a lot.

---

## 3. Fowler's Refactoring Mechanics — with real examples

Every mechanic below has a **before/after code example** in `references/code-examples.md` — read it before executing any of these on real code; the mechanical steps only make sense with the concrete transformation in front of you.

| Mechanic | Used for |
|---|---|
| Extract Method | Long Method, Duplicate Code, Comments explaining a code block |
| Extract Class | Large Class, Divergent Change |
| Move Method / Move Field | Feature Envy, Shotgun Surgery |
| Replace Temp with Query | Long Method, redundant local variables |
| Introduce Parameter Object | Long Parameter List |
| Replace Conditional with Polymorphism | Switch Statements, type-code branching |
| Replace Type Code with Class/Subclasses | Primitive Obsession |
| Hide Delegate / Remove Middle Man | Message Chains, Middle Man |
| Inline Method / Inline Class | Dead abstraction, Middle Man, unnecessary indirection |
| Rename Method/Variable | Poor naming masking any smell |

**Detection isn't just the smell's name** — read `references/smell-detection-signals.md` for the concrete signals (not just definitions) that indicate each smell is actually present, so the diagnostic step doesn't become a guess.

---

## 4. Execution Protocol (Tier 2/3)

1. **Diagnose** — scan for code smells (Section 6 catalog + `references/smell-detection-signals.md`).
2. **Assess risk** — for each smell, cite the concrete evidence behind its severity rating (see `references/verification.md` for the risk-scoring criteria; a bare "High/Medium/Low" with no justification isn't a real assessment).
3. **Check test coverage over the target code** — if none exists, stop and go to `references/no-tests-scenario.md` before touching anything.
4. **Build the plan** — sequence smells into low-risk, ordered steps. Note any step that touches a shared/public interface (`references/shared-api-refactoring.md`) or spans multiple files (`references/large-scale-refactoring.md`).
5. **Pause for approval** (Tier 2/3, per `references/authority-model.md`) before executing.
6. **Execute one mechanic at a time** — change, run tests, confirm green, move to the next step. Commit discipline per `references/version-control-discipline.md`.
7. **If a step fails or behavior changes unexpectedly** — stop, don't push forward; see `references/rollback-and-failure.md`.
8. **Summarize** — what changed structurally, what stayed identical behaviorally, and current test status.

Tier 0/1: skip straight to step 6 for the one mechanic involved.

---

## 5. Verification — every refactoring claim needs evidence

"Tests pass" is not a verification — *which* tests, confirming *what*, is. See `references/verification.md` for the full output template. The short version: never claim a refactoring is safe without naming the actual test(s) run and what they cover.

---

## 6. Code Smells & Refactoring Catalog

| Category | Code Smell | Refactoring Solution |
|---|---|---|
| **Bloaters** | Long Method | Extract Method, Replace Temp with Query, Introduce Parameter Object |
| | Large Class | Extract Class, Extract Subclass, Extract Interface |
| | Primitive Obsession | Replace Data Value with Object, Replace Type Code with Class/Subclasses |
| | Long Parameter List | Introduce Parameter Object, Preserve Whole Object |
| **Object-Orientation Abusers** | Switch Statements | Replace Conditional with Polymorphism, Replace Type Code with State/Strategy |
| | Refused Bequest | Replace Inheritance with Delegation, Push Down Method |
| | Alternative Classes with Different Interfaces | Rename Method, Move Method, Extract Superclass |
| **Change Preventers** | Divergent Change | Extract Class (split responsibilities within one class) |
| | Shotgun Surgery | Move Method, Move Field, Inline Class (consolidate scattered changes) |
| **Dispensables** | Comments (masking unclear code) | Rename Method, Extract Method — make the code explain itself |
| | Duplicate Code | Extract Method, Pull Up Method, Form Template Method |
| | Dead Code | Inline Class, Remove Parameter, delete outright |
| **Couplers** | Feature Envy | Move Method, Extract Method |
| | Message Chains | Hide Delegate, Extract Method |
| | Middle Man | Remove Middle Man, Inline Method |

---

## 7. When NOT to refactor

Refactoring has a real cost — time, risk of introducing a regression, review overhead. Skip or defer it when:

- **The code is about to be deleted or replaced anyway** (a feature being sunset, a module already scheduled for removal).
- **There's a hard deadline and the refactoring isn't blocking the immediate task** — see `references/deadline-pressure.md` for how to phrase deferring this honestly instead of silently skipping it.
- **No test coverage exists and writing characterization tests isn't feasible in the time available** — refactoring genuinely untested code blind is not "safer," it's a gamble; say so rather than proceeding as if it's routine.
- **The change touches a widely shared/public API with no migration plan** — see `references/shared-api-refactoring.md`; don't refactor out from under other teams without a coordinated path.

If a person asks to refactor something in one of these categories, say so directly, explain the specific risk, and let them decide — don't silently comply and don't silently refuse either.

---

## 8. Situations needing more depth — read the relevant reference

- **No tests exist over the code being touched** → `references/no-tests-scenario.md` (Characterization Tests).
- **Deciding if this is refactoring or actually a rewrite** → `references/refactor-vs-rewrite.md`.
- **The refactoring spans many files/modules** → `references/large-scale-refactoring.md`.
- **Git/commit discipline during a multi-step refactoring** → `references/version-control-discipline.md`.
- **The method/class being changed is used by another team or is a public API** → `references/shared-api-refactoring.md`.
- **When to pause and get explicit approval before executing** → `references/authority-model.md`.
- **A refactoring step fails partway, or behavior changed unexpectedly** → `references/rollback-and-failure.md`.
- **The refactoring surfaces a pre-existing bug** → `references/bug-discovery.md`.
- **The codebase is functional/non-OOP and classic patterns don't map directly** → `references/language-variance.md`.
- **A cleaner structure would hurt performance** → `references/performance-tradeoffs.md`.
- **There's a deadline and refactoring might need to wait** → `references/deadline-pressure.md`.
- **The code is in a high-stakes domain (financial, medical, safety-critical)** → `references/criticality-calibration.md`.
- **Recognizing a code smell concretely, not just by definition** → `references/smell-detection-signals.md`.
- **IDE-automated refactoring vs. manual, and what that changes about safety** → `references/tooling-vs-manual.md`.
- **Structuring the Tier 2/3 output with real evidence, plus risk-scoring criteria** → `references/verification.md`.

## Appendix — noted but out of scope

Full formal program-verification techniques (proving behavioral equivalence mathematically) and organization-wide refactoring governance (mandatory review boards, company-wide deprecation policies) are real but sit a level above what a coding assistant should assume — they depend on tooling and process this skill doesn't have visibility into.
