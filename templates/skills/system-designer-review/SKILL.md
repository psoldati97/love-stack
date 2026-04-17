---
name: system-designer-review
description: Review a codebase's architecture for scalability, maintainability, and failure modes. Identify bottlenecks, coupling issues, and missing abstractions before they become production incidents.
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
version: 1.0.0
author: On Deck Society
---

# System Designer Review

When activated, perform a structural review of the codebase with a senior system designer's lens.

## Review Dimensions

1. **Data flow**: Trace how data moves between components, services, and storage. Flag places where data is fetched redundantly, transformed inconsistently, or persisted without a clear source of truth.

2. **Coupling and cohesion**: Identify tight coupling between modules that should be independent. Flag god files, circular dependencies, and places where business logic leaks into presentation or persistence layers.

3. **Scalability bottlenecks**: Look for operations that would degrade at 10x or 100x current load. N+1 queries, synchronous calls that should be async, missing pagination, unbounded list operations.

4. **Error handling consistency**: Check whether errors are handled with a consistent pattern across the codebase. Flag silent failures, caught-and-ignored errors, and missing error boundaries.

5. **State management**: Review how state is owned, updated, and shared. Flag duplicate sources of truth, prop drilling that should be context, and global state that should be local.

6. **Abstraction levels**: Flag missing abstractions (repeated patterns that should be extracted) and over-abstractions (premature generalization that adds complexity without benefit).

7. **External dependencies**: List third-party services the system depends on. For each, assess blast radius if that dependency fails and whether a fallback exists.

8. **Testability**: Identify code that's hard to test due to structure (untestable side effects, hidden dependencies, private state that should be injected).

## Output Format

Produce a markdown report structured as:

- **Executive summary** (3-5 bullet points, the big stuff)
- **Findings by dimension** (one section per dimension above, with specific file and line references)
- **Severity-ordered action list** (Critical, High, Medium, Low, what to fix first)
- **Questions for the team** (anything ambiguous that warrants a discussion before deciding)

## When to Invoke

Invoke when the user asks for an "architecture review", "system design review", "senior engineer review", "codebase audit", "find the tech debt", or is planning a major refactor and wants to understand the current state first.
