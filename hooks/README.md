# Hooks

Two hooks ship in this directory. Both are optional and disabled by default. Both fail silent (`exit 0` on any error) so they never block tool execution.

| Hook | Event | Purpose | Output |
|---|---|---|---|
| [`suggest-agents.ps1`](#1-suggest-agentsps1) | `UserPromptSubmit` | Surface a one-line specialist hint when the user's prompt matches high-confidence keyword regex | Stdout text appended to the assistant's context |
| [`log-skill-fired.ps1`](#2-log-skill-firedps1) | `PreToolUse` (matcher: `Skill`) | Record every Skill-tool invocation to a local JSONL log for offline analysis | Append to `~/.claude/agency-agents-fork-skill-firings.jsonl` |

Both are bundled into the plugin build's `hooks/hooks.json` ([see plugin spec](../scripts/build-plugin.ps1)). The `.ps1` files in this directory are the same scripts referenced from there.

---

## Activation (both at once)

Easiest path — registers both hooks in `~/.claude/settings.json` with backup + rollback:

```powershell
.\scripts\install.ps1 -WithHooks
```

Or invoke the dedicated installer directly:

```powershell
.\scripts\install-hooks-in-settings.ps1
```

Idempotent: pre-existing entries are detected and skipped. Writes a timestamped `.bak` copy of `settings.json` before any change; aborts and restores if JSON validation fails post-write.

To disable: re-run with `-Uninstall`, or remove the entries from `settings.json` manually and the corresponding `.bak` will let you restore.

---

## 1. `suggest-agents.ps1`

A `UserPromptSubmit` hook that scans each incoming prompt for high-confidence specialist triggers and outputs a one-line hint to the main Claude assistant.

### Behavior

- **Silent when no match.** Hooks should not be noisy on unrelated prompts.
- **High-confidence patterns only.** Specific Korean / Japanese / XR / game-dev / paid-media regex — common English words don't fire.
- **At most 3 suggestions per prompt.** Avoids overwhelming the assistant.
- **Hints, never commands.** Final delegation decision stays with the main assistant.

### Manual activation (without `install.ps1 -WithHooks`)

Substitute `<fork-clone-path>` with your absolute path:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "command": "pwsh -NoProfile -File <fork-clone-path>/hooks/suggest-agents.ps1",
        "description": "Suggest agency-agents specialists for matching prompts"
      }
    ]
  }
}
```

### Testing the hook

```powershell
'{"prompt":"한국 거래처와 첫 미팅 준비 중인데 회식 자리에서 뭘 주의해야 할까?","session_id":"test"}' | pwsh -NoProfile -File hooks/suggest-agents.ps1
# Should output:
# [agency-agents hint] The user prompt matched specialist triggers:
#   - Skill: korean-business (handles routing across multiple agents)
# Consider delegating via the Agent tool if the task warrants specialist depth.

'{"prompt":"日本のクライアントに稟議の進め方を聞きたい","session_id":"test"}' | pwsh -NoProfile -File hooks/suggest-agents.ps1
# Should output: japanese-business hint

'{"prompt":"what is the capital of France","session_id":"test"}' | pwsh -NoProfile -File hooks/suggest-agents.ps1
# Should output: nothing (silent on no match)
```

### Adding new triggers

Edit the `$triggers` array in `suggest-agents.ps1`. Each entry:

```powershell
@{ Pattern = '(?i)\b(regex|pattern)\b'; Agent = 'agent-slug'; Skill = 'skill-name' }
```

- `Agent` — invoke directly
- `Skill` — use the routing skill (preferred when multiple agents could apply)
- Both — show agent name but skill takes precedence in output

---

## 2. `log-skill-fired.ps1`

A `PreToolUse` hook (matcher: `Skill`) that logs every Skill-tool invocation to a JSONL file for offline analysis.

### What it records

Per fired skill — one line of JSON appended to `~/.claude/agency-agents-fork-skill-firings.jsonl`:

```json
{"ts":"2026-05-18T11:54:44.2592462+09:00","skill":"korean-business","session":"<uuid>","args_present":true}
```

| Field | Type | Note |
|---|---|---|
| `ts` | ISO 8601 datetime with offset | Server-local |
| `skill` | string | The slug passed to the Skill tool (e.g. `korean-business`, `engineering:debug`) |
| `session` | string | Claude session UUID — for correlating multiple firings within one session |
| `args_present` | bool | Whether `tool_input.args` was a non-empty string |

**Privacy:** prompt text and arg values are **never** recorded. Only the four fields above. See [SECURITY.md](../SECURITY.md) for the full scope.

### Manual activation (without `install.ps1 -WithHooks`)

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Skill",
        "command": "pwsh -NoProfile -File <fork-clone-path>/hooks/log-skill-fired.ps1",
        "description": "Log every Skill-tool invocation to local JSONL"
      }
    ]
  }
}
```

### Testing the hook

```powershell
'{"tool_input":{"skill":"korean-business","args":"test"},"session_id":"manual-test"}' | pwsh -NoProfile -File hooks/log-skill-fired.ps1
# Exit 0, silent. Then verify:
Get-Content ~\.claude\agency-agents-fork-skill-firings.jsonl -Tail 1
# Should show the just-added entry
```

### Analyzing the telemetry

`scripts/show-skill-stats.ps1` reads the JSONL log and reports per-skill fire counts:

```powershell
.\scripts\show-skill-stats.ps1
# Shows: total firings, per-skill counts ranked, sessions seen, log size
```

Use cases:

- **Find dead skills** — skills with 0 firings after weeks of use are candidates for removal or description tightening
- **Spot routing hot paths** — high-fire skills justify deeper specialization
- **Detect false-fire patterns** — a skill firing on prompts that don't match its intent suggests the description needs sharpening

### Rotating / clearing the log

The log grows ~150 bytes per firing. At 100 firings/day that's ~5 MB/year — negligible. To wipe:

```powershell
Remove-Item ~\.claude\agency-agents-fork-skill-firings.jsonl
```

The hook will recreate it on the next firing.

---

## Why hooks at all when we have skills?

- **Skills** auto-invoke based on description matching — passive routing, model-controlled.
- **Hooks** fire deterministically on every event — active, runtime-controlled.

The two work together:

- `suggest-agents.ps1` (hook) surfaces "did you notice this could use a specialist?" so the assistant considers it
- `korean-business` (skill) provides the actual routing logic when the assistant decides to delegate
- `log-skill-fired.ps1` (hook) records what actually fired so the design can be tuned over time

Hook is the active reminder; skill is the executable routing; telemetry is the feedback loop.
