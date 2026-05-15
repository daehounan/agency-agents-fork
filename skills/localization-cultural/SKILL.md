---
name: localization-cultural
description: Cross-cultural localization, regional market navigation, and Spanish ↔ English translation. Use when the user asks about detecting invisible exclusion in software, intersectional representation, designing UX that resonates across cultures, navigating the French ESN / SI consulting freelance ecosystem (Malt, collective.work, portage salarial), or handling Spanish ↔ English translation with regional dialect and cultural context awareness. Triggers on cultural intelligence, CQ, intersectional, inclusive design, ESN, SI, portage salarial, Malt, French consulting market, Spanish translation, English to Spanish, dialect, regional Spanish, Latin American Spanish, Castilian.
---

# Localization & Cultural Routing Skill

When this skill activates, route to the regional / cultural specialist.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Detecting exclusion, intersectional representation in software | `specialized-cultural-intelligence-strategist` |
| French ESN / SI freelance ecosystem, Malt, portage salarial, rate positioning | `specialized-french-consulting-market` |
| Spanish ↔ English translation with dialect / context awareness | `language-translator` |
| Korean business culture / deal mechanics | use `korean-business` skill |
| Japanese business culture / deal mechanics | use `japanese-business` skill |

## Complementary

- Visa / immigration document translation → `ecc:visa-doc-translate` skill
- Inclusive image generation → `design-inclusive-visuals-specialist` agent (via `design-routing` skill)
- Local SEO market entry → `anthropic-skills:local-seo-engine`

## When NOT to use

- China market localization → intentionally excluded from this fork
- Pure software i18n (string extraction, locale files) → use engineering agents directly
- Korean / Japanese business prep → use the dedicated skills, not this one
