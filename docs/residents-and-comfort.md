# Residents and Comfort

## Goal

The first residents system connects housing, energy and comfort.

It is still a domain calculation. UI receives ready-to-render summary data and does not own settlement rules.

## Domain API

Implemented in `src/domain/residents/residents-service.js`.

### `recalculateResidentsState(towerState)`

Returns a new tower state with:

- `population`;
- `capacity`;
- `freeCapacity`;
- `comfort`;
- `comfortDemand`;
- `isComfortable`;
- updated `placedBlocks[].residentCount`.

Rules:

- housing capacity comes from `baseStats.housing`;
- only powered housing receives residents;
- unpowered housing still counts as capacity, but has zero residents;
- comfort contribution comes from powered buildings;
- current comfort demand is `ceil(population / 2)`.

### `getResidentsSummary(towerState)`

Returns a compact summary for UI and tests.

### `getHabitableBlocks(towerState)`

Returns placed blocks with housing capacity.

## Game integration

The build flow now recalculates systems in this order:

1. placement;
2. energy;
3. residents and comfort.

This means a newly placed energy source can immediately power nearby housing and allow residents to move in.

## Presentation

Implemented in `src/presentation/ui/residents-panel.js`.

It returns:

- residents summary;
- simple comfort mood;
- home rows with resident count, capacity and power state.

Debug moods:

- `quiet` — no residents yet;
- `cozy` — comfort is enough;
- `strained` — comfort demand is higher than current comfort.

## Commands

```bash
npm run test:residents
npm test
```

## Current limits

- Residents move in automatically.
- No named residents yet.
- No happiness history yet.
- Comfort is a simple aggregate score.
- Unpowered housing loses residents immediately.
