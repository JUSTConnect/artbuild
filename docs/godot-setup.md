# Godot Setup

This repository contains a playable Godot 4 prototype scaffold.

## How to open

1. Open Godot 4.x.
2. Click **Import**.
3. Select the repository root folder.
4. Choose `project.godot`.
5. Open the project.
6. Run the main scene: `res://scenes/main.tscn`.

## How to play

1. Choose cells per level: 1 to 5.
2. Choose terrain:
   - Plateau: one flat build surface.
   - River: two separated build surfaces.
   - Islands: three or four small build surfaces.
   - Mountains: two to four small build surfaces at different heights.
3. Click **Start Building**.
4. Choose one of three building cards.
5. Click a highlighted cell on the current level.
6. When **LEVEL UP** becomes active, click it to unlock the next build level.
7. Use keyboard **Up** and **Down** arrows to scroll the tall tower view. There is no visible scroll bar.
8. Click **Reset** to return to the setup menu.

## Current building types

- Жилище
- Кафе
- Библиотека
- Мастерская
- Лаборатория
- Университет
- Школа
- Лавка

## Current rules

- You can only build on the currently unlocked level.
- Empty cells on the active level are highlighted.
- Level Up depends on beauty, technology, residents and at least one block on the current level.
- Scroll is limited so the camera cannot move above the built/unlocked tower height.

## What is included

- `project.godot` at the repository root.
- `scenes/main.tscn` as the startup scene.
- `scripts/main.gd` as the playable prototype script.
- `icon.svg` as a lightweight project icon.

## Current state

The full engine-agnostic gameplay prototype still lives in JavaScript modules under `src/`.

The Godot scene now has a simplified playable loop that mirrors the core idea: terrain setup, level-based placement, stats, choices and level up.

## Suggested next porting order

1. Move Godot building data into a dedicated resource or data file.
2. Port TowerState and PlacementSlot concepts from `src/domain`.
3. Replace debug rectangles with real sprites/tiles.
4. Add save/load from the existing save/replay model.
5. Add camera polish, animation and mobile touch controls.
