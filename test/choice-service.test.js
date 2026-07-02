import assert from "node:assert/strict";

import { createGameSession, getChoiceOptions, requireChoiceOption, selectAndBuild } from "../src/game/index.js";
import { renderChoiceCardsText } from "../src/presentation/index.js";

let session = createGameSession({ id: "choice-service-test" });
let choices = getChoiceOptions(session.tower, { limit: 3 });

assert.equal(choices.length, 3);
assert.deepEqual(choices.map((choice) => choice.id), [
  "residential_small_01",
  "cafe_small_01",
  "library_small_01"
]);
assert.ok(choices.every((choice) => choice.isPlayable));
assert.ok(choices.every((choice) => choice.validSlotIds.length > 0));
assert.ok(!choices.some((choice) => choice.id === "foundation_island_01"));
assert.ok(!choices.some((choice) => choice.id === "decor_balcony_01"));

const selected = requireChoiceOption(choices, "residential_small_01");
assert.equal(selected.title, "Small Residential House");
assert.throws(() => requireChoiceOption(choices, "decor_balcony_01"), /Choice is not available/);

const rendered = renderChoiceCardsText(choices);
assert.match(rendered, /1\. Small Residential House/);
assert.match(rendered, /validSlots=3/);

session = selectAndBuild(session, selected.id);
choices = getChoiceOptions(session.tower, { limit: 3 });

assert.equal(choices.length, 3);
assert.ok(choices.every((choice) => choice.validSlotIds.length > 0));
assert.equal(session.tower.placedBlocks.length, 2);
assert.equal(session.turn, 1);

console.log("Choice service test passed.");
