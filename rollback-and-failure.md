# Rollback & Mid-Refactoring Failure

## If a verification step fails (a test goes red after a mechanical step)

1. **Stop immediately — don't attempt the next step while the current one is unverified.** A second unverified change on top of a broken one makes the failure much harder to isolate.
2. **Don't guess-patch the failure forward.** The first instinct should be to check whether the *mechanical transformation itself* was applied correctly (e.g., did Extract Method actually pass all the right variables, or was one missed) — most failures at this stage are transcription errors in the mechanic, not deep bugs.
3. **If the fix isn't immediately obvious, revert the single failed step** (`git checkout`/`git revert` on just that commit, per the one-commit-per-step discipline in `version-control-discipline.md`) rather than trying to fix forward under uncertainty. Refactoring's whole safety model depends on every step being independently revertible — use that property when it's needed.
4. **Re-diagnose before retrying** — the failure might mean the plan's sequencing was wrong (e.g., step 2 assumed something step 1 didn't actually guarantee), not just that the mechanic was mistyped.

## If behavior changes unexpectedly but no test caught it

This means the test coverage had a gap the characterization step should have caught. Don't treat "no test failed" as proof of safety if the person or a manual check surfaces a behavior difference — go back and add a characterization test for the specific case that changed, confirm it would have caught the regression, then decide whether to revert or fix forward.

## Never leave the codebase in a partially-refactored, unverified state across a conversation boundary

If a multi-step Tier 2/3 refactoring can't be completed in the current session, stop at the most recent fully-verified step (tests green, committed) rather than leaving a half-applied transformation uncommitted. State clearly which step was the last verified one, so resuming later starts from a known-good point.
