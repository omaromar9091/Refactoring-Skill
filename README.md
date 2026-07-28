# Refactoring Skill for Claude

A production-ready [Claude Skill](https://docs.claude.com) that applies Martin Fowler's **Refactoring** methodology (*Refactoring: Improving the Design of Existing Code*) — calibrated to task size and risk, backed by real code examples, and honest about the situations the textbook case doesn't cover: no tests, shared APIs, deadline pressure, and bugs discovered mid-refactor.

Drop it into your skills directory and Claude will automatically reach for it whenever you're cleaning up code, identifying code smells, or deciding whether a piece of code is worth refactoring right now.

---

## Quick install (one command)

Run this from the root of any project. It downloads the skill and places it at `.claude/skills/refactoring/`, where Claude Code and other Claude-based agents pick up skills automatically.

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/omaromar9091/refactoring-skill/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
iwr -useb https://raw.githubusercontent.com/omaromar9091/refactoring-skill/main/install.ps1 | iex
```

Prefer to inspect a script first? Open [`install.sh`](install.sh) or [`install.ps1`](install.ps1) — both just download `SKILL.md` and the `references/` files into your project, nothing else.

---

## Why this exists

Most "refactoring assistant" prompts describe Fowler's catalog well but skip the parts that actually matter in practice: what do you do when the code you need to refactor has zero test coverage? When does "refactor" secretly mean "rewrite"? What happens when the method you're about to clean up is called from twelve other files owned by a different team? What do you do when refactoring reveals a bug that's been there for years?

This skill was built specifically to answer those questions — not just restate the golden rules and the code-smell catalog.

---

## What makes this different

- **🎚️ Won't over-engineer a five-minute cleanup.** A task-tiering system scales the ceremony (diagnostic report, step-by-step plan, verification table) to the actual size of the change — a local rename doesn't get a five-phase migration plan.
- **🧪 Treats "no tests exist" as the normal case, not the exception.** Most real refactoring targets are under-tested legacy code. This skill's default path writes characterization tests to lock in current behavior *before* touching anything, rather than assuming coverage that isn't there.
- **💻 Ships real code, not just pattern names.** Every major mechanic (Extract Method, Replace Conditional with Polymorphism, Move Method, and more) has a working before/after example, plus a concrete "signals to actually look for" table so smell detection isn't just pattern-matching on keywords.
- **🔀 Knows the difference between refactoring and rewriting.** A clear test for when "just clean this up" is secretly "let's start over" — and different safety nets for each.
- **🌐 Handles shared and large-scale refactoring seriously.** Separate guidance for changing a method twelve other files depend on, and for a smell that repeats across dozens of files — including when to pause for explicit approval before touching either.
- **⚖️ Defines a clear authority model.** Tells the agent exactly when to proceed silently (small, contained changes) versus when to show a plan and wait for approval (anything cross-cutting, anything touching a shared interface) — and never lets a "clean this up" request quietly turn into a feature change.
- **🐛 Has an explicit protocol for bugs discovered mid-refactor.** Keeps the "preserve behavior" rule intact by separating the discovery from the fix, instead of silently folding a behavior change into a commit that's supposed to prove nothing changed.
- **⏱️ Talks honestly about deadlines and performance.** Doesn't pretend refactoring is always free — gives real guidance on when to defer it, and when a cleaner structure genuinely does cost something in a hot path.

---

## How it's organized

```
refactoring/
├── SKILL.md                          ← Core rules — tiers, golden rules, catalog, when NOT to refactor
└── references/
    ├── code-examples.md              ← Real before/after code for every major mechanic
    ├── no-tests-scenario.md          ← Characterization tests when no coverage exists
    ├── refactor-vs-rewrite.md        ← Telling the two apart before you start
    ├── verification.md               ← Risk-scoring criteria + evidence-based output template
    ├── large-scale-refactoring.md    ← Cross-file / repeated-pattern refactoring
    ├── version-control-discipline.md ← Commit granularity and messages during refactoring
    ├── shared-api-refactoring.md     ← Changing a method other teams depend on
    ├── authority-model.md            ← When to proceed vs. pause and ask
    ├── rollback-and-failure.md       ← What to do when a step fails mid-refactor
    ├── bug-discovery.md              ← Separating a found bug from the refactoring itself
    ├── language-variance.md          ← OOP-catalog mechanics vs. functional/idiomatic equivalents
    ├── performance-tradeoffs.md      ← When a cleaner structure has a real performance cost
    ├── deadline-pressure.md          ← Deferring refactoring honestly instead of silently skipping it
    ├── criticality-calibration.md    ← Extra caution for financial/medical/safety-critical code
    ├── smell-detection-signals.md    ← Concrete signals for each smell, not just definitions
    └── tooling-vs-manual.md          ← When IDE-automated refactoring is safer than manual
```

`SKILL.md` is the only file Claude reads on every single refactoring task — it holds the core rules, the tiering system, and the smell catalog. The `references/` files are **not** all read every time; Claude opens the specific one it needs, only when a situation calls for it. That's deliberate: it keeps everyday small refactors fast, while still having real depth on tap for the harder cases. Below is what each one actually does, in plain language, with no assumed background.

### What each reference file actually does

**`code-examples.md`** — *"Show me what this actually looks like in code."*
The main `SKILL.md` names refactoring techniques (like "Extract Method") but doesn't show full code — that's what this file is for. It has real before/after code snippets in several languages (JavaScript, Python, Java, C#, TypeScript) for the most common techniques, so Claude isn't just repeating a pattern's name — it's applying something with a concrete, working example right in front of it. Claude opens this file whenever it's about to actually change code, not just talk about it.

**`no-tests-scenario.md`** — *"What if there are no tests to check my work against?"*
Refactoring is supposed to be safe because tests catch mistakes. But a lot of real code — especially older code — has no tests at all. This file explains what to do in that exact situation: write small tests first that simply record what the code currently does (called "characterization tests"), *before* changing anything. That way, even code with zero existing tests gets a safety net before it's touched. Claude opens this file the moment it discovers the code it needs to refactor isn't covered by any test.

**`refactor-vs-rewrite.md`** — *"Wait — is this actually a refactor, or did we just agree to rebuild the whole thing?"*
"Refactor this" and "rewrite this" sound similar but carry very different risk. A refactor is a series of small, safe, reversible steps. A rewrite throws away the old code and starts fresh, which is riskier and can't be undone step-by-step. This file gives concrete signals for telling which one is actually being asked for (e.g., if someone says "let's just start over," that's a rewrite, not a refactor) so Claude doesn't quietly treat a big risky rebuild as if it were the safer activity.

**`verification.md`** — *"How do we actually know this change didn't break anything — and how risky was it in the first place?"*
This file has two jobs. First, it explains how to judge whether a code problem is genuinely serious (High risk) or fairly minor (Low risk), using concrete facts — like how many other places in the code call this function, or whether it's caused real bugs before — instead of just guessing a label. Second, it gives the format for proving a refactor was actually safe: naming the specific test that was run and confirming it still passes, instead of just saying "looks good."

**`large-scale-refactoring.md`** — *"This same messy pattern is repeated in 15 different files — how do I fix all of them safely?"*
Fixing one bad pattern is manageable. Fixing the same pattern copy-pasted across many files is a different kind of task — the risk of missing one, or breaking something with a bulk change, goes up a lot. This file explains the safe order: fix and fully verify one occurrence first, then repeat the exact same fix elsewhere one at a time, rather than trying to change everything at once.

**`version-control-discipline.md`** — *"How should this be split into separate saves (commits) as I go?"*
This explains good Git habits specific to refactoring: each small safe step should be its own separate commit (so it can be undone by itself if something goes wrong later), refactoring changes should never be mixed into the same commit as an actual feature change, and commit messages should clearly say "no behavior changed" so anyone looking at the history later understands what happened and why it was safe.

**`shared-api-refactoring.md`** — *"This function is used by other people's code, not just mine — what changes?"*
If a function or method is only used in one small place, changing it is low-risk. But if other files, other teams, or even other companies rely on it, changing its behavior or its signature can break things you can't see or test yourself. This file explains how to recognize when code falls into that riskier "shared" category, and how to change it safely — usually by adding a new option alongside the old one instead of replacing it outright.

**`authority-model.md`** — *"Should the AI just go ahead and do this, or should it check with me first?"*
Not every refactoring needs a green light from the user — a small, obviously safe cleanup can just happen. But a bigger, riskier change should be shown as a plan first, so the person can say "wait, don't touch that part" before anything is actually changed. This file spells out exactly which situations call for "just do it" versus "explain the plan and pause for approval first."

**`rollback-and-failure.md`** — *"One of the safety checks (a test) just failed halfway through — now what?"*
This covers what to do when something goes wrong mid-refactor: stop immediately rather than pushing forward, figure out if the last change was applied correctly before assuming there's a deeper problem, and if needed, undo just that one last step rather than trying to patch over an uncertain situation. It also covers never leaving code in a half-changed, unverified state.

**`bug-discovery.md`** — *"While cleaning this up, I noticed the code has actually been behaving incorrectly this whole time — do I fix that too?"*
Sometimes tidying up code's structure reveals that its logic was already wrong, in a way nobody noticed before. This file says: don't quietly fix the bug as part of the same change — flag it separately, let the person decide if and when it should be fixed, and if they want it fixed, do that as its own separate step with its own test. This keeps "I made the code cleaner" and "I changed what the code does" from getting tangled together.

**`language-variance.md`** — *"This codebase isn't written in a classic object-oriented style — do the same techniques still apply?"*
Many refactoring techniques (like replacing a big `switch` statement with class-based logic) come from an object-oriented way of thinking about code. In codebases written in a more functional style (common in a lot of modern JavaScript/TypeScript, or languages like Elixir and Haskell), the *right* fix for the same underlying problem often looks different. This file explains those differences so Claude doesn't force an object-oriented pattern onto code that's written a different way just out of habit.

**`performance-tradeoffs.md`** — *"Could making this code cleaner actually make it slower?"*
Usually, no — cleaner code has no real performance cost worth worrying about. But in rare cases (very performance-sensitive code, tight loops that run millions of times), some cleanup techniques genuinely can add a small cost. This file is honest about when that's actually a real concern versus when it's an excuse to avoid needed cleanup, and it always recommends measuring rather than guessing.

**`deadline-pressure.md`** — *"There's a deadline tomorrow — should we really be doing cleanup right now?"*
Sometimes yes (a quick cleanup can make the actual urgent task easier and safer to finish). Sometimes no (a bigger cleanup unrelated to the urgent task just adds risk right before a deadline). This file explains how to tell the difference, and — importantly — how to say "let's skip this for now and come back to it later" out loud, so the decision to delay is a clear, visible choice rather than something that quietly gets forgotten.

**`criticality-calibration.md`** — *"This code handles people's money / medical data / safety-critical decisions — should we be extra careful?"*
Yes. This file explains that the exact same cleanup technique should be done more cautiously — smaller steps, more thorough testing, more checking in before proceeding — when the code in question deals with things like payments, health information, or safety systems, compared to a low-stakes hobby project. It also explains how to recognize this kind of code in the first place.

**`smell-detection-signals.md`** — *"How do I actually recognize a 'code smell' in real code, not just know its textbook definition?"*
Terms like "Long Method" or "Feature Envy" (a method that seems more interested in another class's data than its own) are easy to define but harder to *spot* in messy real-world code. This file gives concrete, practical signals to look for — for example, a real tell for duplicate code is finding the *same logic repeated*, even if variable names differ slightly, not just code that merely looks long.

**`tooling-vs-manual.md`** — *"Should this be done by hand, or is there a safer automated way?"*
Many code editors (like VS Code or JetBrains tools) have built-in "safe rename" or "safe move" features that are guaranteed not to miss a reference somewhere in the code. This file explains when it's genuinely safer to recommend using one of those automatic tools instead of making the same change by hand, and when a manual, reasoned-through change is still the better (or only available) option.

---

## Installation (manual)

1. Copy the entire `refactoring/` folder — `SKILL.md` and `references/` together — into your Claude skills directory (e.g. `.claude/skills/refactoring/` in a project, for Claude Code).
2. Claude will consult it automatically whenever a request matches its trigger conditions — refactoring, cleaning up code, code smells, "this is hard to maintain," and similar. See the `description` field in `SKILL.md`'s frontmatter for the exact trigger list.

For any other LLM: paste `SKILL.md` into your system prompt, and pull individual `references/*.md` files into context as the situation calls for them.

---

## Example: how it behaves

Given "this function feels messy, can you clean it up?" on a function with a Long Method smell and **no existing tests**, the skill:

1. Classifies the request as Tier 2 (contained to one function, but structural — not a one-line fix).
2. Recognizes there's no test coverage and **stops to write characterization tests first**, locking in the function's current behavior across representative cases before touching any code.
3. Diagnoses the smells with evidence-based severity, not bare labels — and correctly avoids flagging a pattern that only appears once as "duplication," since duplication requires more than one occurrence.
4. Shows the plan and pauses for approval before executing (open-ended request, Tier 2).
5. Executes one Extract Method at a time, re-running the characterization tests after each step.
6. Produces a verification table naming the actual tests run and confirming behavior stayed identical — not just a claim that "tests pass."

---

## Attribution

This skill is an independent instructional summary and extension, built for AI-agent use, of ideas from Martin Fowler (with Kent Beck)'s *Refactoring: Improving the Design of Existing Code*. It does not reproduce the book's text.

## License

Free to use, modify, and redistribute. Attribution appreciated but not required.

## Contributing

Issues and pull requests are welcome — especially real-world edge cases this skill doesn't handle well yet, additional language examples, or reports of it under- or over-triggering.
