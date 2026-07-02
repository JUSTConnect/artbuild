import assert from "node:assert/strict";

import { getHabitableBlocks, getResidentsSummary } from "../src/domain/residents/index.js";
import { createGameSession, selectAndBuild } from "../src/game/index.js";
import { getComfortMood, getResidentsPanel, renderResidentsPanelText } from "../src/presentation/index.js";

let session = createGameSession({ id: "residents-comfort-test" });

assert.deepEqual(getResidentsSummary(session.tower), {
  population: 0,
  capacity: 0,
  freeCapacity: 0,
  comfort: 1,
  comfortDemand: 0,
  isComfortable: true
});
assert.equal(getComfortMood(getResidentsSummary(session.tower)), "quiet");

session = selectAndBuild(session, "residential_small_01", {
  instanceId: "dark-home"
});

let summary = getResidentsSummary(session.tower);
assert.equal(summary.capacity, 2);
assert.equal(summary.population, 0);
assert.equal(summary.freeCapacity, 2);
assert.equal(summary.comfort, 1);
assert.equal(summary.comfortDemand, 0);
assert.equal(summary.isComfortable, true);
assert.equal(getHabitableBlocks(session.tower).length, 1);
assert.equal(session.tower.placedBlocks.find((block) => block.instanceId === "dark-home").residentCount, 0);

session = selectAndBuild(session, "windmill_small_01", {
  instanceId: "resident-power"
});

summary = getResidentsSummary(session.tower);
assert.equal(summary.capacity, 2);
assert.equal(summary.population, 2);
assert.equal(summary.freeCapacity, 0);
assert.equal(summary.comfort, 2);
assert.equal(summary.comfortDemand, 1);
assert.equal(summary.isComfortable, true);
assert.equal(getComfortMood(summary), "cozy");
assert.equal(session.tower.placedBlocks.find((block) => block.instanceId === "dark-home").residentCount, 2);

const panel = getResidentsPanel(session.tower);
assert.equal(panel.homes.length, 1);
assert.equal(panel.homes[0].residentCount, 2);
assert.equal(panel.mood, "cozy");

const text = renderResidentsPanelText(session.tower);
assert.match(text, /Residents: 2\/2/);
assert.match(text, /comfort=2\/1/);
assert.match(text, /home Small Residential House: 2\/2/);

console.log("Residents comfort test passed.");
