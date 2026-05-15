# Skill Ecosystem Duplicates Audit

Comprehensive map of overlapping skills across the entire Claude Code skill ecosystem (not just the agency-agents fork). For each duplicate cluster, recommends a canonical winner and routing preference.

Generated 2026-05-15. ~500 skills surveyed across namespaces: agency-agents-fork, ecc, anthropic-skills, ruflo-*, vercel, engineering, design, operations, human-resources, common-room, legal, product-management, data, sales, finance, marketing, productivity, enterprise-search, brand-voice, cowork-plugin-management, and Claude Code built-ins.

## Category A — Versioned snapshots (anthropic-skills self-duplicates)

These are dated snapshots vs current. **Always prefer the undated current version.**

| Current | Snapshot | Preference |
|---|---|---|
| `anthropic-skills:career-jd-engine` | `anthropic-skills:career-jd-engine-20260418` | Current |
| `anthropic-skills:doc-coauthoring` | `anthropic-skills:doc-coauthoring-20260419` | Current |
| `anthropic-skills:econ-article-critique` | `anthropic-skills:econ-article-critique-20260418` | Current |
| `anthropic-skills:harness-skill-builder` | `anthropic-skills:harness-skill-builder-20260418` | Current |
| `anthropic-skills:internal-comms` | `anthropic-skills:internal-comms-20260419` | Current |
| `anthropic-skills:mcp-builder` | `anthropic-skills:mcp-builder-20260419` | Current |
| `anthropic-skills:professional-exam-mastery` | `anthropic-skills:professional-exam-mastery-20260418` | Current |
| `anthropic-skills:recitation-drill-skill-v1` | `anthropic-skills:recitation-drill-skill-v1-20260418` | Current |
| `anthropic-skills:uscpa-bar-engine` | `anthropic-skills:uscpa-bar-v22-carveout` | Current engine; carveout is for v2.2 D-6 prep only |

**Rule:** Snapshots are archives. The current version embodies the latest protocol. Only use a snapshot when explicitly reverting or comparing.

## Category B — Legacy slash-entry shims (ecc plugin self-duplicates)

ecc plugin has 11 shims explicitly marked "Legacy slash-entry shim for X. Prefer the skill directly."

| Shim (deprecated) | Real skill (preferred) |
|---|---|
| `ecc:agent-sort` | `ecc:agent-sort` (skill) |
| `ecc:claw` | `ecc:nanoclaw-repl` |
| `ecc:context-budget` (shim) | `ecc:context-budget` (skill) |
| `ecc:devfleet` | `ecc:claude-devfleet` |
| `ecc:docs` | `ecc:documentation-lookup` |
| `ecc:e2e` | `ecc:e2e-testing` |
| `ecc:eval` | `ecc:eval-harness` |
| `ecc:orchestrate` | `ecc:dmux-workflows` + `ecc:autonomous-agent-harness` |
| `ecc:prompt-optimize` | `ecc:prompt-optimizer` |
| `ecc:rules-distill` (shim) | `ecc:rules-distill` (skill) |
| `ecc:tdd` | `ecc:tdd-workflow` |
| `ecc:verify` | `ecc:verification-loop` |

**Rule:** Always invoke the destination skill, not the shim.

## Category C — Cross-namespace functional duplicates

### C1. Code review

| Skill | Scope | When |
|---|---|---|
| `engineering:code-review` | Workflow guide | Strategy / process planning |
| `ecc:code-review` | **Active command** | Local diff or GitHub PR review |
| `ecc:cpp-review`, `ecc:python-review`, `ecc:go-review`, `ecc:rust-review`, `ecc:kotlin-review`, `ecc:flutter-review` | Language-specific | When language is known |
| `ecc:review-pr` | Multi-agent PR review | Comprehensive PR review |
| `review` (root) | Built-in PR review | Lightweight PR triage |
| `security-review` (root) | Built-in security PR review | Security-focused PR |
| `ecc:security-review` | Active security review | Codebase security review |
| `ruflo-core:witness` | Cryptographic fix verification | Manifest-signed releases only |

**Preference order:**
1. Language-specific `ecc:*-review` if language is known
2. `ecc:review-pr` for full PR review
3. `ecc:code-review` for local diff
4. `engineering:code-review` only for strategy/process discussion

### C2. Testing

