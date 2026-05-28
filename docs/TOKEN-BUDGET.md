# Token Budget: Agency Agents Fork

## What This Measures

This table estimates **routing tokens** — the description field from YAML frontmatter of each agent and skill that Claude Code loads at startup to determine which persona to activate. These tokens are charged per turn, whether or not you invoke a specific agent.

**Important disclaimer**: This uses a heuristic of ~4 characters per token. Actual token usage may vary by ±30% depending on the tokenizer. Strategy playbooks in `strategy/` have no YAML frontmatter and do not incur routing costs; they are routed via the `strategy-nexus` skill instead.

## Token Estimate by Division

| Division | Agents | Routing Tokens |
|----------|--------|----------------|
| academic | 5 | 236 |
| design | 8 | 403 |
| engineering | 27 | 1284 |
| finance | 5 | 376 |
| game-development | 20 | 854 |
| marketing | 15 | 805 |
| paid-media | 7 | 478 |
| product | 5 | 267 |
| project-management | 6 | 357 |
| sales | 8 | 462 |
| spatial-computing | 6 | 162 |
| specialized | 37 | 2051 |
| strategy | 0 | 0 |
| support | 6 | 361 |
| testing | 8 | 331 |
| **skills/** | 24 | 3666 |
|----------|--------|----------------|
| **TOTAL** | **187** | **12093** |

**Total agents: 163 | Skills: 24 | Estimated routing tokens: ~12K**

## Picking a Scoped Install

If your per-turn token budget is constrained, use `-Divisions` in `scripts/install.ps1` to install only the divisions you need. Three pre-built scoped variants in the [v1.3.0 release](https://github.com/daehounan/agency-agents-fork/releases/tag/v1.3.0) minimize routing overhead:

### Option 1: Engineering + Finance (~32 agents, ~2.7K tokens)

```powershell
.\scripts\install.ps1 -Divisions engineering,finance -WithSkills
```

Best for: Backend teams, fintech, infrastructure, platform engineering. Combines the deepest engineering bench (27 agents) with financial domain expertise (5 agents).

### Option 2: Marketing + Paid Media + Sales (~30 agents, ~1.7K tokens)

```powershell
.\scripts\install.ps1 -Divisions marketing,paid-media,sales -WithSkills
```

Best for: Go-to-market teams, demand generation, performance marketing. Unified demand stack from campaign strategy through sales enablement.

### Option 3: Game Development (~20 agents, ~0.9K tokens)

```powershell
.\scripts\install.ps1 -Division game-development -WithSkills
```

Best for: Game studios, XR experiences, real-time 3D. Specialized stack for Unity, Unreal, Godot, Blender, and Roblox with cross-engine coordinators.

### Full Install (~163 agents, ~12K tokens)

```powershell
.\scripts\install.ps1 -WithSkills
```

Best for: Multi-disciplinary teams, agency-style work, product-to-execution workflows. No token trade-off if your context window budget allows.

## Estimating Real Per-Turn Cost

Each turn loads:
- Routing descriptions: ~12K tokens (full install) or your scoped subset
- Per-invoked agent: ~0.5–2K tokens (body content, loaded on-demand)
- Per-invoked skill: ~1–3K tokens (body content, loaded on-demand)

If you invoke 2–3 agents per turn, expect ~15–20K total tokens. Scoped installs reduce baseline routing to 0.9–2.7K, freeing that budget for agent bodies.

---

**Last updated**: 2026-05-26 | **Script**: `scripts/estimate-tokens.ps1` | **Method**: Char-count heuristic (~4 chars/token)
