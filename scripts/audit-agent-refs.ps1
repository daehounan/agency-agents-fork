# audit-agent-refs.ps1 — Cross-reference audit
#
# Verifies that every kebab-case slug mentioned in skills/*/SKILL.md resolves
# to one of:
#   1. A real agent .md file in the fork's division directories, OR
#   2. A real SKILL.md inside skills/ (skill->skill cross-reference), OR
#   3. A namespaced external skill/agent (contains ':', e.g. ecc:security-reviewer)
#
# Anything else is reported as an orphan reference — typically a typo, a stale
# slug from before rename, or a reference to a removed component.
#
# Exit codes: 0 = clean, 1 = orphans found.

[CmdletBinding()]
param([switch]$Quiet)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot

# === 1. Build canonical agent slug roster ===
$divisions = @('academic','design','engineering','finance','game-development',
               'marketing','paid-media','product','project-management','sales',
               'spatial-computing','specialized','strategy','support','testing')
$agents = [System.Collections.Generic.HashSet[string]]::new()
foreach ($d in $divisions) {
    $p = Join-Path $repoRoot $d
    if (-not (Test-Path $p)) { continue }
    Get-ChildItem $p -Filter '*.md' -Recurse | ForEach-Object { [void]$agents.Add($_.BaseName) }
}

# === 2. Build canonical skill name roster ===
$skillsDir = Join-Path $repoRoot 'skills'
$skills = [System.Collections.Generic.HashSet[string]]::new()
$skillFiles = Get-ChildItem $skillsDir -Filter 'SKILL.md' -Recurse
foreach ($f in $skillFiles) {
    [void]$skills.Add((Split-Path $f.Directory -Leaf))
}

if (-not $Quiet) {
    Write-Host "Roster: $($agents.Count) agents, $($skills.Count) skills"
}

# === 2b. Load external-skill whitelist (legit refs to skills in other plugins) ===
$externals = [System.Collections.Generic.HashSet[string]]::new()
$externalFile = Join-Path $PSScriptRoot 'external-skill-refs.txt'
if (Test-Path $externalFile) {
    Get-Content $externalFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith('#')) { [void]$externals.Add($line) }
    }
    if (-not $Quiet) { Write-Host "External-skill whitelist: $($externals.Count) entries" }
}

# === 3. Scan SKILL.md files for backticked kebab-case tokens ===
# Catch both single-word (e.g. `anthropologist`) and multi-segment (e.g. `unity-architect`)
# backticked tokens. Markdown link syntax `[text](url)` is excluded by requiring no `(` after.
$kebabRegex = '`([a-z][a-z0-9]*(?:-[a-z0-9]+)*)`'
$subagentRegex = 'subagent_type:\s*[''"]([a-z][a-z0-9-]+)[''"]'
# Namespaced refs (e.g. ecc:foo, anthropic-skills:bar) — extract for whitelist filtering
$namespacedRegex = '`([a-z][a-z0-9-]*:[a-z][a-z0-9-:]+)`'

# Common-English / Markdown-meta tokens that look kebab-shaped but aren't agent/skill refs
$skipTokens = @(
    'use-when','when-to-use','use-instead','when-not','when-to',
    'data-source','data-sources','file-path','example-com',
    'a','i','no','yes','true','false','on','off','tba','tbd',
    'a-tier','b-tier','c-tier',
    'one','two','three','four','five','six','seven','eight','nine','ten'
)

$findings = @()
$totalRefs = 0
$resolvedAgent = 0
$resolvedSkill = 0
$resolvedNamespaced = 0

foreach ($skillFile in $skillFiles) {
    $skillName = Split-Path $skillFile.Directory -Leaf
    $content = [System.IO.File]::ReadAllText($skillFile.FullName, [System.Text.UTF8Encoding]::new($false))

    # Collect namespaced refs first so we don't re-flag them as orphans
    $namespacedSet = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($m in [regex]::Matches($content, $namespacedRegex)) {
        [void]$namespacedSet.Add($m.Groups[1].Value)
    }

    $refs = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($m in [regex]::Matches($content, $kebabRegex)) {
        [void]$refs.Add($m.Groups[1].Value)
    }
    foreach ($m in [regex]::Matches($content, $subagentRegex)) {
        [void]$refs.Add($m.Groups[1].Value)
    }

    # Filter out items that are part of a namespaced ref (we already counted them)
    foreach ($ns in $namespacedSet) {
        $resolvedNamespaced++
    }

    foreach ($ref in $refs) {
        if ($skipTokens -contains $ref) { continue }

        # Ignore refs that are part of a namespaced expression
        $isNamespacePart = $false
        foreach ($ns in $namespacedSet) {
            if ($ns.EndsWith(":$ref")) { $isNamespacePart = $true; break }
        }
        if ($isNamespacePart) { continue }

        $totalRefs++
        if ($agents.Contains($ref))    { $resolvedAgent++; continue }
        if ($skills.Contains($ref))    { $resolvedSkill++; continue }
        if ($externals.Contains($ref)) { $resolvedNamespaced++; continue }

        $findings += [PSCustomObject]@{
            Skill     = $skillName
            BrokenRef = $ref
        }
    }
}

# === 4. Report ===
Write-Host ""
Write-Host "=== Cross-Reference Audit ==="
Write-Host "Skill files scanned:        $($skillFiles.Count)"
Write-Host "Total backticked refs:      $totalRefs"
Write-Host "Resolved to agent file:     $resolvedAgent"
Write-Host "Resolved to skill name:     $resolvedSkill"
Write-Host "Namespaced (ecc:* etc):     $resolvedNamespaced"
Write-Host "Orphan references:          $($findings.Count)"

if ($findings.Count -gt 0) {
    Write-Host ""
    Write-Host "=== Orphans ==="
    $findings | Group-Object Skill | Sort-Object Name | ForEach-Object {
        Write-Host ""
        Write-Host "  Skill: $($_.Name)"
        $_.Group | Sort-Object BrokenRef -Unique | ForEach-Object {
            Write-Host "    - $($_.BrokenRef)"
        }
    }
    exit 1
}

Write-Host ""
Write-Host "[OK] All references resolve."
exit 0
