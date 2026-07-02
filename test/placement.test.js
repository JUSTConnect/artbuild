import assert from "node:assert/strict";

import { getBuildingDefinitionById } from "../src/content/buildings/index.js";
import { createTowerState } from "../src/domain/tower/index.js";
import { canPlaceBuilding, getAvailableSlots, placeBuilding } from "../src/domain/placement/index.js";

const foundation = getBuildingDefinitionById("foundation_island_01");
const residential = getBuildingDefinitionById("residential_small_01");
const balcony = getBuildingDefinitionById("decor_balcony_01");

let tower = createTowerState({ id: "test-tower", foundationDefinition: foundation });

assert.equal(tower.placedBlocks.length, 1);
assert.equal(tower.availableSlots.length, 3);
assert.equal(tower.height, 1);
assert.equal(tower.history[0].type, "tower_started");

const firstTopSlot = getAvailableSlots(tower, "Top")[0];
assert.equal(canPlaceBuilding(tower, residential, firstTopSlot.id).ok, true);
assert.equal(canPlaceBuilding(tower, balcony, firstTopSlot.id).ok, false);

tower = placeBuilding(tower, residential, firstTopSlot.id, {
  instanceId: "residential-test-1",
  selectedFunction: "Housing"
});

assert.equal(tower.placedBlocks.length, 2);
assert.equal(tower.height, 2);
assert.equal(tower.availableSlots.some((slot) => slot.id === firstTopSlot.id), false);
assert.ok(getAvailableSlots(tower, "Top").length >= 3);
assert.equal(tower.history.at(-1).type, "building_placed");
assert.equal(tower.history.at(-1).buildingId, "residential_small_01");

assert.throws(
  () => placeBuilding(tower, residential, firstTopSlot.id),
  /Slot not available/
);

console.log("Placement domain test passed.");
