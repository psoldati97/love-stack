#!/bin/bash

# Love Stack Verification Script
echo ""
echo "Verifying Love Stack installation..."
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

# Core checks
command -v claude >/dev/null 2>&1; check $? "Claude Code CLI installed"
[ -f CLAUDE.md ]; check $? "CLAUDE.md exists"
[ -f vault/memory.md ]; check $? "vault/memory.md exists"
[ -d vault/00-context ]; check $? "Obsidian vault structure"

# Skill checks
[ -d ~/.claude/skills/humanizer ] || [ -d ~/.claude/skills/humanize-writing ]; check $? "Humanizer skill"

# MCP checks
claude mcp list 2>/dev/null | grep -q "Connected"; check $? "At least one MCP server connected"

echo ""
echo "Results: $PASS passed, $FAIL failed"
echo ""
