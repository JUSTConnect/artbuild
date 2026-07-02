import assert from "node:assert/strict";

import { getPolishContentSummary } from "../src/content/index.js";
import {
  createSaveSnapshot,
  createSaveSummary,
  restoreSessionFromSaveSnapshot,
  serializeSaveSnapshot
} from "../src/infrastructure/index.js";
import { createGameSession, selectAndBuild } from "../src/game/index.js";
import { createMobileHudState, renderMobileHudText } from "../src/presentation/index.js";

let session = createGameSession({ id: "polish-save-mobile-ui-test" });
session = selectAndBuild(session, "residential_small_01", { instanceId: "polish-home" });
session = selectAndBuild(session, "windmill_small_01", { instanceId: "polish-windmill" });
session = selectAndBuild(session, "library_small_01", { instanceId: "polish-library" });

const contentSummary = getPolishContentSummary();
assert.equal(contentSummary.isPrototypeReady, true);
assert.ok(contentSummary.totalDefinitions >= 10);
assert.deepEqual(contentSummary.missingCategories, []);
assert.deepEqual(contentSummary.missingConnectionTypes, []);
assert.ok(contentSummary.gatedCount >= 1);

const snapshot = createSaveSnapshot(session, {
  slotId: "test-slot",
  savedAt: "2026-07-02T12:00:00.000Z",
  title: "Polish Save"
});

assert.equal(snapshot.version, 1);
assert.equal(snapshot.session.id, session.id);
assert.equal(snapshot.session.turn, session.turn);
assert.equal(snapshot.sharePayload.finalStats.blocks, session.tower.placedBlocks.length);

const summary = createSaveSummary(snapshot);
assert.equal(summary.slotId, "test-slot");
assert.equal(summary.turn, session.turn);
assert.equal(summary.blocks, session.tower.placedBlocks.length);
assert.equal(summary.population, session.tower.population);

const json = serializeSaveSnapshot(snapshot);
assert.match(json, /Polish Save/);
assert.match(json, /test-slot/);

const restoredSession = restoreSessionFromSaveSnapshot(JSON.parse(json));
assert.equal(restoredSession.id, session.id);
assert.equal(restoredSession.turn, session.turn);
assert.equal(restoredSession.tower.placedBlocks.length, session.tower.placedBlocks.length);
assert.equal(restoredSession.tower.population, session.tower.population);
assert.equal(restoredSession.tower.beauty, session.tower.beauty);

const hud = createMobileHudState(restoredSession, { saveSnapshot: snapshot });
assert.equal(hud.sessionId, session.id);
assert.equal(hud.header.blocks, restoredSession.tower.placedBlocks.length);
assert.ok(hud.choiceTray.length <= 3);
assert.equal(hud.save.slotId, "test-slot");

const hudText = renderMobileHudText(hud);
assert.match(hudText, /HUD polish-save-mobile-ui-test/);
assert.match(hudText, /Energy/);
assert.match(hudText, /Choices:/);
assert.match(hudText, /save=test-slot/);

console.log("Polish save mobile UI test passed.");
