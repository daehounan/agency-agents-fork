---
name: paid-media-routing
description: Paid media campaign routing for Google Ads, Microsoft Ads, Amazon Ads, Meta, LinkedIn, TikTok, programmatic display. Use when the user asks about PPC strategy, account audit, search query analysis, conversion tracking (GTM/GA4/CAPI), Performance Max, RSA ad copy, Meta creative testing, programmatic DSP buys, partner media, ABM display, paid social audience strategy, CPA/ROAS optimization, account takeover, or quarterly paid media reviews. Triggers on Google Ads, Microsoft Ads, Meta Ads, PPC, RSA, Performance Max, GTM, GA4, conversion tracking, CAPI, programmatic, DSP, paid social, account audit, CPA, ROAS, ad copy.
---

# Paid Media Routing Skill

When this skill activates, route to the appropriate paid-media agent based on the workflow phase.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Account audit, competitive analysis, takeover prep | `paid-media-auditor` |
| Account architecture, bidding, budget allocation | `ppc-campaign-strategist` |
| Search term analysis, negative keywords | `search-query-analyst` |
| GTM, GA4, conversion tracking, CAPI | `tracking--measurement-specialist` |
| RSA copy, Meta creative, PMax assets | `ad-creative-strategist` |
| GDN, DSPs, partner media, ABM display | `programmatic--display-buyer` |
| Meta, LinkedIn, TikTok paid social | `paid-social-strategist` |

## Account takeover sequence

For full account takeovers, invoke in this order via separate Agent calls:
1. `paid-media-auditor` (assessment)
2. `tracking--measurement-specialist` (verify tracking accuracy first)
3. `ppc-campaign-strategist` (rebuild architecture)
4. `search-query-analyst` (clean wasted spend)
5. `ad-creative-strategist` (refresh creative)
