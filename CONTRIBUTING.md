# Contributing to agency-agents-fork

Thanks for your interest. This is a curated fork of [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) — 163 Claude Code specialist agents + 24 routing skills, tested and packaged for Windows PowerShell 7+.

## Code of Conduct

We follow the [Contributor Covenant](https://www.contributor-covenant.org/). Be respectful, constructive, and focused on improving the fork for everyone.

## What We're Looking For

Most impactful contributions fall into one of these categories:

- **New routing skills** mapping user signals to the right specialist agent (high priority)
- **Bug fixes** in `install.ps1`, `build-plugin.ps1`, `lint-skills.ps1`, `audit-agent-refs.ps1`, or hooks
- **Documentation** improvements (especially `docs/ecc-overlap.md`, `docs/skill-ecosystem-duplicates.md`)
- **Agent enhancements** when paired with a skill or integration plan
- **Upstream sync** PRs bringing valuable changes from `msitarzewski/agency-agents`

We do **not** accept:

- China-market agents (Baidu, WeChat, Feishu, Alipay, Weibo, Bilibili, etc.) — intentional fork positioning. Contribute these upstream to [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents)
- Agents without a documented routing skill to trigger them
- Bulk submissions without a clear maintenance or integration plan

## Setup

PowerShell 7+ is required. On Windows 11/10, install [PowerShell 7](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows) if you don't have it.

```powershell
git clone https://github.com/daehounan/agency-agents-fork.git
cd agency-agents-fork

# Add upstream for sync
git remote add upstream https://github.com/msitarzewski/agency-agents.git

# Full install: agents + skills + hooks
.\scripts\install.ps1 -WithSkills -WithHooks

# Or preview what would be installed
.\scripts\install.ps1 -DryRun -WithSkills -WithHooks
```

For detailed flag documentation:
```powershell
Get-Help .\scripts\install.ps1 -Full
```

## Adding a New Agent

Agents live in **15 division directories** (one file per agent):

- `academic/` — higher education, research, academic publishing
- `design/` — UX, UI, product design, design systems
- `engineering/` — software, DevOps, infrastructure, security
- `finance/` — accounting, FP&A, tax, investor relations
- `game-development/` — game design, engine-specific (Unity, Unreal, Godot, Roblox)
- `marketing/` — content, performance marketing, brand strategy
- `paid-media/` — Google Ads, Meta, LinkedIn, TikTok, Amazon (conversion tracking, campaign management)
- `product/` — product management, roadmapping, discovery
- `project-management/` — Agile, Waterfall, OKRs, team coordination
- `sales/` — sales enablement, prospecting, deal closing
- `spatial-computing/` — VR/AR, spatial design, volumetric capture
- `specialized/` — cultural navigators (Korean, Japanese business culture)
- `strategy/` — NEXUS playbooks (no YAML frontmatter, not agents — see Strategy Playbooks section)
- `support/` — customer support, DevRel, community management
- `testing/` — QA, test automation, performance testing

> **Note**: `integrations/` exists as a top-level folder for external-tool integration guides (Aider, Cursor, Gemini CLI, etc.) — it is NOT a division for new agents. The build pipeline (`scripts/build-plugin.ps1`) explicitly enumerates the 15 divisions above.

### File path and naming

```
<division>/<division>-<slug>.md

Examples:
  engineering/engineering-rust-systems-engineer.md
  specialized/specialized-korean-business-navigator.md
  paid-media/paid-media-tracking-specialist.md
```

### YAML frontmatter (required fields)

Every agent file starts with frontmatter:

```yaml
---
name: Agent Display Name
description: >-
  One sentence describing the agent's core expertise.
  Keep it focused and specific.
color: "#HEX_COLOR"
emoji: 🎯
vibe: One sentence capturing personality/style.
---
```

### Body conventions

After the frontmatter:

1. **# 🧠 Your Identity & Memory** — Core expertise, memory patterns the agent should track
2. **# 💬 Your Communication Style** — Voice, tone, how to explain concepts
3. **# 🚨 Critical Rules** — Non-negotiable constraints or safety guardrails
4. **# 🎯 Your Core Mission** — Why this agent exists, primary domains
5. (Optional) Additional sections for tools, workflows, or domain-specific guidance

Keep agents focused: 200–500 lines typically. See `specialized/specialized-japanese-business-navigator.md` for a full example.

## Adding a New Routing Skill

Routing skills live in `skills/<skill-name>/SKILL.md` and map user signals to the right agent or existing skill.

### File structure

```
skills/<kebab-case-name>/
├── SKILL.md          (required)
└── (no other files)
```

### Frontmatter

```yaml
---
name: skill-name
description: >-
  80–800 characters. Must include "Use when" or "Triggers on".
  Be specific about what activates this skill.
---
```

### Body format

Markdown explaining the routing logic. Typically includes:
- A "How to invoke" section (how agents call it)
- A routing matrix or decision tree
- "When NOT to use" to avoid false positives
- Link to relevant agents using backtick syntax: `` `<division>-<agent-slug>` ``

### Description quality

**Bad:** "general routing skill for various use cases"  
**Good:** "Use when user asks about GraphQL schema design, resolver patterns, N+1 query prevention, or federation. Triggers on 'GraphQL', '@defer/@stream', 'resolver', 'Apollo Client'."

Agent slugs in backticks (e.g., `` `engineering-solidity-auditor` ``) must resolve to actual agent files — the audit script verifies this.

### Lint requirements (run before PR)

```powershell
.\scripts\lint-skills.ps1 -Strict
```

| Rule | Details |
|---|---|
| `name` matches directory | Tooling assumption |
| `description` 80–800 chars | Too short won't fire; too long wastes tokens |
| `description` includes "Use when" or "Triggers on" | Required for routing prompt |
| Body at least 3 lines | One-liner is not actionable |
| File under 8000 bytes | Larger files should be split |

## Cross-Reference Audit

The `audit-agent-refs.ps1` script verifies that every backtick-quoted agent slug in every SKILL.md resolves to a real agent file. Run it locally before opening a PR:

```powershell
.\scripts\audit-agent-refs.ps1
```

This catches typos, deleted agents, and migration drift. Currently: **0 orphans** across ~180 references.

## Running CI Checks Locally

Before opening a PR, run the same checks CI runs:

```powershell
# Lint all skills in strict mode
.\scripts\lint-skills.ps1 -Strict

# Audit cross-references (agent slugs in SKILL.md must exist)
.\scripts\audit-agent-refs.ps1

# Build the plugin locally (tests the whole pipeline)
.\scripts\build-plugin.ps1
```

If all three pass, your PR is ready. CI will run:

1. **lint.yml** — lints all skill files (`lint-skills.ps1 -Strict`)
2. **build-plugin.yml** — builds the full plugin, verifies agent count

## Branch Naming

- `feat/<short-desc>` — new agent, skill, or feature (e.g., `feat/graphql-routing-skill`)
- `fix/<short-desc>` — bug fix (e.g., `fix/audit-script-false-positive`)
- `docs/<short-desc>` — documentation (e.g., `docs/expand-ecc-overlap`)

## Commit Messages

Conventional commits format. Examples from this repo:

```
feat(skills): add graphql-routing skill for Apollo + Relay

Triggers on schema design, resolver patterns, federation questions.
Routes to engineering-typescript-full-stack and engineering-frontend-architect.

fix(audit): handle agent slugs with numbers correctly

docs(readme): clarify -Divisions parameter with examples

ci(build): increase timeout for plugin packaging from 30s to 60s
```

Types: `feat` `fix` `docs` `refactor` `test` `chore` `ci` `perf`  
Scope (optional): lowercase in parens — `(skills)`, `(install)`, `(docs)`, `(ci)`, etc.

## Pull Request Process

1. **Fork and branch** — feature branches only, no commits to `master`
2. **Implement** — add agent, skill, or fix
3. **Test locally**:
   - `.\scripts\lint-skills.ps1 -Strict` (skills only)
   - `.\scripts\audit-agent-refs.ps1` (all backtick refs)
   - `.\scripts\build-plugin.ps1` (full pipeline)
4. **Open PR** — use the issue template that matches your contribution type (Bug Report, Feature Request, New Skill)
5. **CI will validate** — all three workflows must be green
6. **Maintainer review** — typically 1–2 business days

## Reporting Issues & Requesting Agents

Use the issue templates in `.github/ISSUE_TEMPLATE/`:

- **Bug Report** — something doesn't work (install failure, lint error, broken agent)
- **Feature Request** — suggest an enhancement (new capability, new agent class)
- **New Skill** — propose a routing skill with triggers and routing matrix

Before opening a request:
- Search existing issues (open + closed)
- Check `docs/ecc-overlap.md` to see if the agent already exists in the ecosystem
- Check `docs/skill-ecosystem-duplicates.md` for similar routing skills

## License & Attribution

This fork is licensed under **MIT** (same as upstream). Contributions must be MIT-compatible.

All agent personas, routing skills, and strategy playbooks in this fork are:
- Original work or
- Derived from upstream [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) with attribution retained

Relevant upstream PRs and improvements are welcome. We track upstream changes in the repo; you can submit sync PRs or issues pointing to valuable upstream work.

## Questions?

Open an issue using the appropriate template. We don't use Discussions — everything goes through issues for visibility and searchability.
