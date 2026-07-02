# Domain Placement

## Scope

This document describes the first implementation of the tower and placement domain for the construction prototype.

The implementation is intentionally engine-agnostic. It does not create visual objects and does not know anything about UI. Presentation code can render the resulting state, but the placement rules live in `src/domain`.

## Main models

### TowerState

Implemented in `src/domain/tower/tower-state.js`.

Stores:

- `id`
- `placedBlocks`
- `availableSlots`
- `height`
- aggregate counters for population, capacity, energy, beauty, technology and comfort
- `unlockedBuildingTags`
- `history`

The first tower starts from a foundation definition and creates top placement slots from its width.

### PlacedBuilding

Implemented in `src/domain/building/placed-building.js`.

Stores:

- `instanceId`
- `definitionId`
- logical `position`
- `rotationOrSide`
- `selectedFunction`
- `isPowered`
- `residentCount`
- `connectedSlots`

### PlacementSlot

Implemented in `src/domain/placement/placement-slot.js`.

Stores:

- `id`
- logical `position`
- `connectionType`
- `supportedSize`
- `ownerBuildingId`
- `isOccupied`

## Placement flow

`src/domain/placement/placement-service.js` exposes:

- `getAvailableSlots`
- `canPlaceBuilding`
- `placeBuilding`
- `createTopSlotsForBuilding`

For the first prototype, placement supports the `Top` flow:

1. Find an available slot.
2. Check that the building supports the slot connection type.
3. Check that the building fits the slot size.
4. Create a `PlacedBuilding`.
5. Remove the used slot.
6. Add new top slots if the building creates them.
7. Update tower height and append a history event.

## Current limitations

- Side placement and bridges are not implemented yet.
- Placement is logical only; no engine transforms or collision checks are used.
- Multi-cell support is intentionally minimal and should be expanded when larger buildings are added.

## Validation

Run:

```bash
npm run test:placement
npm test
```

The placement test checks tower creation, available slots, valid top placement, invalid connection type placement and reusing an occupied/removed slot.
