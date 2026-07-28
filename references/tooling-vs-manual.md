# IDE/Tool-Assisted Refactoring vs. Manual

Modern IDEs (JetBrains products, VS Code with language servers, Visual Studio) offer automated refactoring commands (Rename, Extract Method, Move, Inline) that are mechanically guaranteed safe within their supported scope — they update every reference automatically and can't introduce a typo-level error the way a manual find-and-replace can.

## When to prefer recommending tool-assisted refactoring

- **Rename** operations — always safer via IDE tooling than manual search-and-replace, since manual replacement risks matching unrelated identical substrings (renaming a variable `count` manually risks touching an unrelated `count` in a different scope; a proper Rename refactor tool understands scope).
- **Move Method/Class**, **Extract Interface**, and similar structural moves across files — IDE tooling updates imports/references automatically; doing this by hand invites missed references.
- Large-scale, mechanically-repetitive changes (see `large-scale-refactoring.md`) — a scripted or IDE-driven bulk operation with a diff-review step is safer than manually repeating the same edit many times.

## When manual (or Claude-assisted) refactoring is the right call anyway

- The transformation isn't a mechanical rename/move but requires judgment — e.g., deciding *how* to split a Large Class, which fields belong on which new class. Tooling can execute the mechanical extraction once decided, but the design decision itself isn't something a tool infers.
- The codebase/environment doesn't have refactoring-capable tooling available (a script working directly on files, no IDE in the loop).
- The person is explicitly asking for the reasoning and the code changes together, not just an applied tool operation.

## What to say when tooling would be safer

If a person is doing a rename or move by hand (or asking for one to be done that way) and IDE tooling is available in their environment, mention it: "if you're in an IDE, its Rename Symbol/Refactor command will catch every reference automatically and is safer than a manual find-and-replace for this." Don't withhold the manual version if that's what's being asked for or if no tooling is available — just note the safer option when it exists.
