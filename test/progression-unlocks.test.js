import assert from "node:assert/strict";

import { getProgressionSummary } from "../src/domain/progression/index.js";
import { createGameSession, getChoiceOptions, selectAndBuild } from "../src/game/index.js";
import { getProgressionPanel, renderProgressionPanelText } from "../src/presentation/index.js";

let session = createGameSession({ id: "progression-unlocks-test" });
let summary = getProgressionSummary(session.tower);

assert.equal(summary.beauty, 2);
assert.equal(summary.technology, 0);
assert.ok(summary.unlockedBuildingIds.includes("residential_small_01"));
assert.ok(summary.unlockedBuildingIds.includes("windmill_small_01"));
assert.ok(!summary.unlockedBuildingIds.includes("workshop_small_01"));
assert.ok(!summary.unlockedBuildingIds.includes("art_studio_small_01"));
assert.throws(() => selectAndBuild(session, "workshop_small_01"), /Building is locked/);

let choices = getChoiceOptions(session.tower, { limit: 5 });
assert.ok(!choices.some((choice) => choice.id === "workshop_small_01"));
assert.ok(!choices.some((choice) => choice.id === "art_studio_small_01"));

session = selectAndBuild(session, "residential_small_01", { instanceId: "progression-home" });
session = selectAndBuild(session, "windmill_small_01", { instanceId: "progression-windmill" });
session = selectAndBuild(session, "library_small_01", { instanceId: "progression-library" });

summary = getProgressionSummary(session.tower);
assert.equal(summary.beauty, 5);
assert.equal(summary.technology, 3);
assert.ok(summary.unlockedBuildingIds.includes("workshop_small_01"));
assert.ok(summary.unlockedBuildingIds.includes("art_studio_small_01"));
assert.ok(summary.unlockedBuildingIds.includes("decor_balcony_01"));
assert.ok(!summary.unlockedBuildingIds.includes("roof_garden_01"));

choices = getChoiceOptions(session.tower, { limit: 6 });
assert.ok(choices.some((choice) => choice.id === "workshop_small_01"));
assert.ok(choices.some((choice) => choice.id === "art_studio_small_01"));

session = selectAndBuild(session, "cafe_small_01", { instanceId: "progression-cafe" });
summary = getProgressionSummary(session.tower);
assert.ok(summary.beauty >= 7);
assert.ok(session.tower.population >= 2);
assert.ok(summary.unlockedBuildingIds.includes("roof_garden_01"));

const panel = getProgressionPanel(session.tower);
assert.equal(panel.lockedCount, 0);
assert.ok(panel.unlockedCount >= 9);

const text = renderProgressionPanelText(session.tower);
assert.match(text, /Progression: beauty=/);
assert.match(text, /unlocked Roof Garden/);

console.log("Progression unlocks test passed.");
