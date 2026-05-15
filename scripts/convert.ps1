# convert.ps1 - Convert agency agents to other tool formats (Cursor, Aider, Windsurf, OpenCode)
#
# Usage:
#   .\scripts\convert.ps1 -Tool cursor       # writes integrations/cursor/*.mdc
#   .\scripts\convert.ps1 -Tool aider        # writes integrations/aider/CONVENTIONS.md
#   .\scripts\convert.ps1 -Tool windsurf     # writes integrations/windsurf/.windsurfrules
#   .\scripts\convert.ps1 -Tool opencode     # writes integrations/opencode/*.md
#   .\scripts\convert.ps1 -Tool all

[CmdletBinding()]
param(
    [ValidateSet('cursor','aider','windsurf','opencode','all')]
    [string]$Tool = 'all'
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$outBase  = Join-Path $repoRoot 'integrations'
$divisions = @(
    'academic','design','engineering','finance','game-development',
    'marketing','paid-media','product','project-management','sales',
    'spatial-computing','specialized','strategy','support','testing'
)

function Get-AgentFiles {
    $files = @()
    foreach ($div in $divisions) {
        $d = Join-Path $repoRoot $div
        if (Test-Path $d) {
            $files += Get-ChildItem $d -Filter '*.md' -Recurse
        }
    }
    return $files
}

function Parse-Agent($file) {
    $raw = Get-Content $file.FullName -Raw
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
                $val = $matches[2].Trim('"').Trim("'")
                $meta[$key] = $val
            }
        }
    }
    $body = if ($fmEnd -ge 0) { ($lines[($fmEnd + 1)..($lines.Length - 1)] -join "`n").Trim() } else { $raw }
    [PSCustomObject]@{
        File = $file
        Slug = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        Name = $meta['name']
        Description = $meta['description']
        Color = $meta['color']
        Emoji = $meta['emoji']
        Body = $body
    }
}

function Convert-Cursor($agents) {
    $out = Join-Path $outBase 'cursor'
    New-Item $out -ItemType Directory -Force | Out-Null
    foreach ($a in $agents) {
        $mdc = @"
---
description: $($a.Description)
globs:
alwaysApply: false
---

# $($a.Name)

$($a.Body)
"@
        $path = Join-Path $out "$($a.Slug).mdc"
        Set-Content -Path $path -Value $mdc -Encoding UTF8
    }
    Write-Host "[OK] cursor: $($agents.Count) .mdc files -> $out"
}

function Convert-Aider($agents) {
    $out = Join-Path $outBase 'aider'
    New-Item $out -ItemType Directory -Force | Out-Null
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("# Agency Agents - Conventions for Aider")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("Reference agents by name when you want a specific perspective applied.")
    [void]$sb.AppendLine("")
    foreach ($a in $agents) {
        [void]$sb.AppendLine("## $($a.Name)")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("**Slug**: ``$($a.Slug)``")
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine($a.Description)
        [void]$sb.AppendLine("")
        [void]$sb.AppendLine("---")
        [void]$sb.AppendLine("")
    }
    Set-Content -Path (Join-Path $out 'CONVENTIONS.md') -Value $sb.ToString() -Encoding UTF8
    Write-Host "[OK] aider: CONVENTIONS.md ($($agents.Count) agents) -> $out"
}

function Convert-Windsurf($agents) {
    $out = Join-Path $outBase 'windsurf'
    New-Item $out -ItemType Directory -Force | Out-Null
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.AppendLine("# Agency Agents - Windsurf Rules")
    [void]$sb.AppendLine("")
    foreach ($a in $agents) {
        [void]$sb.AppendLine("## $($a.Name) (``$($a.Slug)``)")
        [void]$sb.AppendLine($a.Description)
        [void]$sb.AppendLine("")
    }
    Set-Content -Path (Join-Path $out '.windsurfrules') -Value $sb.ToString() -Encoding UTF8
    Write-Host "[OK] windsurf: .windsurfrules ($($agents.Count) agents) -> $out"
}

function Convert-OpenCode($agents) {
    $out = Join-Path $outBase 'opencode'
    New-Item $out -ItemType Directory -Force | Out-Null
    foreach ($a in $agents) {
        $md = @"
---
name: $($a.Slug)
description: $($a.Description)
---

# $($a.Name)

$($a.Body)
"@
        Set-Content -Path (Join-Path $out "$($a.Slug).md") -Value $md -Encoding UTF8
    }
    Write-Host "[OK] opencode: $($agents.Count) .md files -> $out"
}

$files = Get-AgentFiles
Write-Host "Parsing $($files.Count) agent files..."
$agents = $files | ForEach-Object { Parse-Agent $_ }

switch ($Tool) {
    'cursor'   { Convert-Cursor $agents }
    'aider'    { Convert-Aider $agents }
    'windsurf' { Convert-Windsurf $agents }
    'opencode' { Convert-OpenCode $agents }
    'all' {
        Convert-Cursor $agents
        Convert-Aider $agents
        Convert-Windsurf $agents
        Convert-OpenCode $agents
    }
}
