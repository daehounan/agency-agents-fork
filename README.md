# Agency Agents (Fork)

A curated fork of [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) — **179 specialist agent personas** + **26 routing skills** + **1 prompt-suggestion hook** packaged for our Claude Code + ecc plugin setup on Windows.

## What changed vs upstream

| Change | Detail |
|---|---|
| China-market agents removed | 22 files dropped (see [excluded list](#excluded-agents)) |
| Japanese Business Navigator added | New 216-line agent: 稟議 / 根回し / KY / 飲み会 / 報連相 |
| 26 routing skills added | Auto-invoke skills that delegate to the right specialist (see [Skills](#skills)) |
| UserPromptSubmit hook | Optional regex-based agent-suggestion hook (`hooks/suggest-agents.ps1`) |
| Windows tooling | PowerShell `install.ps1` / `convert.ps1` / `migrate-ecc.ps1` replace bash scripts |
| Overlap mapping | See [`docs/ecc-overlap.md`](docs/ecc-overlap.md) — which fork agents duplicate existing ecc plugins |
| Original count | 200 → 178 (China removed) → 179 (Japanese added) |

Upstream license (MIT) preserved. See `LICENSE`.

## Division roster (post-exclusion)

| Division | Count |
|---|---|
| specialized | 36 |
| engineering | 27 |
| game-development | 20 |
| strategy | 16 |
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
| **Total** | **178** |

## Quick start (Windows / PowerShell)

```powershell
# Install all 178 agents to ~/.claude/agents
.\scripts\install.ps1

# Install just one division
.\scripts\install.ps1 -Division engineering

# Dry run (see what would happen, no copies)
.\scripts\install.ps1 -DryRun

# Don't overwrite existing files
.\scripts\install.ps1 -SkipExisting

# Custom target
.\scripts\install.ps1 -Target "C:\custom\path"
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

If you want any of these back, copy from the upstream tree at `C:\Users\andae\Projects\agency-agents-Shiven0504\agency-agents-main\agency-agents-main\`.

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

26 routing skills in `skills/` auto-invoke based on description matching, delegating to the appropriate specialist agent(s).

### Install skills

```powershell
.\scripts\install.ps1 -WithSkills    # install agents + skills
.\scripts\install.ps1 -SkillsOnly    # install only skills (~/.claude/skills/)
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
| `compliance-audit-routing` | 3 agents | SOC2 / smart contract / automation governance |
| `knowledge-content-routing` | 4 agents | Zettelkasten / doc gen / corp training / tech writer |
| `data-ops-routing` | 3 agents | sales extraction / consolidation / report dispatch |
| `design-routing` | 8 agents | UI / UX / brand / whimsy / inclusive imagery |
| `product-discovery-routing` | 5 agents | sprint / trend / feedback / nudge / PM |
| `project-management-routing` | 6 agents | producer / shepherd / Jira / experiment |
| `ai-infra-routing` | 7 agents | orchestrator / LSP / MCP / identity |
| `support-routing` | 12 agents | support / analytics / infra / civil eng / accounts payable |
| `strategy-nexus` | NEXUS playbook | 7 phases + 4 scenarios + handoff protocols |
| `agency-roster` | Discovery utility | Browse the full 179-agent collection |

## Hook

`hooks/suggest-agents.ps1` is a `UserPromptSubmit` hook (manual activation, not auto-enabled). Silent on no-match, injects one-line agent hint on high-confidence regex pattern matches. See [`hooks/README.md`](hooks/README.md) for activation JSON.

## Overlap with existing ecc / Anthropic skills

Many fork agents duplicate capabilities already provided by your ecc plugin and Anthropic skills. Skills documented here cross-link to stronger alternatives (e.g., `general-engineering-routing` defers to `ecc:architect` and `ecc:code-reviewer` for those use cases). See [`docs/ecc-overlap.md`](docs/ecc-overlap.md) for the side-by-side mapping.

## License

MIT (preserved from upstream).
