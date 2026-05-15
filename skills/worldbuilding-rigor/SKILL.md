---
name: worldbuilding-rigor
description: Scholarly rigor for fiction, game narrative, and world-building — anthropology, geography, history, narratology, psychology. Use when the user is designing fictional cultures/societies/religions, building geographically coherent maps and climate systems, validating historical period accuracy, analyzing story structure (Campbell, Propp, Freytag), or building psychologically credible characters. Triggers on world-building, fictional culture, fantasy geography, period accuracy, story structure, character arc, kinship systems, ritual design, narrative theory, character motivation.
---

# Worldbuilding Rigor Skill

When this skill activates, identify which academic lens applies and delegate to the appropriate scholar agent.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Cultural systems, kinship, rituals, belief systems | `anthropologist` |
| Physical/human geography, climate, cartography, settlement patterns | `geographer` |
| Historical analysis, periodization, material culture | `historian` |
| Story structure, plot patterns, character arcs, narrative theory | `narratologist` |
| Character motivation, personality, cognitive patterns, trauma | `psychologist` |

## When to invoke multiple

A fully realized fictional society usually needs anthropologist + geographer + historian in parallel. Add narratologist when the question is about how the world is *told*, psychologist when it is about how individuals within the world *think*.

## When NOT to use

- Game mechanics or systems design → `game-designer` (separate skill)
- Visual world-building (concept art prompts) → `image-prompt-engineer`
- Marketing copy for a published world → marketing agents
