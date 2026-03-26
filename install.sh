#!/bin/bash

# Love Stack Installer v3.1
# By On Deck Society - https://ondecksociety.com
# MIT License

set -e

echo ""
echo "  ╦  ╔═╗╦  ╦╔═╗  ╔═╗╔╦╗╔═╗╔═╗╦╔═"
echo "  ║  ║ ║╚╗╔╝║╣   ╚═╗ ║ ╠═╣║  ╠╩╗"
echo "  ╩═╝╚═╝ ╚╝ ╚═╝  ╚═╝ ╩ ╩ ╩╚═╝╩ ╩"
echo ""
echo "  The Free Claude Optimization Plugin"
echo "  By On Deck Society"
echo "  v3.1 | MIT License | Free Forever"
echo ""

# Check prerequisites
command -v claude >/dev/null 2>&1 || { echo "Error: Claude Code CLI not found. Install with: npm install -g @anthropic-ai/claude-code"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "Error: git not found."; exit 1; }

# Ask for track
echo "Which track do you want?"
echo ""
echo "  1) Personal     - Writing, research, productivity (no coding)"
echo "  2) Solopreneur  - Marketing, finance, content, strategy"
echo "  3) Developer    - Full engineering stack (170+ skills)"
echo ""
read -p "Enter 1, 2, or 3: " TRACK

if [[ "$TRACK" != "1" && "$TRACK" != "2" && "$TRACK" != "3" ]]; then
    echo "Invalid choice. Please enter 1, 2, or 3."
    exit 1
fi

echo ""
echo "Installing Track $TRACK..."
echo ""

# Get project directory
PROJECT_DIR=$(pwd)

# --- CORE (All Tracks) ---

echo "[1/7] Creating Obsidian vault structure..."
mkdir -p vault/{00-context,01-decisions,02-sessions,03-specs,04-prompts/{shipped,drafts},05-bugs/{open,resolved},06-patterns,07-research,08-changelog}
echo "vault/.obsidian/" >> .gitignore 2>/dev/null || true

echo "[2/7] Creating CLAUDE.md template..."
if [ ! -f CLAUDE.md ]; then
    cp "$(dirname "$0")/templates/CLAUDE.md" ./CLAUDE.md 2>/dev/null || cat > CLAUDE.md << 'CLAUDEEOF'
# CLAUDE.md

## Project
- [Your tech stack here]
- [Your domain here]

## Rules
- [Add your formatting and brand rules here]

## Before Writing Code
1. Read vault/memory.md for current state
2. Read relevant specs from vault/03-specs/
3. Check vault/06-patterns/ for known approaches

## After Writing Code
1. Update vault/memory.md with what changed
2. Log decisions to vault/01-decisions/
3. Log shipped items to vault/08-changelog/
CLAUDEEOF
    echo "  Created CLAUDE.md (customize this for your project)"
else
    echo "  CLAUDE.md already exists, skipping"
fi

echo "[3/7] Creating memory.md..."
if [ ! -f vault/memory.md ]; then
    cat > vault/memory.md << 'MEMEOF'
# Memory

## Current State
- [Describe your project status]

## Last Session
- [What you worked on last]

## Next Up
- [What you're working on next]
MEMEOF
    echo "  Created vault/memory.md"
else
    echo "  vault/memory.md already exists, skipping"
fi

echo "[4/7] Installing core skills..."
# Humanizer
npm install -g humanizer-claude-skill 2>/dev/null || echo "  Humanizer: install manually (npm install -g humanizer-claude-skill)"
# Obsidian Skills
npx skills add git@github.com:kepano/obsidian-skills.git 2>/dev/null || echo "  Obsidian Skills: install manually (npx skills add git@github.com:kepano/obsidian-skills.git)"

# --- SOLOPRENEUR (Tracks 2 and 3) ---

if [[ "$TRACK" == "2" || "$TRACK" == "3" ]]; then
    echo "[5/7] Installing marketing and business skills..."
    npx skills add coreyhaines31/marketingskills 2>/dev/null || echo "  Marketing Skills: install manually (npx skills add coreyhaines31/marketingskills)"

    # GEO-SEO
    if [ ! -d ".claude/skills/improve-aeo-geo" ]; then
        git clone https://github.com/onvoyage-ai/gtm-engineer-skills.git /tmp/gtm-skills 2>/dev/null && \
        cp -r /tmp/gtm-skills/improve-aeo-geo .claude/skills/improve-aeo-geo 2>/dev/null && \
        rm -rf /tmp/gtm-skills && \
        echo "  Installed improve-aeo-geo (AI search optimization)" || \
        echo "  improve-aeo-geo: install manually"
    fi

    # Finance skills
    echo "  To install finance skills, run in CC: /plugin marketplace add alirezarezvani/claude-skills && /plugin install finance-skills"
else
    echo "[5/7] Skipping marketing/business skills (Track 1)"
fi

# --- DEVELOPER (Track 3 only) ---

if [[ "$TRACK" == "3" ]]; then
    echo "[6/7] Installing developer skills..."

    # Superpowers
    echo "  To install Superpowers, run in CC: /plugin marketplace add obra/superpowers"

    # GSD
    npx get-shit-done-cc --claude --global 2>/dev/null || echo "  GSD: install manually (npx get-shit-done-cc --claude --global)"

    # Frontend Design
    echo "  To install Frontend Design, run in CC: /plugin install frontend-design"

    # Security Review
    mkdir -p .claude/skills/security-review
    curl -sL https://raw.githubusercontent.com/curiousleeo/security-review-skill/main/SKILL.md -o .claude/skills/security-review/SKILL.md 2>/dev/null && \
    echo "  Installed security-review" || echo "  security-review: install manually"

    # Playwright
    echo "  To install Playwright skill, run: npx skills add alirezarezvani/claude-skills --skill playwright-skill"

    # Supabase CLI
    command -v supabase >/dev/null 2>&1 && echo "  Supabase CLI: already installed" || echo "  Supabase CLI: install with brew install supabase/tap/supabase"
else
    echo "[6/7] Skipping developer skills (Track $TRACK)"
fi

# --- FINAL SETUP ---

echo "[7/7] Enabling Auto Mode..."
claude --enable-auto-mode 2>/dev/null || echo "  Auto Mode: enable manually with 'claude --enable-auto-mode'"

echo ""
echo "============================================"
echo "  Love Stack installed!"
echo "============================================"
echo ""
echo "  Track: $TRACK"
echo "  Vault: $PROJECT_DIR/vault/"
echo "  Config: $PROJECT_DIR/CLAUDE.md"
echo ""
echo "  Next steps:"
echo "  1. Customize CLAUDE.md for your project"
echo "  2. Open Claude Code: claude"
echo "  3. Type: /memory (check Auto Dream status)"
echo "  4. Try the demo exercise for your track"
echo ""
echo "  Docs: https://github.com/ondecksociety/love-stack"
echo "  Website: https://ondecksociety.com/love-stack"
echo ""
echo "  Built with love and other disruptions."
echo ""
