---
name: compliance-audit-routing
description: Compliance, audit, and governance specialist routing for SOC 2, ISO 27001, HIPAA, PCI-DSS, smart contract security, and business automation governance. Use when the user asks about preparing for a SOC 2 audit, building evidence collection for ISO 27001, smart contract security audit (Solidity / EVM vulnerabilities), gas optimization review, DeFi protocol audit, n8n / business automation risk assessment, or audit governance frameworks. Triggers on SOC 2, ISO 27001, HIPAA audit, PCI-DSS, smart contract audit, blockchain audit, gas optimization, DeFi audit, reentrancy, n8n governance, automation audit, RACI, control framework.
---

# Compliance & Audit Routing Skill

When this skill activates, route based on the compliance domain.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| SOC 2 / ISO 27001 / HIPAA / PCI-DSS readiness, evidence, certification | `compliance-auditor` |
| Smart contract security audit, exploit analysis, gas optimization, DeFi | `blockchain-security-auditor` |
| Business automation governance, n8n audit, workflow risk assessment | `automation-governance-architect` |

## Complementary

- General codebase security review → `ecc:security-review` skill
- Threat detection rules (SIEM/MITRE) → `niche-engineering-routing` skill
- Legal compliance review (contracts) → `legal:compliance-check` skill
- DeFi-specific AMM security patterns → `ecc:defi-amm-security` skill

## When NOT to use

- Internal audit support (financial close, SOX) → `finance:sox-testing` / `finance:audit-support` skills
- General PHI handling in code → `ecc:hipaa-compliance` / `ecc:healthcare-phi-compliance` skills
- One-off contract risk flag in a law firm → `legal-firm-ops` skill
