---
name: social-platform-routing
description: Platform-specific social media specialist routing — Twitter/X, TikTok, Instagram, Reddit, LinkedIn, and short-form carousel content. Use when the user asks about platform-specific content strategy, viral growth tactics, algorithm optimization, community engagement, thought leadership building, or campaign execution on a specific social platform. Triggers on Twitter, X, TikTok, Instagram, Reddit, LinkedIn, viral content, algorithm, engagement rate, thought leadership, carousel, short-form video, social engagement, follower growth, community building.
---

# Social Platform Routing Skill

When this skill activates, route to the platform specialist that matches the user's target channel.

## Routing matrix

| Platform / signal | Agent to invoke |
|---|---|
| Twitter/X real-time engagement, viral threads, thought leadership | `marketing-twitter-engager` |
| TikTok viral content, algorithm, Gen Z/Millennial reach | `marketing-tiktok-strategist` |
| Instagram visual storytelling, aesthetic, community | `marketing-instagram-curator` |
| Reddit authentic community engagement, value-first | `marketing-reddit-community-builder` |
| LinkedIn personal brand, B2B thought leadership, inbound | `marketing-linkedin-content-creator` |
| TikTok/IG carousel auto-generation + publishing | `marketing-carousel-growth-engine` |
| Cross-platform unified strategy | `marketing-social-media-strategist` |
| YouTube algorithm, retention, chaptering, thumbnails | `marketing-video-optimization-specialist` |
| App store visibility (App Store/Play Store ASO) | `marketing-app-store-optimizer` |
| AI recommendation visibility (ChatGPT/Claude/Perplexity AEO) | `marketing-ai-citation-strategist` |
| Agentic search optimization (WebMCP) | `marketing-agentic-search-optimizer` |

## Multi-platform campaign

For campaigns spanning multiple platforms, invoke `marketing-social-media-strategist` first to set the umbrella plan, then platform specialists in parallel.

## When NOT to use

- Paid social ads → use `paid-media-routing` skill
- SEO / organic search → use `marketing-seo-specialist` directly
- General content strategy / editorial calendar → use `marketing-content-creator` or `marketing:content-creation` skill
