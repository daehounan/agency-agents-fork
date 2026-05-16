---
name: niche-engineering-routing
description: Niche engineering specialist routing for net-new domains not covered by ecc plugin — embedded firmware, voice AI / ASR pipelines, email intelligence extraction, threat detection / SIEM, WordPress / Drupal CMS, AI data remediation, and autonomous LLM optimization. Use when the user asks about bare-metal MCU programming (ESP32 / STM32 / Nordic), Whisper / speech-to-text pipelines, email parsing for AI agents, SIEM rule writing, MITRE ATT&CK mapping, WordPress / Drupal theme or plugin development, self-healing data pipelines, or LLM routing with cost guardrails. Triggers on ESP32, STM32, Nordic, FreeRTOS, Zephyr, Whisper, ASR, speaker diarization, email parsing, MIME, SIEM, MITRE ATT&CK, threat hunting, WordPress, Drupal, data remediation, semantic clustering, LLM routing, shadow testing.
---

# Niche Engineering Routing Skill

When this skill activates, route to the specialist that owns the niche.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Embedded / RTOS / ESP32 / STM32 / Nordic / bare-metal firmware | `engineering-embedded-firmware-engineer` |
| Whisper / ASR / speech-to-text pipeline / speaker diarization | `engineering-voice-ai-integration-engineer` |
| Email parsing, MIME extraction, structured email for AI agents | `engineering-email-intelligence-engineer` |
| SIEM rule development, MITRE ATT&CK coverage, threat hunting | `engineering-threat-detection-engineer` |
| WordPress / Drupal theme + plugin + module development | `engineering-cms-developer` |
| Self-healing data pipelines, semantic clustering, air-gapped SLMs | `engineering-ai-data-remediation-engineer` |
| LLM routing, cost optimization, shadow testing | `engineering-autonomous-optimization-architect` |
| Filament PHP admin UI restructuring | `engineering-filament-optimization-specialist` |
| EVM / Solidity / DeFi smart contracts | `engineering-solidity-smart-contract-engineer` |

## When NOT to use

- General application security (web/API/cloud) → `ecc:security-review` skill or `engineering-security-engineer` agent
- General data engineering (ETL/lakehouse) → `engineering-data-engineer` agent (no skill wrapper — use directly)
- Mobile native development → `engineering-mobile-app-builder` agent
- AI/ML model development (general) → `engineering-ai-engineer` agent or `ecc:ai-first-engineering` skill
