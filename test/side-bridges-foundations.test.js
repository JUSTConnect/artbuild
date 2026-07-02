import assert from "node:assert/strict";

import { getBuildingDefinitionById } from "../src/content/buildings/index.js";
import { canPlaceBuilding, getAvailableSlots, placeBuilding } from "../src/domain/placement/index.js";
import { createTowerState } from "../src/domain/tower/index.js";
import { createGameSession, getFirstValidSlot, selectAndBuild } from "../src/game/index.js";

const islandFoundation = getBuildingDefinitionById("foundation_island_01");
const residential = getBuildingDefinitionById("residential_small_01");
const balcony = getBuildingDefinitionById("decor_balcony_01");
const bridge = getBuildingDefinitionById("wooden_bridge_01");
const floatingFoundation = getBuildingDefinitionById("floating_foundation_01");

const reefSession = createGameSession({ id: "reef-session", foundationId: "foundation_reef_01" });
assert.equal(reefSession.tower.placedBlocks[0].definitionId, "foundation_reef_01");
assert.equal(getAvailableSlots(reefSession.tower, "Top").length, 4);

let tower = createTowerState({ id: "side-bridge-test", foundationDefinition: islandFoundation });
const firstTopSlot = getAvailableSlots(tower, "Top")[0];
tower = placeBuilding(tower, residential, firstTopSlot.id, { instanceId: "side-home" });

assert.ok(getAvailableSlots(tower, "SideLeft").length >= 1);
assert.ok(getAvailableSlots(tower, "SideRight").length >= 1);
assert.ok(getAvailableSlots(tower, "Bridge").length >= 1);

const sideSlot = getAvailableSlots(tower, "SideLeft")[0];
assert.equal(canPlaceBuilding(tower, balcony, sideSlot.id).ok, true);
tower = placeBuilding(tower, balcony, sideSlot.id, { instanceId: "side-balcony" });
assert.ok(getAvailableSlots(tower, "Decor").length >= 1);

const bridgeSlot = getAvailableSlots(tower, "Bridge")[0];
assert.equal(canPlaceBuilding(tower, bridge, bridgeSlot.id).ok, true);
tower = placeBuilding(tower, bridge, bridgeSlot.id, { instanceId: "wooden-bridge" });
assert.ok(getAvailableSlots(tower, "Bridge").length >= 1);
assert.ok(getAvailableSlots(tower, "Top").length >= 5);

const foundationBridgeSlot = getAvailableSlots(tower, "Bridge")[0];
assert.equal(canPlaceBuilding(tower, floatingFoundation, foundationBridgeSlot.id).ok, true);
tower = placeBuilding(tower, floatingFoundation, foundationBridgeSlot.id, { instanceId: "floating-foundation" });
assert.equal(tower.placedBlocks.at(-1).definitionId, "floating_foundation_01");
assert.ok(getAvailableSlots(tower, "Top").length >= 7);

let session = createGameSession({ id: "bridge-build-flow" });
session = selectAndBuild(session, "residential_small_01", { instanceId: "flow-home" });
session = selectAndBuild(session, "windmill_small_01", { instanceId: "flow-windmill" });
session = selectAndBuild(session, "library_small_01", { instanceId: "flow-library" });

assert.ok(session.tower.unlockedBuildingIds.includes("wooden_bridge_01"));
assert.ok(session.tower.unlockedBuildingIds.includes("floating_foundation_01"));
assert.equal(getFirstValidSlot(session.tower, bridge).connectionType, "Bridge");
session = selectAndBuild(session, "wooden_bridge_01", { instanceId: "flow-bridge" });
assert.equal(session.tower.placedBlocks.at(-1).definitionId, "wooden_bridge_01");
assert.ok(getAvailableSlots(session.tower, "Bridge").length >= 1);
session = selectAndBuild(session, "floating_foundation_01", { instanceId: "flow-foundation" });
assert.equal(session.tower.placedBlocks.at(-1).definitionId, "floating_foundation_01");

console.log("Side bridges foundations test passed.");
