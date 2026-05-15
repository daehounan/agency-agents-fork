---
name: compliance-audit-routing
description: Two niche audit specialists not covered by existing operations/finance/ecc skills — smart contract security audit (Solidity / EVM / DeFi) and business automation governance (n8n workflow auditing). Use when the user asks about smart contract audit, reentrancy / oracle manipulation / gas optimization in DeFi, or evaluating and governing n8n / Zapier / business automation workflows at scale. For SOC 2 / ISO 27001 / HIPAA / PCI-DSS / SOX, prefer existing skills. Triggers on smart contract audit, blockchain audit, gas optimization audit, DeFi audit, reentrancy, oracle manipulation, n8n governance, workflow audit, automation governance.
---

# Compliance & Audit Routing Skill (Niche)

**Scope intentionally narrow.** For mainstream compliance work use existing skills:
- SOC 2 / ISO 27001 / HIPAA / PCI-DSS evidence collection → `operations:compliance-tracking` + `anthropic-skills:security-audit-engine`
- Financial audit / SOX testing / audit support → `finance:audit-support` + `finance:sox-testing`
- General codebase security review → `ecc:security-review` + `ecc:security-scan`
- HIPAA in code → `ecc:hipaa-compliance` / `ecc:healthcare-phi-compliance`
- Legal compliance check → `legal:compliance-check`
- Operational risk assessment → `operations:risk-assessment`
- Vendor compliance review → `operations:vendor-review`
- Bounty / vulnerability hunting → `ecc:security-bounty-hunter`

## When to use THIS skill

Only when the audit work is one of these two niches:

| User signal | Agent to invoke |
|---|---|
| Solidity / EVM / DeFi smart contract audit, exploit analysis, gas optimization, reentrancy, oracle manipulation | `blockchain-security-auditor` |
| n8n / Zapier / business automation workflow governance, value/risk/maintainability assessment | `automation-governance-architect` |

For both: complementary deep skills are `ecc:defi-amm-security` (DeFi-specific patterns), `ecc:evm-token-decimals` (EVM token math), and `ecc:automation-audit-ops` (automation ops).

## When NOT to use

Anything that maps cleanly to a SOC 2 / SOX / HIPAA / generic security workflow → use the dedicated skills above.
