# Polish, Saves and Mobile UI

## Goal

This stage prepares the prototype for the next pass: content readiness checks, save snapshots and a compact mobile HUD.

## Save snapshots

Implemented in `src/infrastructure/save/save-snapshot.js`.

The save snapshot wraps the existing replay/share payload and adds session metadata.

It includes:

- save format version;
- slot id;
- saved-at marker;
- session id;
- turn;
- selected building id;
- replay/share payload;
- session events.

### API

- `createSaveSnapshot(session, options)`;
- `serializeSaveSnapshot(snapshot)`;
- `restoreSessionFromSaveSnapshot(snapshot)`;
- `createSaveSummary(snapshot)`.

The restored session rebuilds the tower through the replay pipeline.

## Mobile HUD

Implemented in `src/presentation/ui/mobile-hud.js`.

The HUD state contains:

- session id;
- current turn;
- tower height;
- block count;
- residents/capacity;
- energy meter;
- comfort meter;
- beauty;
- technology;
- choice tray with up to three options;
- save badge summary.

`renderMobileHudText` is a debug renderer for this state.

## Content readiness summary

Implemented in `src/content/palettes/polish-content-summary.js`.

It checks whether the prototype catalog has enough definitions, required categories and required connection types for the first playable pass.

## Test

Added:

```bash
node test/polish-save-mobile-ui.test.js
```

This test checks content readiness, save snapshot serialization, session restoration and mobile HUD rendering.

## Current limits

- Save storage is in-memory/JSON only.
- No platform storage adapter yet.
- Mobile HUD is debug text state, not a final UI layout.
- Content readiness checks are simple catalog coverage checks.
