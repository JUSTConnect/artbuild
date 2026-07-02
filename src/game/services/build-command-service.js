import { getBuildingDefinitionById } from "../../content/buildings/index.js";
import { getAvailableSlots, placeBuilding } from "../../domain/placement/index.js";
import { selectBuilding, updateSessionTower } from "../session/game-session.js";

export function getFirstValidTopSlot(tower, buildingDefinition) {
  return getAvailableSlots(tower, "Top").find((slot) => {
    if (slot.isOccupied) return false;
    if (!buildingDefinition.allowedConnections.includes(slot.connectionType)) return false;
    if (buildingDefinition.size.w > slot.supportedSize.w) return false;
    if (buildingDefinition.size.h > slot.supportedSize.h) return false;
    return true;
  }) ?? null;
}

export function buildSelectedBuilding(session, { slotId = null, instanceId = null } = {}) {
  if (!session.selectedBuildingId) {
    throw new Error("Cannot build without a selected building");
  }

  const buildingDefinition = getBuildingDefinitionById(session.selectedBuildingId);

  if (!buildingDefinition) {
    throw new Error(`Unknown building definition: ${session.selectedBuildingId}`);
  }

  const targetSlotId = slotId ?? getFirstValidTopSlot(session.tower, buildingDefinition)?.id;

  if (!targetSlotId) {
    throw new Error(`No valid slot for building: ${buildingDefinition.id}`);
  }

  const nextTower = placeBuilding(session.tower, buildingDefinition, targetSlotId, {
    instanceId: instanceId ?? `${buildingDefinition.id}:turn-${session.turn + 1}`
  });

  return updateSessionTower(
    session,
    nextTower,
    Object.freeze({
      type: "build_completed",
      buildingId: buildingDefinition.id,
      slotId: targetSlotId,
      turn: session.turn + 1
    })
  );
}

export function selectAndBuild(session, buildingId, options = {}) {
  return buildSelectedBuilding(selectBuilding(session, buildingId), options);
}
