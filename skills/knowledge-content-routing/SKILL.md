---
name: knowledge-content-routing
description: Knowledge management, document generation, and corporate training specialist routing. Use when the user wants to build a Zettelkasten-style knowledge base, generate PDF/PPTX/DOCX/XLSX documents from data, design enterprise training programs, write developer-facing technical documentation, or set up internal corporate learning systems. Triggers on Zettelkasten, knowledge base, atomic notes, document generation, PDF report, PPTX deck, DOCX template, XLSX report from code, training program, curriculum design, internal trainer, learning evaluation, technical writer, API reference, README.
---

# Knowledge & Content Routing Skill

When this skill activates, route based on the knowledge artifact type.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Atomic notes, Zettelkasten, connected knowledge graph | `zk-steward` |
| Code-generated PDF / PPTX / DOCX / XLSX with charts | `specialized-document-generator` |
| Enterprise training curriculum, blended learning, trainer development | `corporate-training-designer` |
| Developer documentation, API reference, README, tutorials | `engineering-technical-writer` |

## Complementary

- Skill creation / SKILL.md generation → `ecc:skill-create` skill or `anthropic-skills:skill-creator`
- Anthropic-style PPTX → `anthropic-skills:pptx`
- Anthropic-style DOCX → `anthropic-skills:docx`
- Anthropic-style PDF → `anthropic-skills:pdf`
- Anthropic-style XLSX → `anthropic-skills:xlsx`
- Internal company communications drafting → `internal-comms` skill

## When NOT to use

- Marketing content / blog posts → `marketing-content-creator` or `marketing:content-creation`
- Brand voice guidelines → `brand-voice:*` skills
- Sales proposals → `sales-proposal-strategist` agent
- Slide design (visual) → `anthropic-skills:canvas-design` or `ecc:frontend-slides`
