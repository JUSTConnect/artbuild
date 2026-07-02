# Progression Unlocks

## Goal

This stage adds the first unlock layer for beauty, technology and building availability.

Progression is a domain calculation. UI and choice cards read computed state instead of duplicating unlock rules.

## Domain API

Implemented in `src/domain/progression/progression-service.js`.

### `recalculateProgressionState(towerState)`

Returns a tower state with:

- `beauty`;
- `technology`;
- `unlockedBuildingIds`;
- `lockedBuildingIds`;
- `unlockedBuildingTags`.

Rules:

- beauty comes from all placed buildings;
- technology comes from powered placed buildings;
- unlock rules are read from `BuildingDefinition.unlockRequirements`;
- the build command rejects locked buildings.

### `getProgressionSummary(towerState)`

Returns a compact summary for UI and tests.

### `getUnlockPreview(towerState)`

Returns one entry per building with current lock state and requirements.

## First unlock thresholds

The initial always-available set remains:

- foundation;
- residential house;
- cafe;
- library;
- windmill.

The first gated content is:

- `workshop_small_01` — requires `technology >= 2`;
- `decor_balcony_01` — requires `beauty >= 4`;
- `art_studio_small_01` — requires `beauty >= 5`;
- `roof_garden_01` — requires `beauty >= 6` and `population >= 2`.

## Game integration

The build flow now recalculates systems in this order:

1. placement;
2. energy;
3. residents and comfort;
4. progression and unlocks.

Choice cards now hide locked buildings. Direct build commands also reject locked building definitions.

## Presentation

Implemented in `src/presentation/ui/progression-panel.js`.

It renders:

- current beauty;
- current technology;
- unlocked count;
- locked count;
- readable unlock requirements.

## Commands

```bash
npm run test:progression
npm test
```

## Current limits

- Unlocks are simple threshold checks.
- There is no player level yet.
- No unlock animation yet.
- No persistent save migration yet.
