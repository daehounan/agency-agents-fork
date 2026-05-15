# suggest-agents.ps1 — UserPromptSubmit hook
#
# Scans the incoming user prompt for high-confidence keyword matches against
# the agency-agents fork's specialist roster, and outputs a brief reminder
# to the main Claude assistant suggesting which agents could be delegated to.
#
# Activation: add to ~/.claude/settings.json:
#
#   {
#     "hooks": {
#       "UserPromptSubmit": [
#         {
#           "command": "pwsh -NoProfile -File C:/Users/andae/Projects/agency-agents-fork/hooks/suggest-agents.ps1",
#           "description": "Suggest agency-agents specialists for matching prompts"
#         }
#       ]
#     }
#   }
#
# Stdin: { "prompt": "...", "session_id": "...", ... }
# Stdout: text appended as additional context to the assistant
#
# Philosophy:
#   - HIGH confidence only — false positives are worse than misses
#   - Single match preferred; if 3+ match, suggest the routing skill instead of listing every agent
#   - Silent (no stdout) when no match → zero noise on unrelated prompts

$ErrorActionPreference = 'SilentlyContinue'

# Read stdin
$inputData = [Console]::In.ReadToEnd()
if (-not $inputData) { exit 0 }

try {
    $payload = $inputData | ConvertFrom-Json
    $prompt = $payload.prompt
} catch {
    exit 0
}

if (-not $prompt -or $prompt.Length -lt 10) { exit 0 }

# Trigger table — keyword pattern -> { agent slug, routing skill }
# Order matters: more specific patterns first
$triggers = @(
    @{ Pattern = '(?i)\b(품의|nunchi|눈치|카카오톡 비즈|회식|결재라인|소주.*비즈|한국 거래처|korean business|chaebol)\b'; Agent = 'specialized-korean-business-navigator'; Skill = 'korean-business' }
    @{ Pattern = '(?i)(稟議|根回し|nemawashi|空気を読む|名刺交換|飲み会|接待|報連相|hou-?ren-?sou|japanese business|日本 取引先|商習慣)'; Agent = 'specialized-japanese-business-navigator'; Skill = 'japanese-business' }
    @{ Pattern = '(?i)\b(Vision Pro|visionOS|WebXR|ARKit|RealityKit|spatial UI|hand tracking|immersive cockpit)\b'; Agent = ''; Skill = 'xr-spatial-routing' }
    @{ Pattern = '(?i)\b(Unity ECS|ScriptableObject|Shader Graph|Netcode for GameObjects|Unreal.*Blueprint|GAS|Niagara|World Partition|Godot.*GDScript|Roblox.*Luau|RemoteEvent|DataStore|FMOD|Wwise)\b'; Agent = ''; Skill = 'game-development-routing' }
    @{ Pattern = '(?i)\b(Google Ads|Microsoft Ads|Meta Ads|Performance Max|PMax|RSA copy|programmatic DSP|paid social|GTM.*conversion|GA4.*conversion|CAPI|ROAS|CPA optimization)\b'; Agent = ''; Skill = 'paid-media-routing' }
    @{ Pattern = '(?i)\b(IOLTA|retainer agreement|conflict screening|billable hour.*narrative|legal client intake|TRID|loan officer|MLS listing|escrow|closing disclosure)\b'; Agent = ''; Skill = 'real-estate-mortgage' }
    @{ Pattern = '(?i)\b(three-?statement model|DCF valuation|equity research|due diligence.*portfolio|transfer pricing|ETR|FP&A|rolling forecast|variance analysis|GAAP.*close)\b'; Agent = ''; Skill = 'finance-analysis' }
    @{ Pattern = '(?i)\b(world ?building|fictional culture|kinship system|narratology|Campbell.*hero|fantasy geography|character arc|psychological credibility)\b'; Agent = ''; Skill = 'worldbuilding-rigor' }
    @{ Pattern = '(?i)\b(WCAG|screen reader|axe-core|accessibility audit|ARIA)\b'; Agent = 'accessibility-auditor'; Skill = '' }
    @{ Pattern = '(?i)\b(SLO|error budget|chaos engineering|toil reduction|incident commander|postmortem)\b'; Agent = 'sre-site-reliability-engineer'; Skill = '' }
)

$matches = @()
foreach ($t in $triggers) {
    if ($prompt -match $t.Pattern) {
        $matches += $t
    }
}

if ($matches.Count -eq 0) { exit 0 }

# Compose hint
$lines = @()
$lines += "[agency-agents hint] The user prompt matched specialist triggers:"
foreach ($m in $matches | Select-Object -First 3) {
    if ($m.Skill) {
        $lines += "  - Skill: $($m.Skill) (handles routing across multiple agents)"
    } elseif ($m.Agent) {
        $lines += "  - Agent: $($m.Agent)"
    }
}
$lines += "Consider delegating via the Agent tool if the task warrants specialist depth. Silent if user clearly handles it themselves."

$out = $lines -join "`n"
Write-Output $out
exit 0
