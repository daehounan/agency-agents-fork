---
name: xr-spatial-routing
description: Spatial computing and XR development routing — Apple Vision Pro, visionOS, WebXR, AR/VR, Metal, spatial UI design, immersive controls, terminal integration. Use when the user asks about Vision Pro app development, visionOS APIs, WebXR/three.js, ARKit/RealityKit, spatial interaction patterns, immersive cockpit controls, hand tracking, eye tracking, mixed reality, or Metal-based 3D rendering on Apple platforms. Triggers on Vision Pro, visionOS, WebXR, ARKit, RealityKit, Metal, spatial UI, immersive, AR/VR/XR, hand tracking.
---

# XR Spatial Routing Skill

When this skill activates, route to the appropriate spatial-computing agent based on platform and concern.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Spatial UX, interaction patterns, immersive UI | `xr-interface-architect` |
| visionOS native Swift app | `visionos-spatial-engineer` |
| macOS spatial / Metal / high-performance 3D | `macos-spatial-metal-engineer` |
| WebXR, browser-based AR/VR | `xr-immersive-developer` |
| Cockpit / control-surface XR | `xr-cockpit-interaction-specialist` |
| CLI / terminal tooling in XR context | `terminal-integration-specialist` |

## Combining with engineering agents

For Vision Pro apps involving network/backend work, also invoke `engineering-backend-architect` in parallel. For visionOS UI shipping production, pair with `engineering-frontend-developer` for any companion web surfaces.
