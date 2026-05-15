# Agency Agents (Fork)

A curated fork of [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) — **178 specialist agent personas** across 15 divisions, packaged for our Claude Code + ecc plugin setup on Windows.

## What changed vs upstream

| Change | Detail |
|---|---|
| China-market agents removed | 22 files dropped (see [excluded list](#excluded-agents)) |
| Windows tooling | PowerShell `install.ps1` / `convert.ps1` replace bash scripts |
| Overlap mapping | See [`docs/ecc-overlap.md`](docs/ecc-overlap.md) — which fork agents duplicate existing ecc plugins |
| Original count | 200 → 178 agents |

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

## Overlap with existing ecc / Anthropic skills

Many fork agents duplicate capabilities already provided by your ecc plugin and Anthropic skills. **Don't install duplicates** — see [`docs/ecc-overlap.md`](docs/ecc-overlap.md) for the side-by-side mapping. Recommended install set: **academic, game-development, spatial-computing, finance, strategy** (mostly net-new), plus cherry-picks from the others.

## License

MIT (preserved from upstream).
