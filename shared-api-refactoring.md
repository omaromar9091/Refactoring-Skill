# Refactoring Shared or Public APIs

A method/class signature used only within the file being edited is low-risk to change freely. One used by other teams, other services, or published as a public API is a different category of risk entirely — refactoring it can break code you can't see and can't test.

## Before changing a shared interface's signature

1. **Search for all call sites first** — across the whole repository, not just the file open in front of you. If the codebase spans multiple repositories/services, say plainly that a full search isn't possible from here and ask whether the person can confirm the blast radius.
2. **Prefer additive, backward-compatible changes** over breaking ones — add a new method/overload rather than changing an existing signature, mirroring the Port-versioning guidance from the Clean Architecture skill. Deprecate the old path rather than deleting it outright, if the language/framework supports that.
3. **If a breaking change is genuinely unavoidable**, this becomes Tier 3 by definition — pause for explicit approval (`authority-model.md`) and lay out a migration path (parallel old+new versions, a deprecation window, updating known call sites) rather than a single atomic rename.

## Signals that something is "shared" even without an explicit marker

- It's exported from a package/module's public entry point.
- It has "public," "export," or similar visibility keywords, or lacks any privacy modifier in a language where that's the convention for "internal."
- Multiple other files/modules already import or call it.
- Comments, docs, or naming suggest it's an intentional integration point ("public API," "external interface").

When in doubt about whether something is safe to change freely, treat it as shared and ask, rather than assuming it's private because it's convenient for the current task.
