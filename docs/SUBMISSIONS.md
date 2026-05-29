# External catalog submissions

Pre-drafted submission text and per-catalog process notes for getting `agency-agents-fork` listed in community awesome-lists. Each section is independent — pick which to file based on your appetite for review-queue overhead.

## Status

| Target | Method | Process | Status |
|---|---|---|---|
| **travisvn/awesome-claude-skills** (12.7k★) | PR | Fork → branch → edit README → PR | **PR #746 OPEN** — awaiting maintainer review |
| **hesreallyhim/awesome-claude-code** (44.5k★) | Web form (no PRs accepted) | Issue form → bot validates → maintainer reviews | **Issue #1868 closed "not planned"** — 14-day account cooldown active until ~2026-06-04 |
| **ComposioHQ/awesome-claude-skills** (61.1k★) | PR | Fork → 1-line README edit linking to external repo (validate workflow rejects new folders) | **PR #894 OPEN** (2026-05-21), CI green ✓, `ready-to-merge` label applied 2026-05-22 — awaiting maintainer queue (stuck 5+ days) |
| **VoltAgent/awesome-claude-code-subagents** (20.3k★) | PR | Fork → per-agent .md + category README + plugin.json + marketplace.json → PR | **PR #262 CLOSED silently** by @necatiozmen on 2026-05-25 (no comments, no review). Pattern: too-large PR or off-topic for dev-focused catalog. Do not retry. |
| **BehiSecc/awesome-claude-skills** (9.2k★) | PR | Fork → 1-line README edit (Collections section, append at bottom) | **PR #322 OPEN** (2026-05-27) — maintainer dormant since 2026-04-01, queue depth 10+, low expectation but zero risk |
| **webfuse-com/awesome-claude** (1.5k★) | PR | Fork → 1-line README edit (⭐ Community Curated Lists section, append at bottom) | **PR #243 OPEN** (2026-05-27) — active maintainer (last merge 2026-05-15), 1-7 day expected response |
| ComposioHQ/awesome-claude-plugins (1.7k★) | Hosts plugin source directly | Different pattern (full source copy) | Not a fit |
| rohitg00/awesome-claude-code-toolkit | Hosts toolkit components | Different pattern | Not a fit |
| **Anthropic Marketplace** (agency-agents-fork) | Web form at claude.ai/settings/plugins/submit | Web only, requires login. v1.3.0 plugin-loader-conformant. | **Submitted 2026-05-28** — "Plugin submitted for review" confirmation received; awaiting review team |
| **Anthropic Marketplace** (k-jp-business-navigators) | Web form at claude.ai/settings/plugins/submit | Separate submission for the standalone K+J spin-out. v1.0.0 release. | **Submitted 2026-05-29** — "Plugin submitted for review" confirmation received; awaiting review team. Distinct audience (Korea/Japan business pros), much smaller (~374 routing tokens vs full bundle's 8,400). |

---

## 1. travisvn/awesome-claude-skills (PR-based) — RECOMMENDED first move

**Why this list first**
- 12,621 stars, active, **PRs accepted directly** (no review queue)
- Has a perfect "Community Skills → Collections & Libraries" subsection that matches what we are
- Currently only 2 entries there (`obra/superpowers`, `obra/superpowers-lab`) — easy to find

**Insertion target**: [README.md line 110](https://github.com/travisvn/awesome-claude-skills/blob/main/README.md#L99-L111), at the end of the "Collections & Libraries" section, before the `### Individual Skills` heading.

**Patch to apply** (add after the `obra/superpowers-lab` entry, before the blank line preceding `### Individual Skills`):

```markdown
- **[agency-agents-fork](https://github.com/daehounan/agency-agents-fork)** - 163 specialist agent personas + 24 routing skills bundled as a user-level Claude Code config, fork of `msitarzewski/agency-agents` with China-market agents excluded and Korean / Japanese Business Navigators added
  - Routing skills include `korean-business`, `japanese-business`, `game-development-routing` (Unity / Unreal / Godot / Roblox / Blender), `xr-spatial-routing` (visionOS / WebXR), `paid-media-routing`, `sales-methodology-routing`, plus 18 more
  - Ships `skill-routing-arbitrator` meta-skill that disambiguates across ~500 skills in the wider Claude Code ecosystem (`ecc:*`, `anthropic-skills:*`, `engineering:*`, etc.) — see [`docs/skill-ecosystem-duplicates.md`](https://github.com/daehounan/agency-agents-fork/blob/master/docs/skill-ecosystem-duplicates.md)
  - PowerShell installer (`scripts/install.ps1`) targets Windows; optional UserPromptSubmit + PreToolUse hooks for agent-suggestion telemetry, registered idempotently via `install-hooks-in-settings.ps1` with settings backup and rollback
  - Cross-reference audit (`scripts/audit-agent-refs.ps1`) enforced in CI — every backticked agent slug in every SKILL.md resolves to a real agent file (0 orphans)
  - No outbound network calls. No `--dangerously-skip-permissions` required. See [`SECURITY.md`](https://github.com/daehounan/agency-agents-fork/blob/master/SECURITY.md)
  - **One-liner install via [v1.2.0 release](https://github.com/daehounan/agency-agents-fork/releases/tag/v1.2.0)** — pre-built plugin zips attached, no clone or build needed: `claude --plugin-url https://github.com/daehounan/agency-agents-fork/releases/download/v1.2.0/agency-agents-fork-v1.2.0-full.zip` (or pick a scoped subset: `-engineering-finance`, `-marketing-paid-media-sales`, `-game-development`)
  - Alternative installs: clone + `pwsh scripts/install.ps1 -WithSkills` (user-level bundle, no namespacing), or clone + `pwsh scripts/build-plugin.ps1 -Divisions <list>` (custom scope)
```

**PR workflow**
```powershell
gh repo fork travisvn/awesome-claude-skills --clone --remote
cd awesome-claude-skills
git checkout -b add-agency-agents-fork
# Edit README.md — paste the block above after line 110
git add README.md
git commit -m "Add agency-agents-fork to Collections & Libraries"
git push -u origin add-agency-agents-fork
gh pr create --fill
```

**PR description template**:
```
Adds `daehounan/agency-agents-fork` to Community Skills → Collections & Libraries.

Brief: 163 specialist agent personas + 24 routing skills + 16 strategy playbooks. Fork of
msitarzewski/agency-agents with China-market agents removed and Korean + Japanese Business
Navigators added. Includes ecosystem-wide skill duplicates audit (`docs/skill-ecosystem-duplicates.md`)
mapping ~500 skills into preference clusters, and `skill-routing-arbitrator` meta-skill that
disambiguates across the wider Claude Code ecosystem.

Tagged release available: [v1.2.0](https://github.com/daehounan/agency-agents-fork/releases/tag/v1.2.0)
ships 4 pre-built plugin zips (full 163-agent + 3 scoped subsets). Install via one-liner:
`claude --plugin-url <release-asset-url>` — no clone or PowerShell required for users.

Quality / safety checklist (per CONTRIBUTING):
- Non-promotional: MIT-licensed open source, no paid tier, no SaaS dependencies
- Standalone value: works as a user-level config bundle independent of any commercial product
- Social proof: 3 CI workflows green (Lint Skills, audit-agent-refs, Build Plugin), 0 orphans across 180 backticked refs, 24/24 skills lint clean
- No outbound network calls (SECURITY.md scope)
- Installation works without `--dangerously-skip-permissions`
- Tagged v1.2.0 release with SHA256-digested artifacts

Resource is at least one week old: yes (initial commits 2026-05-16, v1.2.0 tagged 2026-05-18).
```

---

## 2. hesreallyhim/awesome-claude-code (web-form only)

**Why this list second**
- 43,984 stars, the largest awesome-list for Claude Code
- **Strict anti-spam policy** — submissions via `gh` CLI / programmatic means are auto-banned. **Must use browser**.
- Curated personally by the maintainer; not every submission is accepted ("the point of an Awesome List is to be selective")
- Maintainer leans against general-purpose marketplaces — frame our entry around the focused differentiators

**Submission URL** (must open in browser, logged in to GitHub):
👉 https://github.com/hesreallyhim/awesome-claude-code/issues/new?template=recommend-resource.yml

**Form fields to fill in**:

| Field | Value |
|---|---|
| Title | `[Resource]: agency-agents-fork` |
| Display Name | `agency-agents-fork` |
| Category | `Agent Skills` |
| Sub-Category | `General` |
| Primary Link | `https://github.com/daehounan/agency-agents-fork` |
| Author Name | `daehounan` |
| Author Link | `https://github.com/daehounan` |
| License | `MIT` |

**Description field** (paste verbatim):
```
A user-level Claude Code config bundle: 163 specialist agent personas + 24 routing skills
+ 16 NEXUS strategy playbooks. Fork of msitarzewski/agency-agents with China-market agents
removed (22 files) and Korean + Japanese Business Navigators added.

Focused differentiators (since the list rightly leans against general marketplaces):

1. Korean Business Navigator and Japanese Business Navigator — 품의/nunchi/회식/카카오톡 and
   稟議/根回し/KY/飲み会/報連相 deal mechanics for foreign professionals. Each ~200 lines,
   no equivalent in any other public collection.

2. skill-routing-arbitrator meta-skill — disambiguates across ~500 skills in the wider
   Claude Code ecosystem (ecc:*, anthropic-skills:*, engineering:*, design:*, etc.). Encodes
   deterministic preferences per cluster (code review, security audit, MCP build, document
   formats, etc.).

3. Ecosystem-wide skill duplicates audit — docs/skill-ecosystem-duplicates.md maps the
   ecosystem into versioned snapshots, legacy shims, cross-namespace duplicates, and hooks.
   Useful for anyone trying to figure out which of several overlapping skills to use.

4. Cross-reference audit in CI — scripts/audit-agent-refs.ps1 verifies every backticked
   agent slug in every SKILL.md resolves to a real file. Currently 0 orphans across 24
   skills, 163 agents. Catches typos and stale refs before they ship.

5. Idempotent hook installer with settings backup and rollback — install-hooks-in-settings.ps1
   modifies ~/.claude/settings.json atomically with pre-write JSON validation, timestamped
   .bak file, and rollback on failure. Avoids the typical "I broke my settings.json" risk.

Security disclosure:
- Zero outbound network calls. Verified — none of the scripts or hooks call out to any URL.
- Does NOT require --dangerously-skip-permissions.
- Hooks are silent on error (try/catch with exit 0) so they never block tool execution.
- Telemetry hook records only timestamp + skill name + session id + args-present-boolean —
  no prompt content, no arg values.
- SECURITY.md documents the vulnerability reporting process and supported severity tiers.

Installation:

  Easiest — one-liner via v1.2.0 release (no clone, no PowerShell):
    claude --plugin-url https://github.com/daehounan/agency-agents-fork/releases/download/v1.2.0/agency-agents-fork-v1.2.0-full.zip

  Or pick a scoped subset (smaller token footprint):
    -engineering-finance      (32 agents,  205 KB,  ~1.7k description tokens)
    -marketing-paid-media-sales (30 agents, 161 KB, ~1.7k tokens)
    -game-development         (20 agents,  144 KB, ~0.8k tokens)
  Full bundle is 163 agents, 873 KB, ~8.4k description tokens (~22k at Claude runtime).

  Or clone-and-install (Windows / PowerShell 7+):
    git clone https://github.com/daehounan/agency-agents-fork
    cd agency-agents-fork
    pwsh scripts/install.ps1 -WithSkills        # user-level bundle, no namespacing
    pwsh scripts/install.ps1 -WithSkills -WithHooks   # + hooks

  Or clone-and-build a custom scope:
    pwsh scripts/build-plugin.ps1 -Divisions engineering,finance,marketing
    claude --plugin-dir ./dist/plugin

Uninstallation:
  For release-URL installs: `claude plugin disable agency-agents-fork`
  For user-level bundle: remove ~/.claude/agents/<file> and ~/.claude/skills/<dir>
  Hooks: remove the entries from ~/.claude/settings.json (a .bak file from install
  time is at ~/.claude/settings.json.bak-<timestamp> if you want to restore).

Validation: three CI workflows on every push to master — Lint Skills (24/24 pass),
audit-agent-refs (0 orphans across 180 backticked refs), and Build Plugin (asserts
163 agents + 24 skills + 2 hooks produced cleanly). All currently green; badges in
README link to each workflow. v1.2.0 release ships 4 pre-built plugin zips with
SHA256-digested artifacts.

Try it: `claude --plugin-url <release-url-above>` — Claude Code v2.1.143+ will load
the plugin, surface its 163 agents and 24 skills in `/plugins`, and (per v2.1.143
release notes) display the projected per-turn token cost.

This is a collection, not a single focused tool. The maintainer's CONTRIBUTING note
about preferring focused resources is acknowledged — if too broad, please consider
listing just the Korean/Japanese Business Navigator pair, or just the
skill-routing-arbitrator meta-skill, both of which have no public equivalent I'm
aware of.
```

**Other form fields**:
- Resource age: initial commits 2026-05-16, v1.2.0 tagged 2026-05-18, well past the one-week minimum
- Network calls: None. The only network operation in normal use is `claude --plugin-url <github-releases-url>` which is GitHub-hosted, not a private endpoint
- Bypass-permissions: Not required
- Auto-update / network install: None. Plugin installs are pinned to the v1.2.0 release SHAs
- Tagged release with artifacts: yes — https://github.com/daehounan/agency-agents-fork/releases/tag/v1.2.0 (4 zips, SHA256-digested)
- Already listed in travisvn/awesome-claude-skills (PR #746) — disclose this if the form asks
- Demo: README badges (3 green CI workflows) + `scripts/audit-agent-refs.ps1` output (0 orphans) + the release page itself as proof of the build pipeline working

### Outcome (2026-05-21) — closed, account in 14-day cooldown

**Issue #1868** — closed as "not planned" within minutes by `hesreallyhim` personally. Maintainer comment:

> A cooldown period is currently in effect for your account. Submitting during an active cooldown extends the restriction. Please wait at least **14 days** before opening any more submissions. Please review the [CONTRIBUTING guidelines](https://github.com/hesreallyhim/awesome-claude-code/blob/main/CONTRIBUTING.md) and pinned issues before your next submission.

Key facts:
- Form was filled correctly — all 5 Recommendation Checklist boxes ticked, all required fields present, Specific Prompt example given (Unreal multiplayer routing demo).
- Account was **already in a cooldown** before this submission. Root cause unknown — possibly tied to an earlier submission on the account, or pattern-based screening. Submitting during that cooldown *extended* it to a fresh 14 days.
- Labels stuck on the closed issue: `pending-validation`, `resource-submission`. Validation bot never got to run — the cooldown gate is **upstream** of bot validation.

**14-day hold rules** (do NOT violate — repeat offenses extend the cooldown further and can lead to permanent ban):
1. No new issue / PR / comment on `hesreallyhim/awesome-claude-code` until **2026-06-04** at earliest.
2. Do not ask "why was I in cooldown" — that itself counts as a submission.
3. Do not reopen issue #1868.
4. Do not create a fresh GitHub account to retry — the maintainer screens for that pattern.

**During the 14-day window**:
- Read [CONTRIBUTING.md](https://github.com/hesreallyhim/awesome-claude-code/blob/main/CONTRIBUTING.md) end-to-end. Look for explicit "we don't accept X" patterns (broad collections / forks / agent bundles).
- Read all pinned issues in the repo. Maintainer often posts category-level reject notices there.
- If a category-level reject is documented (e.g. "no agent collections, only individual skills"), retire this submission attempt entirely.

**Retry decision tree** (only after 2026-06-04):
- CONTRIBUTING.md explicitly rejects agent collections → **don't retry**, redirect to other channels.
- CONTRIBUTING.md flags fixable issues (length, format, focus) → fix repo first, then retry with narrower framing (e.g. submit only `korean-business` + `japanese-business` as a focused "regional business skill pair" instead of the full 163-agent bundle).
- Cooldown reason remains unclear → don't retry. Asymmetric downside (further ban / permanent block) vs. upside (one list entry).

**Channels unaffected by the hesreallyhim block**: travisvn PR #746 still OPEN (mergeStateStatus=CLEAN), GitHub Release v1.2.0 live, Reddit / dev.to / X / Hacker News / Discord / other awesome-claude-* lists all fully available.

---

## 3. After submission

For travisvn (PR-based):
- Watch the PR for review comments. If they ask for shorter / different framing, the entry can be trimmed to the headline + 2 bullets.

For hesreallyhim (issue-based):
- The validation bot will comment on the issue with format check results. Fix any format errors quickly.
- Maintainer may comment with questions. Answer factually with links — do not push back on subjective preference.
- The bot creates a PR if accepted. You don't open the PR yourself.

If accepted at either list, add the corresponding "Mentioned in Awesome ..." badge to the top of `README.md`:

```markdown
[![Mentioned in Awesome Claude Code](https://awesome.re/mentioned-badge.svg)](https://github.com/hesreallyhim/awesome-claude-code)
```

## 4. Things NOT to do

- Do not open a PR on `hesreallyhim/awesome-claude-code` — they explicitly ban this.
- Do not submit via `gh issue create` on that repo — same ban.
- Submitting to both travisvn and hesreallyhim in the same week is fine — they're independent. Do NOT submit to a third list at the same time; let these two play out first. (travisvn PR #746 is already open at the time of writing.)
- **Do not re-submit to hesreallyhim until 2026-06-04 at earliest.** Issue #1868 was closed as "not planned" and the account is in a 14-day cooldown — any new submission, comment, or reopen attempt extends the restriction (see Section 2 → Outcome). Channel is dead for at least two weeks.
- Do not bump the version in `.claude-plugin/plugin.json` purely for submission churn. Bump only on real changes.

---

## 5. Other awesome-list targets (scouted 2026-05-21)

After the hesreallyhim block, scouted the remaining awesome-claude-* ecosystem via `gh search repos "awesome claude" --limit 30`. 13 active curated lists found. Triaged by fit + maintainer activity + submission friction:

### Tier 1 — recommended next moves

| Repo | ★ | Pattern | Submission cost | Verdict |
|---|---|---|---|---|
| **ComposioHQ/awesome-claude-skills** | 61.1k | PR — folder + SKILL.md + 1 README line | Low | **Submit `agency-agents-fork` as a single bundled entry under "Development & Code Tools" (great_cto precedent)** |
| **VoltAgent/awesome-claude-code-subagents** | 20.3k | PR — per-agent .md + 3 file updates + 2 version bumps | Medium | **Submit Korean + Japanese Business Navigator as two separate PRs to `categories/08-business-product/`** |

#### 5a. ComposioHQ/awesome-claude-skills (61.1k★, created 2025-10-17)

**Why prioritize**: largest reach, daily merge cadence, no anti-spam friction, [`great_cto`](https://github.com/avelikiy/great_cto) entry sets a perfect precedent — also a Claude Code plugin with 7 subagents, also a multi-agent SDLC orchestrator. Our bundle fits the same shelf.

**Legitimacy check passed**: 6,663 forks + 409 watchers + steady stream of external-contributor PRs merged daily (verified 2026-05-22 via `gh pr list`). Not a star-bombed shell repo.

**Submission target**: README "Skills → Development & Code Tools" subsection, alphabetical order.

**Required PR contents** (CONTRIBUTING.md is outdated — `validate` workflow is the source of truth):
1. Fork → branch `add-agency-agents-fork`
2. **README.md change ONLY** — `validate` workflow checks `if (f !== 'README.md') fail('disallowed file changed: ...')`. Do NOT add a new SKILL.md folder despite what CONTRIBUTING.md says. (CONTRIBUTING is documentation drift; the workflow rejects folder adds from external contributors. Internal contributions like `changelog-generator/`, `competitive-ads-extractor/`, etc. were added by maintainers bypassing the workflow.)
3. Add one README line under "Development & Code Tools" (alphabetical), **linking to an external `https://github.com/...` URL** (relative `./folder/` links fail the workflow's "must link to external URL" check):
   ```markdown
   - [agency-agents-fork](https://github.com/daehounan/agency-agents-fork) - Claude Code plugin: 163 specialist agent personas + 24 routing skills ... *By [@daehounan](https://github.com/daehounan)*
   ```
4. **Additional `validate` workflow constraints to respect**:
   - All edits must sit within the `## Skills` ... `## Getting Started` window
   - URL must be `https://` (not relative or `http`)
   - URL host must NOT end in `composio.dev` or `anthropic.com` (internal hosts blocked)
   - No `crypto|cryptocurrency|web3|blockchain|nft|defi|token|wallet|solana|ethereum|bitcoin` keywords anywhere on the added line
   - Bullet must be alphabetically positioned relative to its immediate neighbors (case-insensitive)
5. PR title: `Add agency-agents-fork skill`
6. PR description: real-world use case (multi-domain agency / consulting projects needing instant access to specialist personas), differentiators vs `great_cto` (broader scope + regional Korean/Japanese coverage), attribution (msitarzewski upstream fork link), proof points (3 green CI workflows, v1.2.0 release).

**Lesson learned 2026-05-21**: First push followed CONTRIBUTING.md literally and added `agency-agents-fork/SKILL.md` folder + relative README link. `validate` workflow failed in 5s. Fix was to remove the folder, change link to `https://github.com/daehounan/agency-agents-fork`, amend commit, force-push. Workflow re-ran and passed in 5s. **Always read the validate.yml workflow before assuming CONTRIBUTING.md is current.**

**Risk profile**: low. No cooldown system observed. Rejection downside ≈ rewritten PR or polite close, not account-wide ban.

#### 5b. VoltAgent/awesome-claude-code-subagents (20.3k★, created 2025-07-30)

**Why prioritize**: 20k★ category match — they literally curate "subagents", which is our primary deliverable. PRs from external contributors merged as recently as 2026-05-20.

**Caveat**: Heavier submission. Per [CONTRIBUTING.md](https://github.com/VoltAgent/awesome-claude-code-subagents/blob/main/CONTRIBUTING.md), each agent needs:
1. New `.md` file under `categories/<N>-<cat>/`
2. Main `README.md` updated (alphabetical link)
3. Category `README.md` updated (Available Subagents + Quick Selection Guide + Tech Stacks)
4. `categories/<cat>/.claude-plugin/plugin.json` version bump
5. `.claude-plugin/marketplace.json` matching version bump

Five file updates per agent. So **do NOT submit all 163** — pick the 1–2 with no public equivalent.

**Submission strategy** — two separate PRs:

- **PR 1**: `Add korean-business-navigator subagent` → `categories/08-business-product/korean-business-navigator.md`
- **PR 2**: `Add japanese-business-navigator subagent` → `categories/08-business-product/japanese-business-navigator.md`

Each `.md` is the existing agent definition from `specialized/specialized-korean-business-navigator.md` and `specialized/specialized-japanese-business-navigator.md`, lightly adapted to VoltAgent's template if needed.

**Risk profile**: low. Heavier lift but high signal — VoltAgent's audience is exactly the people who'd want a Korean/Japanese cultural intelligence subagent.

### Tier 2 — defer, evaluate after Tier 1 lands

| Repo | ★ | Pattern | Notes |
|---|---|---|---|
| BehiSecc/awesome-claude-skills | 9.2k | Curated list | Need to scout PR cadence |
| langgptai/awesome-claude-prompts | 5.1k | Prompts focus | Partial fit (skills route to prompts) |
| ccplugins/awesome-claude-code-plugins | 798 | Plugins specifically | v1.2.0 release fits |
| webfuse-com/awesome-claude | 1.5k | Broad list | Lower priority |
| karanb192/awesome-claude-skills | 340 | "50+ verified" skills | Smaller reach |
| JSONbored/awesome-claude (HeyClaude) | 244 | Marketplace registry | Different distribution model |

### Tier 3 — skip

- **vijaythecoder/awesome-claude-agents** (4.3k★) — last merge 2025-10-19, abandoned
- **VoltAgent/awesome-claude-design** (2.3k★) — design only, not a fit
- **rohitg00/awesome-claude-design** (616★) — design only
- **josix/awesome-claude-md** (323★) — claude.md files only
- **milisp/awesome-claude-dxt** (173★) — desktop extensions only
- **win4r/Awesome-Claude-MCP-Servers** (84★) — MCP servers only
- **quemsah/awesome-claude-plugins** (735★) — automated metrics, not human-curated
- **Eyadkelleh/awesome-claude-skills-security** (262★) — security tooling only
- **LimHyungTae/awesome-claudecode-paper-proofreading** (348★) — proofreading only

### Pacing rules (lessons from hesreallyhim)

1. **Open at most one new submission per week.** Watch for cooldown signals before opening a second on the same repo.
2. **Read CONTRIBUTING.md end-to-end before any PR.** Both ComposioHQ and VoltAgent have explicit rules we just verified.
3. **Asymmetric downside**: a rejected PR on a reasonable awesome-list = polite close. A rejected submission on a strict-policy list (hesreallyhim) = account-wide cooldown extension. **Prefer Tier 1 PR-based lists.**
4. **Do NOT use `gh` CLI on hesreallyhim** even for read-only operations from this account — pattern detection may flag and extend the cooldown.

---

## 6. Anthropic Marketplace (official, in-app)

**Why now (2026-05-28)**
- v1.3.0 release ships a plugin-loader-conformant bundle (`.claude-plugin/plugin.json`, flat `agents/`, `hooks/hooks.json`)
- 4 zip variants attached (full + 3 scoped) with SHA256 digests in release notes
- 3 CI workflows green; 0 audit orphans; 24/24 skills lint clean
- Public repo, MIT, no outbound network calls (per `SECURITY.md`)

**Submission URL** (open in browser, logged in to your Anthropic account):
👉 https://claude.ai/settings/plugins/submit

**Pre-filled form values** (copy into whichever fields the form exposes):

| Field | Value |
|---|---|
| Repository URL | `https://github.com/daehounan/agency-agents-fork` |
| Release tag | `v1.3.0` |
| Plugin name | `agency-agents-fork` |
| Author | `daehounan` |
| Homepage | `https://github.com/daehounan/agency-agents-fork/releases/tag/v1.3.0` |
| License | `MIT` |
| Category (if asked) | `Collection` or `Agents` |
| Install command | `claude --plugin-url https://github.com/daehounan/agency-agents-fork/releases/download/v1.3.0/agency-agents-fork-v1.3.0-full.zip` |

**Description field** (paste verbatim, 480 chars):
```
163 specialist agent personas + 24 routing skills + 16 NEXUS strategy playbooks, packaged as a plugin-loader-conformant bundle. Korean & Japanese Business Navigators (品稟議/根回/회식/카카오톡), game-dev across Unity/Unreal/Godot/Roblox/Blender, XR/visionOS, paid-media (Google/Meta/LinkedIn/TikTok), skill-routing-arbitrator meta-skill for disambiguating across ~500 ecosystem skills. Windows-first PowerShell installer + 4 scoped zip variants. Fork of msitarzewski/agency-agents with China-market agents excluded.
```

**Differentiators field** (if asked):
```
1. Korean + Japanese Business Navigator agents — 품의/nunchi/회식/카카오톡 and 稟議/根回し/KY/飲み会/報連相 deal mechanics for foreign professionals. No equivalent in any other public Claude Code collection.

2. skill-routing-arbitrator meta-skill — deterministic disambiguation across the ~500-skill ecosystem (ecc:*, anthropic-skills:*, engineering:*, design:*, operations:*). Maps preference per cluster (code review, security audit, MCP build, document generation, build error resolution).

3. Cross-reference audit (scripts/audit-agent-refs.ps1) enforced in CI — every backticked agent slug in every SKILL.md resolves to a real agent file. 0 orphans across 180 references.

4. Token budget transparency — docs/TOKEN-BUDGET.md plus scripts/estimate-tokens.ps1 surface per-division token cost. 3 scoped zip variants (engineering+finance, game-development, marketing+paid-media+sales) ship pre-built so users can dodge the 15k-token routing budget.
```

**Submission workflow**
1. Open https://claude.ai/settings/plugins/submit in your browser (must be logged in)
2. Paste the values above into matching form fields
3. Submit and capture the confirmation URL / submission ID
4. Update the Status table row + log outcome below

**Post-submission**
- Maintainer queue depth unknown; first-party marketplaces typically respond within 1–7 days
- If approved → update README badge to "Listed on Anthropic Marketplace"
- If rejected → log reason here, no cooldown risk (this is a first-party catalog, not a personal awesome-list)

### Submission outcome log

**2026-05-28 13:30 KST** — Submitted via https://claude.ai/settings/plugins/submit.

Form values entered:
- Link to plugin: `https://github.com/daehounan/agency-agents-fork`
- Plugin homepage: `https://github.com/daehounan/agency-agents-fork/releases/tag/v1.3.0`
- Plugin name: `agency-agents-fork`
- Description: 480-char copy (per Section 6 above)
- Example use cases: 5 examples covering Korean BN, multi-platform routing, Japanese BN, cross-marketplace disambiguation, scoped install
- Platforms: ☑ Claude Code only (Cowork unchecked — not tested)
- License: MIT
- Privacy policy URL: (blank — no PII collection per SECURITY.md)
- Submitter email: an.daehoun@gmail.com

Confirmation screen: "Plugin submitted for review. Your plugin submission has been received. The review team will evaluate it and may reach out for additional information."

**Next action**: passive — await Anthropic review team. Check `claude.ai/settings/plugins` > "View submissions" weekly for status changes.

**Anti-spam notes** (none currently known for this catalog, but apply hesreallyhim lessons defensively)
- Do not crosspost the submission anywhere else within 24h
- If the form asks for "previous distribution attempts", honestly list the 4 open awesome-list PRs (ComposioHQ #894, BehiSecc #322, webfuse #243, travisvn #746)
- Do not re-submit if approved; do not re-submit within 14 days if rejected
