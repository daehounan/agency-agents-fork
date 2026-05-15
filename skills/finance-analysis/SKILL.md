---
name: finance-analysis
description: Financial analysis, modeling, FP&A, investment research, and tax strategy. Use when the user asks about three-statement models, DCF valuation, variance analysis, budgeting, rolling forecasts, equity research, due diligence, portfolio analysis, GAAP/IFRS accounting, month-end close, multi-jurisdictional tax optimization, transfer pricing, ETR analysis, or audit defense. Triggers on financial model, DCF, NPV, IRR, three-statement, GAAP, IFRS, FP&A, budget vs actual, variance analysis, equity research, due diligence, transfer pricing, ETR, audit.
---

# Finance Analysis Routing Skill

When this skill activates, route based on the financial discipline involved.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Month-end close, reconciliation, GAAP, internal controls | `bookkeeper--controller` |
| Financial modeling, three-statement, DCF, scenario analysis | `financial-analyst` |
| Budgeting, rolling forecasts, monthly business reviews | `fpa-analyst` |
| Investment thesis, equity research, portfolio analysis, due diligence | `investment-researcher` |
| Tax optimization, transfer pricing, ETR, audit defense | `tax-strategist` |

## When NOT to use

- Personal finance / budgeting → use general Claude
- Korean USCPA exam prep → use `uscpa-bar-engine` skill
- Real-time market data → these agents do analysis frameworks, not live data fetching
