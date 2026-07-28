# Refactoring Under Deadline Pressure

Fowler's own guidance (and general engineering practice) is that refactoring is often *most* valuable right before you need to change code under a deadline — a clean structure makes the actual feature change faster and safer. But that's not universally true, and pretending refactoring is always free is dishonest.

## When refactoring genuinely helps even under a deadline

- The refactoring is small (Tier 0/1) and directly reduces the effort of the feature work that has the deadline — e.g., extracting a method that the new feature needs to call anyway.
- The code being touched is the exact code the deadline-driven feature needs to modify, and its current mess is what's making the feature slow to implement safely.

## When refactoring should be deferred despite being "the right thing to do"

- The refactoring is Tier 2/3, touches code unrelated to what the deadline requires, and doing it now adds real schedule risk (time to execute, time to verify, risk of introducing a regression right before a deadline-driven release).
- There isn't time to do it safely — i.e., not enough time for proper verification per step. A rushed refactoring with skipped verification isn't actually the safe activity it's supposed to be; it's just a risky code change wearing a refactoring's reputation.

## What to say instead of silently doing (or silently skipping) it

Name the trade-off explicitly: "This method has a few smells worth cleaning up, but given the deadline, I'd suggest doing the minimal change needed for the feature now, and coming back to the broader cleanup afterward — want me to note that as a follow-up, or would you rather I do a fuller refactor now despite the time cost?"

This keeps the decision with the person, rather than either quietly cutting corners that look like discipline, or unilaterally spending their time budget on cleanup they didn't ask for.

## Track deferred refactoring instead of losing it

If a smell is identified but deliberately deferred, say so in a way that survives past the current conversation — a code comment (`// TODO: refactor - see [smell] - deferred for [deadline]`), a note in the commit message, or an explicit mention the person can turn into a ticket. An unspoken "I'll get to this later" is how technical debt silently accumulates.
