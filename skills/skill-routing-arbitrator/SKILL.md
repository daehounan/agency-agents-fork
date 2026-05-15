---
name: skill-routing-arbitrator
description: Disambiguator for when multiple skills could match the same user prompt. Use when uncertain which of several overlapping skills to invoke — e.g., code review (engineering:code-review vs ecc:code-review vs ecc:python-review vs review), security audit (ecc:security-review vs anthropic-skills:security-audit-engine vs ruflo-security-audit:audit), MCP server building (anthropic-skills:mcp-builder vs ecc:mcp-server-patterns), or any case where two or more skills' descriptions match the user's request. Returns the canonical preferred skill and explains why.
---

# Skill Routing Arbitrator

When multiple skills could fire on the same prompt, this skill provides deterministic preferences so Claude routes to the right one.

## Priority hierarchy (general)

1. **Most specific language/domain** wins over generic — e.g., `ecc:python-review` over `ecc:code-review`
2. **Active executor** wins over **strategy/workflow doc** — e.g., `ecc:code-review` (runs review) over `engineering:code-review` (strategy)
3. **Current version** wins over **dated snapshot** — e.g., `anthropic-skills:mcp-builder` over `anthropic-skills:mcp-builder-20260419`
4. **Real skill** wins over **legacy shim** — e.g., `ecc:tdd-workflow` over `ecc:tdd` shim
5. **Connected-data-source skill** wins when data is available — e.g., `common-room:account-research` if Common Room MCP is connected, else `sales:account-research`

## Specific cluster rules

### Code review

| Situation | Skill |
|---|---|
| Language known + active review needed | `ecc:<lang>-review` (cpp, python, go, rust, kotlin, flutter) |
| PR / multi-agent comprehensive | `ecc:review-pr` |
| Local diff review | `ecc:code-review` |
| PR triage (lightweight built-in) | `review` |
| Security focus on PR | `security-review` |
| Codebase security review | `ecc:security-review` |
| Strategy / process discussion only | `engineering:code-review` |

### Testing

| Situation | Skill |
|---|---|
| TDD in language X | `ecc:<lang>-test` |
| E2E specifically | `ecc:e2e-testing` |
| Generate tests from existing file | `ruflo-testgen:testgen` |
| Identify coverage gaps | `ruflo-testgen:test-gaps` |
| Strategy / test plan | `engineering:testing-strategy` |

### Build error resolution

Pick by language: `ecc:cpp-build` / `go-build` / `kotlin-build` / `rust-build` / `flutter-build` / `gradle-build`.

### Security audit

| Situation | Skill |
|---|---|
| Codebase review (vulnerabilities in code) | `ecc:security-review` |
| Dependency / supply chain CVE | `ruflo-security-audit:dependency-check` |
| Formal SOC 2 / ISO 27001 / HIPAA readiness | `anthropic-skills:security-audit-engine` |
| Smart contract / DeFi | `agency-agents-fork:compliance-audit-routing` → `blockchain-security-auditor` |
| Healthcare PHI in code | `ecc:healthcare-phi-compliance` |
| LLM trading agent security | `ecc:llm-trading-agent-security` |
| Bug bounty mode | `ecc:security-bounty-hunter` |
| PR-context lightweight | `security-review` |

### Documentation

| Situation | Skill |
|---|---|
| Library / API docs lookup | `ecc:documentation-lookup` (NOT `ecc:docs` shim) |
| Auto-generate from code | `ruflo-docs:doc-gen` or `ruflo-docs:api-docs` |
| Plan documentation strategy | `engineering:documentation` |
| RuFlo-managed project | `ruflo-docs:ruflo-docs` |

### Document generation by file format

Always prefer format-specific:
- PDF → `anthropic-skills:pdf`
- PPTX → `anthropic-skills:pptx`
- DOCX → `anthropic-skills:docx`
- XLSX → `anthropic-skills:xlsx`

