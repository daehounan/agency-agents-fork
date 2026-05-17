# Overlap Map: Fork agents vs existing ecc plugins / Anthropic skills

Generated 2026-05-15. Use this to decide which fork agents to install vs which to skip because you already have a stronger equivalent.

**Legend**
- 🔴 **High overlap** — existing tool is stronger / more current; skip the fork agent.
- 🟡 **Partial overlap** — fork agent adds something (persona, deliverable templates, China-free angle); cherry-pick.
- 🟢 **No overlap (net new)** — install the fork agent; nothing equivalent in current setup.

## Engineering (27 agents)

| Fork Agent | Overlap | Existing equivalent | Recommendation |
|---|---|---|---|
| engineering-frontend-developer | 🔴 | `vercel:react-best-practices`, `ecc:frontend-patterns`, `ecc:nextjs-turbopack` | Skip |
| engineering-backend-architect | 🔴 | `ecc:api-design`, `ecc:backend-patterns`, `ecc:architect` agent | Skip |
| engineering-mobile-app-builder | 🟡 | `vercel:react-native-skills`, `ecc:flutter-reviewer` | Cherry-pick (covers RN+Flutter+iOS together) |
| engineering-ai-engineer | 🔴 | `ecc:ai-first-engineering`, `ecc:claude-api` | Skip |
| engineering-devops-automator | 🟡 | `vercel:deployments-cicd`, `ecc:deployment-patterns` | Cherry-pick if you want generic DevOps not Vercel-bound |
| engineering-rapid-prototyper | 🟢 | none | Install |
| engineering-senior-developer | 🟡 | overlaps `ecc:laravel-patterns` (Laravel-specific) | Skip if not Laravel |
| engineering-filament-optimization-specialist | 🟢 | none | Install if you use Filament PHP |
| engineering-security-engineer | 🔴 | `ecc:security-review`, `security-reviewer` agent, `ecc:security-bounty-hunter` | Skip |
| engineering-autonomous-optimization-architect | 🟢 | none directly (loose tie to `ecc:cost-aware-llm-pipeline`) | Install |
| engineering-embedded-firmware-engineer | 🟢 | none | Install |
| engineering-incident-response-commander | 🟡 | `engineering:incident-response` skill | Skip (Anthropic skill is current) |
| engineering-solidity-smart-contract-engineer | 🟡 | `ecc:defi-amm-security`, `ecc:evm-token-decimals` | Cherry-pick (broader Solidity coverage) |
| engineering-codebase-onboarding-engineer | 🔴 | `ecc:codebase-onboarding` skill | Skip |
| engineering-technical-writer | 🟡 | `engineering:documentation` skill, `ecc:doc-updater` agent | Cherry-pick |
| engineering-threat-detection-engineer | 🟢 | none (security-reviewer is appsec, this is SOC/SIEM) | Install |
| engineering-code-reviewer | 🔴 | `ecc:code-reviewer` agent, all language-specific `ecc:*-reviewer` | Skip |
| engineering-database-optimizer | 🔴 | `ecc:database-reviewer` agent, `ecc:postgres-patterns` | Skip |
| engineering-git-workflow-master | 🟡 | `ecc:git-workflow` skill | Skip |
| engineering-software-architect | 🔴 | `ecc:architect` agent, `ecc:architecture-decision-records` | Skip |
| engineering-sre | 🟢 | none | Install |
| engineering-ai-data-remediation-engineer | 🟢 | none | Install |
| engineering-data-engineer | 🟡 | `data:*` skills (mostly analytics, not pipeline) | Install |
| engineering-cms-developer | 🟢 | none (WordPress/Drupal specialist) | Install |
| engineering-email-intelligence-engineer | 🟢 | none | Install |
| engineering-voice-ai-integration-engineer | 🟢 | none | Install |

**Suggested engineering install** (12): rapid-prototyper, filament-optimization, autonomous-optimization-architect, embedded-firmware, threat-detection, sre, ai-data-remediation, data-engineer, cms-developer, email-intelligence, voice-ai-integration, mobile-app-builder.

## Design (8) — mostly net new

All 🟢 except brand-guardian (🟡 overlaps `brand-voice:*` skills). **Install all 7-8.**

## Marketing (15 after exclusion)

