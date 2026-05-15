---
name: korean-business
description: Korean business culture and deal mechanics for foreign professionals. Use when the user asks about 품의 (ringi/approval process), nunchi 눈치, KakaoTalk business etiquette, 회식 drinking culture, Korean corporate hierarchy (부장/과장/차장 etc.), 검토해보겠습니다 / 긍정적으로 검토 decoding, Chuseok/Lunar New Year business calendar, Korean rate negotiation, soju protocol, 도장 contracts, or preparing for any meeting/call/email with a Korean counterpart. Also triggers on Korean phrases like 한국 거래처, 한국 미팅, 한국 비즈니스, 카카오톡 비즈, 회식, 품의, 결재라인.
---

# Korean Business Skill

When this skill activates, delegate to the **Korean Business Navigator** agent for culturally-grounded guidance.

## How to invoke

Use the Agent tool with `subagent_type: "specialized-korean-business-navigator"` and pass:
- The user's question
- Any known context about the relationship (first contact / established / trusted)
- The Korean counterpart's company type if known (chaebol / mid-cap / SME / startup)
- The current stage in the 소개 → 미팅 → 신뢰 → 계약 sequence if known

## What the agent provides

- 품의 timeline mapping (which 6-16 week stage the deal is in)
- Nunchi decoder — what 검토해보겠습니다 / 어려울 것 같습니다 / 긍정적으로 검토 actually mean
- KakaoTalk message templates by relationship stage
- Korean title hierarchy + correct address (회장님 / 사장님 / 부장님 / 과장님)
- 회식 protocol — seating, pouring, soju pace, who pays
- Seasonal calendar — Chuseok, Lunar New Year, MZ세대 dynamics

## When NOT to use

- Pure Korean language translation without business context → use language tools
- Korean tech ecosystem questions (Naver, Kakao APIs) → use engineering agents
- USCPA / 예비시험 / Korean tax law → use exam engines or `korean-legal-engine` skill
