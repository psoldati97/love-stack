---
name: responsive-design
description: Review a web UI for responsive design quality across mobile, tablet, and desktop breakpoints. Identify layout breaks, touch target issues, and mobile-specific failures.
allowed-tools: ["Read", "Glob", "Grep"]
version: 1.0.0
author: On Deck Society
---

# Responsive Design

When activated, review the user's UI code and CSS for responsive design quality. Focus on the places most commonly broken.

## The Review Checklist

1. **Viewport meta tag**: Confirm the HTML head has `<meta name="viewport" content="width=device-width, initial-scale=1">`. Flag if missing or configured to prevent user scaling.

2. **Breakpoint strategy**: Identify the project's breakpoints (via Tailwind config, media queries, or CSS variables). Flag if breakpoints are inconsistent across files or if mobile-first is not the default.

3. **Touch targets on mobile**: Interactive elements (buttons, links, form inputs) should be at least 44x44 CSS pixels on mobile per WCAG 2.2 AA. Flag elements smaller than this on mobile breakpoints.

4. **Font sizes on mobile**: Body text should be at least 16px on mobile to prevent iOS zoom-on-focus. Flag smaller font sizes on inputs and readable content.

5. **Horizontal scroll**: Search for CSS that could cause horizontal overflow on mobile (fixed widths larger than viewport, non-responsive images, tables without overflow handling). Flag each.

6. **Grid and flex wrapping**: Verify multi-column layouts collapse gracefully on narrow viewports. Flag grids that don't wrap and flex containers with items that overflow.

7. **Image responsiveness**: Check that images use responsive patterns (srcset, sizes, max-width: 100%, object-fit). Flag images with fixed pixel widths.

8. **Mobile-specific UI patterns**: Verify mobile users have appropriate patterns (hamburger or bottom nav, full-screen modals instead of desktop modals, swipe gestures where expected). Flag desktop-only interactions that don't have mobile equivalents.

9. **Orientation handling**: If the app supports landscape, verify layouts don't break at landscape aspect ratios on phones.

10. **Safe areas on notched devices**: For apps that go edge-to-edge, verify CSS env() safe-area-inset usage on iOS notched devices.

## Output Format

Produce a report with:
- Pass/Fail/Partial per check
- Specific file and line references
- Severity (Critical for anything that makes the app unusable on mobile, High for anything that causes visible breakage, Medium for UX polish, Low for best-practice improvements)
- One-line recommended fix per finding

## When to Invoke

Invoke when the user says: "responsive review", "check mobile", "is this mobile friendly", "audit breakpoints", "does this work on tablet", or asks for a review that includes mobile quality.
