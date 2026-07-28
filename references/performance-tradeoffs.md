# Refactoring vs. Performance Trade-offs

Most refactoring has negligible performance impact, and premature performance concern is itself a classic mistake ("premature optimization is the root of all evil" — Knuth, frequently invoked by Fowler too). But some refactorings do have a real, measurable cost, and it's dishonest to pretend otherwise.

## Refactorings that can carry a genuine performance cost

- **Extract Method** on a hot path can add function-call overhead in languages/runtimes where that matters (rare in practice with modern JIT compilers/optimizers, but not zero in tight loops in lower-level languages).
- **Replace Conditional with Polymorphism** replaces a cheap branch with virtual dispatch — usually negligible, but can matter in extremely hot, tightly-looped code (e.g., a per-frame calculation in a game engine, a per-row operation over millions of rows).
- **Introduce Parameter Object** can add allocation overhead if it replaces primitive parameters with a heap-allocated object in a very hot path, in languages where that distinction matters (C, Rust performance-critical sections, etc.).
- **Additional abstraction layers in general** (introduced by several of these mechanics) can inhibit compiler inlining/optimization in performance-sensitive, low-level code.

## The rule

1. **Default to refactoring normally** — for the overwhelming majority of code, clarity and maintainability outweigh a theoretical, unmeasured performance cost.
2. **If the target code is a known, measured hot path** (profiled, not assumed), say so explicitly before applying a mechanic with a real cost, and consider whether the clarity gain is worth it here specifically — this is a case-by-case judgment call, not an automatic block.
3. **Never guess at performance impact — measure it** if it's actually in question. Suggest a before/after benchmark rather than asserting "this will/won't be slower" from intuition alone.
4. **If a person pushes back on a suggested refactoring citing performance, take it seriously rather than dismissing it as premature optimization by default** — ask whether the code path is actually measured as hot; if it is, that changes the calculus and this reference's trade-off table applies.
