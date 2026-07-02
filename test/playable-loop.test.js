import assert from "node:assert/strict";

import { createGameSession, getPrototypeBuildOptions, runPrototypeBuildLoop } from "../src/game/index.js";
import { renderPrototypeRun, renderTowerText } from "../src/presentation/index.js";

const session = createGameSession({ id: "playable-loop-test" });
const initialOptions = getPrototypeBuildOptions(session.tower, { limit: 3 });

assert.equal(initialOptions.length, 3);
assert.ok(initialOptions.every((option) => !option.placementRules.startOnly));

const result = runPrototypeBuildLoop({ steps: 10, session });

assert.equal(result.snapshots.length, 10);
assert.equal(result.session.turn, 10);
assert.equal(result.session.tower.placedBlocks.length, 11);
assert.ok(result.session.tower.height >= 4);
assert.ok(result.session.tower.availableSlots.length >= 1);
assert.equal(result.session.tower.history.filter((event) => event.type === "building_placed").length, 10);
assert.ok(result.snapshots.every((snapshot) => snapshot.options.length > 0));
assert.ok(result.snapshots.every((snapshot) => snapshot.selected));

const towerText = renderTowerText(result.session.tower);
assert.match(towerText, /Tower tower-1/);
assert.match(towerText, /blocks=11/);

const runText = renderPrototypeRun(result);
assert.match(runText, /Step 1:/);
assert.match(runText, /Step 10:/);

console.log("Playable loop test passed.");
