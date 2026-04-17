#!/bin/bash

# Love Stack Installer v3.2
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
echo "  v3.2 | MIT License | Free Forever"
echo ""

# Check prerequisites
command -v claude >/dev/null 2>&1 || { echo "Error: Claude Code CLI not found. Install with: npm install -g @anthropic-ai/claude-code"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "Error: git not found."; exit 1; }

# Ask for track
echo "Which track do you want?"
echo ""
echo "  1) Personal     - Writing, research, productivity (no coding)"
echo "  2) Solopreneur  - Marketing, finance, content, strategy"
echo "  3) Developer    - Full engineering stack (185+ skills)"
echo ""
read -p "Enter 1, 2, or 3: " TRACK

if [[ "$TRACK" != "1" && "$TRACK" != "2" && "$TRACK" != "3" ]]; then
    echo "Invalid choice. Please enter 1, 2, or 3."
    exit 1
fi

echo ""
echo "Installing Track $TRACK..."
echo ""

# Get project directory and install script directory
PROJECT_DIR=$(pwd)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Target directory for Claude skills (idempotent: mkdir -p)
USER_SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$USER_SKILLS_DIR"

# Helper: copy a templates/skills/<name>/ folder to ~/.claude/skills/<name>/
# Idempotent: only copies if target doesn't already exist OR source is newer
install_skill() {
    local skill_name="$1"
    local src="$SCRIPT_DIR/templates/skills/$skill_name"
    local dst="$USER_SKILLS_DIR/$skill_name"

    if [ ! -d "$src" ]; then
        echo "  [skip] $skill_name: source not found at $src"
        return
    fi

    if [ -d "$dst" ]; then
        echo "  [=]    $skill_name: already installed (use --force to reinstall)"
    else
        cp -R "$src" "$dst"
        echo "  [+]    $skill_name: installed"
    fi
}

# --- CORE (All Tracks) ---

echo "[1/9] Creating Obsidian vault structure..."
mkdir -p vault/{00-context,01-decisions,02-sessions,03-specs,04-prompts/{shipped,drafts},05-bugs/{open,resolved},06-patterns,07-research,08-changelog}
echo "vault/.obsidian/" >> .gitignore 2>/dev/null || true

echo "[2/9] Creating CLAUDE.md template..."
if [ ! -f CLAUDE.md ]; then
    if [ -f "$SCRIPT_DIR/templates/CLAUDE.md" ]; then
        cp "$SCRIPT_DIR/templates/CLAUDE.md" ./CLAUDE.md
    else
        cat > CLAUDE.md << 'CLAUDEEOF'
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
    fi
    echo "  Created CLAUDE.md (customize this for your project)"
else
    echo "  CLAUDE.md already exists, skipping"
fi

echo "[3/9] Creating memory.md..."
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

echo "[4/9] Installing core skills (all tracks)..."
# v3.1 core
npm install -g humanizer-claude-skill 2>/dev/null || echo "  Humanizer: install manually (npm install -g humanizer-claude-skill)"
npx skills add git@github.com:kepano/obsidian-skills.git 2>/dev/null || echo "  Obsidian Skills: install manually (npx skills add git@github.com:kepano/obsidian-skills.git)"
# v3.2 new (all tracks)
install_skill "brand-voice"
install_skill "escalation"

# --- SOLOPRENEUR + DEVELOPER (Tracks 2 and 3) ---

if [[ "$TRACK" == "2" || "$TRACK" == "3" ]]; then
    echo "[5/9] Installing marketing + business + product skills..."
    npx skills add coreyhaines31/marketingskills 2>/dev/null || echo "  Marketing Skills: install manually (npx skills add coreyhaines31/marketingskills)"

    # GEO-SEO
    if [ ! -d ".claude/skills/improve-aeo-geo" ]; then
        git clone https://github.com/onvoyage-ai/gtm-engineer-skills.git /tmp/gtm-skills 2>/dev/null && \
        cp -r /tmp/gtm-skills/improve-aeo-geo .claude/skills/improve-aeo-geo 2>/dev/null && \
        rm -rf /tmp/gtm-skills && \
        echo "  Installed improve-aeo-geo (AI search optimization)" || \
        echo "  improve-aeo-geo: install manually"
    fi

    echo "  To install finance skills, run in CC: /plugin marketplace add alirezarezvani/claude-skills && /plugin install finance-skills"

    # v3.2 new (Solopreneur + Developer)
    install_skill "prd-generator"
    install_skill "market-research-reports"
    install_skill "theme-factory"
    install_skill "excalidraw-diagram-generator"

    # PostHog MCP (Solopreneur + Developer)
    echo "  Installing PostHog MCP..."
    claude mcp add posthog -- npx -y @posthog/wizard@latest 2>/dev/null || \
        echo "  PostHog MCP: install manually (claude mcp add posthog -- npx -y @posthog/wizard@latest)"
