---
name: knowledge-content-routing
description: Two niche knowledge specialists not covered by existing document-format / documentation skills — Zettelkasten knowledge graph stewardship and enterprise training curriculum design. Use when the user wants to build a Luhmann-style atomic-note knowledge base with connectivity validation, or design a multi-track enterprise learning program with internal trainer development and effectiveness evaluation. For document generation by file format, use existing anthropic-skills. Triggers on Zettelkasten, Luhmann, atomic notes, connectivity validation, knowledge graph stewardship, enterprise training curriculum, internal trainer development, blended learning program design, learning effectiveness evaluation.
---

# Knowledge & Content Routing Skill (Niche)

**Scope intentionally narrow.** For document generation by format use existing skills:
- PDF → `anthropic-skills:pdf`
- PPTX → `anthropic-skills:pptx`
- DOCX → `anthropic-skills:docx`
- XLSX → `anthropic-skills:xlsx`
- Code-generated documents with charts (mixed format) → `specialized-document-generator` agent directly

For developer documentation use existing skills:
- API reference, README, technical docs → `engineering:documentation` + `ecc:doc-updater` agent
- Internal company comms → `internal-comms` / `internal-comms-20260419`
- Document co-authoring workflow → `doc-coauthoring`
- Skill creation → `anthropic-skills:skill-creator` / `ecc:skill-create`

## When to use THIS skill

Only when the work is one of these two niches:

| User signal | Agent to invoke |
|---|---|
| Luhmann-style Zettelkasten, atomic-note knowledge base, connectivity validation, knowledge graph stewardship | `zk-steward` |
| Enterprise training needs analysis, multi-track curriculum, internal trainer development, learning effectiveness evaluation | `corporate-training-designer` |

## When NOT to use

Generic document generation by file format → existing anthropic-skills. Generic technical writing → existing engineering skills.
