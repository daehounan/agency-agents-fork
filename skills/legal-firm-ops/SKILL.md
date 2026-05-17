---
name: legal-firm-ops
description: Law firm operations and legal vertical workflows — client intake, conflict screening, time tracking, billing narratives, IOLTA, document review, contract risk flagging. Use when the user works at a law firm and asks about prospect qualification, retainer agreements, billable hour capture, trust accounting, attorney-ready document review, version comparison, or any law-firm-specific operational workflow. Distinct from the engineering legal-compliance-checker — this skill is for in-firm operations, not codebase compliance review.
---

# Legal Firm Operations Routing Skill

When this skill activates, route to the appropriate legal-vertical agent.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Prospect intake, conflict screening, retainer | `legal-client-intake` |
| Time capture, billing narratives, IOLTA, collections | `legal-billing-time-tracking` |
| Contract review, risk flagging, version comparison | `legal-document-review` |
| Codebase / corporate compliance review (NOT firm ops) | use ecc `security-reviewer` or `legal:compliance-check` skill instead |

## When NOT to use

- General legal research / Korean law questions → `korean-legal-engine` skill
- US filings (SEC, USPTO, etc.) → `us-filing-engine` skill
- Personal legal advice → recommend consulting a licensed attorney directly
