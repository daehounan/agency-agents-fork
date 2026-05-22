# install.ps1 - Install agency agents (and optionally skills) to Claude Code (Windows PowerShell)

<#
.SYNOPSIS
    Install agency-agents fork agents and skills to ~/.claude/, optionally registering hooks.

.DESCRIPTION
    Copies markdown agent definitions into ~/.claude/agents/ (and optionally skills into
    ~/.claude/skills/). With -WithHooks, also registers the UserPromptSubmit + PreToolUse(Skill)
    hooks in ~/.claude/settings.json by invoking install-hooks-in-settings.ps1.

    Safe to re-run: existing files are overwritten unless -SkipExisting is used. Use -DryRun
    to preview every action without writing anything.

.PARAMETER Division
    Restrict install to one division (legacy single-division switch). Prefer -Divisions
    for multiple. When both are set, -Divisions wins. When neither is set, all 15
    division directories install (academic, design, engineering, finance,
    game-development, marketing, paid-media, product, project-management, sales,
    spatial-computing, specialized, strategy, support, testing).

.PARAMETER Divisions
    Restrict install to a list of divisions. Mirrors scripts/build-plugin.ps1's
    -Divisions for UX parity. Accepts comma, semicolon, or whitespace as a separator,
    so all of these work identically:
        -Divisions finance,engineering
        -Divisions "finance;engineering"
        -Divisions finance engineering

.PARAMETER Target
    Destination directory for agents. Defaults to ~/.claude/agents.

.PARAMETER SkillsTarget
    Destination directory for skills. Defaults to ~/.claude/skills.

.PARAMETER DryRun
    Preview every copy/overwrite without writing any files. Also forwarded to the hook
    installer when combined with -WithHooks.

.PARAMETER SkipExisting
    Do not overwrite files that already exist at the destination.

.PARAMETER WithSkills
    Also install skills (in addition to agents).

.PARAMETER SkillsOnly
    Install only skills; skip the agent install step entirely.

.PARAMETER WithHooks
    After install, also register the suggest-agents (UserPromptSubmit) and skill-telemetry
    (PreToolUse:Skill) hooks in ~/.claude/settings.json by invoking
    install-hooks-in-settings.ps1. Idempotent — pre-existing entries are detected and skipped.

.EXAMPLE
    .\scripts\install.ps1
    Install 163 agents + 16 strategy playbook docs (179 .md files total) to ~/.claude/agents.

.EXAMPLE
    .\scripts\install.ps1 -Division engineering
    Install only the engineering division (legacy single-division flag).

.EXAMPLE
    .\scripts\install.ps1 -Divisions finance,engineering
    Install only finance + engineering agents (~32 .md files).

.EXAMPLE
    .\scripts\install.ps1 -Divisions specialized -WithSkills -WithHooks
    Install the specialized division (incl. Korean + Japanese Business Navigators)
    plus all 24 skills plus both hooks.

.EXAMPLE
    .\scripts\install.ps1 -DryRun -WithHooks
    Preview the full install including hook registration; writes nothing.

.LINK
    https://github.com/daehounan/agency-agents-fork
#>

