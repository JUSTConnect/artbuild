import assert from "node:assert/strict";

import { getEnergySummary, getGridDistance } from "../src/domain/energy/index.js";
import { createGameSession, selectAndBuild } from "../src/game/index.js";
import { getEnergyFeedback, renderEnergyFeedbackText } from "../src/presentation/index.js";

let session = createGameSession({ id: "energy-system-test" });

assert.deepEqual(getEnergySummary(session.tower), {
  produced: 0,
  required: 0,
  unpoweredCount: 0,
  isBalanced: true
});
assert.equal(getGridDistance({ x: 0, y: 0 }, { x: 1, y: 2 }), 3);

session = selectAndBuild(session, "residential_small_01", {
  instanceId: "house-without-energy"
});

let summary = getEnergySummary(session.tower);
assert.equal(summary.produced, 0);
assert.equal(summary.required, 1);
assert.equal(summary.unpoweredCount, 1);
assert.equal(summary.isBalanced, false);
assert.equal(session.tower.placedBlocks.find((block) => block.instanceId === "house-without-energy").isPowered, false);

session = selectAndBuild(session, "windmill_small_01", {
  instanceId: "nearby-windmill"
});

summary = getEnergySummary(session.tower);
assert.equal(summary.produced, 3);
assert.equal(summary.required, 1);
assert.equal(summary.unpoweredCount, 0);
assert.equal(summary.isBalanced, true);
assert.equal(session.tower.placedBlocks.find((block) => block.instanceId === "house-without-energy").isPowered, true);
assert.equal(session.tower.placedBlocks.find((block) => block.instanceId === "nearby-windmill").isPowered, true);

const feedback = getEnergyFeedback(session.tower);
assert.equal(feedback.windowLightMode, "lit");
assert.equal(feedback.buildingStates.length, session.tower.placedBlocks.length);

const text = renderEnergyFeedbackText(session.tower);
assert.match(text, /Energy: 3\/1/);
assert.match(text, /on Small Residential House/);
assert.match(text, /on Small Windmill/);

console.log("Energy system test passed.");