| Fork Agent | Overlap | Note |
|---|---|---|
| growth-hacker | 🟡 | partial overlap with `marketing:campaign-plan` |
| content-creator | 🔴 | `marketing:content-creation`, `marketing:draft-content` |
| twitter-engager | 🟢 | install |
| tiktok-strategist | 🟢 | install |
| instagram-curator | 🟢 | install |
| reddit-community-builder | 🟢 | install |
| app-store-optimizer | 🟢 | install |
| social-media-strategist | 🟡 | partial overlap with marketing skills |
| linkedin-content-creator | 🟢 | install |
| seo-specialist | 🟡 | `marketing:seo-audit`, `ecc:seo` |
| book-co-author | 🟢 | install |
| ai-citation-strategist | 🟢 | install (AEO/GEO is novel) |
| video-optimization-specialist | 🟢 | install (YouTube focus) |
| carousel-growth-engine | 🟢 | install |
| affiliate-marketing? | — | not in list |

**Suggested marketing install**: 11–12 net-new social/platform specialists.

## Sales (8)

| Fork Agent | Overlap | Note |
|---|---|---|
| outbound-strategist | 🟡 | `sales:draft-outreach`, `common-room:compose-outreach` |
| discovery-coach | 🟢 | install |
| deal-strategist | 🟢 | install (MEDDPICC) |
| sales-engineer | 🟢 | install |
| proposal-strategist | 🟢 | install |
| pipeline-analyst | 🟡 | `sales:pipeline-review`, `sales:forecast` |
| account-strategist | 🟡 | `common-room:generate-account-plan` |
| sales-coach | 🟢 | install |

**Suggested**: 5–6 install.

## Specialized (36) — many net new

| Fork Agent | Recommendation |
|---|---|
| agents-orchestrator | 🔴 skip — `ecc:autonomous-agent-harness`, swarm coordinator |
| lsp-index-engineer | 🟢 install |
| sales-data-extraction-agent | 🟢 install |
| data-consolidation-agent | 🟢 install |
| report-distribution-agent | 🟢 install |
| agentic-identity-trust | 🟢 install |
| identity-graph-operator | 🟢 install |
| accounts-payable-agent | 🟢 install |
| blockchain-security-auditor | 🟢 install |
| compliance-auditor | 🟡 partial overlap `operations:compliance-tracking` |
| cultural-intelligence-strategist | 🟢 install |
| developer-advocate | 🟢 install |
| model-qa | 🟢 install |
| zk-steward | 🟢 install |
| mcp-builder | 🔴 `ecc:mcp-server-patterns`, `anthropic-skills:mcp-builder` |
| document-generator | 🟢 install |
| automation-governance-architect | 🟢 install |
| corporate-training-designer | 🟢 install |
| workflow-architect | 🟡 |
| salesforce-architect | 🟢 install |
| french-consulting-market | 🟢 install (unique vertical) |
| korean-business-navigator | 🟢 install — **directly relevant to your context** |
| civil-engineer | 🟢 install |
| customer-service | 🟢 install |
| healthcare-customer-service | 🟢 install |
| hospitality-guest-services | 🟢 install |
| hr-onboarding | 🟡 `human-resources:onboarding` |
| language-translator | 🟢 install |
| legal-billing-time-tracking | 🟢 install |
| legal-client-intake | 🟢 install |
| legal-document-review | 🟡 `legal:review-contract`, `legal:legal-response` |
| loan-officer-assistant | 🟢 install |
| real-estate-buyer-seller | 🟢 install |
| retail-customer-returns | 🟢 install |
| sales-outreach | 🟡 same as sales/outbound-strategist |

**Suggested**: 25+ install — this is the highest-value division.

## Net-new divisions (install whole)

| Division | Count | Reason |
|---|---|---|
| academic | 5 | No equivalent — niche scholarly personas |
| game-development | 20 | No game-dev coverage in current setup |
| spatial-computing | 6 | No XR coverage |
| finance | 5 | Stronger than current `finance:*` skills (which are accounting-process focused) |
| strategy | 16 | Mostly business strategy, no equivalent |
| paid-media | 7 | No equivalent — `marketing:*` skills are organic-only |

## Recommended total install

- **Net-new divisions** (5 above): ~59 agents
- **Cherry-picks from overlapping divisions**: ~45 agents
- **Total recommendation**: ~100 of 163 agents
- **Skip**: ~63 that duplicate ecc/Anthropic skills

## Install commands

```powershell
# Install net-new divisions in full
.\scripts\install.ps1 -Division academic
.\scripts\install.ps1 -Division game-development
.\scripts\install.ps1 -Division spatial-computing
.\scripts\install.ps1 -Division finance
.\scripts\install.ps1 -Division strategy
.\scripts\install.ps1 -Division paid-media

# For partial divisions, install all then manually delete duplicates,
# or copy individual files:
Copy-Item .\specialized\specialized-korean-business-navigator.md $env:USERPROFILE\.claude\agents\
```