| Skill | Scope | When |
|---|---|---|
| `engineering:testing-strategy` | Strategy doc | Planning test approach |
| `ecc:tdd-workflow` | Generic TDD workflow | Cross-language TDD |
| `ecc:cpp-test`, `ecc:go-test`, `ecc:kotlin-test`, `ecc:rust-test`, `ecc:flutter-test` | Language-specific TDD | When language is known |
| `ecc:e2e-testing` | E2E test runs | End-to-end testing |
| `ruflo-testgen:testgen` | Test generation from file | Specific file/module |
| `ruflo-testgen:tdd-workflow` | RuFlo's TDD | RuFlo-managed projects |
| `ruflo-testgen:test-gaps` | Coverage gap analysis | Gap identification |
| `*-testing` ecc skills (cpp, python, rust, golang, kotlin, swift, csharp, perl) | Language testing patterns | Pattern reference |

**Preference order:**
1. Language-specific `ecc:*-test` for TDD on known language
2. `ruflo-testgen:testgen` for generating tests from existing code
3. `ecc:e2e-testing` for E2E specifically
4. `engineering:testing-strategy` only for strategy planning

### C3. Build error resolution

| Skill | Language |
|---|---|
| `ecc:cpp-build` | C++ |
| `ecc:go-build` | Go |
| `ecc:kotlin-build` | Kotlin |
| `ecc:rust-build` | Rust |
| `ecc:flutter-build` | Dart/Flutter |
| `ecc:gradle-build` | Android/KMP Gradle |

**Rule:** Use the language-specific build resolver. No cross-plugin duplicates.

### C4. Security

| Skill | Scope | When |
|---|---|---|
| `ecc:security-review` | Active codebase review | Code-level vulnerabilities |
| `ecc:security-scan` | Scan tools | Automated scanner runs |
| `ecc:security-bounty-hunter` | Vulnerability hunting | Bug bounty mode |
| `ruflo-security-audit:audit` | RuFlo full audit | RuFlo-managed projects |
| `ruflo-security-audit:security-scan` | RuFlo scan | RuFlo-managed projects |
| `ruflo-security-audit:dependency-check` | Dependency CVE check | Supply chain audit |
| `anthropic-skills:security-audit-engine` | Formal compliance audit | SOC 2 / ISO 27001 readiness |
| `security-review` (root) | Built-in PR security | PR-context |
| `ecc:hipaa-compliance` | HIPAA in code | Healthcare code |
| `ecc:healthcare-phi-compliance` | PHI handling | Healthcare data |
| `ecc:llm-trading-agent-security` | LLM trading | Niche |
| `ecc:defi-amm-security` | DeFi AMM | Smart contract DeFi |
| `agency-agents-fork:compliance-audit-routing` | Smart contract + n8n | Niche only after slim |

**Preference matrix:**
- Generic codebase review → `ecc:security-review`
- Dependency / supply chain → `ruflo-security-audit:dependency-check`
- Formal compliance (SOC 2 / ISO 27001 / HIPAA audit prep) → `anthropic-skills:security-audit-engine`
- Healthcare PHI in code → `ecc:healthcare-phi-compliance`
- Smart contract audit → `agency-agents-fork:compliance-audit-routing` → `blockchain-security-auditor`
- PR-context lightweight check → `security-review`

### C5. Documentation

| Skill | Scope | When |
|---|---|---|
| `engineering:documentation` | Workflow strategy | Doc strategy / process |
| `ecc:documentation-lookup` | Library doc lookup | Look up package/API docs |
| `ecc:docs` | Shim → `ecc:documentation-lookup` | Don't use |
| `ruflo-docs:doc-gen` | Generate docs | Auto-generate from code |
| `ruflo-docs:api-docs` | API reference | OpenAPI / SDK refs |
| `ruflo-docs:ruflo-docs` | RuFlo-managed | RuFlo projects |

**Preference:**
- Library / API docs lookup → `ecc:documentation-lookup`
- Generate from code → `ruflo-docs:doc-gen` or `ruflo-docs:api-docs`
- Plan documentation strategy → `engineering:documentation`

### C6. Document generation by format

| Skill | Format |
|---|---|
| `anthropic-skills:pptx` | PowerPoint |
| `anthropic-skills:docx` | Word |
| `anthropic-skills:pdf` | PDF |
| `anthropic-skills:xlsx` | Excel |
| `specialized-document-generator` (agent) | Code-generated mixed formats with charts |
| `agency-agents-fork:knowledge-content-routing` (slim) | Routes to specialized-document-generator only when complex / mixed format |

**Rule:** Format known → use `anthropic-skills:<format>`. Mixed/programmatic → use document-generator agent.

### C7. Brand voice

