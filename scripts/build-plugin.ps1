<#
.SYNOPSIS
    Produce a Claude Code plugin-loader-conformant build in dist/plugin/.

.DESCRIPTION
    Source-of-truth layout in this repo is organized by division (academic/, engineering/, etc.)
    which is friendly for browsing but does NOT match the official plugin spec at
    https://code.claude.com/docs/en/plugins. The spec expects:
      - All agent .md files under a single agents/ directory at plugin root
      - skills/<name>/SKILL.md at plugin root
      - hooks/hooks.json (NOT loose .ps1 files at top of hooks/) declaring matchers
      - .claude-plugin/plugin.json with metadata only (no file lists)

    This script generates that conformant structure into dist/plugin/ without disturbing
    the source. The output is suitable for:
      - Local testing: `claude --plugin-dir ./dist/plugin`
      - Zip-archive testing: scripts/build-plugin.ps1 -Zip -> dist/agency-agents-fork-plugin.zip
      - GitHub Release asset upload
      - Submitting to claude.ai/settings/plugins/submit (point reviewers at dist/plugin/)

    Safe to re-run: dist/plugin/ is wiped and rebuilt every invocation.

.PARAMETER OutDir
    Where to write the plugin. Defaults to 'dist/plugin' (relative to repo root).

.PARAMETER Divisions
    Optional list of divisions to include. When omitted, all 14 are included (163 agents,
    ~22k tokens of agent description — above Claude's recommended 15k budget). Pass a
    subset to reduce the per-turn token overhead.

    Valid: academic, design, engineering, finance, game-development, marketing,
    paid-media, product, project-management, sales, spatial-computing, specialized,
    support, testing.

.PARAMETER Zip
    Also emit dist/agency-agents-fork-plugin.zip after the build. The zip can be served
    over HTTP or file:// and consumed via `claude --plugin-url`.

.PARAMETER Verbose_
    Print each agent/skill as it's copied. (Named with trailing underscore to avoid
    colliding with the built-in -Verbose common parameter.)

.EXAMPLE
    .\scripts\build-plugin.ps1
    Full build: 163 agents + 24 skills + 2 hooks. Prints a token-budget warning since
    descriptions exceed ~15k.

.EXAMPLE
    .\scripts\build-plugin.ps1 -Divisions finance,engineering
    Scoped build: only finance + engineering agents (32 agents total, ~4.5k tokens).
    Plugin name becomes 'agency-agents-fork-engineering-finance'.

.EXAMPLE
    .\scripts\build-plugin.ps1 -Divisions game-development -Zip
    Scoped + zipped: only game-development agents, plus dist/agency-agents-fork-plugin.zip.

.EXAMPLE
    pwsh -NoProfile -File C:\path\to\agency-agents-fork\scripts\build-plugin.ps1
    Run from any cwd via absolute path. The script resolves repo root from its own
    location, not the working directory.

.LINK
    https://github.com/daehounan/agency-agents-fork
#>

[CmdletBinding()]
param(
    [string]$OutDir = 'dist/plugin',
    [string[]]$Divisions,
    [switch]$Zip,
    [switch]$Verbose_
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$outRoot  = Join-Path $repoRoot $OutDir

# === 0. Resolve which divisions to include ===
$allDivisions = @('academic','design','engineering','finance','game-development','marketing','paid-media','product','project-management','sales','spatial-computing','specialized','support','testing')

if ($Divisions) {
    # Accept both array form (-Divisions a,b) AND single-string form (-Divisions "a,b").
    # The latter happens when pwsh -File passes args from another shell. Split on any
    # commas/semicolons/whitespace, lowercase, trim, drop empties.
    $Divisions = $Divisions |
        ForEach-Object { $_ -split '[\s,;]+' } |
        ForEach-Object { $_.Trim().ToLower() } |
        Where-Object { $_ }
    $unknown = $Divisions | Where-Object { $_ -notin $allDivisions }
    if ($unknown) {
        throw "Unknown division(s): $($unknown -join ', '). Valid: $($allDivisions -join ', ')"
    }
    $divisions = $Divisions
    $isSubset = $true
} else {
    $divisions = $allDivisions
    $isSubset = $false
}

# === 1. Clean out dir ===
if (Test-Path $outRoot) {
    Remove-Item $outRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $outRoot -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $outRoot 'agents') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $outRoot 'skills') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $outRoot 'hooks') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $outRoot '.claude-plugin') -Force | Out-Null

# === 2. Flatten agents from selected division dirs to agents/ ===
$agentCount = 0
$seen = @{}
$descTotalChars = 0  # for token estimate

