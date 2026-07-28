# Verification & Risk-Scoring (Tier 2/3 output)

## Risk-scoring criteria (not a bare label)

A severity of "High/Medium/Low" with no justification isn't an assessment — it's a guess dressed up as one. Score each identified smell against concrete criteria:

| Factor | Raises severity | Lowers severity |
|---|---|---|
| **Test coverage over the affected code** | None or thin | Strong, fast, already passing |
| **Blast radius** | Touches a shared/public interface, or code called from many places | Fully contained inside one private method/class |
| **Change frequency** | This code changes often (hot spot — check version-control history) | Stable, rarely touched |
| **Comprehension cost** | New team members consistently misunderstand or fear this code | Code is understood even if inelegant |
| **Concrete failure history** | This code has caused production incidents before | No incident history |

State which of these factors actually applies — e.g. "High severity: this method has no test coverage, is called from 14 places across 3 modules, and shows up 6 times in the last quarter's incident postmortems" — not just "High."

## Verification output template

For Tier 0/1: a sentence confirming which tests were run and that they pass is enough.

For Tier 2/3, structure the response as:

1. **Diagnostic Summary** — smells found, each with a risk score justified by the criteria above.
2. **Plan** — the ordered list of mechanical steps, each naming the Fowler mechanic used.
3. **Verification Table** — for each step actually executed:

| Step | Mechanic Applied | Test(s) Run | Result | Behavior Confirmed Unchanged? |
|---|---|---|---|---|
| 1 | Extract Method: `calculateTotal` | `InvoiceTest.test_total_calculation` (4 cases) | Pass | Yes — same output for all 4 cases pre/post |
| 2 | Replace Conditional with Polymorphism | `BirdSpeedTest` (3 subtypes) | Pass | Yes — speed values match prior switch output |

A row that says "Pass" with no named test is not a verification — it's a claim. Don't produce one.

4. **What changed vs. what stayed the same** — plain-language summary distinguishing structural changes (real) from behavioral changes (should be zero, unless Section on bug-discovery applies).
