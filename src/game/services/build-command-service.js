import { getBuildingDefinitionById } from "../../content/buildings/index.js";
import { recalculateEnergyState } from "../../domain/energy/index.js";
import { getAvailableSlots, placeBuilding } from "../../domain/placement/index.js";
import {
  getProgressionMetrics,
  isBuildingUnlocked,
  recalculateProgressionState
} from "../../domain/progression/index.js";
import { recalculateResidentsState } from "../../domain/residents/index.js";
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

  if (!isBuildingUnlocked(buildingDefinition, getProgressionMetrics(session.tower))) {
    throw new Error(`Building is locked: ${buildingDefinition.id}`);
  }

  const targetSlotId = slotId ?? getFirstValidTopSlot(session.tower, buildingDefinition)?.id;

  if (!targetSlotId) {
    throw new Error(`No valid slot for building: ${buildingDefinition.id}`);
  }

  const placedTower = placeBuilding(session.tower, buildingDefinition, targetSlotId, {
    instanceId: instanceId ?? `${buildingDefinition.id}:turn-${session.turn + 1}`
  });
  const nextTower = recalculateProgressionState(
    recalculateResidentsState(recalculateEnergyState(placedTower))
  );

  return updateSessionTower(
    session,
    nextTower,
    Object.freeze({
      type: "build_completed",
      buildingId: buildingDefinition.id,
      slotId: targetSlotId,
      turn: session.turn + 1,
      energyProduced: nextTower.energyProduced,
      energyRequired: nextTower.energyRequired,
      unpoweredCount: nextTower.unpoweredCount,
      population: nextTower.population,
      capacity: nextTower.capacity,
      comfort: nextTower.comfort,
      isComfortable: nextTower.isComfortable,
      beauty: nextTower.beauty,
      technology: nextTower.technology,
      unlockedBuildingIds: nextTower.unlockedBuildingIds
    })
  );
}

export function selectAndBuild(session, buildingId, options = {}) {
  return buildSelectedBuilding(selectBuilding(session, buildingId), options);
}
