---
name: real-estate-mortgage
description: Residential real estate transactions and mortgage lending workflows. Use when the user asks about buyer/seller representation, offers, transaction coordination, mortgage borrower intake, TRID compliance, loan pipeline tracking, closing coordination, MLS, escrow, title, or appraisal contingencies. Triggers on real estate, MLS, escrow, mortgage, TRID, FHA, VA loan, closing disclosure, listing agreement, buyer's agent, loan officer, pre-approval.
---

# Real Estate + Mortgage Routing Skill

When this skill activates, route to the appropriate vertical agent.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Buyer/seller representation, offers, MLS, transaction coordination | `real-estate-buyer-seller` |
| Borrower intake, loan structuring, TRID, pipeline, closing | `loan-officer-assistant` |

## Cross-functional flow

For a buyer needing a loan, invoke both agents in parallel:
- `real-estate-buyer-seller` for the property/offer side
- `loan-officer-assistant` for the financing side
