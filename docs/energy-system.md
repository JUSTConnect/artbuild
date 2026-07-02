# Energy System

## Goal

The first energy system tracks whether buildings are powered after each construction step.

It stays in the domain layer. Presentation receives already computed state and only renders feedback.

## Domain API

Implemented in `src/domain/energy/energy-service.js`.

### `recalculateEnergyState(towerState)`

Returns a new tower state with:

- `energyProduced`;
- `energyRequired`;
- `unpoweredCount`;
- `isEnergyBalanced`;
- updated `placedBlocks[].isPowered`.

Rules:

- buildings with `energyRequired = 0` are powered by default;
- buildings with `energyRequired > 0` need an energy source inside radius;
- radius comes from `placementRules.energyRadius`;
- distance is measured on the logical grid.

### `getEnergySummary(towerState)`

Returns a compact summary for UI and tests.

### `powersBlock(source, targetBlock)`

Checks whether one energy source powers a target block.

## Content

The first source is `windmill_small_01`.

Its content data already has:

- `energyProduced: 3`;
- `energyRequired: 0`;
- `placementRules.energyRadius: 1`.

## Game integration

`BuildCommandService` calls `recalculateEnergyState` after every successful placement.

`createGameSession` also initializes the first tower with an energy state.

## Presentation feedback

Implemented in `src/presentation/animation/energy-feedback.js`.

It returns:

- tower energy summary;
- global window light mode;
- per-building light state.

This is debug feedback for now. A future engine view can use the same data to light windows, dim buildings or show small warning markers.

## Commands

```bash
npm run test:energy
npm test
```

## Current limits

- Energy is radius-based, not wired through cables.
- Energy capacity is not consumed per source yet.
- Only logical grid distance is used.
- No final animation is implemented yet.
