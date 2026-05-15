---
name: general-engineering-routing
description: General engineering specialist routing for frontend, backend, mobile, AI/ML, DevOps, SRE, security, architecture, code review, database optimization, rapid prototyping, and codebase onboarding. Use when the user asks about implementing a feature, building an API, mobile app development, ML model integration, CI/CD pipelines, SLO / error budget design, application security threat modeling, system architecture decisions, code quality review, database schema or query optimization, fast POC creation, or understanding an unfamiliar codebase. Distinct from niche-engineering-routing which covers embedded, voice AI, email intel, threat detection, CMS, AI remediation, and autonomous optimization.
---

# General Engineering Routing Skill

When this skill activates, route based on the engineering domain.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| React / Vue / Angular UI implementation, performance, accessibility | `engineering-frontend-developer` |
| API design, database architecture, scalable backend systems | `engineering-backend-architect` |
| iOS / Android native, React Native, Flutter cross-platform | `engineering-mobile-app-builder` |
| ML model development, deployment, AI feature integration | `engineering-ai-engineer` |
| CI/CD pipelines, infrastructure automation, cloud ops | `engineering-devops-automator` |
| Fast POC, MVP, hackathon-style iteration | `engineering-rapid-prototyper` |
| Laravel / Livewire / FluxUI premium implementation | `engineering-senior-developer` |
| Application security threat modeling, secure code review | `engineering-security-engineer` |
| SLO, error budgets, observability, chaos, toil reduction | `engineering-sre` |
| Production incident command, post-mortems, on-call | `engineering-incident-response-commander` |
| Read-only codebase exploration, factual onboarding | `engineering-codebase-onboarding-engineer` |
| Code review (constructive, actionable, non-style) | `engineering-code-reviewer` |
| PostgreSQL / MySQL schema, query optimization, indexing | `engineering-database-optimizer` |
| Branching strategy, conventional commits, history cleanup | `engineering-git-workflow-master` |
| System design, DDD, architectural patterns, trade-offs | `engineering-software-architect` |
| Data pipelines, lakehouse, ETL/ELT, dbt, Spark | `engineering-data-engineer` |
| Minimum-viable diff, refusing scope creep | `engineering-minimal-change-engineer` |
| Developer documentation, API reference, README, tutorials | `engineering-technical-writer` |

## Complementary skills (prefer over agent when match)

Many of these have ecc equivalents that are typically stronger:
- Architecture → `ecc:architect` agent / `ecc:architecture-decision-records` skill
- Code review → `ecc:code-reviewer` agent / `ecc:code-review` skill
- Security review → `ecc:security-review` skill / `ecc:security-reviewer` agent
- TDD workflow → `ecc:tdd-workflow` / `ecc:tdd` skill
- Performance optimization → `ecc:performance-optimizer` agent
- Database review → `ecc:database-reviewer` agent / `ecc:postgres-patterns` skill
- Git workflow → `ecc:git-workflow` skill
- Frontend patterns → `ecc:frontend-patterns`, `ecc:nextjs-turbopack`, `ecc:nuxt4-patterns`
- API design → `ecc:api-design` skill
- Backend patterns → `ecc:backend-patterns` skill

**Heuristic:** when both agency-agents and ecc cover the same area, prefer ecc skills/agents — they are typically more current and project-aware. Fall back to agency agents when ecc has no match or when the user wants the agency persona depth.

## When NOT to use

- Embedded firmware / voice AI / email intel / threat detection / CMS / AI remediation → `niche-engineering-routing` skill instead
- AI agent infrastructure (MCP, orchestrator, LSP) → `ai-infra-routing` skill instead
- Game engine work → `game-development-routing` skill
- XR / spatial → `xr-spatial-routing` skill
- Blockchain audit → `compliance-audit-routing` skill
