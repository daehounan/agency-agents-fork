# build-ecc-style-package.ps1 - Package the migrated ecc-style agents into a
# standalone installable bundle so ecc plugin users can adopt the agency
# personas without forking this whole repo.
#
# Usage:
#   .\scripts\build-ecc-style-package.ps1                  # build to dist/ecc-style/
#   .\scripts\build-ecc-style-package.ps1 -OutDir custom\path
#   .\scripts\build-ecc-style-package.ps1 -Install         # also copy to ~/.claude/agents/ecc-style/

[CmdletBinding()]
param(
    [string]$OutDir = "",
    [switch]$Install
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$migrated = Join-Path $repoRoot 'integrations\ecc-style'
if (-not (Test-Path $migrated)) {
    Write-Host "[!!] integrations/ecc-style/ not found. Running migrate-ecc.ps1 first..."
    & powershell -NoProfile -File (Join-Path $PSScriptRoot 'migrate-ecc.ps1')
}

if (-not $OutDir) { $OutDir = Join-Path $repoRoot 'dist\ecc-style' }
if (Test-Path $OutDir) { Remove-Item $OutDir -Recurse -Force }
New-Item -Path $OutDir -ItemType Directory -Force | Out-Null

# Copy all migrated agents
$agentDir = Join-Path $OutDir 'agents'
New-Item -Path $agentDir -ItemType Directory -Force | Out-Null
$count = 0
Get-ChildItem $migrated -Filter '*.md' | ForEach-Object {
    Copy-Item $_.FullName (Join-Path $agentDir $_.Name)
    $count++
}

# Generate a minimal plugin.json for the ecc-style bundle
$manifest = [ordered]@{
    name = "agency-agents-ecc-style"
    version = "1.0.0"
    description = "Agency-agents fork personas re-frontmatter'd to ecc plugin convention (lowercase slug name, tools array, model field, PROACTIVELY trigger). $count agents."
    author = [ordered]@{
        name = "andae"
        url = "https://github.com/daehounan"
    }
    license = "MIT"
    keywords = @("claude-code","agents","ecc-style","agency-fork")
    agents = @((Get-ChildItem $agentDir -Filter '*.md' | Sort-Object Name | ForEach-Object { "./agents/$($_.Name)" }))
}
$pluginDir = Join-Path $OutDir '.claude-plugin'
New-Item -Path $pluginDir -ItemType Directory -Force | Out-Null
$json = $manifest | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText((Join-Path $pluginDir 'plugin.json'), $json, [System.Text.UTF8Encoding]::new($false))

# README
$readme = @"
# agency-agents-ecc-style

$count agency-agents personas converted to ecc plugin frontmatter convention:
- lowercase kebab-case `name`
- `tools: [...]` array (division-dependent defaults)
- `model: sonnet|opus` (architects + security + strategy get opus)
- `description` augmented with `Use PROACTIVELY when ...` trigger

## Install (manual)

```powershell
Copy-Item .\agents\*.md `$env:USERPROFILE\.claude\agents\ecc-style\ -Recurse -Force
```

## Install (plugin format)

Point a marketplace.json at this directory. plugin.json is included.

## Origin

Generated from the agency-agents fork via `scripts/migrate-ecc.ps1`.
See [agency-agents-fork](https://github.com/daehounan/agency-agents-fork).
"@
[System.IO.File]::WriteAllText((Join-Path $OutDir 'README.md'), $readme, [System.Text.UTF8Encoding]::new($false))

Write-Host ""
Write-Host "=== Build Summary ==="
Write-Host "Agents packaged: $count"
Write-Host "Output:          $OutDir"
Write-Host "Manifest:        $(Join-Path $pluginDir 'plugin.json')"

if ($Install) {
    $target = Join-Path $env:USERPROFILE '.claude\agents\ecc-style'
    if (-not (Test-Path $target)) { New-Item $target -ItemType Directory -Force | Out-Null }
    Get-ChildItem $agentDir -Filter '*.md' | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $target $_.Name) -Force
    }
    Write-Host "Installed to:    $target"
}
