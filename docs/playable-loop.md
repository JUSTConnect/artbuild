# Playable Loop Prototype

## Goal

This prototype checks the first construction loop without choosing a final game engine.

The loop:

1. Creates a game session.
2. Starts a tower from the foundation.
3. Collects up to three valid build options.
4. Selects a test building.
5. Places it into a valid top slot.
6. Updates tower state, height, slots and history.
7. Prints a text view of the tower.
8. Repeats the flow for 10 steps.

## Commands

```bash
npm run prototype:loop
npm run test:playable-loop
npm test
```

`npm run prototype:loop` prints the tower growth step by step.

## Runtime pieces

### Game session

Implemented in `src/game/session/game-session.js`.

The session stores the active tower, current turn, selected building id and session events.

### Build command service

Implemented in `src/game/services/build-command-service.js`.

Responsibilities:

- select a building;
- find the first valid top slot;
- call domain placement logic;
- return the updated session.

### Prototype loop service

Implemented in `src/game/services/prototype-loop.js`.

Responsibilities:

- collect up to three valid building options;
- skip foundation-only content;
- run a repeatable 10-step build scenario for tests.

### Text tower view

Implemented in `src/presentation/tower-view/text-tower-view.js`.

The text renderer makes the loop easy to inspect before a real visual engine is connected.

Glyphs:

```text
___ foundation
[H] residential
[C] recreation
[L] knowledge
[T] technology
[A] art
[W] energy
[*] decor
```

## Current limits

- This is a text/debug prototype, not final UI.
- The loop chooses options automatically for repeatable tests.
- Only top placement is used.
- Energy, residents and progression are not applied yet.
- Visual animation is represented as snapshots.

## Done for this stage

- A session can be created.
- At least three valid options are available.
- 10 sequential buildings can be placed.
- Tower height and available slots update after placement.
- A readable tower view can be rendered.
- Automated tests cover the flow.
