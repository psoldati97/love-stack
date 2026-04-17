---
name: parallel-debugging
description: Debug a bug by investigating multiple hypotheses simultaneously rather than sequentially, then converge on the most likely cause based on evidence.
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
version: 1.0.0
author: On Deck Society
---

# Parallel Debugging

When activated, help the user debug a reported issue by pursuing multiple hypotheses in parallel instead of the traditional linear "try one thing, see if it works" loop.

## The Process

1. **Clarify the symptom**: Ask for the exact behavior observed, the expected behavior, and the reproduction steps. Do not skip this. A vague symptom makes parallel debugging impossible because you can't score evidence against hypotheses.

2. **Generate 3-5 hypotheses**: Before touching code, list the possible causes. Each hypothesis should be a concrete, testable claim. Examples:
   - "The API returns stale data because the cache TTL is longer than we think."
   - "The race condition fires when two users submit within the same 100ms window."
   - "The migration didn't run in production but did in staging."

3. **For each hypothesis, identify a cheap test**: What's the single fastest check that would either rule this in or rule it out? A log statement, a database query, a git log, a test repro.

4. **Run all tests in parallel**: Execute the cheap tests for every hypothesis before drawing conclusions. Do not pick a favorite and chase it to the end.

5. **Score the evidence**: After all tests return, rank hypotheses by how well the evidence supports them. Eliminate the disproven ones.

6. **Narrow and repeat if needed**: If no hypothesis is clearly correct, generate new ones based on what you learned.

## Anti-patterns to Avoid

- Fixating on the first hypothesis and ignoring contradicting evidence
- Running tests sequentially when they're independent
- Skipping the clarification step because you "already know" what's wrong
- Confirming a hypothesis without also running tests that would disprove it

## Output

For each debugging session, produce:
- The stated symptom and reproduction
- The 3-5 hypotheses considered
- The test and result for each
- The conclusion with evidence references
- The fix (or the next round of hypotheses if not yet resolved)

## When to Invoke

Invoke when the user says: "debug this", "I can't figure out why X is happening", "something is broken and I don't know what", "help me troubleshoot", or presents an unexpected behavior that isn't obvious from the code alone.
