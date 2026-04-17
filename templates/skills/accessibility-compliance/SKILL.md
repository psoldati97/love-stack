---
name: accessibility-compliance
description: Audit a web UI against WCAG 2.2 Level AA accessibility standards. Identify violations and recommend fixes before shipping.
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
version: 1.0.0
author: On Deck Society
---

# Accessibility Compliance

When activated, review the user's UI code for WCAG 2.2 AA compliance. Focus on the issues most commonly shipped to production.

## The Review Checklist

1. **Semantic HTML**: Verify the page uses semantic landmarks (header, nav, main, footer, aside, section) instead of generic divs. Flag div-only structures, missing heading hierarchy, or headings that skip levels (h1 to h3 without h2).

2. **Image alt text**: Every img and picture element must have meaningful alt text, or empty alt="" for decorative images. Flag images with missing, auto-generated, or placeholder alt values like "image" or the file name.

3. **Form labels**: Every form input must have an associated label (via for/id, aria-label, or aria-labelledby). Flag inputs without labels, placeholder-only labels, and labels without visible text.

4. **Color contrast**: Body text requires 4.5:1 contrast against background, large text requires 3:1 (WCAG 2.2 AA). Flag any inline or token color combinations likely to fail.

5. **Keyboard navigation**: Every interactive element must be reachable by Tab and operable by Enter/Space. Flag div or span elements with click handlers and no tabIndex, role, or keyboard handler.

6. **Focus indicators**: Interactive elements must show a visible focus ring. Flag outline:none or focus styles removed without a replacement.

7. **ARIA correctness**: ARIA attributes must be valid and applied to the right element. Flag aria-hidden on focusable elements, incorrect roles, missing aria-expanded on toggles, and misuse of aria-label on decorative elements.

8. **Target size (WCAG 2.2 new)**: Interactive targets must be at least 24x24 CSS pixels (minimum), 44x44 recommended for touch. Flag small buttons, icon-only controls, and tightly packed links.

9. **Motion and animation**: Respect prefers-reduced-motion for any animation longer than 5 seconds or essential to meaning. Flag auto-playing video or heavy parallax without a reduced-motion variant.

10. **Screen reader hazards**: Flag text injected as CSS content (invisible to most screen readers), icon-font-only labels, and dynamic content regions missing aria-live.

## Output Format

Produce a markdown report with:
- Pass/Fail/Partial per check
- Specific file and line references for every flagged item
- Severity (Critical for WCAG A failures, High for AA failures, Medium for best-practice AA, Low for AAA improvements)
- WCAG 2.2 success criterion reference for each finding (for example, "SC 1.4.3 Contrast (Minimum)")
- One-line recommended fix per finding

## When to Invoke

Invoke when the user says: "accessibility audit", "a11y review", "WCAG check", "is this accessible", "screen reader compatibility", "is my site ADA compliant", or similar.
