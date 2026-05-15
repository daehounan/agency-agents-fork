# Hooks

## suggest-agents.ps1

A `UserPromptSubmit` hook that scans incoming user prompts for high-confidence specialist triggers and outputs a one-line hint to the main Claude assistant.

### Behavior

- **Silent when no match.** Hooks should not be noisy on unrelated prompts.
- **High-confidence patterns only.** Uses specific Korean/Japanese/XR/game-dev/paid-media keyword regex — common English words don't trigger.
- **At most 3 suggestions per prompt.** Avoids overwhelming the assistant with options.
- **Hints, never commands.** Final delegation decision stays with the main assistant.

### Activation

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "command": "pwsh -NoProfile -File C:/Users/andae/Projects/agency-agents-fork/hooks/suggest-agents.ps1",
        "description": "Suggest agency-agents specialists for matching prompts"
      }
    ]
  }
}
```

### Disable

Remove the entry from `settings.json`, or comment out by renaming the file. No global state to clean up.

### Testing the hook

```powershell
'{"prompt":"how do I prep for a Korean client 회식?"}' | pwsh -NoProfile -File hooks/suggest-agents.ps1
# Should output: [agency-agents hint] The user prompt matched specialist triggers:
#                  - Skill: korean-business (...)
#                  - Agent: specialized-korean-business-navigator
```

### Adding new triggers

Edit `$triggers` array in `suggest-agents.ps1`. Each entry is:

```powershell
@{ Pattern = '(?i)\b(regex|pattern)\b'; Agent = 'agent-slug'; Skill = 'skill-name' }
```

- `Agent` — invoke directly
- `Skill` — use the routing skill (preferred when multiple agents could apply)
- Both — show agent name but skill takes precedence in output

### Why hooks instead of just skills?

- **Skills** auto-invoke based on description matching — passive routing.
- **Hooks** fire on every prompt — active, deterministic.
- Hook + Skill combo: hook surfaces the option, skill handles invocation. Hook is the "did you notice this could use a specialist?" reminder.
