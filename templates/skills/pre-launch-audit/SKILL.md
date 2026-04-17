---
name: pre-launch-audit
description: Run a 10-point production readiness audit on any web application codebase before launch or deployment.
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
version: 1.0.0
author: On Deck Society
---

# Pre-Launch Audit

When activated, perform a structured 10-point audit of the user's codebase and report findings.

## The 10 Checks

1. **Authorization**: Review auth middleware, protected routes, and RLS policies. Flag any endpoint that handles user data without auth verification.

2. **Input validation and sanitization**: Check form handlers, API routes, and database writes for validation. Flag any endpoint that accepts user input without a validation schema (Zod, Yup, or equivalent).

3. **CORS policy**: Inspect CORS configuration. Flag wildcard origins in production code.

4. **Rate limiting on API endpoints**: Search for rate limiter middleware. Flag endpoints with no rate limiting, especially auth and public-facing endpoints.

5. **Password reset link expirations**: If password reset exists, verify tokens expire within a reasonable window (under 1 hour recommended). Flag non-expiring or long-lived tokens.

6. **Error handling**: Scan catch blocks and error boundaries. Flag any place where raw stack traces, SQL errors, or internal paths could leak to the client.

7. **Database indexing**: Check schema and migration files for indexes on frequently queried columns (foreign keys, email fields, timestamps used in ORDER BY).

8. **Logging**: Verify structured logging is in place for auth events, payment events, and errors. Flag console.log in production code paths.

9. **Alerts and monitoring**: Check for error tracking (Sentry, LogRocket, etc.) and health checks. Flag if none are configured.

10. **Rollback strategy**: Verify deployment configuration supports rollback. Check for migration rollback scripts, feature flags, or blue-green deploy configuration.

## Output Format

Produce a markdown report with:
- Pass/Fail/Partial status per check
- Specific file and line references for every flagged item
- Severity label (Critical, High, Medium, Low)
- One-line recommendation per finding
- Summary at top: "X of 10 passed, Y critical issues, Z high-severity issues"

## When to Invoke

Invoke this skill whenever the user mentions: "pre-launch audit", "launch readiness", "production readiness", "deployment checklist", "are we ready to ship", or similar. Also invoke proactively when the user says they're about to deploy to production and haven't run this recently.
