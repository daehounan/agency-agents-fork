---
name: sales-methodology-routing
description: B2B sales methodology specialist routing — SPIN, Gap Selling, Sandler, MEDDPICC, discovery, deal qualification, technical pre-sales, proposal craft, pipeline analysis, account expansion, and rep coaching. Use when the user asks about preparing for a discovery call, scoring an opportunity, exposing deal risk, writing a proposal that persuades, qualifying with MEDDPICC, building outbound sequences with personalization, planning account expansion, or coaching a rep. Triggers on MEDDPICC, SPIN, Sandler, Gap Selling, discovery call, deal qualification, pipeline review, forecast accuracy, win plan, RFP response, competitive battlecard, sales coaching, account expansion, QBR, NRR.
---

# Sales Methodology Routing Skill

When this skill activates, route based on the sales workflow phase.

## Routing matrix

| User signal / sales phase | Agent to invoke |
|---|---|
| Outbound prospecting, ICP definition, multi-channel sequences | `sales-outbound-strategist` |
| Discovery call prep, question design, current-state mapping | `sales-discovery-coach` |
| Deal scoring, MEDDPICC, win plan, competitive positioning | `sales-deal-strategist` |
| Technical demo, POC scoping, competitive battlecards | `sales-engineer` |
| RFP response, win themes, executive summary craft | `sales-proposal-strategist` |
| Pipeline health, forecast accuracy, deal velocity, RevOps | `sales-pipeline-analyst` |
| Land-and-expand, QBR facilitation, NRR growth | `sales-account-strategist` |
| Rep coaching, call coaching, pipeline review facilitation | `sales-coach` |
| Cold prospecting top-of-funnel (lighter than outbound-strategist) | `sales-outreach` |

## Complementary skills

- Common Room outreach drafting → `common-room:compose-outreach`
- Account research → `common-room:account-research` or `sales:account-research`
- Daily briefings → `sales:daily-briefing`

## When NOT to use

- Korean / Japanese client cultural prep → `korean-business` / `japanese-business` skill
- Customer success / post-sale support → `customer-service-vertical` skill
- Marketing-driven lead generation → `social-platform-routing` or `marketing:*` skills