foreach ($d in $divisions) {
    $srcDir = Join-Path $repoRoot $d
    if (-not (Test-Path $srcDir)) { continue }

    Get-ChildItem $srcDir -Filter '*.md' -Recurse | ForEach-Object {
        # Skip non-agent files (no YAML frontmatter on line 1)
        $line1 = (Get-Content $_.FullName -TotalCount 1)
        if (-not ($line1 -and $line1.Trim() -eq '---')) { return }

        $name = $_.Name
        if ($seen.ContainsKey($name)) {
            throw "Filename collision: $name appears in $($seen[$name]) and $($_.FullName.Substring($repoRoot.Length+1))"
        }
        $seen[$name] = $_.FullName.Substring($repoRoot.Length+1)

        $dest = Join-Path $outRoot "agents/$name"
        Copy-Item $_.FullName $dest -Force
        $agentCount++

        # Estimate tokens from the description field (claude reads this for routing)
        $content = [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($false))
        if ($content -match '(?ms)^---\s*\r?\n(.*?)\r?\n---') {
            $fm = $matches[1]
            if ($fm -match '(?m)^description:\s*(.+?)\s*$') {
                $descTotalChars += $matches[1].Length
            }
        }

        if ($Verbose_) { Write-Host "  agent: $name  (from $d)" }
    }
}

# Rough token estimate: ~4 chars per token (English) — under-estimates CJK
$estTokens = [int]($descTotalChars / 4)

# === 3. Copy skills directory verbatim ===
$skillCount = 0
Get-ChildItem (Join-Path $repoRoot 'skills') -Directory | ForEach-Object {
    $skillFile = Join-Path $_.FullName 'SKILL.md'
    if (-not (Test-Path $skillFile)) { return }
    $destSkillDir = Join-Path $outRoot "skills/$($_.Name)"
    New-Item -ItemType Directory -Path $destSkillDir -Force | Out-Null
    Copy-Item $skillFile (Join-Path $destSkillDir 'SKILL.md') -Force
    # Copy any other files alongside SKILL.md (reference docs, scripts dir)
    Get-ChildItem $_.FullName | Where-Object { $_.Name -ne 'SKILL.md' } | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $destSkillDir $_.Name) -Recurse -Force
    }
    $skillCount++
    if ($Verbose_) { Write-Host "  skill: $($_.Name)" }
}

# === 4. Copy hook .ps1 files + generate hooks/hooks.json ===
# The plugin spec wants a hooks/hooks.json declaring matchers + commands.
# Loose .ps1 files at hooks/ top level are NOT auto-discovered.
Get-ChildItem (Join-Path $repoRoot 'hooks') -File | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $outRoot "hooks/$($_.Name)") -Force
    if ($Verbose_) { Write-Host "  hook file: $($_.Name)" }
}

$hooksJson = [ordered]@{
    hooks = [ordered]@{
        UserPromptSubmit = @(
            [ordered]@{
                hooks = @(
                    [ordered]@{
                        type    = 'command'
                        command = 'pwsh -NoProfile -File ${CLAUDE_PLUGIN_ROOT}/hooks/suggest-agents.ps1'
                    }
                )
            }
        )
        PreToolUse = @(
            [ordered]@{
                matcher = 'Skill'
                hooks = @(
                    [ordered]@{
                        type    = 'command'
                        command = 'pwsh -NoProfile -File ${CLAUDE_PLUGIN_ROOT}/hooks/log-skill-fired.ps1'
                    }
                )
            }
        )
    }
}
$hooksJsonPath = Join-Path $outRoot 'hooks/hooks.json'
$hooksJsonStr = ($hooksJson | ConvertTo-Json -Depth 8)
[System.IO.File]::WriteAllText($hooksJsonPath, $hooksJsonStr, [System.Text.UTF8Encoding]::new($false))

# === 5. Generate clean .claude-plugin/plugin.json (metadata only, no file lists) ===
$pluginName = if ($isSubset) { 'agency-agents-fork-' + (($divisions | Sort-Object) -join '-') } else { 'agency-agents-fork' }
$pluginDesc = if ($isSubset) {
    "Scoped build of agency-agents-fork: $agentCount agents from $($divisions -join ', ') + $skillCount routing skills + 2 hooks. Use this when you only need a subset of the 163-agent collection. Built via scripts/build-plugin.ps1 -Divisions $($divisions -join ',')."
} else {
    "163 specialist agent personas across 14 divisions + 24 routing skills + 2 hooks. Korean & Japanese Business Navigators, ecosystem-wide skill duplicates audit. China-market agents excluded. Built from daehounan/agency-agents-fork via scripts/build-plugin.ps1. Heads-up: full bundle agent descriptions sum to ~22k tokens (above Claude's 15k recommended budget) — use -Divisions X,Y,Z to scope down."
}
$pluginJson = [ordered]@{
    name        = $pluginName
    version     = '1.3.0'
    description = $pluginDesc
    author      = [ordered]@{
        name = 'andae'
        url  = 'https://github.com/daehounan'
    }
    homepage    = 'https://github.com/daehounan/agency-agents-fork'
    repository  = 'https://github.com/daehounan/agency-agents-fork'
    license     = 'MIT'
    keywords    = @(
        'claude-code','agents','skills','subagents','routing',
        'korean-business','japanese-business','game-development','xr',
        'spatial-computing','paid-media','sales-methodology',
        'compliance-audit','worldbuilding','agency','powershell'
    )
}
$pluginJsonPath = Join-Path $outRoot '.claude-plugin/plugin.json'
$pluginJsonStr = ($pluginJson | ConvertTo-Json -Depth 6)
[System.IO.File]::WriteAllText($pluginJsonPath, $pluginJsonStr, [System.Text.UTF8Encoding]::new($false))

