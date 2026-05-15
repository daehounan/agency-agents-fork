# install.ps1 - Install agency agents (and optionally skills) to Claude Code (Windows PowerShell)
#
# Usage:
#   .\scripts\install.ps1                          # install all agents to ~/.claude/agents
#   .\scripts\install.ps1 -Division engineering    # one division only
#   .\scripts\install.ps1 -DryRun                  # preview, no copies
#   .\scripts\install.ps1 -SkipExisting            # do not overwrite existing files
#   .\scripts\install.ps1 -WithSkills              # also install skills to ~/.claude/skills
#   .\scripts\install.ps1 -SkillsOnly              # install only skills, skip agents
#   .\scripts\install.ps1 -Target "$env:USERPROFILE\.claude\agents"

[CmdletBinding()]
param(
    [string]$Division = '',
    [string]$Target = "$env:USERPROFILE\.claude\agents",
    [string]$SkillsTarget = "$env:USERPROFILE\.claude\skills",
    [switch]$DryRun,
    [switch]$SkipExisting,
    [switch]$WithSkills,
    [switch]$SkillsOnly
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$divisions = @(
    'academic','design','engineering','finance','game-development',
    'marketing','paid-media','product','project-management','sales',
    'spatial-computing','specialized','strategy','support','testing'
)

if ($Division -and ($Division -notin $divisions)) {
    Write-Error "Unknown division '$Division'. Valid: $($divisions -join ', ')"
    exit 1
}

$toInstall = if ($Division) { @($Division) } else { $divisions }

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

# === Hook reminder ===
if (-not $SkillsOnly) {
    $hookPath = Join-Path $repoRoot 'hooks\suggest-agents.ps1'
    if (Test-Path $hookPath) {
        Write-Host ""
        Write-Host "=== Optional: UserPromptSubmit hook ==="
        Write-Host "To enable the agent-suggestion hook, add to ~/.claude/settings.json:"
        Write-Host "  hooks.UserPromptSubmit -> command: pwsh -NoProfile -File $hookPath"
        Write-Host "See hooks/README.md for the JSON snippet."
    }
}