[CmdletBinding()]
param(
    [string]$Division = '',
    [string[]]$Divisions,
    [string]$Target = "$env:USERPROFILE\.claude\agents",
    [string]$SkillsTarget = "$env:USERPROFILE\.claude\skills",
    [switch]$DryRun,
    [switch]$SkipExisting,
    [switch]$WithSkills,
    [switch]$SkillsOnly,
    [switch]$WithHooks
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$allDivisions = @(
    'academic','design','engineering','finance','game-development',
    'marketing','paid-media','product','project-management','sales',
    'spatial-computing','specialized','strategy','support','testing'
)

# === Resolve which divisions to install ===
# Priority: -Divisions (plural, new) > -Division (singular, legacy) > all 15.
# -Divisions supports comma / semicolon / whitespace separators because
# pwsh -File from another shell flattens arrays into a single string.
if ($Divisions) {
    $expanded = @()
    foreach ($d in $Divisions) {
        $expanded += ($d -split '[\s,;]+' | Where-Object { $_ })
    }
    $expanded = $expanded | ForEach-Object { $_.Trim().ToLower() }
    $unknown = $expanded | Where-Object { $_ -notin $allDivisions }
    if ($unknown) {
        Write-Error "Unknown division(s): $($unknown -join ', '). Valid: $($allDivisions -join ', ')"
        exit 1
    }
    $toInstall = $expanded
    $isSubset = $true
} elseif ($Division) {
    if ($Division -notin $allDivisions) {
        Write-Error "Unknown division '$Division'. Valid: $($allDivisions -join ', ')"
        exit 1
    }
    $toInstall = @($Division)
    $isSubset = $true
} else {
    $toInstall = $allDivisions
    $isSubset = $false
}

if ($isSubset) {
    Write-Host "Scope: $($toInstall -join ', ')  (subset of 15 division directories)"
    Write-Host ""
}

$copied = 0
$skipped = 0
$overwritten = 0

# === Agents ===
if (-not $SkillsOnly) {
    if (-not (Test-Path $Target)) {
        if ($DryRun) {
            Write-Host "[DRY] Would create $Target"
        } else {
            New-Item -Path $Target -ItemType Directory -Force | Out-Null
            Write-Host "[OK]  Created $Target"
        }
    }

    foreach ($div in $toInstall) {
        $srcDir = Join-Path $repoRoot $div
        if (-not (Test-Path $srcDir)) { continue }
        Get-ChildItem $srcDir -Filter '*.md' -Recurse | ForEach-Object {
            $destPath = Join-Path $Target $_.Name
            $exists = Test-Path $destPath
            if ($exists -and $SkipExisting) {
                $skipped++
                return
            }
            if ($DryRun) {
                $action = if ($exists) { 'overwrite' } else { 'copy' }
                Write-Host "[DRY] $action $($_.Name)"
            } else {
                Copy-Item $_.FullName $destPath -Force
                if ($exists) { $overwritten++ } else { $copied++ }
            }
        }
    }

    Write-Host ""
    Write-Host "=== Agents Summary ==="
    Write-Host "Copied (new):       $copied"
    Write-Host "Overwritten:        $overwritten"
    Write-Host "Skipped (existing): $skipped"
    Write-Host "Target:             $Target"
}

# === Skills ===
if ($WithSkills -or $SkillsOnly) {
    $skillsSrc = Join-Path $repoRoot 'skills'
    if (-not (Test-Path $skillsSrc)) {
        Write-Host ""
        Write-Host "[!!] No skills/ directory found in fork — skipping skills install."
    } else {
        if (-not (Test-Path $SkillsTarget)) {
            if ($DryRun) {
                Write-Host "[DRY] Would create $SkillsTarget"
            } else {
                New-Item -Path $SkillsTarget -ItemType Directory -Force | Out-Null
            }
        }

        $skillCopied = 0
        $skillOverwritten = 0
        Get-ChildItem $skillsSrc -Directory | ForEach-Object {
            $skillDir = $_
            $skillFile = Join-Path $skillDir.FullName 'SKILL.md'
            if (-not (Test-Path $skillFile)) { return }

            $destSkillDir = Join-Path $SkillsTarget $skillDir.Name
            $destSkillFile = Join-Path $destSkillDir 'SKILL.md'
            $exists = Test-Path $destSkillFile

            if ($exists -and $SkipExisting) { return }

            if ($DryRun) {
                $action = if ($exists) { 'overwrite' } else { 'copy' }
                Write-Host "[DRY] $action skill: $($skillDir.Name)"
            } else {
                if (-not (Test-Path $destSkillDir)) { New-Item -Path $destSkillDir -ItemType Directory -Force | Out-Null }
                Copy-Item $skillFile $destSkillFile -Force
                if ($exists) { $skillOverwritten++ } else { $skillCopied++ }
            }
        }

        Write-Host ""
        Write-Host "=== Skills Summary ==="
        Write-Host "Copied (new):       $skillCopied"
        Write-Host "Overwritten:        $skillOverwritten"
        Write-Host "Target:             $SkillsTarget"
    }
}

# === Hooks: explicit opt-in via -WithHooks, otherwise just remind ===
$hookInstaller = Join-Path $repoRoot 'scripts\install-hooks-in-settings.ps1'
$suggestHook   = Join-Path $repoRoot 'hooks\suggest-agents.ps1'

if ($WithHooks) {
    if (-not (Test-Path $hookInstaller)) {
        Write-Host ""
        Write-Host "[!!] -WithHooks requested but installer not found at: $hookInstaller"
    } else {
        Write-Host ""
        Write-Host "=== Hooks (-WithHooks) ==="
        $hookArgs = @('-NoProfile','-File',$hookInstaller)
        if ($DryRun) { $hookArgs += '-DryRun' }
        & pwsh @hookArgs
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[!!] Hook installer exited with code $LASTEXITCODE — agents/skills already installed."
        }
    }
} elseif (-not $SkillsOnly -and (Test-Path $suggestHook)) {
    Write-Host ""
    Write-Host "=== Optional: hooks (not installed) ==="
    Write-Host "Re-run with -WithHooks to register UserPromptSubmit (agent suggestions)"
    Write-Host "and PreToolUse(Skill) (skill telemetry) in ~/.claude/settings.json."
    Write-Host "Or run scripts\install-hooks-in-settings.ps1 directly. See hooks/README.md."
}