# === 6. Generate README.md inside dist/plugin/ ===
$buildDate = (Get-Date).ToString('yyyy-MM-dd')
$scopeLine = if ($isSubset) { "**Scope**: $($divisions -join ', ') (scoped subset)" } else { "**Scope**: full (14 divisions)" }
$pluginReadme = @"
# $pluginName (plugin build)

This is the plugin-loader-conformant build of [daehounan/agency-agents-fork](https://github.com/daehounan/agency-agents-fork).

**Generated**: $buildDate via ``scripts/build-plugin.ps1``
**Contents**: $agentCount agents + $skillCount skills + 2 hooks
$scopeLine
**Agent description tokens**: ~$($estTokens.ToString('N0'))

## Install

Local development:
``````
claude --plugin-dir ./dist/plugin
``````

Via plugin marketplace (after the marketplace listing is approved):
``````
/plugin install daehounan/agency-agents-fork
``````

## What's inside

- ``agents/`` — $agentCount flat agent ``.md`` files (originally organized by division in the source repo)
- ``skills/`` — $skillCount routing skill directories, each with ``SKILL.md``
- ``hooks/`` — ``hooks.json`` declaring 2 hooks + the ``.ps1`` scripts they call
- ``.claude-plugin/plugin.json`` — manifest

## Source repo

For the source layout (organized by division), installation scripts, contribution guidelines, and security policy, see https://github.com/daehounan/agency-agents-fork.

## License

MIT. See the source repo's LICENSE file.
"@
$pluginReadmePath = Join-Path $outRoot 'README.md'
[System.IO.File]::WriteAllText($pluginReadmePath, $pluginReadme, [System.Text.UTF8Encoding]::new($false))

# === 7. Optional zip ===
$zipPath = $null
if ($Zip) {
    $zipPath = Join-Path $repoRoot 'dist/agency-agents-fork-plugin.zip'
    if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
    Compress-Archive -Path "$outRoot/*" -DestinationPath $zipPath
}

# === 8. Summary ===
Write-Host ""
Write-Host "=== Plugin build complete ==="
Write-Host "Output:       $outRoot"
Write-Host "Agents:       $agentCount (flat in agents/)"
Write-Host "Skills:       $skillCount (skills/<name>/SKILL.md)"
Write-Host "Hooks:        2 (UserPromptSubmit + PreToolUse:Skill via hooks/hooks.json)"
Write-Host "Manifest:     .claude-plugin/plugin.json (v$($pluginJson.version), name=$($pluginJson.name))"
if ($isSubset) {
    Write-Host "Scope:        $($divisions -join ', ')  (subset of 14 divisions)"
}
Write-Host ""
Write-Host "Token estimate (agent description fields only): ~$($estTokens.ToString('N0')) tokens"
Write-Host "  Note: Claude's own runtime warning fires at ~15,000 cumulative tokens and"
Write-Host "  may count more than just description fields (frontmatter + first body section)."
Write-Host "  Empirically, the full 163-agent bundle reports ~22k at runtime."
if ($estTokens -gt 15000) {
    Write-Host "  [WARN] Description-only estimate already over 15k. Consider -Divisions to scope."
} elseif ($isSubset) {
    Write-Host "  [OK]   Scoped to $($divisions.Count) division(s) — well within runtime budget."
} else {
    Write-Host "  [INFO] Full bundle. If Claude warns at runtime, use -Divisions <list> to slim down."
    Write-Host "         Valid divisions: $($allDivisions -join ', ')"
}
if ($zipPath) { Write-Host ""; Write-Host "Zip:          $zipPath" }
Write-Host ""
Write-Host "Test (absolute path — works from any cwd):"
Write-Host "  claude --plugin-dir $outRoot"
if ($zipPath) {
    Write-Host ""
    Write-Host "Test via zip URL:"
    Write-Host "  claude --plugin-url file://$($zipPath -replace '\\','/')"
}
