import { getBuildingDefinitionById } from "../../content/buildings/index.js";
import { recalculateEnergyState } from "../../domain/energy/index.js";
import { canPlaceBuilding, placeBuilding } from "../../domain/placement/index.js";
import { recalculateProgressionState } from "../../domain/progression/index.js";
import { recalculateResidentsState } from "../../domain/residents/index.js";
import { createTowerState } from "../../domain/tower/index.js";

export const replayFormatVersion = 1;

export function createReplayTimeline(towerState, { msPerStep = 700 } = {}) {
  return Object.freeze(towerState.history.map((event, index) => {
    const definition = getBuildingDefinitionById(event.buildingId);

    return Object.freeze({
      step: index,
      atMs: index * msPerStep,
      type: event.type,
      buildingId: event.buildingId,
      title: definition?.name ?? event.buildingId,
      instanceId: event.instanceId,
      slotId: event.slotId ?? null,
      connectionType: event.connectionType ?? null,
      selectedFunction: event.selectedFunction ?? null,
      position: Object.freeze({ ...(event.position ?? { x: 0, y: 0 }) })
    });
  }));
}

export function createSharePayload(towerState, { title = "Artbuild Tower", msPerStep = 700 } = {}) {
  return Object.freeze({
    version: replayFormatVersion,
    title,
    towerId: towerState.id,
    finalStats: Object.freeze({
      height: towerState.height ?? 0,
      blocks: towerState.placedBlocks.length,
      population: towerState.population ?? 0,
      capacity: towerState.capacity ?? 0,
      energyProduced: towerState.energyProduced ?? 0,
      energyRequired: towerState.energyRequired ?? 0,
      beauty: towerState.beauty ?? 0,
      technology: towerState.technology ?? 0,
      comfort: towerState.comfort ?? 0
    }),
    timeline: createReplayTimeline(towerState, { msPerStep })
  });
}

export function serializeSharePayload(payload) {
  return JSON.stringify(payload, null, 2);
}

export function restoreTowerFromSharePayload(payload) {
  if (!payload || payload.version !== replayFormatVersion) {
    throw new Error(`Unsupported replay payload version: ${payload?.version ?? "missing"}`);
  }

  const timeline = payload.timeline ?? [];
  const startEvent = timeline.find((event) => event.type === "tower_started");

  if (!startEvent) {
    throw new Error("Replay payload is missing tower_started event");
  }

  const foundationDefinition = getBuildingDefinitionById(startEvent.buildingId);

  if (!foundationDefinition) {
    throw new Error(`Unknown foundation definition: ${startEvent.buildingId}`);
  }

  let tower = recalculateAllSystems(createTowerState({
    id: payload.towerId ?? "replayed-tower",
    foundationDefinition
  }));

  for (const event of timeline.filter((item) => item.type === "building_placed")) {
    const definition = getBuildingDefinitionById(event.buildingId);

    if (!definition) {
      throw new Error(`Unknown replay building definition: ${event.buildingId}`);
    }

    const slotId = event.slotId ?? findReplaySlotId(tower, definition, event);

    if (!slotId || !canPlaceBuilding(tower, definition, slotId).ok) {
      throw new Error(`Cannot replay placement for ${event.buildingId}`);
    }

    tower = recalculateAllSystems(placeBuilding(tower, definition, slotId, {
      instanceId: event.instanceId,
      selectedFunction: event.selectedFunction ?? undefined
    }));
  }

  return tower;
}

export function findReplaySlotId(towerState, definition, event) {
  const slot = towerState.availableSlots.find((candidate) => {
    if (!canPlaceBuilding(towerState, definition, candidate.id).ok) return false;
    if (!event.position) return true;
    return candidate.position.x === event.position.x && candidate.position.y === event.position.y;
  });

  return slot?.id ?? null;
}

function recalculateAllSystems(towerState) {
  return recalculateProgressionState(
    recalculateResidentsState(recalculateEnergyState(towerState))
  );
}
