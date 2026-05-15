---
name: game-development-routing
description: Game development task router across Unity, Unreal Engine, Godot, Blender, and Roblox Studio. Use when the user asks about game design, level design, shaders, multiplayer networking (NGO / GAS / replication), gameplay scripting (Luau / GDScript / C# / C++ / Blueprint), game audio (FMOD / Wwise), technical art, Niagara/VFX, World Partition, DataStore, Game Passes, ScriptableObjects, ECS/DOTS, Material Editor, narrative branching, monetization loops, or any engine-specific implementation question. Triggers on Unity, Unreal, Godot, Roblox, Blender, GDScript, Blueprint, Luau, FMOD, Wwise, Nanite, Niagara, ScriptableObject, RemoteEvent, DataStore, 게임 개발, ゲーム開発.
---

# Game Development Routing Skill

When this skill activates, identify the engine and persona, then delegate to the most appropriate game-dev agent.

## Routing matrix

| User signal | Agent to invoke |
|---|---|
| Unity ECS, ScriptableObjects, DOTS, architecture | `unity-architect` |
| Unity shaders, Shader Graph, URP/HDRP | `unity-shader-graph-artist` |
| Unity multiplayer, Netcode for GameObjects | `unity-multiplayer-engineer` |
| Unity EditorWindows, asset pipeline tools | `unity-editor-tool-developer` |
| Unreal C++/Blueprint, GAS, gameplay systems | `unreal-systems-engineer` |
| Unreal Niagara, Material Editor, PCG | `unreal-technical-artist` |
| Unreal replication, GameMode/GameState | `unreal-multiplayer-architect` |
| Unreal World Partition, Landscape, LWC | `unreal-world-builder` |
| Godot GDScript, scene composition | `godot-gameplay-scripter` |
| Godot multiplayer, RPCs | `godot-multiplayer-engineer` |
| Godot shaders, VisualShader | `godot-shader-developer` |
| Blender Python, addon, pipeline | `blender-addon-engineer` |
| Roblox Luau, RemoteEvents, DataStore | `roblox-systems-scripter` |
| Roblox monetization, retention, Game Pass | `roblox-experience-designer` |
| Roblox UGC, avatar items | `roblox-avatar-creator` |
| Game design docs, economy balancing | `game-designer` |
| Level layout, encounter design | `level-designer` |
| Adaptive audio, FMOD/Wwise | `game-audio-engineer` |
| Branching dialogue, lore | `narrative-designer` |
| Engine-agnostic shaders, VFX, art pipeline | `technical-artist` |

## When multiple agents apply

Call them in parallel via separate Agent tool invocations in one message — e.g., a Unity multiplayer + shader task gets both `unity-multiplayer-engineer` and `unity-shader-graph-artist`.
