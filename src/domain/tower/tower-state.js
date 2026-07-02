import { createPlacedBuilding } from "../building/placed-building.js";
import { createPlacementSlot, createSlotId } from "../placement/placement-slot.js";

export function createTowerState({ id = "tower-1", foundationDefinition }) {
  if (!foundationDefinition) throw new Error("createTowerState requires foundationDefinition");

  const foundationInstanceId = `${foundationDefinition.id}:0`;
  const foundation = createPlacedBuilding({
    instanceId: foundationInstanceId,
    definitionId: foundationDefinition.id,
    position: { x: 0, y: 0 },
    selectedFunction: foundationDefinition.functionOptions[0] ?? "Foundation",
    connectedSlots: []
  });

  return Object.freeze({
    id,
    placedBlocks: Object.freeze([foundation]),
    availableSlots: Object.freeze(createInitialTopSlots(foundation, foundationDefinition)),
    height: foundationDefinition.size.h,
    population: 0,
    capacity: 0,
    energyProduced: 0,
    energyRequired: 0,
    beauty: foundationDefinition.baseStats.beauty ?? 0,
    technology: foundationDefinition.baseStats.technology ?? 0,
    comfort: foundationDefinition.baseStats.comfort ?? 0,
    unlockedBuildingTags: Object.freeze([]),
    history: Object.freeze([
      Object.freeze({
        type: "tower_started",
        buildingId: foundationDefinition.id,
        instanceId: foundationInstanceId,
        position: foundation.position
      })
    ])
  });
}

export function createInitialTopSlots(foundation, foundationDefinition) {
  return Array.from({ length: foundationDefinition.size.w }, (_, x) => {
    const y = foundationDefinition.size.h;
    return createPlacementSlot({
      id: createSlotId({
        x,
        y,
        connectionType: "Top",
        ownerBuildingId: foundation.instanceId
      }),
      position: { x, y },
      connectionType: "Top",
      supportedSize: { w: 1, h: 1 },
      ownerBuildingId: foundation.instanceId
    });
  });
}
