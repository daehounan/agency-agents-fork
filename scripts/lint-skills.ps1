# lint-skills.ps1 - Validate SKILL.md files in the fork
#
# Usage:
#   .\scripts\lint-skills.ps1                  # lint all 24 skills
#   .\scripts\lint-skills.ps1 -SkillName korean-business
#   .\scripts\lint-skills.ps1 -Strict          # fail on warnings

[CmdletBinding()]
param(
    [string]$SkillName = '',
    [switch]$Strict
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$skillsDir = Join-Path $repoRoot 'skills'

if (-not (Test-Path $skillsDir)) {
    Write-Error "skills/ directory not found at $skillsDir"
    exit 1
}

$skills = if ($SkillName) {
    @(Get-Item (Join-Path $skillsDir $SkillName) -ErrorAction Stop)
} else {
    Get-ChildItem $skillsDir -Directory
}

$errors = 0
$warnings = 0
$lintedSkills = 0

function Parse-Frontmatter {
    param([string]$Path)
    $raw = [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
    $lines = $raw -split "`r?`n"
    $fmStart = -1; $fmEnd = -1
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -eq '---') {
            if ($fmStart -lt 0) { $fmStart = $i }
            elseif ($fmEnd -lt 0) { $fmEnd = $i; break }
        }
    }
    $meta = @{}
    if ($fmStart -ge 0 -and $fmEnd -gt $fmStart) {
        for ($i = $fmStart + 1; $i -lt $fmEnd; $i++) {
            $line = $lines[$i]
            if ($line -match '^([a-zA-Z_]+):\s*(.+)$') {
                $key = $matches[1]
                $val = $matches[2].Trim().Trim('"').Trim("'")
                $meta[$key] = $val
            }
        }
    }
    $body = if ($fmEnd -ge 0 -and $fmEnd + 1 -lt $lines.Length) {
        ($lines[($fmEnd + 1)..($lines.Length - 1)] -join "`n").TrimStart()
    } else { $raw }
    return [PSCustomObject]@{
        Meta = $meta
        Body = $body
        BodyLines = ($body -split "`r?`n").Length
        RawSize = $raw.Length
    }
}

Write-Host "Linting $($skills.Count) skill(s)..."
Write-Host ""

foreach ($skill in $skills) {
    $skillFile = Join-Path $skill.FullName 'SKILL.md'
    if (-not (Test-Path $skillFile)) {
        Write-Host "[ERR ] $($skill.Name): no SKILL.md found"
        $errors++
        continue
    }

    $parsed = Parse-Frontmatter -Path $skillFile
    $skillErrors = @()
    $skillWarnings = @()

    # E1: name field required
    if (-not $parsed.Meta['name']) {
        $skillErrors += "missing 'name' field in frontmatter"
    } elseif ($parsed.Meta['name'] -ne $skill.Name) {
        $skillErrors += "name field '$($parsed.Meta['name'])' does not match directory '$($skill.Name)'"
    }

    # E2: description field required
    if (-not $parsed.Meta['description']) {
        $skillErrors += "missing 'description' field"
    } else {
        $descLen = $parsed.Meta['description'].Length
        # W1: description too short (less likely to match prompts)
        if ($descLen -lt 80) {
            $skillWarnings += "description too short ($descLen chars) — may miss trigger matches"
        }
        # W2: description too long (wastes system tokens)
        if ($descLen -gt 800) {
            $skillWarnings += "description too long ($descLen chars) — consider trimming"
        }
        # W3: description should explain WHEN to use
        if ($parsed.Meta['description'] -notmatch '(?i)\b(use when|use for|trigger|when the user)\b') {
            $skillWarnings += "description lacks explicit 'use when' / trigger phrasing"
        }
    }

    # E3: body must exist
    if ($parsed.BodyLines -lt 3) {
        $skillErrors += "body too short ($($parsed.BodyLines) lines) — should explain routing logic"
    }

    # W4: total size sanity
    if ($parsed.RawSize -gt 8000) {
        $skillWarnings += "skill file unusually large ($($parsed.RawSize) bytes) — consider splitting"
    }

    # Output
    if ($skillErrors.Count -eq 0 -and $skillWarnings.Count -eq 0) {
        Write-Host "[OK  ] $($skill.Name)"
        $lintedSkills++
    } else {
        foreach ($e in $skillErrors) {
            Write-Host "[ERR ] $($skill.Name): $e"
            $errors++
        }
        foreach ($w in $skillWarnings) {
            Write-Host "[WARN] $($skill.Name): $w"
            $warnings++
        }
        if ($skillErrors.Count -eq 0) { $lintedSkills++ }
    }
}

Write-Host ""
Write-Host "=== Summary ==="
Write-Host "Skills passed: $lintedSkills / $($skills.Count)"
Write-Host "Errors:        $errors"
Write-Host "Warnings:      $warnings"

if ($errors -gt 0) { exit 1 }
if ($Strict -and $warnings -gt 0) { exit 2 }
exit 0
