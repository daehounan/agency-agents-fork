---
name: strategy-nexus
description: NEXUS multi-agent orchestration playbook for end-to-end strategic engagements. Use when the user wants to orchestrate a full agency-style engagement across multiple specialists, run a phased strategic project (discovery → strategy → foundation → build → hardening → launch → operate), execute one of the named scenarios (startup MVP, enterprise feature, marketing campaign, incident response), or apply quality gates and handoff protocols across an entire team of agents. Triggers on NEXUS, multi-agent orchestration, agency engagement, phased strategic project, discovery phase, hardening phase, MVP launch, enterprise feature shipping, agent coordination matrix, quality gate, handoff protocol.
---

# NEXUS Strategy Orchestration Skill

When this skill activates, route the user to the appropriate NEXUS playbook based on engagement type and phase.

## Top-level entry points

| User signal | Playbook to load |
|---|---|
| "Where do I start?" / "how do I run an engagement?" | `strategy/QUICKSTART.md` |
| "Give me the executive view" | `strategy/EXECUTIVE-BRIEF.md` |
| "Walk me through the full doctrine" | `strategy/nexus-strategy.md` |

## Phase playbooks (sequential)

| Phase | Focus | Playbook |
|---|---|---|
| 0 | Intelligence & Discovery | `strategy/playbooks/phase-0-discovery.md` |
| 1 | Strategy & Architecture | `strategy/playbooks/phase-1-strategy.md` |
| 2 | Foundation & Scaffolding | `strategy/playbooks/phase-2-foundation.md` |
| 3 | Build & Iterate | `strategy/playbooks/phase-3-build.md` |
| 4 | Quality & Hardening | `strategy/playbooks/phase-4-hardening.md` |
| 5 | Launch & Growth | `strategy/playbooks/phase-5-launch.md` |
| 6 | Operate & Evolve | `strategy/playbooks/phase-6-operate.md` |

## Named scenarios (cross-phase)

| Scenario | Runbook |
|---|---|
| Startup MVP shipping | `strategy/runbooks/scenario-startup-mvp.md` |
| Enterprise feature delivery | `strategy/runbooks/scenario-enterprise-feature.md` |
| Marketing campaign launch | `strategy/runbooks/scenario-marketing-campaign.md` |
| Production incident response | `strategy/runbooks/scenario-incident-response.md` |

## Coordination assets

- Agent activation prompts: `strategy/coordination/agent-activation-prompts.md`
- Handoff templates: `strategy/coordination/handoff-templates.md`

## When NOT to use

- Single-agent task → call the agent directly
- Tactical question (one phase only) → load that one phase playbook
- Lightweight planning → use `ecc:planner` or `ecc:plan` instead
