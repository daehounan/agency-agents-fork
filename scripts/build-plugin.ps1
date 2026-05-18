# build-plugin.ps1 - Produce a Claude Code plugin-loader-conformant build in dist/plugin/
#
# Source-of-truth layout in this repo is organized by division (academic/, engineering/, etc.)
# which is friendly for browsing but does NOT match the official plugin spec at
# https://code.claude.com/docs/en/plugins. The spec expects:
#   - All agent .md files under a single agents/ directory at plugin root
#   - skills/<name>/SKILL.md at plugin root
#   - hooks/hooks.json (NOT loose .ps1 files at the top of hooks/) declaring matchers
#   - .claude-plugin/plugin.json with metadata only (no file lists)
#
# This script generates that conformant structure into dist/plugin/ without disturbing the
# source. The output is suitable for:
#   - Local testing: `claude --plugin-dir ./dist/plugin`
#   - Zip-archive testing: Compress-Archive dist/plugin -> dist/plugin.zip
#   - GitHub Release asset upload
#   - Submitting to claude.ai/settings/plugins/submit (point reviewers at dist/plugin/)
#
# Safe to re-run: dist/plugin/ is wiped and rebuilt every invocation.

[CmdletBinding()]
param(
    [string]$OutDir = 'dist/plugin',
    [switch]$Zip,
    [switch]$Verbose_
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$outRoot  = Join-Path $repoRoot $OutDir

# === 1. Clean out dir ===
if (Test-Path $outRoot) {
    Remove-Item $outRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $outRoot -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $outRoot 'agents') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $outRoot 'skills') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $outRoot 'hooks') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $outRoot '.claude-plugin') -Force | Out-Null

# === 2. Flatten agents from division dirs to agents/ ===
$divisions = @('academic','design','engineering','finance','game-development','marketing','paid-media','product','project-management','sales','spatial-computing','specialized','support','testing')
$agentCount = 0
$seen = @{}

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
        if ($Verbose_) { Write-Host "  agent: $name  (from $d)" }
    }
}

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
$pluginJson = [ordered]@{
    name        = 'agency-agents-fork'
    version     = '1.2.0'
    description = "163 specialist agent personas across 14 divisions + 24 routing skills + 2 hooks. Korean & Japanese Business Navigators, ecosystem-wide skill duplicates audit. China-market agents excluded. Built from daehounan/agency-agents-fork via scripts/build-plugin.ps1."
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
$pluginReadme = @"
# agency-agents-fork (plugin build)

This is the plugin-loader-conformant build of [daehounan/agency-agents-fork](https://github.com/daehounan/agency-agents-fork).

**Generated**: $buildDate via ``scripts/build-plugin.ps1``
**Contents**: $agentCount agents + $skillCount skills + 2 hooks

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
Write-Host "Manifest:     .claude-plugin/plugin.json (v$($pluginJson.version))"
if ($zipPath) { Write-Host "Zip:          $zipPath" }
Write-Host ""
Write-Host "Test (absolute path — works from any cwd):"
Write-Host "  claude --plugin-dir $outRoot"
if ($zipPath) {
    Write-Host ""
    Write-Host "Test via zip URL:"
    Write-Host "  claude --plugin-url file://$($zipPath -replace '\\','/')"
}
