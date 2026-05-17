# Contributing to agency-agents-fork

Thanks for your interest. This is a curated personal fork of
[msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents).
Most changes worth shipping fall into one of these buckets:

- **New routing skills** that map high-confidence prompts to the right agent
- **Bug fixes** in `install.ps1`, `convert.ps1`, `migrate-ecc.ps1`, `lint-skills.ps1`, or `hooks/`
- **Documentation** improvements (especially `docs/ecc-overlap.md` and `docs/skill-ecosystem-duplicates.md`)
- **Upstream sync** changes

We do **not** accept PRs that:

- Re-add the China-market agents — intentional curation, see [README §What changed vs upstream](README.md#what-changed-vs-upstream)
- Add bulk agents from other sources without a routing or integration plan

## Setup

Windows-first. Cross-platform contributions are welcome but currently unverified.

```powershell
git clone https://github.com/daehounan/agency-agents-fork
cd agency-agents-fork
.\scripts\install.ps1 -WithSkills -WithHooks   # full install: agents + skills + hooks
.\scripts\install.ps1 -DryRun -WithHooks       # preview without writing anything
```

`Get-Help .\scripts\install.ps1 -Full` lists every flag with examples.

## Adding a new routing skill

1. Create `skills/<your-skill-name>/SKILL.md` with YAML frontmatter:
   - `name: <your-skill-name>` (must match the directory name)
   - `description: <80–800 chars>` — include explicit "Use when ..." or "Triggers on ..." phrasing
2. Body explains the routing matrix — typically a table mapping user signals to target agents or skills.
3. Run `.\scripts\lint-skills.ps1 -Strict` locally — must finish with `Errors: 0` and `Warnings: 0`.
4. Open a PR. CI runs the same `-Strict` lint and will block merge on any violation.

## Lint requirements

Every `skills/*/SKILL.md` file must satisfy:

| Rule | Why |
|---|---|
| `name` field matches the directory name | Tooling assumption |
| `description` is 80–800 characters | Below 80 → won't trigger reliably; above 800 → wastes system tokens |
| `description` includes "Use when" or "Triggers on" | Required for the routing prompt to fire |
| Body is at least 3 lines | A one-liner skill is useless |
| File size under 8000 bytes | Anything larger probably wants to be split |

## Commit messages

Conventional commits, lowercase scope in parens. Examples from this repo:

- `feat(skills): add legal-tech routing skill`
- `fix(install): handle missing skills/ directory`
- `docs(readme): document -WithHooks flag`
- `ci(lint): enforce -Strict on every PR`

Types: `feat` `fix` `docs` `refactor` `test` `chore` `ci` `perf`.

## Pull request process

1. Fork, then branch (`feat/<short-desc>` or `fix/<short-desc>`)
2. Implement + ensure `.\scripts\lint-skills.ps1 -Strict` passes
3. Open PR using the template — CI will validate
4. Maintainer review

## Questions

Open an issue using the Bug report or Feature request template. The Discussions
tab is intentionally off; we use issues for everything.
