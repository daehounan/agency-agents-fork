---
name: japanese-business
description: Japanese business culture and deal mechanics for foreign professionals. Use when the user asks about 稟議 (ringi) / 根回し (nemawashi) consensus process, 空気を読む (KY) signal reading, 名刺交換 business card protocol, 飲み会 / 接待 entertainment, 報連相 (hou-ren-sou) communication, LINE/Chatwork business etiquette, Japanese hierarchy (社長/部長/課長 etc.), keigo selection, お中元/お歳暮 gift timing, Golden Week/Obon calendar, 検討させていただきます / 前向きに検討 decoding, hanko 印鑑 contracts, or preparing for any meeting/call/email with a Japanese counterpart. Also triggers on phrases like 日本 取引先, 日本 商談, ビジネス日本語, 稟議, 根回し, 名刺, 飲み会, 商習慣.
---

# Japanese Business Skill

When this skill activates, delegate to the **Japanese Business Navigator** agent for culturally-grounded guidance.

## How to invoke

Use the Agent tool with `subagent_type: "specialized-japanese-business-navigator"` and pass:
- The user's question
- Any known context about the relationship (first contact / established / trusted / 飲み会-tested)
- The Japanese counterpart's company type (大手 / 中小 / startup / 外資)
- The current stage in the 紹介 → 根回し → 稟議 → 契約 sequence if known

## What the agent provides

- 稟議 + 根回し timeline mapping (8-20 week stages)
- KY decoder — what 検討させていただきます / ちょっと / はい、はい / 善処します actually mean
- LINE / email templates by relationship stage with proper keigo
- Japanese title hierarchy + correct address (会長 / 社長 / 部長 / 課長 + 様)
- 名刺交換 protocol — two-hand, table placement, never-write-on-it
- 飲み会 / 接待 protocol — kamiza seating, 両手 pouring, kanpai etiquette
- お中元 / お歳暮 / 年賀状 timing
- 報連相 communication cadence expectations
- Seasonal calendar — Golden Week, Obon, 忘年会 season

## When NOT to use

- Pure Japanese language translation without business context → use language tools
- Japanese tech ecosystem (LINE API, Mercari, etc.) → use engineering agents
- 外務員 / Japanese securities exam → use `professional-exam-mastery` skill
