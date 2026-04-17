# MemPalace Installation

**What it is:** Persistent AI memory for Claude Code. 29 MCP tools, auto-save hooks, 5 guided skills. 96.6% recall on LongMemEval. Runs entirely on your local machine.

**Upstream:** https://github.com/MemPalace/mempalace (MIT License)

**Track:** Developer only.

## Install Steps

MemPalace is NOT bulk-copied into Love Stack. The Love Stack installer pulls it from the official repo at install time so you always get the latest version.

### 1. Install the Python package

```bash
pip install mempalace
```

### 2. Initialize a palace for your project

```bash
mempalace init ~/projects/your-project
```

### 3. Register MemPalace as an MCP server with Claude Code

```bash
claude mcp add mempalace -- python -m mempalace.mcp_server
```

Or, if MemPalace ships as a Claude Code plugin:

```bash
claude plugin add github:MemPalace/mempalace
```

### 4. Verify

```bash
claude mcp list | grep mempalace
```

You should see mempalace listed as Connected.

## What You Get

- **29 MCP tools** for palace operations, knowledge-graph queries, drawer management, and agent diaries
- **5 guided skills** that teach Claude when to search memory and when to save
- **Auto-save hooks** that capture completed tasks and learnings without manual intervention
- **Memory protocol**: before responding about a person, project, or past event, Claude searches memory first

## Post-Install

On next Claude Code session start, ~170 tokens of critical memory facts are loaded automatically. Search happens as needed during the session.
