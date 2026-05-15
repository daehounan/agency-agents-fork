---
name: customer-service-vertical
description: Vertical-specific customer service routing — general, healthcare, hospitality, and retail returns. Use when the user asks about handling customer inquiries, complaint resolution, returns processing, patient support with HIPAA awareness, hotel/restaurant guest services, loyalty programs, escalation protocols, complaint recovery, or any frontline customer interaction in a specific industry. Triggers on customer service, complaint handling, return processing, refund, exchange, patient support, HIPAA, guest services, concierge, hotel check-in, restaurant reservation, loyalty program, escalation, customer escalation.
---

# Customer Service Vertical Routing Skill

When this skill activates, identify the industry context and route to the matching CS specialist.

## Routing matrix

| Industry / signal | Agent to invoke |
|---|---|
| General omnichannel CS (any industry default) | `customer-service` |
| Healthcare / patient support / HIPAA-aware billing+insurance | `healthcare-customer-service` |
| Hotels / resorts / restaurants / event venues | `hospitality-guest-services` |
| Retail returns / exchanges / fraud prevention | `retail-customer-returns` |

## When NOT to use

- Sales outreach / prospecting → `sales-methodology-routing` skill
- B2B technical support (developer questions) → `specialized-developer-advocate` agent
- Law firm client intake (legal vertical) → `legal-firm-ops` skill
- Internal HR onboarding → `human-resources:onboarding` skill
- Real estate buyer/seller representation → `real-estate-mortgage` skill
