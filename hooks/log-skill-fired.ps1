# log-skill-fired.ps1 — PreToolUse hook for the Skill tool
#
# Logs every Skill tool invocation to a JSONL file for later analysis.
# Used to identify dead skills, frequently-fired clusters, and routing patterns.
#
# Activation: add to ~/.claude/settings.json under hooks.PreToolUse:
#
#   {
#     "matcher": "Skill",
#     "hooks": [
#       {
#         "type": "command",
#         "command": "pwsh -NoProfile -File C:/Users/andae/Projects/agency-agents-fork/hooks/log-skill-fired.ps1"
#       }
#     ]
#   }
#
# Stdin: { "tool_input": { "skill": "<name>", "args": "..." }, "session_id": "...", ... }
# Output: silent (writes to log file, returns 0 to allow tool execution)
# Log location: ~/.claude/agency-agents-fork-skill-firings.jsonl

$ErrorActionPreference = 'SilentlyContinue'

try {
    $inputData = [Console]::In.ReadToEnd()
    if (-not $inputData) { exit 0 }

    $payload = $inputData | ConvertFrom-Json
    $skill = $payload.tool_input.skill
    if (-not $skill) { exit 0 }

    # Build log entry
    $entry = [ordered]@{
        ts = (Get-Date).ToString("o")
        skill = $skill
        session = $payload.session_id
        args_present = ($null -ne $payload.tool_input.args -and $payload.tool_input.args.Length -gt 0)
    }

    $logPath = Join-Path $env:USERPROFILE '.claude/agency-agents-fork-skill-firings.jsonl'
    $logDir = Split-Path $logPath -Parent
    if (-not (Test-Path $logDir)) { New-Item $logDir -ItemType Directory -Force | Out-Null }

    $line = ($entry | ConvertTo-Json -Compress) + "`n"
    [System.IO.File]::AppendAllText($logPath, $line, [System.Text.UTF8Encoding]::new($false))
} catch {
    # Never block the tool — hook failures must be silent
}

exit 0
