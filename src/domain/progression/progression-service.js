import { buildingDefinitions } from "../../content/buildings/index.js";

export function recalculateProgressionState(towerState, catalog = buildingDefinitions) {
  const metrics = getProgressionMetrics(towerState);
  const unlockedBuildingIds = catalog
    .filter((definition) => isBuildingUnlocked(definition, metrics))
    .map((definition) => definition.id);
  const unlockedBuildingTags = [...new Set(catalog
    .filter((definition) => unlockedBuildingIds.includes(definition.id))
    .map((definition) => definition.category))];

  return Object.freeze({
    ...towerState,
    beauty: metrics.beauty,
    technology: metrics.technology,
    unlockedBuildingIds: Object.freeze(unlockedBuildingIds),
    unlockedBuildingTags: Object.freeze(unlockedBuildingTags),
    lockedBuildingIds: Object.freeze(catalog
      .filter((definition) => !unlockedBuildingIds.includes(definition.id))
      .map((definition) => definition.id))
  });
}

export function getProgressionMetrics(towerState) {
  const placedDefinitionIds = towerState.placedBlocks.map((block) => block.definitionId);
  const beauty = towerState.placedBlocks.reduce((sum, block) => {
    const definition = buildingDefinitions.find((item) => item.id === block.definitionId);
    return sum + (definition?.baseStats.beauty ?? 0);
  }, 0);
  const technology = towerState.placedBlocks.reduce((sum, block) => {
    const definition = buildingDefinitions.find((item) => item.id === block.definitionId);
    return sum + (block.isPowered ? (definition?.baseStats.technology ?? 0) : 0);
  }, 0);

  return Object.freeze({
    beauty,
    technology,
    population: towerState.population ?? 0,
    height: towerState.height ?? 0,
    placedDefinitionIds: Object.freeze(placedDefinitionIds)
  });
}

export function isBuildingUnlocked(definition, metrics) {
  const requirements = definition.unlockRequirements ?? {};

  if (requirements.initiallyUnlocked) return true;
  if ((requirements.minBeauty ?? 0) > metrics.beauty) return false;
  if ((requirements.minTechnology ?? 0) > metrics.technology) return false;
  if ((requirements.minPopulation ?? 0) > metrics.population) return false;
  if ((requirements.minHeight ?? 0) > metrics.height) return false;

  const requiredBuildings = requirements.requiresBuildingIds ?? [];
  return requiredBuildings.every((buildingId) => metrics.placedDefinitionIds.includes(buildingId));
}

export function getProgressionSummary(towerState) {
  return Object.freeze({
    beauty: towerState.beauty ?? 0,
    technology: towerState.technology ?? 0,
    unlockedBuildingIds: Object.freeze(towerState.unlockedBuildingIds ?? []),
    lockedBuildingIds: Object.freeze(towerState.lockedBuildingIds ?? []),
    unlockedBuildingTags: Object.freeze(towerState.unlockedBuildingTags ?? [])
  });
}

export function getUnlockPreview(towerState, catalog = buildingDefinitions) {
  const metrics = getProgressionMetrics(towerState);

  return Object.freeze(catalog.map((definition) => Object.freeze({
    id: definition.id,
    title: definition.name,
    category: definition.category,
    isUnlocked: isBuildingUnlocked(definition, metrics),
    requirements: Object.freeze({ ...(definition.unlockRequirements ?? {}) })
  })));
}
