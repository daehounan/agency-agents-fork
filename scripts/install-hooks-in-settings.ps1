# install-hooks-in-settings.ps1 - Register fork hooks into ~/.claude/settings.json
#
# Registers two hooks atomically:
#   1. UserPromptSubmit -> hooks/suggest-agents.ps1   (auto-suggest specialists)
#   2. PreToolUse(Skill) -> hooks/log-skill-fired.ps1 (telemetry on skill firings)
#
# Safety: automatic backup, JSON validation before/after, idempotent re-run,
#         atomic rollback on any failure.
#
# Usage:
#   pwsh -NoProfile -File scripts/install-hooks-in-settings.ps1
#   pwsh -NoProfile -File scripts/install-hooks-in-settings.ps1 -DryRun
#   pwsh -NoProfile -File scripts/install-hooks-in-settings.ps1 -Uninstall

[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$Uninstall,
    [string]$SettingsPath = (Join-Path $env:USERPROFILE '.claude\settings.json')
)

$ErrorActionPreference = 'Stop'

# Resolve fork repo root (this script lives at <fork>/scripts/)
$forkRoot = Split-Path -Parent $PSScriptRoot
$suggestAgentsPath = Join-Path $forkRoot 'hooks\suggest-agents.ps1'
$logSkillFiredPath = Join-Path $forkRoot 'hooks\log-skill-fired.ps1'

# Convert to forward-slash for JSON portability
$suggestCmd = "pwsh -NoProfile -File " + ($suggestAgentsPath -replace '\\','/')
$logCmd     = "pwsh -NoProfile -File " + ($logSkillFiredPath -replace '\\','/')

# === Pre-flight ===
if (-not (Test-Path $SettingsPath)) {
    Write-Error "settings.json not found at $SettingsPath"
    exit 1
}
if (-not (Test-Path $suggestAgentsPath)) {
    Write-Error "suggest-agents.ps1 not found at $suggestAgentsPath"
    exit 1
}
if (-not (Test-Path $logSkillFiredPath)) {
    Write-Error "log-skill-fired.ps1 not found at $logSkillFiredPath"
    exit 1
}

# Validate current settings.json parses
try {
    $original = Get-Content $SettingsPath -Raw -Encoding UTF8
    $settings = $original | ConvertFrom-Json -AsHashtable
} catch {
    Write-Error "settings.json failed to parse — aborting before any change. Error: $_"
    exit 1
}

# === Backup ===
$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backup = "$SettingsPath.bak-$timestamp"
if (-not $DryRun) {
    Copy-Item $SettingsPath $backup -Force
    Write-Host "[OK]  Backup: $backup"
}

# Ensure hooks key
if (-not $settings.ContainsKey('hooks')) { $settings.hooks = @{} }
$beforeUserPromptCount = if ($settings.hooks.ContainsKey('UserPromptSubmit')) { @($settings.hooks.UserPromptSubmit).Count } else { 0 }
$beforePreToolCount = if ($settings.hooks.ContainsKey('PreToolUse')) { @($settings.hooks.PreToolUse).Count } else { 0 }

# === Detect existing entries ===
function Has-Hook($eventName, $matchPattern) {
    if (-not $settings.hooks.ContainsKey($eventName)) { return $false }
    foreach ($e in @($settings.hooks[$eventName])) {
        foreach ($h in @($e.hooks)) {
            if ($h.command -and $h.command -match $matchPattern) { return $true }
        }
    }
    return $false
}

$alreadySuggest = Has-Hook 'UserPromptSubmit' 'suggest-agents'
$alreadyLog = Has-Hook 'PreToolUse' 'log-skill-fired'

