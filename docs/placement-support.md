# Placement Support Rules

This document tracks the first Godot implementation of issue #26.

## Goal

A building should not be placed fully in the air. The active build slots are filtered so the player can only click cells that have real support.

## Current implementation

The support rules live in `scripts/support_rules.gd` and run as a Godot autoload.

The controller observes the current tower slot buttons after `main.gd` renders the world. Unsupported slot buttons are disabled and hidden.

## Rules

- Level 1 is supported by terrain.
- On level 2 or higher, a new placement needs at least one supported bottom cell.
- A cell is supported if the same surface and cell index is occupied on the level below.
- Tall and shaped buildings support only the cells that are actually occupied by their footprint.
- For an L-shaped building, support is checked only for its bottom footprint cells.

## Notes

This is intentionally implemented as a small controller around the current prototype loop. A later refactor should move the support check directly into the core `_can_place` placement method when the Godot gameplay model is split out of `main.gd`.
