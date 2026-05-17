# External catalog submissions

Pre-drafted submission text and per-catalog process notes for getting `agency-agents-fork` listed in community awesome-lists. Each section is independent — pick which to file based on your appetite for review-queue overhead.

## Status

| Target | Method | Process | Status |
|---|---|---|---|
| **travisvn/awesome-claude-skills** (12.6k★) | PR | Fork → branch → edit README → PR | Draft ready below ⬇️ |
| **hesreallyhim/awesome-claude-code** (43.9k★) | Web form (no PRs accepted) | Issue form → bot validates → maintainer reviews | Draft ready below ⬇️ |
| ComposioHQ/awesome-claude-plugins | Hosts plugin source directly | Different pattern (full source copy) | Not a fit |
| rohitg00/awesome-claude-code-toolkit | Hosts toolkit components | Different pattern | Not a fit |
| Official Anthropic marketplace | In-app form at claude.ai/settings/plugins/submit | Web only, requires login | Defer until repo is plugin-loader-conformant |

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
  - Installation: clone the repo, then `pwsh scripts/install.ps1 -WithSkills` (add `-WithHooks` for hook telemetry)
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

Quality / safety checklist (per CONTRIBUTING):
- Non-promotional: MIT-licensed open source, no paid tier, no SaaS dependencies
- Standalone value: works as a user-level config bundle independent of any commercial product
- Social proof: CI lint + cross-reference audit enforced (badges in README), 0 orphans across 24 skills
- No outbound network calls (SECURITY.md scope)
- Installation works without `--dangerously-skip-permissions`

Resource is at least one week old: yes (initial commits 2026-05-16).
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

Installation (Windows / PowerShell 7+):
  git clone https://github.com/daehounan/agency-agents-fork
  cd agency-agents-fork
  pwsh scripts/install.ps1 -WithSkills        # agents + skills
  pwsh scripts/install.ps1 -WithSkills -WithHooks   # + hooks

Uninstallation:
  Remove-Item ~/.claude/agents/<file>           # per agent, or
  Remove-Item ~/.claude/agents -Recurse         # all
  Remove-Item ~/.claude/skills/<dir> -Recurse   # per skill
  Then remove the hooks block from ~/.claude/settings.json (a .bak file from install time
  is at ~/.claude/settings.json.bak-<timestamp> if you want to restore).

Validation: scripts/lint-skills.ps1 and scripts/audit-agent-refs.ps1 both run on every push
in GitHub Actions (Lint Skills badge on the README links to the workflow). Both currently
green. Try it: clone the repo, run pwsh scripts/lint-skills.ps1 and watch all 24 skills pass.

This is a collection, not a single focused tool. The maintainer's CONTRIBUTING note about
preferring focused resources is acknowledged — if too broad, please consider listing just
the Korean/Japanese Business Navigator pair, or just the skill-routing-arbitrator meta-skill,
both of which have no public equivalent that I know of.
```

**Other form fields**:
- Resource age: at least one week (initial commits 2026-05-16, public 2026-05-17, submission 2026-05-17+)
- Network calls: None outside the user's own `git pull`/`git push`
- Bypass-permissions: Not required
- Auto-update / network install: None
- Demo: link to the README badges section (CI green) and `scripts/audit-agent-refs.ps1` output

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
- Do not submit to multiple lists simultaneously expecting them all to land. Start with travisvn (fastest), wait for outcome, then escalate to hesreallyhim if accepted there or to other lists if rejected.
- Do not bump the version in `.claude-plugin/plugin.json` purely for submission churn. Bump only on real changes.
