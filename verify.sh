#!/bin/bash

# Love Stack v3.2 Verification Script
# By On Deck Society - https://ondecksociety.com
# MIT License

echo ""
echo "Verifying Love Stack v3.2 installation..."
echo ""

PASS=0
FAIL=0

check() {
    if [ $1 -eq 0 ]; then
        echo "  [PASS] $2"
        PASS=$((PASS + 1))
    else
        echo "  [FAIL] $2"
        FAIL=$((FAIL + 1))
    fi
}

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER_SKILLS_DIR="$HOME/.claude/skills"

# Core checks
command -v claude >/dev/null 2>&1; check $? "Claude Code CLI installed"
[ -f CLAUDE.md ]; check $? "CLAUDE.md exists"
[ -f vault/memory.md ]; check $? "vault/memory.md exists"
[ -d vault/00-context ]; check $? "Obsidian vault structure"

# v3.1 Skill checks
[ -d ~/.claude/skills/humanizer ] || [ -d ~/.claude/skills/humanize-writing ]; check $? "Humanizer skill (v3.1)"

# v3.2 template presence checks (in repo)
[ -f "$SCRIPT_DIR/templates/skills/brand-voice/SKILL.md" ]; check $? "brand-voice template"
[ -f "$SCRIPT_DIR/templates/skills/escalation/SKILL.md" ]; check $? "escalation template"
[ -f "$SCRIPT_DIR/templates/skills/prd-generator/SKILL.md" ]; check $? "prd-generator template"
[ -f "$SCRIPT_DIR/templates/skills/market-research-reports/SKILL.md" ]; check $? "market-research-reports template"
[ -f "$SCRIPT_DIR/templates/skills/theme-factory/SKILL.md" ]; check $? "theme-factory template"
[ -f "$SCRIPT_DIR/templates/skills/excalidraw-diagram-generator/SKILL.md" ]; check $? "excalidraw-diagram-generator template"
[ -f "$SCRIPT_DIR/templates/skills/system-designer-review/SKILL.md" ]; check $? "system-designer-review template"
[ -f "$SCRIPT_DIR/templates/skills/pre-launch-audit/SKILL.md" ]; check $? "pre-launch-audit template (ODS-original)"
[ -f "$SCRIPT_DIR/templates/skills/parallel-debugging/SKILL.md" ]; check $? "parallel-debugging template"
[ -f "$SCRIPT_DIR/templates/skills/accessibility-compliance/SKILL.md" ]; check $? "accessibility-compliance template"
[ -f "$SCRIPT_DIR/templates/skills/responsive-design/SKILL.md" ]; check $? "responsive-design template"
[ -f "$SCRIPT_DIR/templates/skills/gdpr-data-handling/SKILL.md" ]; check $? "gdpr-data-handling template"

# v3.2 MCP config presence
[ -f "$SCRIPT_DIR/templates/mcp-config/posthog.json" ]; check $? "PostHog MCP config"
[ -f "$SCRIPT_DIR/templates/mcp-config/playwright.json" ]; check $? "Playwright MCP config"

# v3.2 MemPalace plugin docs
[ -f "$SCRIPT_DIR/templates/plugins/mempalace/INSTALL.md" ]; check $? "MemPalace install docs"

# v3.2 installed skill checks (in ~/.claude/skills, after install.sh has run)
if [ -d "$USER_SKILLS_DIR/brand-voice" ]; then
    echo "  [PASS] brand-voice installed to $USER_SKILLS_DIR"
    PASS=$((PASS + 1))
else
    echo "  [INFO] brand-voice not yet installed (run install.sh)"
fi

if [ -d "$USER_SKILLS_DIR/pre-launch-audit" ]; then
    echo "  [PASS] pre-launch-audit installed to $USER_SKILLS_DIR"
    PASS=$((PASS + 1))
fi

# MCP runtime checks
claude mcp list 2>/dev/null | grep -q "Connected"; check $? "At least one MCP server connected"

# MemPalace plugin presence
if claude mcp list 2>/dev/null | grep -qi "mempalace"; then
    echo "  [PASS] MemPalace MCP registered"
    PASS=$((PASS + 1))
else
    echo "  [INFO] MemPalace MCP not registered (Developer track only; see templates/plugins/mempalace/INSTALL.md)"
fi

echo ""
echo "Results: $PASS passed, $FAIL failed"
echo ""
