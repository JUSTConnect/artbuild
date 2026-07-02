# Side Elements, Bridges and Foundations

## Goal

This stage expands the building graph beyond vertical stacking.

The tower can now grow sideways with side slots, bridge slots and additional foundations.

## Placement changes

Implemented in `src/domain/placement/placement-service.js`.

### `createSlotsForBuilding(placedBuilding, buildingDefinition)`

This is the new generic slot generator.

It supports:

- `Top`;
- `SideLeft`;
- `SideRight`;
- `Bridge`;
- `Decor`;
- `Utility`.

`createTopSlotsForBuilding` remains as a compatibility wrapper.

### Side slots

Buildings can create `SideLeft` and `SideRight` slots. These support small decor pieces and bridge pieces.

The first active example is `decor_balcony_01`.

### Bridge slots

Buildings can create `Bridge` slots. A bridge slot supports wider pieces and lets the tower grow horizontally.

The first active bridge is `wooden_bridge_01`.

### Build command changes

`BuildCommandService` now has:

- `getFirstValidTopSlot`;
- `getFirstValidSlot`.

Default build flow uses `getFirstValidSlot`, so side-only and bridge-only buildings can be built without a custom caller.

## New content

Added content:

- `foundation_reef_01` — alternate start foundation with four top slots;
- `wooden_bridge_01` — a two-wide bridge/decor piece;
- `floating_foundation_01` — a bridge-attached foundation that creates new top slots.

Updated content:

- more buildings can create bridge slots;
- residential blocks create side and bridge slots;
- balcony now creates a decor slot.

## Unlocks

Bridge content follows the existing progression system:

- `wooden_bridge_01` requires `technology >= 2`;
- `floating_foundation_01` requires `beauty >= 5` and `technology >= 3`.

## Commands

```bash
npm run test:side-bridges
npm test
```

## Current limits

- Collision checks are still simple.
- Bridges grow along the logical grid.
- Bridge visuals are placeholders.
- Floating foundations are logical pieces, not separate full islands yet.
