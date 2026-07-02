import assert from "node:assert/strict";

import {
  createReplayTimeline,
  createSharePayload,
  restoreTowerFromSharePayload,
  serializeSharePayload
} from "../src/infrastructure/index.js";
import { createGameSession, selectAndBuild } from "../src/game/index.js";
import { renderReplayTimelineText, renderShareSummaryText } from "../src/presentation/index.js";

let session = createGameSession({ id: "replay-share-test" });
session = selectAndBuild(session, "residential_small_01", { instanceId: "replay-home" });
session = selectAndBuild(session, "windmill_small_01", { instanceId: "replay-windmill" });
session = selectAndBuild(session, "library_small_01", { instanceId: "replay-library" });
session = selectAndBuild(session, "wooden_bridge_01", { instanceId: "replay-bridge" });
session = selectAndBuild(session, "floating_foundation_01", { instanceId: "replay-foundation" });

const timeline = createReplayTimeline(session.tower, { msPerStep: 500 });
assert.equal(timeline.length, session.tower.history.length);
assert.equal(timeline[0].type, "tower_started");
assert.equal(timeline[1].connectionType, "Top");
assert.equal(timeline.at(-1).buildingId, "floating_foundation_01");
assert.equal(timeline.at(-1).atMs, (timeline.length - 1) * 500);

const payload = createSharePayload(session.tower, {
  title: "Replay Test Tower",
  msPerStep: 500
});
assert.equal(payload.version, 1);
assert.equal(payload.finalStats.blocks, session.tower.placedBlocks.length);
assert.equal(payload.finalStats.height, session.tower.height);
assert.equal(payload.timeline.length, timeline.length);

const json = serializeSharePayload(payload);
assert.match(json, /Replay Test Tower/);
assert.match(json, /replay-foundation/);

const restoredTower = restoreTowerFromSharePayload(JSON.parse(json));
assert.equal(restoredTower.placedBlocks.length, session.tower.placedBlocks.length);
assert.equal(restoredTower.height, session.tower.height);
assert.equal(restoredTower.population, session.tower.population);
assert.equal(restoredTower.beauty, session.tower.beauty);
assert.deepEqual(
  restoredTower.placedBlocks.map((block) => block.definitionId),
  session.tower.placedBlocks.map((block) => block.definitionId)
);
assert.deepEqual(
  restoredTower.placedBlocks.map((block) => block.position),
  session.tower.placedBlocks.map((block) => block.position)
);

const timelineText = renderReplayTimelineText(session.tower, { msPerStep: 500 });
assert.match(timelineText, /0. 0ms start Small Island Foundation/);
assert.match(timelineText, /place Floating Foundation/);

const summaryText = renderShareSummaryText(payload);
assert.match(summaryText, /Replay Test Tower/);
assert.match(summaryText, /blocks=/);
assert.match(summaryText, /beauty=/);

console.log("Replay share test passed.");
