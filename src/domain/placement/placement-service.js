import { createPlacedBuilding } from "../building/placed-building.js";
import { createPlacementSlot, createSlotId } from "./placement-slot.js";

export function getAvailableSlots(towerState, connectionType = null) {
  if (!connectionType) return towerState.availableSlots;
  return towerState.availableSlots.filter((slot) => slot.connectionType === connectionType && !slot.isOccupied);
}

export function canPlaceBuilding(towerState, buildingDefinition, slotId) {
  const errors = [];
  const slot = towerState.availableSlots.find((candidate) => candidate.id === slotId);

  if (!slot) {
    errors.push(`Slot not available: ${slotId}`);
    return { ok: false, errors };
  }

  if (slot.isOccupied) {
    errors.push(`Slot is occupied: ${slotId}`);
  }

  if (!buildingDefinition.allowedConnections.includes(slot.connectionType)) {
    errors.push(`Building ${buildingDefinition.id} cannot use ${slot.connectionType} connection`);
  }

  if (buildingDefinition.size.w > slot.supportedSize.w || buildingDefinition.size.h > slot.supportedSize.h) {
    errors.push(`Building ${buildingDefinition.id} does not fit slot ${slotId}`);
  }

  return { ok: errors.length === 0, errors };
}

export function placeBuilding(towerState, buildingDefinition, slotId, options = {}) {
  const validation = canPlaceBuilding(towerState, buildingDefinition, slotId);

  if (!validation.ok) {
    throw new Error(validation.errors.join("; "));
  }

  const slot = towerState.availableSlots.find((candidate) => candidate.id === slotId);
  const instanceId = options.instanceId ?? `${buildingDefinition.id}:${towerState.placedBlocks.length + 1}`;
  const selectedFunction = options.selectedFunction ?? buildingDefinition.functionOptions[0] ?? null;

  const placedBuilding = createPlacedBuilding({
    instanceId,
    definitionId: buildingDefinition.id,
    position: slot.position,
    rotationOrSide: slot.connectionType,
    selectedFunction,
    connectedSlots: [slot.id]
  });

  const nextSlots = createSlotsForBuilding(placedBuilding, buildingDefinition);
  const availableSlots = towerState.availableSlots
    .filter((candidate) => candidate.id !== slotId)
    .concat(nextSlots);

  const height = Math.max(towerState.height, placedBuilding.position.y + buildingDefinition.size.h);

  return Object.freeze({
    ...towerState,
    placedBlocks: Object.freeze([...towerState.placedBlocks, placedBuilding]),
    availableSlots: Object.freeze(availableSlots),
    height,
    history: Object.freeze([
      ...towerState.history,
      Object.freeze({
        type: "building_placed",
        buildingId: buildingDefinition.id,
        instanceId,
        slotId,
        position: placedBuilding.position
      })
    ])
  });
}

export function createTopSlotsForBuilding(placedBuilding, buildingDefinition) {
  return createSlotsForBuilding(placedBuilding, {
    ...buildingDefinition,
    placementRules: { ...buildingDefinition.placementRules, createsSlots: ["Top"] }
  });
}

export function createSlotsForBuilding(placedBuilding, buildingDefinition) {
  const slotTypes = buildingDefinition.placementRules.createsSlots ?? [];

  return slotTypes.flatMap((connectionType) => createSlotsByType(placedBuilding, buildingDefinition, connectionType));
}

function createSlotsByType(placedBuilding, buildingDefinition, connectionType) {
  if (connectionType === "Top") {
    return Array.from({ length: buildingDefinition.size.w }, (_, offset) => createSlot({
      placedBuilding,
      connectionType,
      position: {
        x: placedBuilding.position.x + offset,
        y: placedBuilding.position.y + buildingDefinition.size.h
      }
    }));
  }

  if (connectionType === "SideLeft") {
    return [createSlot({
      placedBuilding,
      connectionType,
      position: { x: placedBuilding.position.x - 1, y: placedBuilding.position.y },
      supportedSize: { w: 2, h: 1 }
    })];
  }

  if (connectionType === "SideRight") {
    return [createSlot({
      placedBuilding,
      connectionType,
      position: { x: placedBuilding.position.x + buildingDefinition.size.w, y: placedBuilding.position.y },
      supportedSize: { w: 2, h: 1 }
    })];
  }

  if (connectionType === "Bridge") {
    return [createSlot({
      placedBuilding,
      connectionType,
      position: { x: placedBuilding.position.x + buildingDefinition.size.w, y: placedBuilding.position.y },
      supportedSize: { w: 2, h: 1 }
    })];
  }

  if (connectionType === "Decor") {
    return [createSlot({
      placedBuilding,
      connectionType,
      position: { x: placedBuilding.position.x, y: placedBuilding.position.y + buildingDefinition.size.h }
    })];
  }

  if (connectionType === "Utility") {
    return [createSlot({
      placedBuilding,
      connectionType,
      position: { x: placedBuilding.position.x, y: placedBuilding.position.y }
    })];
  }

  return [];
}

function createSlot({ placedBuilding, connectionType, position, supportedSize = { w: 1, h: 1 } }) {
  return createPlacementSlot({
    id: createSlotId({
      x: position.x,
      y: position.y,
      connectionType,
      ownerBuildingId: placedBuilding.instanceId
    }),
    position,
    connectionType,
    supportedSize,
    ownerBuildingId: placedBuilding.instanceId
  });
}
