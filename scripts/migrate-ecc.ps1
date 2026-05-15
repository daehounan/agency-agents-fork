# migrate-ecc.ps1 — Convert agency-agents .md files to ecc-style frontmatter.
#
# Reads agents from the fork tree, rewrites frontmatter to match the ecc plugin
# convention (lowercase slug name, tools array, model field, PROACTIVELY trigger),
# and writes the converted files to integrations/ecc-style/.
#
# ecc-style frontmatter:
#   ---
#   name: <kebab-case-slug>
#   description: <original description>. Use PROACTIVELY when <auto-derived hint>.
#   tools: ["Read", "Grep", "Glob", ...]   # division-dependent default
#   model: <sonnet|opus|haiku>             # division-dependent default
#   ---
#
# Usage:
#   .\scripts\migrate-ecc.ps1
#   .\scripts\migrate-ecc.ps1 -OutDir custom\path
#   .\scripts\migrate-ecc.ps1 -Install         # also copy to ~/.claude/agents/ecc-style/

[CmdletBinding()]
param(
    [string]$OutDir = "",
    [switch]$Install
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
if (-not $OutDir) { $OutDir = Join-Path $repoRoot 'integrations\ecc-style' }
$divisions = @(
    'academic','design','engineering','finance','game-development',
    'marketing','paid-media','product','project-management','sales',
    'spatial-computing','specialized','strategy','support','testing'
)

# Per-division defaults: tools + model + proactive trigger phrase
$divisionDefaults = @{
    'academic'           = @{ Tools = '["Read","Grep","Glob"]';                                              Model = 'sonnet'; Trigger = 'researching cultural, historical, geographical, narrative, or psychological context for world-building' }
    'design'             = @{ Tools = '["Read","Grep","Glob","Write","Edit"]';                               Model = 'sonnet'; Trigger = 'designing UI, brand systems, visual narratives, or design documentation' }
    'engineering'        = @{ Tools = '["Read","Grep","Glob","Write","Edit","Bash"]';                        Model = 'sonnet'; Trigger = 'implementing code, debugging, or technical engineering work' }
    'finance'            = @{ Tools = '["Read","Grep","Glob","Write","Edit"]';                               Model = 'sonnet'; Trigger = 'doing financial analysis, modeling, accounting, or tax strategy' }
    'game-development'   = @{ Tools = '["Read","Grep","Glob","Write","Edit","Bash"]';                        Model = 'sonnet'; Trigger = 'designing or implementing game systems, levels, audio, or engine-specific work' }
    'marketing'          = @{ Tools = '["Read","Grep","Glob","Write","Edit","WebFetch"]';                    Model = 'sonnet'; Trigger = 'drafting marketing copy, content strategy, or platform-specific campaigns' }
    'paid-media'         = @{ Tools = '["Read","Grep","Glob","Write","Edit"]';                               Model = 'sonnet'; Trigger = 'planning paid media buys, audits, tracking, or ad creative' }
    'product'            = @{ Tools = '["Read","Grep","Glob","Write","Edit"]';                               Model = 'sonnet'; Trigger = 'shaping product strategy, research synthesis, sprint planning, or trend analysis' }
    'project-management' = @{ Tools = '["Read","Grep","Glob","Write","Edit"]';                               Model = 'sonnet'; Trigger = 'planning sprints, tracking experiments, or coordinating project execution' }
    'sales'              = @{ Tools = '["Read","Grep","Glob","Write","Edit"]';                               Model = 'sonnet'; Trigger = 'building pipeline, preparing for discovery calls, qualifying deals, or writing proposals' }
    'spatial-computing'  = @{ Tools = '["Read","Grep","Glob","Write","Edit","Bash"]';                        Model = 'sonnet'; Trigger = 'designing or implementing XR, AR/VR, visionOS, or spatial interaction systems' }
    'specialized'        = @{ Tools = '["Read","Grep","Glob","Write","Edit"]';                               Model = 'sonnet'; Trigger = 'handling vertical-specific or cross-functional specialist tasks' }
    'strategy'           = @{ Tools = '["Read","Grep","Glob","Write","Edit","WebFetch"]';                    Model = 'opus';   Trigger = 'doing strategic analysis, planning, or executive-level synthesis' }
    'support'            = @{ Tools = '["Read","Grep","Glob","Write","Edit"]';                               Model = 'sonnet'; Trigger = 'analyzing support data, generating exec summaries, or compliance/legal review' }
    'testing'            = @{ Tools = '["Read","Grep","Glob","Bash"]';                                       Model = 'sonnet'; Trigger = 'running QA, accessibility audits, performance benchmarks, or evidence-based verification' }
}

# Per-agent overrides (architect-style roles get opus, read-only reviewers get restricted tools)
$agentOverrides = @{
    'engineering-software-architect'        = @{ Model = 'opus' }
    'engineering-backend-architect'         = @{ Model = 'opus' }
    'engineering-ai-engineer'               = @{ Model = 'opus' }
    'engineering-security-engineer'         = @{ Tools = '["Read","Grep","Glob"]'; Model = 'opus' }
    'engineering-code-reviewer'             = @{ Tools = '["Read","Grep","Glob","Bash"]' }
    'engineering-incident-response-commander' = @{ Model = 'opus' }
    'engineering-sre'                       = @{ Model = 'opus' }
    'specialized-blockchain-security-auditor' = @{ Tools = '["Read","Grep","Glob"]'; Model = 'opus' }
    'specialized-compliance-auditor'        = @{ Tools = '["Read","Grep","Glob","Write","Edit"]'; Model = 'opus' }
    'testing-reality-checker'               = @{ Tools = '["Read","Grep","Glob","Bash"]' }
    'testing-accessibility-auditor'         = @{ Tools = '["Read","Grep","Glob","Bash"]' }
}

function To-KebabSlug {
    param([string]$Name)
    # e.g., "Frontend Developer" -> "frontend-developer"
    $s = $Name -replace '\s+', '-'
    $s = $s -replace '[^a-zA-Z0-9\-]', ''
    return $s.ToLower()
}

function Parse-Frontmatter {
    param([string]$Path)
    $raw = Get-Content $Path -Raw
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
    return [PSCustomObject]@{ Meta = $meta; Body = $body }
}

# Setup output
if (Test-Path $OutDir) { Remove-Item $OutDir -Recurse -Force }
New-Item -Path $OutDir -ItemType Directory -Force | Out-Null

$processed = 0
$report = @()

foreach ($div in $divisions) {
    $srcDir = Join-Path $repoRoot $div
    if (-not (Test-Path $srcDir)) { continue }
    $defaults = $divisionDefaults[$div]

    Get-ChildItem $srcDir -Filter '*.md' -Recurse | ForEach-Object {
        $parsed = Parse-Frontmatter -Path $_.FullName
        $origName = $parsed.Meta['name']
        if (-not $origName) { $origName = [System.IO.Path]::GetFileNameWithoutExtension($_.Name) }
        $slug = To-KebabSlug $origName
        $description = $parsed.Meta['description']
        if (-not $description) { $description = "Specialist agent: $origName" }

        # Compose ecc-style description with PROACTIVELY trigger appended if not already present
        if ($description -notmatch '(?i)\bPROACTIVELY\b') {
            $description = "$description Use PROACTIVELY when $($defaults.Trigger)."
        }

        # Resolve tools + model (override beats default)
        $fileStem = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
        $tools = $defaults.Tools
        $model = $defaults.Model
        if ($agentOverrides.ContainsKey($fileStem)) {
            $ov = $agentOverrides[$fileStem]
            if ($ov.ContainsKey('Tools')) { $tools = $ov['Tools'] }
            if ($ov.ContainsKey('Model')) { $model = $ov['Model'] }
        }

        # Build new frontmatter
        $fm = @"
---
name: $slug
description: $description
tools: $tools
model: $model
---
"@
        $newContent = "$fm`n`n$($parsed.Body)"

        # Write to output (flat, slug-named, no division subfolder — matches ecc convention)
        $outPath = Join-Path $OutDir "$slug.md"
        Set-Content -Path $outPath -Value $newContent -Encoding UTF8
        $processed++

        $report += [PSCustomObject]@{
            Division = $div
            Slug = $slug
            Model = $model
        }
    }
}

Write-Host ""
Write-Host "=== Migration Summary ==="
Write-Host "Processed:    $processed agents"
Write-Host "Output dir:   $OutDir"
Write-Host ""
Write-Host "Model distribution:"
$report | Group-Object Model | Sort-Object Count -Descending | ForEach-Object {
    Write-Host "  $($_.Name): $($_.Count)"
}

if ($Install) {
    $target = Join-Path $env:USERPROFILE '.claude\agents\ecc-style'
    if (-not (Test-Path $target)) { New-Item $target -ItemType Directory -Force | Out-Null }
    Get-ChildItem $OutDir -Filter '*.md' | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $target $_.Name) -Force
    }
    Write-Host ""
    Write-Host "Installed to: $target"
}
