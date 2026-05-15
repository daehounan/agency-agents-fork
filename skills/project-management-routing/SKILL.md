---
name: project-management-routing
description: Project management specialist routing for studio operations, cross-functional shepherding, experiment tracking, realistic scoping, and Jira workflow discipline. Use when the user asks about high-level portfolio orchestration, day-to-day studio efficiency, cross-team project coordination, A/B experiment management, converting specs to realistic tasks, or enforcing Jira-linked Git workflow and traceable commits. Triggers on portfolio management, multi-project, studio operations, project shepherding, cross-functional coordination, experiment tracking, A/B test management, hypothesis validation, realistic scoping, spec to tasks, Jira ticket, conventional commits, branch strategy.
---

# Project Management Routing Skill

When this skill activates, route based on the PM scope.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| High-level portfolio, strategic alignment, multi-project oversight | `project-management-studio-producer` |
| Cross-functional project coordination, timeline, stakeholders | `project-management-project-shepherd` |
| Day-to-day studio efficiency, process optimization | `project-management-studio-operations` |
| A/B test design, experiment tracking, hypothesis validation | `project-management-experiment-tracker` |
| Realistic scoping, spec → task conversion | `project-manager-senior` |
| Jira-linked Git workflow, conventional commits, branch strategy | `project-management-jira-workflow-steward` |

## Complementary skills

- Sprint planning → `product-management:sprint-planning` or `product-discovery-routing` skill
- Status report → `internal-comms` or `internal-comms-20260419`
- Capacity planning → `operations:capacity-plan`
- Change request → `operations:change-request`
- Process documentation → `operations:process-doc`
- Risk assessment → `operations:risk-assessment`
- Runbook → `operations:runbook`
- Jira integration → `ecc:jira` skill / `ecc:jira-integration`

## When NOT to use

- Engineering-only planning → `ecc:planner` agent
- Strategic engagement orchestration (full agency) → `strategy-nexus` skill
- Personal task management → `productivity:task-management`
