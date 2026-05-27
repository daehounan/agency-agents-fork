<#
.SYNOPSIS
    Estimate token cost of agency-agents descriptions at install time.

.DESCRIPTION
    Walks division directories and skills/ to extract YAML frontmatter descriptions,
    then estimates tokens using a ~4-chars-per-token heuristic. Outputs a markdown
    table with per-division agent count, description tokens, and a grand total.

    Note: This estimates ROUTING tokens (descriptions loaded at Claude Code startup).
    Body tokens load on-demand and are not counted. Real token cost may vary ±30% due
    to tokenizer differences (this uses a simple char-count heuristic, not tiktoken).

    Strategy playbooks (in strategy/) have no frontmatter and are excluded from counts.

.PARAMETER Out
    Optional file path to write the markdown table. If omitted, output to stdout only.

.PARAMETER Divisions
    Restrict tokenization to a list of divisions. Mirrors install.ps1's -Divisions
    for UX parity. Accepts comma, semicolon, or whitespace separators:
        -Divisions finance,engineering
        -Divisions "finance;engineering"
        -Divisions finance engineering
    If omitted, all 15 division directories are processed.

.EXAMPLE
    .\scripts\estimate-tokens.ps1
    Output token estimate table to stdout.

.EXAMPLE
    .\scripts\estimate-tokens.ps1 -Out docs\TOKEN-BUDGET.md
    Write table to docs/TOKEN-BUDGET.md.

.EXAMPLE
    .\scripts\estimate-tokens.ps1 -Divisions engineering,finance
    Estimate tokens only for engineering + finance divisions.

.LINK
    https://github.com/daehounan/agency-agents-fork
#>

[CmdletBinding()]
param(
    [string]$Out = '',
    [string[]]$Divisions
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$allDivisions = @(
    'academic','design','engineering','finance','game-development',
    'marketing','paid-media','product','project-management','sales',
    'spatial-computing','specialized','strategy','support','testing'
)

# === Resolve divisions ===
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
    $toProcess = $expanded
} else {
    $toProcess = $allDivisions
}

# === Extract YAML frontmatter description ===
function Extract-Description {
    param([string]$FilePath)

    if (-not (Test-Path $FilePath)) { return '' }

    $content = [System.IO.File]::ReadAllText($FilePath, [System.Text.UTF8Encoding]::new($false))

    # Match YAML frontmatter block: ---\n ... \n---
    if ($content -match '(?sm)^---\s*\r?\n(.+?)\r?\n---') {
        $frontmatter = $matches[1]

        # Match description field — handle quoted, literal (|), and folded (>-)
        if ($frontmatter -match '(?m)^description:\s*"([^"]+)"') {
            # Quoted single-line
            $desc = $matches[1]
        } elseif ($frontmatter -match '(?sm)^description:\s*\|\s*\r?\n((?:.*\r?\n)*?)(?=^[a-z]|$)') {
            # Literal block |
            $desc = $matches[1]
        } elseif ($frontmatter -match '(?sm)^description:\s*>-\s*\r?\n((?:.*\r?\n)*?)(?=^[a-z]|$)') {
            # Folded block >-
            $desc = $matches[1]
        } elseif ($frontmatter -match '(?m)^description:\s*(.+)$') {
            # Plain unquoted
            $desc = $matches[1]
        } else {
            return ''
        }

        # Trim and collapse multi-line whitespace
        $desc = $desc -replace '(?m)^\s+', ''
        $desc = $desc -replace '\s+', ' '
        $desc = $desc -replace '^\s+|\s+$', ''

        return $desc
    }

    return ''
}

# === Calculate tokens (heuristic: ~4 chars per token) ===
function Estimate-Tokens {
    param([string]$Text)

    if ([string]::IsNullOrWhiteSpace($Text)) { return 0 }
    # Remove markdown and punctuation for more accurate char count
    $cleaned = $text -replace '[\*`_\[\](){}\\]', ''
    return [Math]::Ceiling($cleaned.Length / 4)
}

# === Process divisions ===
$divisionResults = @()
$totalAgents = 0
$totalTokens = 0

foreach ($div in $toProcess) {
    $divPath = Join-Path $repoRoot $div

    if (-not (Test-Path $divPath)) {
        continue
    }

    $divAgents = @()
    $divTokens = 0

    Get-ChildItem $divPath -Filter '*.md' -Recurse | ForEach-Object {
        $desc = Extract-Description $_.FullName
        if ($desc) {
            $tokens = Estimate-Tokens $desc
            $divTokens += $tokens
            $divAgents += $null  # Count the agent
        }
    }

    $agentCount = @($divAgents).Count
    $totalAgents += $agentCount
    $totalTokens += $divTokens

    $divisionResults += [PSCustomObject]@{
        Division = $div
        Agents = $agentCount
        Tokens = $divTokens
    }
}

# === Process skills ===
$skillsPath = Join-Path $repoRoot 'skills'
$skillTokens = 0
$skillCount = 0

if (Test-Path $skillsPath) {
    Get-ChildItem $skillsPath -Directory | ForEach-Object {
        $skillFile = Join-Path $_.FullName 'SKILL.md'
        if (Test-Path $skillFile) {
            $desc = Extract-Description $skillFile
            if ($desc) {
                $tokens = Estimate-Tokens $desc
                $skillTokens += $tokens
                $skillCount++
            }
        }
    }
}

$totalTokens += $skillTokens

# === Build markdown table ===
$tableLines = @()
$tableLines += '| Division | Agents | Routing Tokens |'
$tableLines += '|----------|--------|----------------|'

foreach ($result in $divisionResults | Sort-Object Division) {
    $tableLines += "| $($result.Division) | $($result.Agents) | $($result.Tokens) |"
}

if ($skillCount -gt 0) {
    $tableLines += "| **skills/** | $skillCount | $skillTokens |"
}

$tableLines += '|----------|--------|----------------|'
$tableLines += "| **TOTAL** | **$($totalAgents + $skillCount)** | **$totalTokens** |"

$table = $tableLines -join "`n"

# === Output ===
Write-Host $table

if ($Out) {
    [System.IO.File]::WriteAllText($Out, $table, [System.Text.UTF8Encoding]::new($false))
    Write-Host ""
    Write-Host "[OK] Written to: $Out"
}

# === Summary ===
Write-Host ""
Write-Host "Total agents: $totalAgents | Skills: $skillCount | Estimated routing tokens: $totalTokens"
