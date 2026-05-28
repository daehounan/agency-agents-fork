# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.3.0] - 2026-05-28

Distribution + onboarding release. Bundles ~8 commits since v1.2.0 focused on inbound-traffic conversion (README polish, examples, token budget transparency) and external contributor enablement (CHANGELOG, CONTRIBUTING, submission tracking).

### Added
- `examples/` folder backported from upstream — 5 multi-agent workflow walkthroughs (`workflow-startup-mvp`, `workflow-landing-page`, `workflow-book-chapter`, `workflow-with-memory`, `nexus-spatial-discovery`) + README
- Tagline and one-line install above-the-fold in README
- `CHANGELOG.md` (this file) — version history per Keep a Changelog
- `CONTRIBUTING.md` — external-contributor guide (PR pattern, agent/skill addition, China-exclusion policy)
- `scripts/estimate-tokens.ps1` + `docs/TOKEN-BUDGET.md` — static token-cost estimator + budget table per division
- Repo metadata polish — GitHub description rewritten, homepage set to v1.2.0 release, topics expanded 8 → 20
- `docs/SUBMISSIONS.md` Section 5 — Tier 2 awesome-list submission scout + outcome of hesreallyhim issue #1868
- v1.2.0 release URL surfaced as third install path in README

### Fixed
- README division count: "14 divisions" corrected to "15 divisions"
- Marketplace submission drafts for travisvn and hesreallyhim improved with v1.2.0 release citations
- `install.ps1` `-Divisions` flag parity with `build-plugin.ps1`

## [1.2.0] - 2026-05-18

Initial tagged release. Spans the fork period from 2026-05-15 to 2026-05-18.

### Added
- GitHub Release with 4 pre-built plugin ZIP archives (full scope + 3 scoped subsets)
- `scripts/build-plugin.ps1` with `-Divisions` parameter for custom-scope plugin builds
- `scripts/install.ps1` with `-Divisions` flag for scoped user-level installations
- `scripts/show-skill-stats.ps1` for skill-firing telemetry analysis
- Claude Code plugin packaging conforming to plugin-loader specification
- 24 routing skills with explicit ecosystem deduplication against `ecc:*` and `anthropic-skills:*` — includes `korean-business`, `japanese-business`, `game-development-routing`, `xr-spatial-routing`, `paid-media-routing`, `sales-methodology-routing`, `skill-routing-arbitrator` (meta-disambiguator across the ~500-skill ecosystem), plus 17 others
- Cross-reference audit infrastructure + GitHub Actions lint workflow for skill validation
- `SECURITY.md` documenting security practices and responsible disclosure
- GitHub Issue templates (`.github/ISSUE_TEMPLATE/` — bug_report, config, feature_request, new_skill)
- `hooks/suggest-agents.ps1` (UserPromptSubmit activation hint) and `hooks/log-skill-fired.ps1` (telemetry capture)
- Comprehensive marketplace submission drafts for broader ecosystem integration
- Accuracy corrections: documented 163 agents + 16 NEXUS strategy playbooks (not 179)

### Fixed
- 30+ broken agent slug references identified and corrected by cross-reference audit
- UTF-8 encoding bug in migrate-ecc.ps1 PowerShell helper
- Absolute home paths removed before public visibility flip
- Plugin build script absolute path printing and working directory clarity in README

### Changed
- Routing skills curated to 24 with explicit non-overlap policy against `ecc:*`, `anthropic-skills:*`, `engineering:*`, `design:*`, and `operations:*` namespaces. Audit captured in `docs/skill-ecosystem-duplicates.md`.

## [1.0.0] - 2026-05-15

Initial fork from [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents).

### Added
- Fork created with China-market agent scope exclusion (deliberate architectural decision)
- Japanese Business Navigator agent (~217 lines): specialized in Japanese business culture patterns
  - Implements 稟議 (ringi/circulation approval)
  - Handles 根回し (nemawashi/groundwork consensus-building)
  - Incorporates KY (空気を読む/reading the room)
  - Accounts for 飲み会 (nominication/drinking culture networking)
  - Applies 報連相 (hokuren-so/report-contact-consult discipline)
- Windows-first, PowerShell 7+ environment target established

### Removed
- 22 China-market agent files deliberately excluded from fork scope:
  - Baidu, WeChat, Feishu, Weibo, Bilibili, Alipay, Douyin platform specialists and localization agents
  - Not a regrettable deletion; architectural scope decision for non-China market positioning

[Unreleased]: https://github.com/daehounan/agency-agents-fork/compare/v1.3.0...HEAD
[1.3.0]: https://github.com/daehounan/agency-agents-fork/releases/tag/v1.3.0
[1.2.0]: https://github.com/daehounan/agency-agents-fork/releases/tag/v1.2.0
[1.0.0]: https://github.com/daehounan/agency-agents-fork/releases/tag/v1.0.0
