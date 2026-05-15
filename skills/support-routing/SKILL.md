---
name: support-routing
description: Business support specialist routing for customer support operations, analytics reporting, finance tracking, infrastructure maintenance, legal compliance review, and executive summary generation. Use when the user asks about multi-channel support operations, building dashboards and KPI reports, business financial planning and cash flow, system reliability and infrastructure operations, regulatory compliance and legal review, or generating C-suite executive summaries. Triggers on support operations, ticket queue, NPS, CSAT, dashboard, KPI report, analytics report, business financial planning, cash flow, budget, infrastructure maintenance, system reliability, regulatory compliance, legal review, executive summary, board memo.
---

# Support & Operations Routing Skill

When this skill activates, route based on the support function.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Multi-channel customer support, issue resolution, retention | `support-support-responder` |
| Dashboards, KPI tracking, BI / analytics reports | `support-analytics-reporter` |
| Business financial planning, budget, cash flow analysis | `support-finance-tracker` |
| System reliability, infrastructure ops, monitoring | `support-infrastructure-maintainer` |
| Legal compliance, regulations, risk review | `support-legal-compliance-checker` |
| C-suite executive summary, strategic communication | `support-executive-summary-generator` |
| Accounts payable processing, vendor payments, audit trail | `accounts-payable-agent` |
| Developer advocacy, community building, DX | `specialized-developer-advocate` |
| ML model QA, audit, interpretability | `specialized-model-qa` |
| Salesforce architecture, multi-cloud design, governor limits | `specialized-salesforce-architect` |
| Civil / structural engineering, building codes | `specialized-civil-engineer` |
| HR onboarding, 30-60-90 day plans | `hr-onboarding` |

## Complementary skills

- C-suite executive briefs → `anthropic-skills:executive-outreach` or `internal-comms` skill
- Status reports → `operations:status-report`
- Capacity planning → `operations:capacity-plan`
- Process documentation → `operations:process-doc`
- Runbooks → `operations:runbook`
- Vendor review → `operations:vendor-review`
- Risk assessment → `operations:risk-assessment`
- Change request → `operations:change-request`
- HR comp / offer / interview prep → `human-resources:*` skills
- Analytics & dashboards (data domain) → `data:build-dashboard`, `data:create-viz`

## When NOT to use

- Customer service in a specific industry (healthcare / hospitality / retail) → `customer-service-vertical` skill
- Bookkeeping, FP&A, investment research → `finance-analysis` skill (different from `support-finance-tracker` which is broader business finance)
- Legal firm operations (intake/billing/document review) → `legal-firm-ops` skill
- Strategic engagement orchestration → `strategy-nexus` skill
