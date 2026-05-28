# Agency Agents (Fork)

> **163 Claude Code specialist agents + 24 routing skills, one-line install.** Korean / Japanese business culture navigators · game-dev across Unity / Unreal / Godot / Roblox / Blender · XR / spatial · paid-media · `skill-routing-arbitrator` for disambiguating across the ~500-skill Claude Code ecosystem.

[![Lint Skills](https://github.com/daehounan/agency-agents-fork/actions/workflows/lint.yml/badge.svg?branch=master)](https://github.com/daehounan/agency-agents-fork/actions/workflows/lint.yml)
[![Build Plugin](https://github.com/daehounan/agency-agents-fork/actions/workflows/build-plugin.yml/badge.svg?branch=master)](https://github.com/daehounan/agency-agents-fork/actions/workflows/build-plugin.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Agents](https://img.shields.io/badge/agents-163-brightgreen.svg)](#division-roster-post-exclusion)
[![Skills](https://img.shields.io/badge/skills-24-blue.svg)](#skills)
[![Playbooks](https://img.shields.io/badge/playbooks-16-yellow.svg)](#strategy-playbooks-non-agent)
[![Security Policy](https://img.shields.io/badge/security-policy-orange.svg)](SECURITY.md)
[![Cross-platform](https://img.shields.io/badge/install-macOS%20·%20Linux%20·%20Windows-informational.svg)](#install-in-one-line)
[![Tooling](https://img.shields.io/badge/tooling-PowerShell%207%2B-lightgrey.svg)](#quick-start-windows--powershell)

## Install in one line

```
claude --plugin-url https://github.com/daehounan/agency-agents-fork/releases/download/v1.3.0/agency-agents-fork-v1.3.0-full.zip
```

Or grab a smaller scoped subset from the [v1.3.0 release](https://github.com/daehounan/agency-agents-fork/releases/tag/v1.3.0):
[`engineering-finance`](https://github.com/daehounan/agency-agents-fork/releases/download/v1.3.0/agency-agents-fork-v1.3.0-engineering-finance.zip) (32 agents) ·
[`marketing-paid-media-sales`](https://github.com/daehounan/agency-agents-fork/releases/download/v1.3.0/agency-agents-fork-v1.3.0-marketing-paid-media-sales.zip) (30) ·
[`game-development`](https://github.com/daehounan/agency-agents-fork/releases/download/v1.3.0/agency-agents-fork-v1.3.0-game-development.zip) (20).

> **Just want the Korean + Japanese Business Navigators?** → standalone plugin at [`daehounan/k-jp-business-navigators`](https://github.com/daehounan/k-jp-business-navigators) (2 agents, ~374 routing tokens vs full bundle's ~8,400).

---

A curated fork of [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) — **163 specialist agent personas** across 15 divisions + **24 routing skills** (consolidated, no duplicates with existing ecc/Anthropic skills) + **16 NEXUS strategy playbooks** + **2 hooks** + **ecosystem-wide duplicates audit**.

Three install paths supported:

| Path | When | How |
|---|---|---|
| **Pre-built plugin from release** (recommended) | You just want the plugin, no clone, no build step. | `claude --plugin-url https://github.com/daehounan/agency-agents-fork/releases/download/v1.3.0/agency-agents-fork-v1.3.0-full.zip` |
| **User-level config bundle** | You want agents in `~/.claude/agents/` and skills in `~/.claude/skills/` (no namespacing). Windows. | `pwsh scripts/install.ps1 -WithSkills [-WithHooks]` |
| **Plugin built from source** | You want to customize divisions or hack on the build. | `pwsh scripts/build-plugin.ps1` → `claude --plugin-dir ./dist/plugin` |

The plugin build flattens the division-organized source into a spec-conformant `agents/` directory plus `hooks/hooks.json` and a clean `.claude-plugin/plugin.json`. The division dirs in the source repo are kept for browsing. See [Plugin build](#plugin-build) below.

### Pre-built release assets ([v1.3.0](https://github.com/daehounan/agency-agents-fork/releases/tag/v1.3.0))

| Variant | Agents | URL suffix (under `…/releases/download/v1.3.0/`) |
|---|---|---|
| Full bundle | 163 | `agency-agents-fork-v1.3.0-full.zip` |
| Engineering + finance | 32 | `agency-agents-fork-v1.3.0-engineering-finance.zip` |
| Marketing + paid-media + sales | 30 | `agency-agents-fork-v1.3.0-marketing-paid-media-sales.zip` |
| Game development | 20 | `agency-agents-fork-v1.3.0-game-development.zip` |

For other subsets, build locally with [`scripts/build-plugin.ps1 -Divisions <list>`](#plugin-build).

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

# Install just one division (legacy single-division flag)
.\scripts\install.ps1 -Division engineering

# Install a scoped subset (multi-division — UX parity with build-plugin.ps1 -Divisions)
.\scripts\install.ps1 -Divisions engineering,finance
.\scripts\install.ps1 -Divisions specialized   # Korean + Japanese Business Navigators
.\scripts\install.ps1 -Divisions "marketing;paid-media;sales"

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

## Plugin build

`scripts/build-plugin.ps1` produces a Claude Code plugin-loader-conformant build at `dist/plugin/` from the division-organized source.

```powershell
.\scripts\build-plugin.ps1                                # all 163 agents
.\scripts\build-plugin.ps1 -Divisions finance,engineering # scoped subset (32 agents)
.\scripts\build-plugin.ps1 -Divisions game-development    # single division (20 agents)
.\scripts\build-plugin.ps1 -Verbose_                      # show each file as it's copied
.\scripts\build-plugin.ps1 -Zip                           # also emit dist/agency-agents-fork-plugin.zip
```

### About token cost

The full 163-agent bundle's agent description fields sum to ~8k tokens by static estimation, but Claude Code's runtime warning fires at ~22k cumulative — it counts more than just description fields. That's above Claude's recommended 15k budget for plugin-supplied agent metadata, so every turn pays a real overhead.

If you only need a slice of the collection, build a scoped plugin:

| Use case | Command | Agents | Plugin name |
|---|---|---|---|
| Game dev only | `-Divisions game-development` | 20 | `agency-agents-fork-game-development` |
| Engineering + finance | `-Divisions engineering,finance` | 32 | `agency-agents-fork-engineering-finance` |
| Marketing + paid-media + sales | `-Divisions marketing,paid-media,sales` | 30 | `agency-agents-fork-marketing-paid-media-sales` |
| Korean/Japanese business prep | `-Divisions specialized` | 37 | `agency-agents-fork-specialized` |
| Full bundle (default) | (no flag) | 163 | `agency-agents-fork` |

Valid divisions: `academic, design, engineering, finance, game-development, marketing, paid-media, product, project-management, sales, spatial-computing, specialized, support, testing`.

Comma, semicolon, and whitespace all work as separators: `-Divisions finance,engineering` or `-Divisions "finance;engineering;academic"` are both fine.

All 24 routing skills are always included regardless of scope — they're small (~14k chars total) and several route to skills outside the local bundle (e.g. `ecc:*`, `anthropic-skills:*`), so they remain useful even in a slim build.

Resulting structure:

```
dist/plugin/
├── .claude-plugin/plugin.json   # manifest only (no file lists — spec-conformant)
├── agents/                      # 163 flat .md files (flattened from division dirs)
├── skills/                      # 24 skill directories with SKILL.md
├── hooks/
│   ├── hooks.json               # declares UserPromptSubmit + PreToolUse:Skill
│   ├── suggest-agents.ps1
│   └── log-skill-fired.ps1
└── README.md
```

Test the build locally — **run from the repo root** (`cd` first), or use absolute paths:

```powershell
# Option A: cd to repo first (recommended)
cd C:\Users\andae\Projects\agency-agents-fork
.\scripts\build-plugin.ps1
claude --plugin-dir .\dist\plugin

# Option B: absolute paths from anywhere (e.g. another terminal session)
pwsh -NoProfile -File C:\Users\andae\Projects\agency-agents-fork\scripts\build-plugin.ps1
claude --plugin-dir C:\Users\andae\Projects\agency-agents-fork\dist\plugin
```

If you run `.\scripts\build-plugin.ps1` from `C:\Users\andae` (or any directory that isn't the repo root), PowerShell can't find the script — that's not a build failure, it's the wrong working directory. The build script prints the absolute `--plugin-dir` path on success so you can copy-paste it regardless of cwd.

Or zip the directory and use `--plugin-url`:

```powershell
.\scripts\build-plugin.ps1 -Zip
# emits dist/agency-agents-fork-plugin.zip plus a ready-to-paste --plugin-url command
```

The build is verified on every push by [`build-plugin.yml`](.github/workflows/build-plugin.yml) — asserts 163 agents, 24 skills, both JSON manifests parse, then uploads the artifact for 30-day retention.

`dist/` is gitignored. Source-of-truth is the division dirs; the build is reproducible from them.

## Security

See [`SECURITY.md`](SECURITY.md) for the vulnerability reporting policy, scope (PowerShell scripts, hooks, agent personas), and the hardening already in place (settings.json backup, silent-on-error hooks, no outbound network).

## Verification scripts

| Script | What it does | Run on CI |
|---|---|---|
| `scripts/lint-skills.ps1` | YAML frontmatter + description + body validation across all 24 skills | ✅ |
| `scripts/audit-agent-refs.ps1` | Cross-references every backticked slug in `skills/*/SKILL.md` against the actual 163 agent files (catches typos, stale refs, renamed agents) | ✅ |
| `scripts/build-plugin.ps1` | Builds a Claude Code plugin-loader-conformant package at `dist/plugin/` (flat `agents/` + `hooks/hooks.json` + clean manifest) | ✅ |
| `scripts/show-skill-stats.ps1` | Reads the local telemetry log and reports fire counts per skill | — |
| `scripts/install-hooks-in-settings.ps1` | Idempotent registration of UserPromptSubmit + PreToolUse(Skill) hooks in `~/.claude/settings.json` with backup/rollback | — |

External skill names referenced from routing tables without a namespace prefix (e.g. built-in `/review`, `internal-comms`) are whitelisted in [`scripts/external-skill-refs.txt`](scripts/external-skill-refs.txt) so the audit treats them as resolved.

## License

MIT (preserved from upstream).
