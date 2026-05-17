# Agency Agents (Fork)

[![Lint Skills](https://github.com/daehounan/agency-agents-fork/actions/workflows/lint.yml/badge.svg?branch=master)](https://github.com/daehounan/agency-agents-fork/actions/workflows/lint.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Agents](https://img.shields.io/badge/agents-163-brightgreen.svg)](#division-roster-post-exclusion)
[![Skills](https://img.shields.io/badge/skills-24-blue.svg)](#skills)
[![Playbooks](https://img.shields.io/badge/playbooks-16-yellow.svg)](#strategy-playbooks-non-agent)
[![Security Policy](https://img.shields.io/badge/security-policy-orange.svg)](SECURITY.md)
[![Platform](https://img.shields.io/badge/platform-Windows%20PowerShell%207%2B-informational.svg)](#quick-start-windows--powershell)

A curated fork of [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) — **163 specialist agent personas** across 14 divisions + **24 routing skills** (consolidated, no duplicates with existing ecc/Anthropic skills) + **16 NEXUS strategy playbooks** + **2 hooks** + **ecosystem-wide duplicates audit**. Packaged as a user-level Claude Code config bundle for Windows (PowerShell installer).

> **Not (yet) a packaged Claude Code plugin.** The repo is a user-level config bundle: `scripts/install.ps1` copies agents into `~/.claude/agents/` and skills into `~/.claude/skills/`. The `.claude-plugin/` metadata is informational. Plugin-loader conformance (a flat `agents/` directory + `hooks/hooks.json`) is on the roadmap.

## What changed vs upstream

| Change | Detail |
|---|---|
| China-market agents removed | 22 files dropped (see [excluded list](#excluded-agents)) |
| Japanese Business Navigator added | New 216-line agent: 稟議 / 根回し / KY / 飲み会 / 報連相 |
| 24 routing skills added | Auto-invoke skills that delegate to the right specialist (see [Skills](#skills)). Consolidated to avoid duplicates with `ecc:*`, `engineering:*`, `design:*`, `operations:*` etc. Includes `skill-routing-arbitrator` for ecosystem-wide disambiguation. |
| Ecosystem duplicates audit | [`docs/skill-ecosystem-duplicates.md`](docs/skill-ecosystem-duplicates.md) maps ~500 skills into preference clusters (versioned snapshots, legacy shims, cross-namespace duplicates, hooks) |
| UserPromptSubmit hook | Optional regex-based agent-suggestion hook (`hooks/suggest-agents.ps1`) |
| Windows tooling | PowerShell `install.ps1` / `convert.ps1` / `migrate-ecc.ps1` replace bash scripts |
| Overlap mapping | See [`docs/ecc-overlap.md`](docs/ecc-overlap.md) — which fork agents duplicate existing ecc plugins |
| Original count | 200 markdown files → 178 (China removed) → 179 (Japanese Business Navigator added). Of those 179, **163 are agent personas** (with YAML frontmatter) and **16 are NEXUS strategy playbooks** (documentation, no frontmatter). |

Upstream license (MIT) preserved. See `LICENSE`.

## Division roster (post-exclusion)

| Division | Agents |
|---|---|
| specialized | 37 |
| engineering | 27 |
| game-development | 20 |
| marketing | 15 |
| design | 8 |
| sales | 8 |
| testing | 8 |
| paid-media | 7 |
| project-management | 6 |
| spatial-computing | 6 |
| support | 6 |
| academic | 5 |
| finance | 5 |
| product | 5 |
| **Agent total** | **163** |

## Strategy playbooks (non-agent)

The `strategy/` directory contains **16 NEXUS engagement documents** (not agents — no YAML frontmatter, not loadable as personas). They are referenced by the `strategy-nexus` routing skill:

- `EXECUTIVE-BRIEF.md`, `QUICKSTART.md`, `nexus-strategy.md`
- `playbooks/phase-{0..6}-*.md` — 7 phase playbooks (discovery → operate)
- `runbooks/scenario-{enterprise-feature, incident-response, marketing-campaign, startup-mvp}.md`
- `coordination/{agent-activation-prompts, handoff-templates}.md`

## Quick start (Windows / PowerShell)

```powershell
# Install 163 agents + 16 playbook docs (179 .md files total) to ~/.claude/agents
.\scripts\install.ps1

# Install just one division
.\scripts\install.ps1 -Division engineering

# Dry run (see what would happen, no copies)
.\scripts\install.ps1 -DryRun

# Don't overwrite existing files
.\scripts\install.ps1 -SkipExisting

# Custom target
.\scripts\install.ps1 -Target "C:\custom\path"

# Also register the suggest-agents + skill-telemetry hooks in ~/.claude/settings.json
.\scripts\install.ps1 -WithHooks
```

## Convert to other tools

```powershell
.\scripts\convert.ps1 -Tool cursor      # -> integrations/cursor/*.mdc
.\scripts\convert.ps1 -Tool aider       # -> integrations/aider/CONVENTIONS.md
.\scripts\convert.ps1 -Tool windsurf    # -> integrations/windsurf/.windsurfrules
.\scripts\convert.ps1 -Tool opencode    # -> integrations/opencode/*.md
.\scripts\convert.ps1 -Tool all         # all four
```

## Excluded agents

22 files removed (China-market focus):

**Engineering**
- `engineering-feishu-integration-developer.md`
- `engineering-wechat-mini-program-developer.md`

**Marketing** (15)
- `marketing-baidu-seo-specialist.md`
- `marketing-bilibili-content-strategist.md`
- `marketing-china-ecommerce-operator.md`
- `marketing-china-market-localization-strategist.md`
- `marketing-cross-border-ecommerce.md`
- `marketing-douyin-strategist.md`
- `marketing-kuaishou-strategist.md`
- `marketing-livestream-commerce-coach.md`
- `marketing-podcast-strategist.md` (Chinese podcast market)
- `marketing-private-domain-operator.md`
- `marketing-short-video-editing-coach.md`
- `marketing-wechat-official-account.md`
- `marketing-weibo-strategist.md`
- `marketing-xiaohongshu-specialist.md`
- `marketing-zhihu-strategist.md`

**Specialized** (5)
- `government-digital-presales-consultant.md` (China ToG)
- `healthcare-marketing-compliance.md` (China healthcare advertising)
- `supply-chain-strategist.md` (China manufacturing ecosystem)
- `study-abroad-advisor.md` (Chinese students)
- `recruitment-specialist.md` (China hiring platforms)

If you want any of these back, copy them in from a fresh clone of the upstream `agency-agents` repository — this fork removed them.

## Agent file format

Each agent is a Markdown file with YAML frontmatter:

```markdown
---
name: Frontend Developer
description: Expert frontend developer specializing in...
color: cyan
emoji: 🖥️
vibe: One-line vibe statement.
---

# <Agent Name> Agent Personality

## 🧠 Your Identity & Memory
...

## 🎯 Your Core Mission
...

## 🚨 Critical Rules You Must Follow
...

## 📋 Your Technical Deliverables
... (with code examples)

## 🔄 Your Workflow Process
...

## 💭 Your Communication Style
...
```

## Skills

24 routing skills in `skills/` auto-invoke based on description matching, delegating to the appropriate specialist agent(s). The original 26 were consolidated — duplicates with existing skills (`engineering:*`, `design:*`, `ecc:autonomous-agent-harness`, `ecc:mcp-server-patterns`, etc.) were removed (3 dropped, 3 slimmed) so each routing skill has genuine net-new value.

### Consolidation history

| Removed (3) | Why | Use instead |
|---|---|---|
| `general-engineering-routing` | 100% overlap with `engineering:*` (10 skills) + ecc agents | `ecc:architect`, `ecc:code-reviewer`, `engineering:architecture`, `engineering:debug` |
| `ai-infra-routing` | Overlap with `ecc:mcp-server-patterns`, `ecc:autonomous-agent-harness`, `anthropic-skills:mcp-builder`, `ruflo-swarm:*` | Those skills directly |
| `design-routing` | Overlap with `design:*` (7 skills) | `design:design-critique`, `design:design-system`, etc. |

| Slimmed (3) | Original scope | Now covers only |
|---|---|---|
| `compliance-audit-routing` | SOC 2/ISO/HIPAA + smart contract + n8n | Smart contract + n8n only (SOC 2 etc. → `operations:compliance-tracking`, `anthropic-skills:security-audit-engine`) |
| `knowledge-content-routing` | Zettelkasten + doc generation + tech writer | Zettelkasten + corp training only (formats → `anthropic-skills:pptx/docx/pdf/xlsx`) |
| `product-discovery-routing` | 5 product agents | Behavioral nudge + trend researcher persona only (sprint/PRD/roadmap → `product-management:*`) |

### Install skills

```powershell
.\scripts\install.ps1 -WithSkills              # install agents + skills
.\scripts\install.ps1 -SkillsOnly              # install only skills (~/.claude/skills/)
.\scripts\install.ps1 -WithSkills -WithHooks   # agents + skills + hooks (full install)
```

### Skill roster

| Skill | Routes to | Domain |
|---|---|---|
| `korean-business` | Korean Business Navigator | 품의 / nunchi / 회식 / KakaoTalk |
| `japanese-business` | Japanese Business Navigator | 稟議 / 根回し / KY / 飲み会 / 報連相 |
| `localization-cultural` | 3 agents | French ESN / cultural intel / ES↔EN translation |
| `xr-spatial-routing` | 6 agents | visionOS / WebXR / Vision Pro / Metal |
| `game-development-routing` | 19 agents | Unity / Unreal / Godot / Roblox / Blender |
| `niche-engineering-routing` | 9 agents | embedded / voice AI / email intel / SIEM / CMS / AI remediation |
| `general-engineering-routing` | 18 agents | frontend / backend / mobile / SRE / DevOps |
| `paid-media-routing` | 7 agents | Google Ads / Meta / programmatic / tracking |
| `social-platform-routing` | 11 agents | Twitter / TikTok / IG / Reddit / LinkedIn / YouTube |
| `sales-methodology-routing` | 9 agents | MEDDPICC / SPIN / discovery / proposal / coach |
| `legal-firm-ops` | 3 agents | intake / billing / document review |
| `real-estate-mortgage` | 2 agents | buyer-seller / loan officer |
| `customer-service-vertical` | 4 agents | general / healthcare / hospitality / retail |
| `finance-analysis` | 5 agents | bookkeeper / FP&A / DCF / tax |
| `worldbuilding-rigor` | 5 agents | anthropologist / geographer / historian / narratologist / psychologist |
| `qa-testing-routing` | 8 agents | evidence / reality / perf / API / a11y |
| `compliance-audit-routing` | 2 agents (slim) | smart contract + n8n governance only |
| `knowledge-content-routing` | 2 agents (slim) | Zettelkasten + corporate training only |
| `data-ops-routing` | 3 agents | sales extraction / consolidation / report dispatch |
| `product-discovery-routing` | 2 agents (slim) | behavioral nudge + trend researcher only |
| `project-management-routing` | 6 agents | producer / shepherd / Jira / experiment |
| `support-routing` | 12 agents | support / analytics / infra / civil eng / accounts payable |
| `strategy-nexus` | NEXUS playbook | 7 phases + 4 scenarios + handoff protocols |
| `agency-roster` | Discovery utility | Browse the full 163-agent collection |
| `skill-routing-arbitrator` | **Meta-skill** | Resolves which skill to use when multiple match (covers all ecosystem clusters) |

## Hook

`hooks/suggest-agents.ps1` is a `UserPromptSubmit` hook (manual activation, not auto-enabled). Silent on no-match, injects one-line agent hint on high-confidence regex pattern matches. See [`hooks/README.md`](hooks/README.md) for activation JSON.

## Overlap with existing ecc / Anthropic skills

Many fork agents duplicate capabilities already provided by your ecc plugin and Anthropic skills. Skills documented here cross-link to stronger alternatives (e.g., `general-engineering-routing` defers to `ecc:architect` and `ecc:code-reviewer` for those use cases). See [`docs/ecc-overlap.md`](docs/ecc-overlap.md) for the side-by-side mapping.

## Security

See [`SECURITY.md`](SECURITY.md) for the vulnerability reporting policy, scope (PowerShell scripts, hooks, agent personas), and the hardening already in place (settings.json backup, silent-on-error hooks, no outbound network).

## Verification scripts

| Script | What it does | Run on CI |
|---|---|---|
| `scripts/lint-skills.ps1` | YAML frontmatter + description + body validation across all 24 skills | ✅ |
| `scripts/audit-agent-refs.ps1` | Cross-references every backticked slug in `skills/*/SKILL.md` against the actual 163 agent files (catches typos, stale refs, renamed agents) | ✅ |
| `scripts/show-skill-stats.ps1` | Reads the local telemetry log and reports fire counts per skill | — |
| `scripts/install-hooks-in-settings.ps1` | Idempotent registration of UserPromptSubmit + PreToolUse(Skill) hooks in `~/.claude/settings.json` with backup/rollback | — |

External skill names referenced from routing tables without a namespace prefix (e.g. built-in `/review`, `internal-comms`) are whitelisted in [`scripts/external-skill-refs.txt`](scripts/external-skill-refs.txt) so the audit treats them as resolved.

## License

MIT (preserved from upstream).
