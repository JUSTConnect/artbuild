# Replay and Share Pipeline

## Goal

This stage turns construction history into a replay/share contract.

The game already records `tower.history`. The replay pipeline makes that history exportable, readable and restorable.

## Replay format

Implemented in `src/infrastructure/sharing/replay-pipeline.js`.

Current format version: `1`.

A share payload contains:

- `version`;
- `title`;
- `towerId`;
- `finalStats`;
- `timeline`.

Each timeline entry contains:

- `step`;
- `atMs`;
- `type`;
- `buildingId`;
- `title`;
- `instanceId`;
- `slotId`;
- `connectionType`;
- `selectedFunction`;
- `position`.

## API

### `createReplayTimeline(towerState, options)`

Builds a time-based timeline from `tower.history`.

### `createSharePayload(towerState, options)`

Builds a JSON-ready payload for a future share/export flow.

### `serializeSharePayload(payload)`

Serializes the payload as readable JSON.

### `restoreTowerFromSharePayload(payload)`

Rebuilds a tower from the replay timeline by applying placement events again.

It also recalculates:

1. energy;
2. residents;
3. progression.

### `findReplaySlotId(towerState, definition, event)`

Fallback helper for older history entries that do not include `slotId`.

## Placement history changes

`building_placed` history events now include:

- `connectionType`;
- `selectedFunction`.

Older history can still replay when slot and position data are enough.

## Presentation

Implemented in `src/presentation/ui/replay-panel.js`.

It provides:

- `renderReplayTimelineText`;
- `renderShareSummaryText`.

These are debug helpers for now. A future renderer can use the same payload to render a vertical replay video or social share card.

## Commands

```bash
npm run test:replay
npm test
```

## Current limits

- Replay output is JSON only.
- No video renderer yet.
- No platform share SDK integration yet.
- No compression or save-file migration yet.
