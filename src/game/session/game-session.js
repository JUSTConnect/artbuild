import { getBuildingDefinitionById } from "../../content/buildings/index.js";
import { recalculateEnergyState } from "../../domain/energy/index.js";
import { recalculateResidentsState } from "../../domain/residents/index.js";
import { createTowerState } from "../../domain/tower/index.js";

export function createGameSession({
  id = "session-1",
  towerId = "tower-1",
  foundationId = "foundation_island_01"
} = {}) {
  const foundationDefinition = getBuildingDefinitionById(foundationId);

  if (!foundationDefinition) {
    throw new Error(`Unknown foundation definition: ${foundationId}`);
  }

  const tower = recalculateResidentsState(
    recalculateEnergyState(createTowerState({ id: towerId, foundationDefinition }))
  );

  return Object.freeze({
    id,
    turn: 0,
    selectedBuildingId: null,
    tower,
    events: Object.freeze([
      Object.freeze({
        type: "session_started",
        sessionId: id,
        towerId
      })
    ])
  });
}

export function updateSessionTower(session, tower, event = null) {
  return Object.freeze({
    ...session,
    turn: session.turn + 1,
    selectedBuildingId: null,
    tower,
    events: Object.freeze(event ? [...session.events, event] : session.events)
  });
}

export function selectBuilding(session, buildingId) {
  return Object.freeze({
    ...session,
    selectedBuildingId: buildingId,
    events: Object.freeze([
      ...session.events,
      Object.freeze({ type: "building_selected", buildingId, turn: session.turn })
    ])
  });
}
