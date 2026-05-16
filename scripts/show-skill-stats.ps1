# show-skill-stats.ps1 — Summarize skill-firing telemetry from log-skill-fired.ps1
#
# Reads the JSONL log written by hooks/log-skill-fired.ps1 and prints a ranked
# table of skill activations: count, unique sessions, last-fired timestamp, and
# how recent that last firing was. Useful for spotting dead skills, dominant
# routers, and routing drift.

<#
.SYNOPSIS
    Show skill-firing telemetry collected by the log-skill-fired hook.

.DESCRIPTION
    Reads ~/.claude/agency-agents-fork-skill-firings.jsonl (written by
    hooks/log-skill-fired.ps1) and aggregates it into a sortable table:
    fire count, unique sessions, last-fired timestamp, and recency.

    Use this to identify which routing skills are actually firing, which are
    dormant, and which sessions cluster around the same skill. If the log
    does not exist yet, install the hooks via:
        .\scripts\install.ps1 -WithHooks

.PARAMETER LogPath
    Override the default log path. Defaults to
    ~/.claude/agency-agents-fork-skill-firings.jsonl.

.PARAMETER Days
    Only count firings within the last N days. 0 = all-time (default).

.PARAMETER Top
    Show only the top N skills by count. 0 = show all (default).

.PARAMETER SortBy
    Sort column: Count (default), Recent, Sessions, Skill.

.PARAMETER ShowZero
    Include skills with zero firings — only meaningful when -KnownSkillsDir
    is supplied so the script knows the full catalog.

.PARAMETER KnownSkillsDir
    Directory of installed skills. When present, the report distinguishes
    "fired" vs "dormant" (installed but never fired). Defaults to
    ~/.claude/skills.

.EXAMPLE
    .\scripts\show-skill-stats.ps1
    Show all skill firings, ranked by count, all-time.

.EXAMPLE
    .\scripts\show-skill-stats.ps1 -Days 7 -Top 10
    Top 10 most-fired skills in the last week.

.EXAMPLE
    .\scripts\show-skill-stats.ps1 -ShowZero
    Include installed-but-never-fired skills (dormant detection).

.EXAMPLE
    .\scripts\show-skill-stats.ps1 -SortBy Recent
    Sort by most-recently-fired skill first.

.NOTES
    Telemetry is opt-in via -WithHooks. No data leaves the local machine.
#>

[CmdletBinding()]
param(
    [string]$LogPath = (Join-Path $env:USERPROFILE '.claude/agency-agents-fork-skill-firings.jsonl'),
    [int]$Days = 0,
    [int]$Top = 0,
    [ValidateSet('Count','Recent','Sessions','Skill')]
    [string]$SortBy = 'Count',
    [switch]$ShowZero,
    [string]$KnownSkillsDir = (Join-Path $env:USERPROFILE '.claude/skills')
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $LogPath)) {
    Write-Host "No telemetry log found at: $LogPath"
    Write-Host ""
    Write-Host "To collect data, install the hook:"
    Write-Host "  .\scripts\install.ps1 -WithHooks"
    Write-Host ""
    Write-Host "Then use Claude Code normally — every Skill tool invocation gets logged."
    exit 0
}

# === Parse ===
$cutoff = if ($Days -gt 0) { (Get-Date).AddDays(-$Days) } else { [datetime]::MinValue }

$entries = @()
$parseErrors = 0
Get-Content $LogPath | ForEach-Object {
    if (-not $_) { return }
    try {
        $e = $_ | ConvertFrom-Json
        $ts = [datetime]::Parse($e.ts)
        if ($ts -ge $cutoff) {
            $entries += [PSCustomObject]@{
                Skill = $e.skill
                Session = $e.session
                Ts = $ts
                ArgsPresent = [bool]$e.args_present
            }
        }
    } catch { $parseErrors++ }
}

if ($entries.Count -eq 0) {
    $range = if ($Days -gt 0) { "in last $Days day(s)" } else { 'all-time' }
    Write-Host "No skill firings found ($range)."
    if ($parseErrors -gt 0) { Write-Host "($parseErrors malformed line(s) skipped.)" }
    exit 0
}

# === Aggregate by skill ===
$now = Get-Date
$grouped = $entries | Group-Object Skill | ForEach-Object {
    $sk = $_
    $last = ($sk.Group | Sort-Object Ts -Descending | Select-Object -First 1).Ts
    $sessions = ($sk.Group | Select-Object -ExpandProperty Session -Unique).Count
    $withArgs = ($sk.Group | Where-Object ArgsPresent).Count
    [PSCustomObject]@{
        Skill = $sk.Name
        Count = $sk.Count
        Sessions = $sessions
        WithArgs = $withArgs
        Last = $last
        Recency = (New-TimeSpan -Start $last -End $now)
    }
}

# === Optionally include dormant skills ===
if ($ShowZero -and (Test-Path $KnownSkillsDir)) {
    $fired = $grouped | Select-Object -ExpandProperty Skill
    Get-ChildItem $KnownSkillsDir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.Name -notin $fired) {
            $grouped = @($grouped) + [PSCustomObject]@{
                Skill = $_.Name
                Count = 0
                Sessions = 0
                WithArgs = 0
                Last = $null
                Recency = $null
            }
        }
    }
}

# === Sort + truncate ===
$sorted = switch ($SortBy) {
    'Count'    { $grouped | Sort-Object @{e='Count';desc=$true}, @{e='Last';desc=$true} }
    'Recent'   { $grouped | Sort-Object @{e='Last';desc=$true} }
    'Sessions' { $grouped | Sort-Object @{e='Sessions';desc=$true}, @{e='Count';desc=$true} }
    'Skill'    { $grouped | Sort-Object Skill }
}
if ($Top -gt 0) { $sorted = $sorted | Select-Object -First $Top }

# === Format output ===
function Format-Recency($span) {
    if ($null -eq $span) { return 'never' }
    if ($span.TotalMinutes -lt 60)   { return "{0:N0}m ago" -f $span.TotalMinutes }
    if ($span.TotalHours   -lt 24)   { return "{0:N0}h ago" -f $span.TotalHours }
    if ($span.TotalDays    -lt 30)   { return "{0:N0}d ago" -f $span.TotalDays }
    return "{0:N0}mo ago" -f ($span.TotalDays / 30)
}

$range = if ($Days -gt 0) { "last $Days day(s)" } else { 'all-time' }
Write-Host ""
Write-Host "=== Skill firings ($range) — sorted by $SortBy ==="
Write-Host ""

$rows = $sorted | ForEach-Object {
    [PSCustomObject]@{
        Skill     = $_.Skill
        Count     = $_.Count
        Sessions  = $_.Sessions
        WithArgs  = $_.WithArgs
        LastFired = if ($_.Last) { $_.Last.ToString('yyyy-MM-dd HH:mm') } else { '—' }
        Recency   = Format-Recency $_.Recency
    }
}
$rows | Format-Table -AutoSize

# === Summary ===
$total = ($entries | Measure-Object).Count
$uniqueSkills = ($entries | Select-Object -ExpandProperty Skill -Unique).Count
$uniqueSessions = ($entries | Select-Object -ExpandProperty Session -Unique).Count
Write-Host "Total firings: $total | Distinct skills: $uniqueSkills | Distinct sessions: $uniqueSessions"
if ($parseErrors -gt 0) { Write-Host "Malformed lines skipped: $parseErrors" }
if ($ShowZero) {
    $dormant = ($sorted | Where-Object Count -eq 0).Count
    Write-Host "Dormant (installed, never fired): $dormant"
}
