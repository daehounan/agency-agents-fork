# Security Policy

## Scope

This repository ships **agent personas (Markdown)**, **routing skills (Markdown)**, **PowerShell installation scripts**, and **PowerShell hook scripts**. It does not run as a long-lived service, hold credentials, or transit network traffic on its own.

Realistic security concerns therefore fall into a small set of categories:

1. **PowerShell script execution** — `scripts/*.ps1` and `hooks/*.ps1` run on the user's machine as their user account. A malicious change could read files, modify `~/.claude/settings.json`, or run arbitrary commands.
2. **Settings.json corruption** — `scripts/install-hooks-in-settings.ps1` modifies `~/.claude/settings.json`. A bug here could break a user's Claude Code configuration. Mitigation in place: pre-write backup (`.bak-<timestamp>`), JSON validation pre/post, atomic write, rollback on failure.
3. **Hook prompt injection** — `hooks/suggest-agents.ps1` reads stdin (the user's prompt) and emits text the assistant sees. A hostile pattern in stdin content cannot escalate beyond emitting hint text; the hook never executes input as code.
4. **Telemetry log leakage** — `hooks/log-skill-fired.ps1` writes to `~/.claude/agency-agents-fork-skill-firings.jsonl`. It records: timestamp, skill name, session id, whether args were present. **It does not record prompt content or args.**
5. **Agent definition contents** — Agent `.md` files are personas read by Claude as system context. They cannot directly execute anything; they shape behavior. A malicious persona could attempt prompt-injection-style manipulation of the assistant.

## Reporting a vulnerability

If you find a security issue, please **do not open a public GitHub issue** for high-severity findings. Instead:

1. Email the maintainer at the address listed in this repository's `git log` author field, or
2. Open a [private security advisory](https://github.com/daehounan/agency-agents-fork/security/advisories/new) on GitHub.

Include:
- The affected file (path + line/commit if possible)
- The category from the list above (or "other" with explanation)
- A minimal reproduction (input that triggers it, observed behavior, expected behavior)
- Your assessment of severity and any suggested fix

You should expect an acknowledgment within ~7 days. Coordinated disclosure timelines depend on severity:

| Severity | Target fix window |
|---|---|
| Arbitrary code execution from default install | 7 days |
| Settings corruption or destructive write | 14 days |
| Telemetry leakage of prompt/args content | 14 days |
| Persona that meaningfully misleads downstream tools | 30 days |
| Documentation-only / hardening request | best effort |

## What is NOT in scope

- Bugs in Claude Code itself, in MCP servers, or in upstream Anthropic skills — report those to the appropriate vendor.
- General "this persona could give bad advice" feedback — open a normal GitHub issue with the `bug_report` template.
- Performance or quality-of-output issues with specific agents — same, normal issue.
- Behaviors of the upstream [msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents) repo we forked from — report to upstream.

## Supported versions

Only `master` is actively maintained. There are no version tags; the rolling head is the supported version. Pinning is supported by commit SHA only.

## Hardening already in place

- **Hooks are silent on error.** Hook scripts use `try/catch` with `exit 0` so a malformed payload or write failure never blocks tool execution.
- **Installation is idempotent.** Re-running `install.ps1` does not corrupt prior state. Re-running `install-hooks-in-settings.ps1` detects existing hook entries and skips.
- **`.bak` files on settings modification.** Every run that mutates `~/.claude/settings.json` writes a timestamped backup first; failure to write the backup aborts the run.
- **No outbound network.** None of the scripts in this repo call out to remote URLs. The only network operation in the user's workflow is `git pull` / `git push` against their own remote.
- **CI on every push and PR.** `Lint Skills` workflow runs `scripts/lint-skills.ps1` on `ubuntu-latest` with `pwsh`. CI failure blocks merge expectations.
- **Cross-reference audit available.** `scripts/audit-agent-refs.ps1` verifies every agent slug mentioned in routing skills resolves to a real file — catches typos and stale references before they ship.

## License note

This repository is MIT-licensed (preserved from upstream). The license disclaims warranty. Security best-effort is provided by maintainers in good faith, not as a contractual obligation.
