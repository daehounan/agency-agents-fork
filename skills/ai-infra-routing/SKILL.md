---
name: ai-infra-routing
description: AI agent infrastructure specialist routing — multi-agent orchestration, Language Server Protocol indexing, MCP server development, agent identity / authentication, and shared identity graph operations. Use when the user is building multi-agent systems, designing agent authentication and audit trails, building code intelligence with LSP / semantic indexing, developing MCP servers, or operating a shared identity graph that multiple AI agents resolve against. Triggers on agent orchestration, multi-agent, LSP, language server, semantic indexing, MCP server, model context protocol, agent identity, agent authentication, agent authorization, identity graph, entity resolution, agent audit trail.
---

# AI Infrastructure Routing Skill

When this skill activates, route based on the agent-infra domain.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Multi-agent coordination, workflow orchestration | `agents-orchestrator` |
| LSP, language server protocol, semantic code indexing | `lsp-index-engineer` |
| MCP server development, AI agent tooling, custom tools/resources | `specialized-mcp-builder` |
| Agent identity, authentication, authorization, audit trails | `agentic-identity-trust` |
| Shared identity graph, entity resolution across agents | `identity-graph-operator` |
| Chief of staff / cross-cutting orchestration for a single principal | `specialized-chief-of-staff` |
| Workflow discovery and mapping before code is written | `specialized-workflow-architect` |

## Complementary skills (often stronger)

- MCP server patterns → `ecc:mcp-server-patterns` skill / `ecc:mcp-builder-20260419` / `anthropic-skills:mcp-builder`
- Autonomous agent harness → `ecc:autonomous-agent-harness` skill
- Agent harness construction → `ecc:agent-harness-construction` skill
- Agent eval → `ecc:agent-eval` skill
- Agent introspection / debugging → `ecc:agent-introspection-debugging` skill
- Agentic engineering principles → `ecc:agentic-engineering` skill
- Continuous agent loops → `ecc:continuous-agent-loop` skill
- Multi-agent swarm → `ruflo-swarm:swarm` skill
- Pipeline coordinator → `ruflo-autopilot:autopilot` skill

## Heuristic

ecc and ruflo plugins generally have stronger / more current implementations for agent infrastructure. Prefer those skills first. Use agency-agents agents only when:
- You want the persona depth / narrative style (e.g., `specialized-chief-of-staff` distinct opinionated point of view)
- The specific named role (LSP engineer, identity graph operator) doesn't exist elsewhere

## When NOT to use

- Building a specific feature (not infra) → use feature-specific skill
- Code review of agent code → `ecc:code-reviewer`
- General software architecture → `ecc:architect` agent
