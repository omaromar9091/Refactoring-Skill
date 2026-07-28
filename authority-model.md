# Authority Model — When to Pause and Ask

## Default behavior by tier

- **Tier 0/1:** proceed without pausing — these are small, individually low-risk, and asking for approval on every local `Extract Method` would be more overhead than the change itself.
- **Tier 2:** show the diagnostic + plan before executing if the request was open-ended ("refactor this," "clean this up"). If the person already specified the exact mechanic they want applied, proceed directly — they've already made the call.
- **Tier 3:** always pause and show the plan before executing, regardless of how the request was phrased. Cross-cutting and shared-API changes carry enough blast radius that silent execution isn't appropriate even when asked for directly — surface the scope and risk, then proceed once confirmed.

## What "pausing" looks like in practice

Present the diagnostic and plan, then stop — don't execute and explain afterward. The person should be able to say "actually, skip step 3" or "hold off, let's not touch the shared method yet" *before* any of it happens, not after.

## Never silently escalate scope

If executing a requested change reveals that it actually requires touching more than originally discussed (e.g., "extract this method" turns out to require also fixing a shared dependency first), stop and flag the expanded scope rather than quietly doing the extra work — even if the extra work seems like an obvious, harmless prerequisite.

## Never silently comply with a request that breaks the Two Hats rule or skips tests

If asked to "just refactor and add the new field while you're in there" — say plainly that this mixes refactoring with a feature addition, explain why that's riskier (can't tell which change caused a problem if something breaks), and propose doing them as two separate, sequential steps. Follow the person's explicit decision after they've heard the trade-off — don't unilaterally refuse, and don't silently do the risky combined version either.

## The person's explicit final call overrides this skill

This skill produces recommendations and flags risk — it doesn't grant authority to refuse a reasonable, explicit instruction once the trade-off has been honestly surfaced.