if ($Uninstall) {
    # === Uninstall mode ===
    Write-Host ""
    Write-Host "=== Uninstall mode ==="
    $changes = 0

    if ($settings.hooks.ContainsKey('UserPromptSubmit')) {
        $kept = @()
        foreach ($e in @($settings.hooks.UserPromptSubmit)) {
            $keep = $true
            foreach ($h in @($e.hooks)) {
                if ($h.command -match 'suggest-agents') { $keep = $false }
            }
            if ($keep) { $kept += $e }
        }
        if ($kept.Count -ne @($settings.hooks.UserPromptSubmit).Count) {
            if ($kept.Count -eq 0) { $settings.hooks.Remove('UserPromptSubmit') }
            else { $settings.hooks.UserPromptSubmit = $kept }
            $changes++
            Write-Host "[OK]  Removed suggest-agents from UserPromptSubmit"
        }
    }

    if ($settings.hooks.ContainsKey('PreToolUse')) {
        $kept = @()
        foreach ($e in @($settings.hooks.PreToolUse)) {
            $keep = $true
            foreach ($h in @($e.hooks)) {
                if ($h.command -match 'log-skill-fired') { $keep = $false }
            }
            if ($keep) { $kept += $e }
        }
        if ($kept.Count -ne @($settings.hooks.PreToolUse).Count) {
            $settings.hooks.PreToolUse = $kept
            $changes++
            Write-Host "[OK]  Removed log-skill-fired from PreToolUse"
        }
    }

    if ($changes -eq 0) {
        Write-Host "[--]  No fork hooks found to remove."
        exit 0
    }
} else {
    # === Install mode ===
    Write-Host ""
    Write-Host "=== Install mode ==="

    # 1) UserPromptSubmit -> suggest-agents
    if ($alreadySuggest) {
        Write-Host "[--]  UserPromptSubmit suggest-agents already registered — skip"
    } else {
        $entry = @{
            matcher = "*"
            hooks = @(@{ type = "command"; command = $suggestCmd })
        }
        if (-not $settings.hooks.ContainsKey('UserPromptSubmit')) {
            $settings.hooks.UserPromptSubmit = @($entry)
        } else {
            $existing = @($settings.hooks.UserPromptSubmit)
            $existing += $entry
            $settings.hooks.UserPromptSubmit = $existing
        }
        Write-Host "[+]   UserPromptSubmit: + suggest-agents"
    }

    # 2) PreToolUse(Skill) -> log-skill-fired
    if ($alreadyLog) {
        Write-Host "[--]  PreToolUse Skill log-skill-fired already registered — skip"
    } else {
        $entry = @{
            matcher = "Skill"
            hooks = @(@{ type = "command"; command = $logCmd })
        }
        if (-not $settings.hooks.ContainsKey('PreToolUse')) {
            $settings.hooks.PreToolUse = @($entry)
        } else {
            $existing = @($settings.hooks.PreToolUse)
            $existing += $entry
            $settings.hooks.PreToolUse = $existing
        }
        Write-Host "[+]   PreToolUse Skill: + log-skill-fired"
    }
}

# === Serialize + write + validate ===
$newJson = $settings | ConvertTo-Json -Depth 20

if ($DryRun) {
    Write-Host ""
    Write-Host "=== Dry run — no file written ==="
    Write-Host "Would write $($newJson.Length) bytes to: $SettingsPath"
    exit 0
}

# Pre-write validation: ensure new JSON parses
try {
    $null = $newJson | ConvertFrom-Json
} catch {
    Write-Host "[FAIL] Generated JSON does not parse. Restoring from backup."
    Copy-Item $backup $SettingsPath -Force
    Write-Error "Aborted before writing. Backup restored. Error: $_"
    exit 1
}

[System.IO.File]::WriteAllText($SettingsPath, $newJson, [System.Text.UTF8Encoding]::new($false))

# Post-write validation: re-read and parse
try {
    $verify = Get-Content $SettingsPath -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Host "[FAIL] Post-write parse failed. Restoring from backup."
    Copy-Item $backup $SettingsPath -Force
    Write-Error "Restored. Error: $_"
    exit 1
}

$afterUserPromptCount = if ($verify.hooks.UserPromptSubmit) { @($verify.hooks.UserPromptSubmit).Count } else { 0 }
$afterPreToolCount = if ($verify.hooks.PreToolUse) { @($verify.hooks.PreToolUse).Count } else { 0 }

Write-Host ""
Write-Host "=== Summary ==="
Write-Host "UserPromptSubmit entries: $beforeUserPromptCount -> $afterUserPromptCount"
Write-Host "PreToolUse entries:       $beforePreToolCount -> $afterPreToolCount"
Write-Host "Backup retained:          $backup"
Write-Host ""
if ($Uninstall) {
    Write-Host "Hooks removed. Restart Claude Code to take effect."
} else {
    Write-Host "Hooks installed. Open a NEW Claude Code session to take effect."
    Write-Host "Test by prompting: 'how do I prep for a Korean client 회식?'"
    Write-Host "Expected: agency-agents hint surfaces korean-business skill."
}
