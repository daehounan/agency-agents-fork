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
    # === Cultural / business ===
    @{ Pattern = '(?i)\b(품의|nunchi|눈치|카카오톡 비즈|회식|결재라인|소주.*비즈|한국 거래처|korean business|chaebol)\b'; Agent = 'specialized-korean-business-navigator'; Skill = 'korean-business' }
    @{ Pattern = '(?i)(稟議|根回し|nemawashi|空気を読む|名刺交換|飲み会|接待|報連相|hou-?ren-?sou|japanese business|日本 取引先|商習慣)'; Agent = 'specialized-japanese-business-navigator'; Skill = 'japanese-business' }
    @{ Pattern = '(?i)\b(portage salarial|ESN consulting|Malt freelance|French consulting market|cultural intelligence strategist|intersectional representation|Spanish.*English translation|Castilian|Latin American Spanish)\b'; Agent = ''; Skill = 'localization-cultural' }

    # === Engineering / niches ===
    @{ Pattern = '(?i)\b(Vision Pro|visionOS|WebXR|ARKit|RealityKit|spatial UI|hand tracking|immersive cockpit)\b'; Agent = ''; Skill = 'xr-spatial-routing' }
    @{ Pattern = '(?i)\b(Unity ECS|ScriptableObject|Shader Graph|Netcode for GameObjects|Unreal.*Blueprint|GAS|Niagara|World Partition|Godot.*GDScript|Roblox.*Luau|RemoteEvent|DataStore|FMOD|Wwise)\b'; Agent = ''; Skill = 'game-development-routing' }
    @{ Pattern = '(?i)\b(ESP32|STM32|Nordic nRF|FreeRTOS|Zephyr|bare-metal firmware|Whisper.*ASR|speech to text pipeline|speaker diarization|email.*MIME|SIEM rule|MITRE ATT&CK|threat hunting|WordPress plugin|Drupal module|data remediation pipeline|LLM routing|shadow testing)\b'; Agent = ''; Skill = 'niche-engineering-routing' }
    @{ Pattern = '(?i)\b(frontend developer|backend architect|mobile app builder|rapid prototyper|database optimizer|SRE|incident commander|software architect|DevOps automator|code reviewer)\b'; Agent = ''; Skill = 'general-engineering-routing' }

    # === Marketing / sales / paid media ===
    @{ Pattern = '(?i)\b(Google Ads|Microsoft Ads|Meta Ads|Performance Max|PMax|RSA copy|programmatic DSP|paid social|GTM.*conversion|GA4.*conversion|CAPI|ROAS|CPA optimization)\b'; Agent = ''; Skill = 'paid-media-routing' }
    @{ Pattern = '(?i)\b(Twitter strategy|X.com.*viral|TikTok algorithm|Instagram aesthetic|Reddit community|LinkedIn thought leadership|carousel.*Instagram|YouTube algorithm|app store optimization|ASO|AEO|GEO|AI citation|ChatGPT visibility)\b'; Agent = ''; Skill = 'social-platform-routing' }
    @{ Pattern = '(?i)\b(MEDDPICC|SPIN selling|Gap Selling|Sandler|discovery call|deal qualification|forecast accuracy|win plan|RFP response|sales coaching|QBR|NRR growth|land and expand)\b'; Agent = ''; Skill = 'sales-methodology-routing' }

    # === Verticals / operations ===
    @{ Pattern = '(?i)\b(IOLTA|retainer agreement|conflict screening|billable hour.*narrative|legal client intake|contract review.*risk flag)\b'; Agent = ''; Skill = 'legal-firm-ops' }
    @{ Pattern = '(?i)\b(TRID|loan officer|MLS listing|escrow|closing disclosure|FHA loan|VA loan|buyer.?s agent|listing agreement)\b'; Agent = ''; Skill = 'real-estate-mortgage' }
    @{ Pattern = '(?i)\b(patient support.*billing|HIPAA.*service|hotel guest service|concierge|hospitality complaint|retail return|exchange.*refund|loyalty program)\b'; Agent = ''; Skill = 'customer-service-vertical' }
    @{ Pattern = '(?i)\b(three-?statement model|DCF valuation|equity research|due diligence.*portfolio|transfer pricing|ETR|FP&A|rolling forecast|variance analysis|GAAP.*close)\b'; Agent = ''; Skill = 'finance-analysis' }

    # === Compliance / audit ===
    @{ Pattern = '(?i)\b(SOC ?2|ISO 27001|HIPAA audit|PCI-?DSS|smart contract audit|gas optimization audit|DeFi audit|reentrancy|n8n governance|automation audit|RACI matrix)\b'; Agent = ''; Skill = 'compliance-audit-routing' }
    @{ Pattern = '(?i)\b(WCAG|screen reader|axe-core|accessibility audit|ARIA)\b'; Agent = 'testing-accessibility-auditor'; Skill = 'qa-testing-routing' }
    @{ Pattern = '(?i)\b(visual regression|screenshot evidence|production readiness certification|reality check.*release|performance benchmark|load test|API endpoint test|tool evaluation)\b'; Agent = ''; Skill = 'qa-testing-routing' }

    # === Knowledge / strategy / orchestration ===
    @{ Pattern = '(?i)\b(NEXUS|multi-agent orchestration|agency engagement|phased strategic project|discovery phase|hardening phase|agent coordination matrix|quality gate|handoff protocol)\b'; Agent = ''; Skill = 'strategy-nexus' }
    @{ Pattern = '(?i)\b(Zettelkasten|atomic notes|knowledge graph|document generator.*chart|PPTX from code|DOCX from data|enterprise training curriculum|blended learning)\b'; Agent = ''; Skill = 'knowledge-content-routing' }
    @{ Pattern = '(?i)\b(agent orchestrator|LSP.*semantic indexing|MCP server build|agent identity.*authentication|identity graph.*entity resolution)\b'; Agent = ''; Skill = 'ai-infra-routing' }

    # === Worldbuilding / academic ===
    @{ Pattern = '(?i)\b(world ?building|fictional culture|kinship system|narratology|Campbell.*hero|fantasy geography|character arc|psychological credibility)\b'; Agent = ''; Skill = 'worldbuilding-rigor' }

    # === Design / product / PM / support ===
    @{ Pattern = '(?i)\b(UI design.*component library|design system foundation|brand identity guideline|visual storytelling|whimsy.*delight|Midjourney prompt|Stable Diffusion prompt|inclusive imagery|representation in AI image)\b'; Agent = ''; Skill = 'design-routing' }
    @{ Pattern = '(?i)\b(sprint prioritization|RICE.*scoring|ICE.*scoring|behavioral nudge|habit loop.*engagement|product roadmap.*GTM|feedback synthesizer)\b'; Agent = ''; Skill = 'product-discovery-routing' }
    @{ Pattern = '(?i)\b(studio producer|project shepherd|studio operations|experiment tracker.*A.B|spec to tasks|Jira.*Git workflow steward|conventional commits enforcement)\b'; Agent = ''; Skill = 'project-management-routing' }
    @{ Pattern = '(?i)\b(executive summary.*C-?suite|board memo|business financial planning|infrastructure maintainer|Salesforce architect|civil engineer.*structural|model QA.*ML|accounts payable.*automation)\b'; Agent = ''; Skill = 'support-routing' }
    @{ Pattern = '(?i)\b(sales data extraction.*Excel|MTD.*YTD|territory consolidation|automated report distribution)\b'; Agent = ''; Skill = 'data-ops-routing' }

    # === Roster discovery ===
    @{ Pattern = '(?i)\b(what agents do I have|which agent should I use|list.*available specialists|show me the agent roster|browse capabilities|agency roster)\b'; Agent = ''; Skill = 'agency-roster' }
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