For code-generated mixed-format documents with charts → `specialized-document-generator` agent (via `knowledge-content-routing`).

### Brand voice

| Situation | Skill |
|---|---|
| Search platforms for brand materials | `brand-voice:discover-brand` |
| Generate guidelines from materials | `brand-voice:generate-guidelines` |
| Apply guidelines to content | `brand-voice:enforce-voice` |
| Review existing content for brand fit | `marketing:brand-review` |
| Anthropic-branded artifact (colors/typography) | `anthropic-skills:brand-guidelines` |

### MCP server building

| Situation | Skill |
|---|---|
| New MCP server | `anthropic-skills:mcp-builder` |
| Pattern reference | `ecc:mcp-server-patterns` |
| Snapshot (don't use) | `anthropic-skills:mcp-builder-20260419` |

### Skill creation pipeline

| Stage | Skill |
|---|---|
| Author new skill | `anthropic-skills:harness-skill-builder` |
| Review pre-package | `anthropic-skills:skill-review-gate` |
| Package as patch/upgrade | `anthropic-skills:skill-upgrade-pipeline` |
| Patch exam engine | `anthropic-skills:exam-engine-patcher` |
| Extract from git history | `ecc:skill-create` |
| Compliance scan on skills | `ecc:skill-comply` |
| Portfolio dashboard | `ecc:skill-health` |
| Inventory | `ecc:skill-stocktake` |

### Planning / execution

Canonical PRP flow: `ecc:prp-prd` → `ecc:prp-plan` → `ecc:prp-implement` → `ecc:prp-pr` → `ecc:prp-commit`.

Alternatives:
- Multi-agent agency engagement → `agency-agents-fork:strategy-nexus`
- Agent-to-agent handoff doc → `anthropic-skills:work-order-drafter`
- Lightweight restate + plan → `ecc:plan`

### Compliance (route by domain)

| Domain | Skill |
|---|---|
| SOX testing | `finance:sox-testing` |
| Financial audit support | `finance:audit-support` |
| HIPAA in code | `ecc:hipaa-compliance` |
| Healthcare PHI | `ecc:healthcare-phi-compliance` |
| Legal contract compliance | `legal:compliance-check` |
| Operational tracking | `operations:compliance-tracking` |
| Smart contract / n8n | `agency-agents-fork:compliance-audit-routing` |
| Formal SOC 2 / ISO 27001 | `anthropic-skills:security-audit-engine` |
| Skill ecosystem compliance | `ecc:skill-comply` |

### Sales / account research

| Situation | Skill |
|---|---|
| Common Room MCP available | `common-room:account-research` / `compose-outreach` / `call-prep` / `weekly-prep-brief` |
| No Common Room data | `sales:account-research` / `draft-outreach` / `call-prep` |
| Methodology depth (MEDDPICC etc.) | `agency-agents-fork:sales-methodology-routing` |

### Memory / session

| Situation | Skill |
|---|---|
| Working memory edits | `productivity:memory-management` |
| Cleanup / consolidate | `anthropic-skills:consolidate-memory` |
| Save session state | `ecc:save-session` |
| Resume session | `ecc:resume-session` |
| Pre-compaction prep | `ecc:strategic-compact` |
| RAG memory CRUD | `ruflo-rag-memory:ruflo-memory` |
| RAG semantic recall | `ruflo-rag-memory:recall` |

## Always avoid

- **Legacy shims:** `ecc:tdd`, `ecc:e2e`, `ecc:eval`, `ecc:docs`, `ecc:devfleet`, `ecc:claw`, `ecc:orchestrate`, `ecc:prompt-optimize` — use the destination skill directly
- **Dated snapshots:** `*-20260418`, `*-20260419` suffixes — use the current version

## See also

[`docs/skill-ecosystem-duplicates.md`](../../docs/skill-ecosystem-duplicates.md) — full audit with rationale for every cluster.
