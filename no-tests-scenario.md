# No Tests Exist Over the Target Code

This is the single most common real-world blocker — most legacy code that needs refactoring has thin or zero test coverage over the exact area being touched. Don't treat "no tests" as a reason to skip testing discipline; treat it as the reason to write **characterization tests** first.

## What a characterization test is

A test that documents *current* behavior — including behavior that might look like a bug — purely so that refactoring has something to verify against. It is not testing "correct" behavior; it's testing "unchanged" behavior.

```python
# The method has no tests and unclear behavior for edge cases.
# Before refactoring anything, pin down what it currently does:

def test_characterize_current_behavior():
    # Not necessarily "correct" — just what it does right now
    assert calculate_shipping(weight=0) == 5.00      # surprising, but that's what happens today
    assert calculate_shipping(weight=-3) == 5.00     # also surprising — negative weight is untreated
    assert calculate_shipping(weight=10) == 12.50
    assert calculate_shipping(weight=100) == 45.00
```

## Process

1. **Call the target function/method with a representative range of inputs** — typical cases, boundary values (0, negative, empty, max), and any inputs the code visibly branches on.
2. **Record the actual current output**, not the output you think is "correct." If something looks like a bug, write the test to lock in the current (buggy) behavior for now — see `bug-discovery.md` for what to do about the bug itself, separately.
3. **Get these tests passing against the untouched code first.** Only once they're green do you start refactoring.
4. **Refactor in small steps, re-running the characterization tests after each one.** Any red test means the refactoring changed behavior — stop and investigate before continuing.
5. **Once refactoring is done**, these characterization tests can graduate into the permanent test suite (renamed to describe intended behavior, not just "current" behavior).

## When characterization testing isn't feasible

If the target code has external dependencies that make it hard to test in isolation (hits a real database, calls a third-party API, depends on global state), don't skip testing — use the smallest safe seam:
- **Extract the untestable dependency behind an interface/function parameter first** (this itself is a tiny, safe refactoring — Extract Method / dependency injection at the seam) so the core logic can be tested without the external dependency.
- If even that's not feasible in the time available, say so plainly and treat this as a "when NOT to refactor right now" case (see the main SKILL.md, Section 7) rather than proceeding without any safety net.
