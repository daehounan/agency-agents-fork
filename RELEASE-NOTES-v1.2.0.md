# agency-agents-fork v1.2.0

First tagged release. The repo has been stabilizing since fork on 2026-05-16; v1.2.0 marks the point where it became installable as both a user-level config bundle **and** a Claude Code plugin per the official spec at [code.claude.com/docs/en/plugins](https://code.claude.com/docs/en/plugins).

**163 specialist agent personas** across 14 divisions + **24 routing skills** + **16 NEXUS strategy playbooks** + **2 hooks** + ecosystem-wide skill duplicates audit.

## What's in this release

### Plugin-loader conformance (new)

```powershell
.\scripts\build-plugin.ps1                                # full 163-agent build
.\scripts\build-plugin.ps1 -Divisions engineering,finance # 32-agent scoped build
claude --plugin-dir .\dist\plugin                         # test locally
```

The `build-plugin.ps1` script generates a spec-conformant layout:
- `dist/plugin/agents/` — all selected agents flattened into a single directory
- `dist/plugin/skills/<name>/SKILL.md` — 24 routing skills
- `dist/plugin/hooks/hooks.json` — declares `UserPromptSubmit` + `PreToolUse:Skill` matchers
- `dist/plugin/.claude-plugin/plugin.json` — clean manifest (metadata only, no file lists)

Verified by GitHub Actions (`Build Plugin` workflow) on every push:
- 163 agents present, 24 skills present, both manifests parse
- `-Divisions finance,engineering` produces exactly 32 agents
- `-Divisions bogus` is correctly rejected with a clear error

### Scoped builds (new)

The full 163-agent bundle's agent metadata totals about 22k tokens at Claude's runtime tally — above the 15k recommended budget for plugin-supplied descriptions. Every turn pays that overhead.

The `-Divisions` parameter lets you build a focused subset. Pre-built samples are attached to this release:

| Asset | Agents | Token estimate (description fields) | Use case |
|---|---|---|---|
| `agency-agents-fork-v1.2.0-full.zip` | 163 | ~8.4k (Claude reports ~22k cumulative) | Full collection |
| `agency-agents-fork-v1.2.0-engineering-finance.zip` | 32 | ~1.7k | Software + financial workflows |
| `agency-agents-fork-v1.2.0-marketing-paid-media-sales.zip` | 30 | ~1.7k | Marketing / sales ops |
| `agency-agents-fork-v1.2.0-game-development.zip` | 20 | ~0.8k | Unity / Unreal / Godot / Roblox / Blender |

Install a release asset by URL:

```powershell
claude --plugin-url https://github.com/daehounan/agency-agents-fork/releases/download/v1.2.0/agency-agents-fork-v1.2.0-game-development.zip
```

Or build your own subset locally with any combination of: `academic, design, engineering, finance, game-development, marketing, paid-media, product, project-management, sales, spatial-computing, specialized, support, testing`.

### Cross-reference audit (new)

`scripts/audit-agent-refs.ps1` parses every backticked slug reference in every `skills/*/SKILL.md` and verifies it resolves to a real agent file, a real skill name, a namespaced external skill (e.g. `ecc:foo`), or an entry in `scripts/external-skill-refs.txt`. The current state: **0 orphans across 180 backticked references**.

The audit caught 30+ broken refs during initial development (mostly missing division prefixes like `financial-analyst` → `finance-financial-analyst`, and double-hyphen artifacts from a slugification bug). All fixed.

Runs on every push as a `Lint Skills` workflow job.

### Hook stack

Two hooks ship with the plugin, both verified end-to-end with synthetic Claude Code stdin:

| Hook | Trigger | Purpose | Verification |
|---|---|---|---|
| `suggest-agents.ps1` | `UserPromptSubmit` | High-confidence regex match → suggests the right routing skill | Korean / Japanese / unrelated prompts produce expected output |
| `log-skill-fired.ps1` | `PreToolUse:Skill` | Append JSONL entry (ts, skill, session, args-present-flag) to `~/.claude/agency-agents-fork-skill-firings.jsonl` | 3 synthetic firings → 3 valid JSON entries; malformed input → silent + exit 0 |

Both hooks are silent on error, never block tool execution.

### Other infrastructure

- **`SECURITY.md`** — vulnerability reporting policy, scope, hardening already in place (settings.json backup, silent-on-error hooks, zero outbound network calls)
- **CI workflows** — `Lint Skills` (24 skills + 0 orphans) and `Build Plugin` (asserts 163/24, validates JSON, tests `-Divisions` parameter, uploads artifacts for 30-day retention)
- **`scripts/install-hooks-in-settings.ps1`** — idempotent registration of both hooks into `~/.claude/settings.json` with timestamped backup and JSON-validation-with-rollback
- **`docs/skill-ecosystem-duplicates.md`** — audit of ~500 skills across 20 namespaces, preference clusters for cross-namespace routing
- **`docs/SUBMISSIONS.md`** — pre-drafted submission text for `travisvn/awesome-claude-skills` (PR-based) and `hesreallyhim/awesome-claude-code` (web-form-based)

## Accuracy corrections vs upstream

The fork's README and plugin manifest both originally claimed "179 specialist agents." Audit showed:

| Field | Claimed | Actual | Note |
|---|---|---|---|
| Total `.md` files | 179 | 179 | ✓ |
| Files with YAML frontmatter (real personas) | 179 | **163** | -16 |
| `strategy/` files counted as agents | 16 | **0** | These are NEXUS playbook docs, no frontmatter |
| `specialized/` agents | 36 | **37** | -1 |

The release uses **163** consistently.

## What changed vs upstream `msitarzewski/agency-agents`

| Change | Detail |
|---|---|
| China-market agents removed | 22 files dropped (Baidu, WeChat, Douyin, Bilibili, Weibo, Xiaohongshu, etc.) |
| Japanese Business Navigator added | New 216-line agent: 稟議 / 根回し / KY / 飲み会 / 報連相 / hou-ren-sou |
| Korean Business Navigator extended | 품의 / nunchi / KakaoTalk / 회식 / 결재라인 |
| 24 routing skills | Auto-invoke skills that delegate to the right specialist; consolidated to avoid duplicates with existing `ecc:*`, `engineering:*`, `design:*` skill namespaces |
| Ecosystem duplicates audit | Maps ~500 skills across the wider Claude Code ecosystem into preference clusters |
| Windows PowerShell tooling | `install.ps1` / `build-plugin.ps1` / `convert.ps1` / `migrate-ecc.ps1` replace upstream bash scripts |

Upstream MIT license preserved.

## Install

### As a user-level config bundle (no namespacing)

```powershell
git clone https://github.com/daehounan/agency-agents-fork
cd agency-agents-fork
pwsh scripts/install.ps1 -WithSkills              # agents + skills
pwsh scripts/install.ps1 -WithSkills -WithHooks   # + hooks
```

Agents land in `~/.claude/agents/`, skills in `~/.claude/skills/`. Same names you see in the source.

### As a Claude Code plugin (namespaced, recommended for distribution)

```powershell
git clone https://github.com/daehounan/agency-agents-fork
cd agency-agents-fork
pwsh scripts/build-plugin.ps1
claude --plugin-dir .\dist\plugin
```

Skills become `/agency-agents-fork:korean-business`, `/agency-agents-fork:japanese-business`, etc.

For scoped subsets, see the Scoped builds section above or use the pre-built zips attached to this release.

## Security

Zero outbound network calls. Hooks silent on error. Does NOT require `--dangerously-skip-permissions`. See [`SECURITY.md`](https://github.com/daehounan/agency-agents-fork/blob/master/SECURITY.md) for the vulnerability reporting flow.

## Verification

| Check | Result |
|---|---|
| `Lint Skills` CI | ✅ 24/24 skills, 0 errors, 0 warnings |
| `audit-agent-refs` CI | ✅ 0 orphans across 180 backticked references |
| `Build Plugin` CI | ✅ 163 agents, 24 skills, both manifests parse |
| `-Divisions finance,engineering` test | ✅ 32 agents, manifest name correct |
| `-Divisions bogus` rejection | ✅ throws `Unknown division(s)` |
| Hook synthetic-stdin tests | ✅ Korean / Japanese / silent / malformed all handled correctly |
| Filename collision check | ✅ 0 collisions across 163 agents — flat `agents/` is lossless |

## Acknowledgments

Built on [`msitarzewski/agency-agents`](https://github.com/msitarzewski/agency-agents) (MIT). All upstream credit preserved in `LICENSE`. Korean / Japanese Business Navigators, ecosystem duplicates audit, plugin build, hooks, scoped builds, and Windows tooling are net-new in this fork.
