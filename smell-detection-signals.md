# Code Smell Detection Signals (Not Just Definitions)

Knowing a smell's name isn't the same as recognizing it in real code. These are the concrete signals to actually look for.

| Smell | Concrete signal to look for |
|---|---|
| **Long Method** | A method that doesn't fit on one screen without scrolling; more than ~2-3 levels of nested control flow; a method whose name is vague ("process", "handle", "doStuff") because it does several unrelated things. |
| **Large Class** | A class with more than roughly 10 public methods or 7+ fields covering unrelated concerns; a class name containing "Manager," "Processor," or "Handler" with no more specific responsibility. |
| **Primitive Obsession** | Multiple parameters that are always passed together (`street, city, zipCode` everywhere instead of an `Address`); a `string` or `int` that represents a constrained set of values validated ad hoc in several places (a "status" string checked against `"active"`, `"pending"`, `"closed"` scattered across the codebase instead of an enum/type). |
| **Long Parameter List** | More than 3-4 parameters, especially if several are optional/nullable, or if callers frequently pass `null`/`undefined` for some of them. |
| **Switch Statements** | The *same* switch/if-else chain on the same type code appears in more than one method — this is the real tell (a single switch used once is often fine; the same one duplicated is the smell). |
| **Refused Bequest** | A subclass overrides a parent method just to throw `NotImplementedException`, or overrides it to do nothing, or the subclass only uses a small fraction of what it inherits. |
| **Divergent Change** | You need to open the same class for unrelated reasons on different tickets — "I changed this class because the tax rate changed" and separately "I changed this same class because the UI layout changed." |
| **Shotgun Surgery** | A single logical change (e.g., adding a new field) requires touching many different files/classes in small ways each time. |
| **Comments** | A comment explains *what* a block of code does (rather than *why* — a genuinely useful comment type) — that's a signal the code itself isn't clear enough to skip the comment. |
| **Duplicate Code** | Look for near-identical blocks (not just byte-identical) — same logic with a few renamed variables or slightly different literals is still duplication. |
| **Dead Code** | A method/branch with zero call sites found via a project-wide search, or a feature flag that's been permanently on/off for a long time with the "off" branch never reachable anymore. |
| **Feature Envy** | Count the field/method accesses a method makes on `this` vs. on another object's fields/methods — if it accesses another class's internals more than its own, that's the signal. |
| **Message Chains** | Code with more than 2-3 chained accessors (`a.getB().getC().getD()`) — each `.get` is a place a `null` can break the chain and a place the caller is coupled to internal structure it shouldn't need to know about. |
| **Middle Man** | A class where most methods just delegate to another object with no added logic — check if callers could go directly to the delegate instead. |

## When a signal is ambiguous

Not every long method or every chain of method calls is actually a problem — these are signals to *investigate*, not automatic verdicts. A method that's long because it's a single cohesive sequential algorithm (with no natural sub-steps to extract) isn't the same as a method that's long because it does five unrelated things. State the reasoning, not just the smell name, when flagging something — "this is long, and specifically mixes three unrelated concerns (X, Y, Z), which is why it's a Long Method smell rather than just a long-but-cohesive one."
