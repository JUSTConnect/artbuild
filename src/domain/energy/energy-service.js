import { getBuildingDefinitionById } from "../../content/buildings/index.js";

export function recalculateEnergyState(towerState) {
  const energySources = towerState.placedBlocks
    .map((block) => ({ block, definition: getBuildingDefinitionById(block.definitionId) }))
    .filter(({ definition }) => (definition?.baseStats.energyProduced ?? 0) > 0);

  const placedBlocks = towerState.placedBlocks.map((block) => {
    const definition = getBuildingDefinitionById(block.definitionId);
    const energyRequired = definition?.baseStats.energyRequired ?? 0;
    const isPowered = energyRequired === 0 || energySources.some((source) => powersBlock(source, block));

    return Object.freeze({
      ...block,
      isPowered
    });
  });

  const energyProduced = towerState.placedBlocks.reduce((sum, block) => {
    const definition = getBuildingDefinitionById(block.definitionId);
    return sum + (definition?.baseStats.energyProduced ?? 0);
  }, 0);

  const energyRequired = towerState.placedBlocks.reduce((sum, block) => {
    const definition = getBuildingDefinitionById(block.definitionId);
    return sum + (definition?.baseStats.energyRequired ?? 0);
  }, 0);

  const unpoweredCount = placedBlocks.filter((block) => !block.isPowered).length;

  return Object.freeze({
    ...towerState,
    placedBlocks: Object.freeze(placedBlocks),
    energyProduced,
    energyRequired,
    unpoweredCount,
    isEnergyBalanced: energyProduced >= energyRequired && unpoweredCount === 0
  });
}

export function powersBlock(source, targetBlock) {
  const radius = source.definition?.placementRules.energyRadius ?? 0;

  if (source.block.instanceId === targetBlock.instanceId) {
    return true;
  }

  return getGridDistance(source.block.position, targetBlock.position) <= radius;
}

export function getGridDistance(a, b) {
  return Math.abs(a.x - b.x) + Math.abs(a.y - b.y);
}

export function getEnergySummary(towerState) {
  return Object.freeze({
    produced: towerState.energyProduced ?? 0,
    required: towerState.energyRequired ?? 0,
    unpoweredCount: towerState.unpoweredCount ?? 0,
    isBalanced: towerState.isEnergyBalanced ?? false
  });
}
