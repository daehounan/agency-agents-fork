---
name: agency-roster
description: List and discover available specialist agents from the agency-agents fork. Use when the user asks "what agents do I have", "which agent should I use for X", "list the available specialists", "show me the agent roster", or wants to browse capabilities across the 163-agent collection. Also use when uncertain which agent to delegate to and want to ground the choice in the actual installed roster.
---

# Agency Roster Skill

When this skill activates, help the user discover and choose specialist agents.

## Action

1. List agents in `~/.claude/agents/` filtered by relevance to the user's stated need.
2. For each candidate, surface name + one-line description from the file's frontmatter.
3. Recommend the best match with a one-sentence rationale.
4. If multiple match, propose calling them in parallel.

## Roster overview (163 agents, 14 divisions + 16 strategy playbooks)

- **academic** (5): anthropologist, geographer, historian, narratologist, psychologist
- **design** (8): UI/UX designer, brand guardian, visual storyteller, whimsy injector, etc.
- **engineering** (27): frontend, backend, AI, DevOps, SRE, security, embedded, voice AI, etc.
- **finance** (5): bookkeeper, financial analyst, FP&A, investment researcher, tax strategist
- **game-development** (20): Unity/Unreal/Godot/Blender/Roblox + cross-engine roles
- **marketing** (15, China excluded): SEO, growth hacker, content, Twitter/IG/TikTok/Reddit/LinkedIn, book co-author, AEO/GEO, YouTube
- **paid-media** (7): PPC strategist, auditor, search query, tracking, creative, programmatic, paid social
- **product** (5): sprint prioritizer, trend researcher, feedback synthesizer, behavioral nudge, product manager
- **project-management** (6): studio producer, project shepherd, studio ops, experiment tracker, senior PM, Jira steward
- **sales** (8): outbound, discovery, deal strategist, sales engineer, proposal, pipeline, account, sales coach
- **spatial-computing** (6): XR interface, visionOS, macOS Metal, WebXR, cockpit, terminal integration
- **specialized** (37): orchestrator, LSP, AP, blockchain audit, compliance, healthcare CS, hospitality, legal vertical, real estate, mortgage, **Korean Business Navigator**, **Japanese Business Navigator**, etc.
- **support** (6): support responder, analytics, finance tracker, infra, legal compliance, exec summary
- **testing** (8): evidence collector, reality checker, performance benchmarker, API tester, accessibility auditor, etc.

Plus **strategy/** — 16 NEXUS playbook documents (not agents, no frontmatter): EXECUTIVE-BRIEF, QUICKSTART, nexus-strategy, 7 phase playbooks, 4 scenario runbooks, 2 coordination docs. Routed via `strategy-nexus` skill, not the Agent tool.

## When NOT to use

- User has clearly named an agent → just delegate, no roster needed
- User wants ecc/Anthropic skill instead of agent → don't push roster
