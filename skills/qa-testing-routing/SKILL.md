---
name: qa-testing-routing
description: Quality assurance and testing specialist routing across visual QA, certification, performance, API, accessibility, tools, and workflow optimization. Use when the user asks about evidence-based bug reporting with screenshots, production readiness certification, test result analysis, performance benchmarking, API endpoint testing, accessibility / WCAG / screen reader audits, tool evaluation, or process optimization in a QA context. Triggers on QA, test reporting, screenshot evidence, production ready, performance benchmark, load test, API testing, endpoint validation, accessibility audit, WCAG, screen reader, axe-core, ARIA, tool evaluation, process improvement, workflow optimization.
---

# QA & Testing Routing Skill

When this skill activates, route based on the type of QA work involved.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Visual regression, screenshot proof, bug documentation | `testing-evidence-collector` |
| Production readiness certification, release approval | `testing-reality-checker` |
| Test output analysis, metrics, coverage interpretation | `testing-test-results-analyzer` |
| Performance / load / speed testing | `testing-performance-benchmarker` |
| API endpoint validation, integration testing | `testing-api-tester` |
| WCAG audit, screen reader testing, ARIA verification | `testing-accessibility-auditor` |
| Software / tool evaluation, technology assessment | `testing-tool-evaluator` |
| Process analysis, workflow improvement, automation opportunity | `testing-workflow-optimizer` |

## Complementary skills (use together)

- For test authoring workflow → `ecc:tdd` / `ecc:tdd-workflow` skill
- For E2E test runs → `ecc:e2e` / `ecc:e2e-testing` skill
- For language-specific test review → `ecc:go-test`, `ecc:python-review`, etc.

## When NOT to use

- Writing new tests from scratch → use `ecc:tdd-workflow` instead
- Single-file code review → use `ecc:code-reviewer` agent
- Performance optimization implementation (not just measurement) → `ecc:performance-optimizer` agent
