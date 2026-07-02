# Choice Service

## Goal

`ChoiceService` turns the temporary prototype option list into a real game service for the first choice-from-three loop.

It is still engine-agnostic and does not render UI directly. It returns choice cards that presentation code can display.

## Main API

Implemented in `src/game/services/choice-service.js`.

### `getChoiceOptions(tower, options)`

Returns up to three playable choice cards.

Rules:

- skip foundation-only content;
- only include buildings that can be placed in at least one available slot;
- sort by simple category weights;
- keep output deterministic for tests.

### `createChoiceCard(definition, tower)`

Creates a card with:

- id;
- title;
- category;
- rarity;
- visual prefab id;
- function options;
- base stats;
- valid slot ids;
- playable flag.

### `requireChoiceOption(choiceOptions, choiceId)`

Returns the selected choice or throws if the choice is not currently available.

## Presentation

Implemented in `src/presentation/ui/choice-cards.js`.

`renderChoiceCardsText` and `renderChoiceCardText` provide a simple debug representation of the three options.

A future engine UI should use the same card data, not duplicate choice rules.

## Prototype loop integration

`src/game/services/prototype-loop.js` now uses `getChoiceOptions`, so the playable loop and future UI share the same option-generation rules.

## Commands

```bash
npm run test:choice
npm test
```

## Current limits

- Category weights are simple constants.
- Unlock rules are not applied yet.
- Energy, residents, beauty and technology are not used for choice weighting yet.
- The first playable loop still auto-selects a card for repeatable tests.