| Skill | Scope |
|---|---|
| `brand-voice:discover-brand` | Search platforms for brand materials |
| `brand-voice:generate-guidelines` | Generate guidelines |
| `brand-voice:enforce-voice` | Apply to content |
| `brand-voice:brand-voice-enforcement` | Apply to content (alt) |
| `marketing:brand-review` | Review for brand fit |
| `anthropic-skills:brand-guidelines` | Anthropic colors/typography only |
| `ecc:brand-voice` | ecc generic |

**Preference:**
- Discovery → `brand-voice:discover-brand`
- Guidelines generation → `brand-voice:generate-guidelines`
- Apply → `brand-voice:enforce-voice` (or `brand-voice-enforcement` synonym)
- Brand-fit review → `marketing:brand-review`
- Anthropic-branded artifacts → `anthropic-skills:brand-guidelines`

### C8. Compliance

| Skill | Domain |
|---|---|
| `operations:compliance-tracking` | Operational compliance |
| `legal:compliance-check` | Legal compliance |
| `finance:sox-testing` | SOX |
| `finance:audit-support` | Financial audit |
| `ecc:hipaa-compliance` | HIPAA |
| `ecc:healthcare-phi-compliance` | PHI handling |
| `anthropic-skills:security-audit-engine` | Formal security audit |
| `ecc:skill-comply` | Skill compliance |
| `agency-agents-fork:compliance-audit-routing` (slim) | Smart contract + n8n only |
| `ecc:automation-audit-ops` | Automation audit ops |

**Routing by domain:** Each handles a different compliance vertical. No real duplicates — but easy to misroute. Always pick by domain, not by general "compliance" keyword.

### C9. Sales outreach / account research

| Skill | Source data |
|---|---|
| `common-room:account-research` | Common Room data (if connected) |
| `sales:account-research` | Generic CRM-agnostic |
| `common-room:compose-outreach` | Common Room signals |
| `sales:draft-outreach` | Generic outreach |
| `common-room:prospect` | Common Room prospecting |
| `common-room:contact-research` | Common Room contacts |
| `common-room:call-prep` | Common Room context |
| `sales:call-prep` | Generic |
| `common-room:weekly-prep-brief` | Common Room weekly |
| `common-room:weekly-brief` | Common Room weekly (alt) |
| `agency-agents-fork:sales-methodology-routing` | MEDDPICC/SPIN methodology depth |

**Preference:**
- Common Room data available → `common-room:*`
- Generic CRM-agnostic → `sales:*`
- Methodology depth (MEDDPICC etc.) → `sales-methodology-routing`

### C10. Memory / session management

| Skill | Scope |
|---|---|
| `productivity:memory-management` | Working memory |
| `anthropic-skills:consolidate-memory` | Memory cleanup, dedup |
| `ecc:save-session`, `ecc:resume-session` | Session state I/O |
| `ecc:strategic-compact` | Pre-compaction prep |
| `ruflo-rag-memory:ruflo-memory` | RAG CRUD |
| `ruflo-rag-memory:recall` | RAG semantic recall |
| `ruflo-rag-memory:memory-search` | RAG search |
| `ruflo-rag-memory:memory-bridge` | RAG bridging |

**Preference:**
- Working memory edits → `productivity:memory-management`
- Cleanup / consolidate → `anthropic-skills:consolidate-memory`
- Session resume → `ecc:resume-session`
- Pre-compaction → `ecc:strategic-compact`
- RAG operations → `ruflo-rag-memory:*` (only on RuFlo projects)

### C11. MCP server building

| Skill | Status |
|---|---|
| `anthropic-skills:mcp-builder` | Current (preferred) |
| `anthropic-skills:mcp-builder-20260419` | Snapshot |
| `ecc:mcp-server-patterns` | Pattern reference |
| `specialized-mcp-builder` (agent) | Persona-style |
| `mcp-builder` (specialist agent) | Plugin agent |

**Preference:**
1. `anthropic-skills:mcp-builder` for new server creation
2. `ecc:mcp-server-patterns` for patterns reference
3. `specialized-mcp-builder` agent only if you want the persona depth

### C12. Skill creation pipeline

| Skill | Use |
|---|---|
| `anthropic-skills:skill-creator` | Generic creation, eval-driven |
| `anthropic-skills:harness-skill-builder` | Harness-engineered skills (current) |
| `anthropic-skills:harness-skill-builder-20260418` | Snapshot |
| `anthropic-skills:skill-review-gate` | Pre-package review |
| `anthropic-skills:skill-upgrade-pipeline` | Patch packaging |
| `anthropic-skills:exam-engine-patcher` | Exam engine specific |
| `ecc:skill-create` | From git history |
| `ecc:skill-comply` | Compliance check on skills |
| `ecc:skill-health` | Portfolio dashboard |
| `ecc:skill-stocktake` | Inventory |
| `ecc:hookify` | Create hooks |
| `update-config` (built-in) | settings.json hooks |

