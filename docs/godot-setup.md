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

## Smartphone HUD layout

The scene is split into three fixed regions:

- Top HUD: title, current level and compact stats.
- Tower viewport: clipped construction area that contains the scrollable tower.
- Bottom HUD: choice cards, Level Up, hint and Reset.

Only the tower viewport should move when the tower grows or the player scrolls. The top and bottom HUD backdrops are fixed to keep the interface readable on a vertical smartphone screen.

## Current building types

- Жилище
- Кафе
- Библиотека
- Мастерская
- Лаборатория
- Университет
- Школа
- Лавка

## Footprints and shapes

Building cards are generated as a combination of building type and shape.

Current shapes include:

- 1x1;
- 1 wide / 2 high;
- 1 wide / 3 high;
- 2 wide / 1 high;
- 2x2;
- 2 wide / 3 high;
- 3 wide / 1 high;
- 3 wide / 2 high;
- 3x3;
- 2x2 L variants: left, right and upper;
- 2x3 tall L variants: left, right and upper;
- 3x2 flat / лежачая L variants: left, right, upper and mirrored;
- 3x3 corner variants;
- T shape;
- Tall T shape;
- U shape.

A tall building occupies cells on future levels. For example, a 1x3 building placed on level 1 blocks the same column on levels 1, 2 and 3. You can only build above it after unlocking a high enough level.

An L-shaped building only blocks the cells that belong to its actual shape. This means the open part above the shorter side can be used earlier, while the tall side stays blocked until higher levels are unlocked.

Mirrored and lying L forms are separate card footprints. They are filtered by the same placement rules, so a mirrored form appears only if it can actually fit inside the available foundation cells.

## Current rules

- You can only place the anchor of a new building on the currently unlocked level.
- The building footprint may occupy cells above the current level.
- Cards are filtered before they appear: if only one free cell remains, wider buildings are not offered.
- A card is offered only if it has at least one valid anchor cell on the current level.
- Empty cells on the active level are highlighted.
- After choosing a card, only valid anchor cells for that exact shape stay highlighted.
- Level Up depends on beauty, technology, residents and occupied cells on the current level.
- Scroll is limited so the camera cannot move above the built/unlocked tower height.

## What is included

- `project.godot` at the repository root.
- `scenes/main.tscn` as the startup scene.
- `scripts/main.gd` as the playable prototype script.

## Current state

The full engine-agnostic gameplay prototype still lives in JavaScript modules under `src/`.

The Godot scene now has a simplified playable loop that mirrors the core idea: terrain setup, footprint-based level placement, stats, choices and level up.

## Suggested next porting order

1. Move Godot building data into a dedicated resource or data file.
2. Port TowerState and PlacementSlot concepts from `src/domain`.
3. Replace debug rectangles with real sprites/tiles.
4. Add save/load from the existing save/replay model.
5. Add camera polish, animation and mobile touch controls.
