---
name: product-discovery-routing
description: Product management and discovery specialist routing covering sprint planning, market intelligence, feedback synthesis, behavioral nudge design, and full product lifecycle ownership. Use when the user asks about feature prioritization, agile sprint planning, market trend analysis, competitive intelligence, user feedback synthesis, behavioral psychology applied to engagement, or end-to-end product strategy and roadmap. Triggers on sprint planning, backlog prioritization, RICE, ICE scoring, market trend, competitive intelligence, opportunity assessment, feedback analysis, user insight, behavioral nudge, habit loop, engagement design, product roadmap, PRD, discovery, go-to-market.
---

# Product Discovery Routing Skill

When this skill activates, route based on the product workflow phase.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Agile sprint planning, feature prioritization, backlog management | `product-sprint-prioritizer` |
| Market intelligence, competitive analysis, opportunity assessment | `product-trend-researcher` |
| User feedback collection, analysis, synthesis | `product-feedback-synthesizer` |
| Behavioral psychology applied to engagement, habit loops, nudges | `product-behavioral-nudge-engine` |
| Full product lifecycle, discovery → PRD → roadmap → GTM | `product-manager` |

## Complementary skills

- Spec writing → `product-management:write-spec`
- Roadmap update → `product-management:roadmap-update`
- Sprint planning ceremonies → `product-management:sprint-planning`
- Stakeholder update → `product-management:stakeholder-update`
- Research synthesis → `product-management:synthesize-research`
- Product brainstorming → `product-management:brainstorm` or `product-management:product-brainstorming`
- Competitive brief → `product-management:competitive-brief`
- Metrics review → `product-management:metrics-review`
- Interactive PRD generation → `ecc:prp-prd`

## When NOT to use

- Engineering planning / refactoring plan → `ecc:planner` agent or `ecc:plan` skill
- Marketing campaign → `marketing:*` skills
- Sales-side qualification (MEDDPICC etc.) → `sales-methodology-routing` skill
