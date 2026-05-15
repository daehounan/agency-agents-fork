# install.ps1 - Install agency agents to Claude Code (Windows PowerShell)
#
# Usage:
#   .\scripts\install.ps1                    # install all to ~/.claude/agents
#   .\scripts\install.ps1 -Division engineering
#   .\scripts\install.ps1 -DryRun
#   .\scripts\install.ps1 -SkipExisting      # do not overwrite existing files
#   .\scripts\install.ps1 -Target "$env:USERPROFILE\.claude\agents"

[CmdletBinding()]
param(
    [string]$Division = '',
    [string]$Target = "$env:USERPROFILE\.claude\agents",
    [switch]$DryRun,
    [switch]$SkipExisting
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

if (-not (Test-Path $Target)) {
    if ($DryRun) {
        Write-Host "[DRY] Would create $Target"
    } else {
        New-Item -Path $Target -ItemType Directory -Force | Out-Null
        Write-Host "[OK]  Created $Target"
    }
}

$copied = 0
$skipped = 0
$overwritten = 0

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
Write-Host "=== Summary ==="
Write-Host "Copied (new):       $copied"
Write-Host "Overwritten:        $overwritten"
Write-Host "Skipped (existing): $skipped"
Write-Host "Target:             $Target"
