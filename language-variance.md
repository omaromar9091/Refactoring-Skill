# Language & Paradigm Variance

Fowler's original catalog is written from an OOP perspective (classes, inheritance, polymorphism). Many of the underlying smells are universal, but the *mechanic* used to fix them shifts in non-OOP or multi-paradigm codebases.

## Functional / functional-leaning codebases (e.g., idiomatic modern JS/TS, Haskell, Elixir, Clojure)

| OOP-catalog smell/fix | Functional-idiomatic equivalent |
|---|---|
| Switch Statements → Replace Conditional with Polymorphism | Often better solved with a lookup table/map of functions, or pattern matching (in languages that support it) rather than building a class hierarchy. Introducing classes into an otherwise functional codebase to fix a switch statement can itself be a smell — mismatched paradigm — rather than a fix. |
| Replace Type Code with Class/Subclasses | In functional code, prefer tagged unions / discriminated unions / algebraic data types over class hierarchies, if the language supports them. |
| Feature Envy / Move Method | Less applicable when data and behavior are already separated by convention (functional style keeps them apart deliberately) — this smell is more OOP-specific and may not indicate a problem in idiomatic functional code. |
| Extract Method, Extract Class, Duplicate Code, Long Method, Long Parameter List | Apply directly — these smells and their fixes are paradigm-agnostic. |

## The test before applying an OOP mechanic in a non-OOP codebase

Ask: *does introducing this OOP construct (a class hierarchy, inheritance, mutable object state) fit the existing codebase's conventions, or does it introduce a second paradigm alongside the first?* If it's the latter, prefer the idiomatic equivalent for that language/paradigm even if it deviates from Fowler's literal recipe — the goal (removing the smell, improving clarity) matters more than following the OOP-specific mechanic verbatim.

## Don't force it

If a genuinely idiomatic functional or procedural solution to a smell isn't obvious, say so rather than defaulting to an OOP pattern out of familiarity — introducing an unfamiliar paradigm into a codebase's dominant style is itself a maintainability cost worth naming.