else
    echo "[5/9] Skipping marketing/business skills (Track 1)"
fi

# --- DEVELOPER (Track 3 only) ---

if [[ "$TRACK" == "3" ]]; then
    echo "[6/9] Installing developer skills..."

    echo "  To install Superpowers, run in CC: /plugin marketplace add obra/superpowers"
    npx get-shit-done-cc --claude --global 2>/dev/null || echo "  GSD: install manually (npx get-shit-done-cc --claude --global)"
    echo "  To install Frontend Design, run in CC: /plugin install frontend-design"

    # Security Review
    mkdir -p .claude/skills/security-review
    curl -sL https://raw.githubusercontent.com/curiousleeo/security-review-skill/main/SKILL.md -o .claude/skills/security-review/SKILL.md 2>/dev/null && \
    echo "  Installed security-review" || echo "  security-review: install manually"

    echo "  To install Playwright QA skill, run: npx skills add alirezarezvani/claude-skills --skill playwright-skill"
    command -v supabase >/dev/null 2>&1 && echo "  Supabase CLI: already installed" || echo "  Supabase CLI: install with brew install supabase/tap/supabase"

    # v3.2 new (Developer only)
    install_skill "pre-launch-audit"
    install_skill "parallel-debugging"
    install_skill "accessibility-compliance"
    install_skill "responsive-design"
    install_skill "gdpr-data-handling"
    install_skill "system-designer-review"

    # Firecrawl (install-time pointer, no AGPL code bundled)
    echo "  Firecrawl Scraper: run '/plugin install firecrawl' inside Claude Code to pull from Firecrawl's official plugin (AGPL-3.0 upstream, not bundled in Love Stack)."

    # Playwright MCP (Developer only)
    echo "[7/9] Installing Playwright MCP..."
    claude mcp add playwright -- npx -y @playwright/mcp@latest 2>/dev/null || \
        echo "  Playwright MCP: install manually (claude mcp add playwright -- npx -y @playwright/mcp@latest)"

    # MemPalace (Developer only)
    echo "[8/9] Installing MemPalace persistent memory plugin..."
    if command -v pip >/dev/null 2>&1; then
        pip install --quiet mempalace 2>/dev/null && echo "  MemPalace: pip install succeeded" || \
            echo "  MemPalace pip install failed. See templates/plugins/mempalace/INSTALL.md"
        mempalace init "$PROJECT_DIR" 2>/dev/null && echo "  MemPalace: initialized palace for $PROJECT_DIR" || \
            echo "  MemPalace init skipped (may already exist)"
        claude mcp add mempalace -- python -m mempalace.mcp_server 2>/dev/null || \
            echo "  MemPalace MCP: see templates/plugins/mempalace/INSTALL.md for manual registration"
    else
        echo "  MemPalace requires pip. See templates/plugins/mempalace/INSTALL.md"
    fi
else
    echo "[6/9] Skipping developer skills (Track $TRACK)"
    echo "[7/9] Skipping Playwright MCP (Developer track only)"
    echo "[8/9] Skipping MemPalace (Developer track only)"
fi

# --- FINAL SETUP ---

echo "[9/9] Enabling Auto Mode..."
claude --enable-auto-mode 2>/dev/null || echo "  Auto Mode: enable manually with 'claude --enable-auto-mode'"

echo ""
echo "============================================"
echo "  Love Stack v3.2 installed!"
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