**Preference:** Choose by lifecycle stage — `harness-skill-builder` for new, `skill-review-gate` for review, `skill-upgrade-pipeline` for patches, `ecc:skill-create` only when extracting from git history.

### C13. Planning / execution

| Skill | Stage |
|---|---|
| `ecc:prp-prd` | PRD (interactive) |
| `ecc:prp-plan` | Implementation plan |
| `ecc:prp-implement` | Execute plan |
| `ecc:prp-pr` | Open PR |
| `ecc:prp-commit` | Natural-language commit |
| `ecc:plan` | Restate + plan (manual) |
| `ecc:feature-dev` | Feature development guide |
| `anthropic-skills:work-order-drafter` | Agent-to-agent handoff |
| `anthropic-skills:work-order-quality-gate` | Critique work order |
| `anthropic-skills:setup-cowork` | Cowork setup |
| `agency-agents-fork:strategy-nexus` | NEXUS multi-agent orchestration |

**Preference:**
- Feature flow → `ecc:prp-prd` → `ecc:prp-plan` → `ecc:prp-implement` → `ecc:prp-pr`
- Agent handoff → `anthropic-skills:work-order-drafter`
- Multi-agent agency engagement → `strategy-nexus`

### C14. SEO

| Skill | Scope |
|---|---|
| `marketing:seo-audit` | SEO audit |
| `ecc:seo` | SEO patterns |
| `anthropic-skills:local-seo-engine` | Local SEO |

### C15. Productivity / start-of-session

| Skill | Scope |
|---|---|
| `productivity:start` | Session start |
| `productivity:update` | Update task list |
| `productivity:task-management` | Task tracking |
| `productivity:memory-management` | Memory ops |

**Rule:** Each has distinct phase. Not duplicates.

## Category D — User-level non-namespaced skills

| User-level | Plugin equivalent | Action |
|---|---|---|
| `vercel-react-best-practices` | Plugin's `react-best-practices` (different scope: reviewer that auto-fires) | **Keep both** — user-level is declarative guideline, plugin is auto-reviewer |
| `vercel-composition-patterns` | None | Keep |
| `vercel-react-native-skills` | None | Keep |
| `web-design-guidelines` | None | Keep |

No user-level deletions safe. All 4 serve distinct purposes.

## Category E — Built-in shortcuts

| Built-in | Function |
|---|---|
| `init` | Initialize project |
| `review` | Review a PR |
| `security-review` | Security PR review |
| `loop` | Recurring task |
| `schedule` | Cron schedule |
| `simplify` | Code review pass |
| `update-config` | settings.json edits |
| `keybindings-help` | Customize keybindings |
| `fewer-permission-prompts` | Allow-list scan |
| `claude-api` | Claude API SDK help |

**Rule:** Built-ins are minimal interface. Prefer explicit slash command invocation.

## Summary recommendations

| Action | Count |
|---|---:|
| Plugin self-shims (use destination directly) | 12 |
| Versioned snapshots (use current) | 9 |
| Cross-namespace clusters needing routing rules | 15 |
| User-level deletions safe | **0** |
| Total skills surveyed | ~500 |

## Hooks audit

Current hooks in `~/.claude/settings.json`:

| Event | Count | Notes |
|---|---:|---|
| PreToolUse | 11 | Multiple Bash matchers — all via `run-with-flags.js` runner |
| PostToolUse | 10 | Two split `post-bash-command-log.js` (audit + cost) could merge |
| PreCompact | 1 | ok |
| PostToolUseFailure | 1 | mcp-health-check |
| SessionStart | 1 | bootstrap |
| Stop | 6 | ok |
| SessionEnd | 1 | ok |

**Recommendations:**
- The 11 PreToolUse Bash entries are individually scoped; consolidating into a single dispatcher is possible but increases coupling. Leave as-is.
- `post-bash-command-log.js audit` + `cost` could share one invocation with both flags — minor optimization.
- All hooks use the project's `run-with-flags.js` wrapper which is already deduplication-friendly.

## How to use this audit

When Claude routing is ambiguous between two skills:
1. Find the cluster in this doc
2. Apply the preference rule
3. If both still seem valid, prefer the one with narrower scope description

This audit is read-only documentation. No skill files were modified. For active routing in this fork, see `skills/skill-routing-arbitrator/SKILL.md`.
