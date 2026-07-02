# Godot Setup

This repository now contains a minimal Godot 4 project scaffold.

## How to open

1. Open Godot 4.x.
2. Click **Import**.
3. Select the repository root folder.
4. Choose `project.godot`.
5. Open the project.
6. Run the main scene: `res://scenes/main.tscn`.

## What is included

- `project.godot` at the repository root.
- `scenes/main.tscn` as the startup scene.
- `scripts/main.gd` as the first Godot script.
- `icon.svg` as a lightweight project icon.

## Current state

The gameplay prototype still lives in the JavaScript modules under `src/`.

The Godot scaffold is intentionally small. Its job is to make the repository visible to Godot and provide a clean place to start porting the existing systems into GDScript or a Godot-specific runtime layer.

## Suggested next porting order

1. Content definitions.
2. Tower state.
3. Placement slots and placement service.
4. Choice service.
5. Energy, residents and progression.
6. Save and replay pipeline.
7. Visual tower renderer.
