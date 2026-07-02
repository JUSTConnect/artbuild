import { getBuildingDefinitionById } from "../../content/buildings/index.js";

export function recalculateResidentsState(towerState) {
  const placedBlocks = towerState.placedBlocks.map((block) => {
    const definition = getBuildingDefinitionById(block.definitionId);
    const housing = definition?.baseStats.housing ?? 0;
    const residentCount = block.isPowered && housing > 0 ? housing : 0;

    return Object.freeze({
      ...block,
      residentCount
    });
  });

  const capacity = placedBlocks.reduce((sum, block) => {
    const definition = getBuildingDefinitionById(block.definitionId);
    return sum + (definition?.baseStats.housing ?? 0);
  }, 0);

  const population = placedBlocks.reduce((sum, block) => sum + block.residentCount, 0);
  const comfort = placedBlocks.reduce((sum, block) => {
    const definition = getBuildingDefinitionById(block.definitionId);
    const contribution = definition?.baseStats.comfort ?? 0;
    return sum + (block.isPowered ? contribution : 0);
  }, 0);
  const comfortDemand = Math.ceil(population / 2);

  return Object.freeze({
    ...towerState,
    placedBlocks: Object.freeze(placedBlocks),
    population,
    capacity,
    comfort,
    comfortDemand,
    freeCapacity: Math.max(capacity - population, 0),
    isComfortable: population === 0 || comfort >= comfortDemand
  });
}

export function getResidentsSummary(towerState) {
  return Object.freeze({
    population: towerState.population ?? 0,
    capacity: towerState.capacity ?? 0,
    freeCapacity: towerState.freeCapacity ?? 0,
    comfort: towerState.comfort ?? 0,
    comfortDemand: towerState.comfortDemand ?? 0,
    isComfortable: towerState.isComfortable ?? true
  });
}

export function getHabitableBlocks(towerState) {
  return Object.freeze(towerState.placedBlocks.filter((block) => {
    const definition = getBuildingDefinitionById(block.definitionId);
    return (definition?.baseStats.housing ?? 0) > 0;
  }));
}
