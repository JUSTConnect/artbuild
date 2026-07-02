import { buildingDefinitions } from "./building-definitions.js";

export { buildingDefinitions };

export function getBuildingDefinitionById(id) {
  return buildingDefinitions.find((definition) => definition.id === id) ?? null;
}

export function getInitiallyUnlockedBuildings() {
  return buildingDefinitions.filter((definition) => definition.unlockRequirements.initiallyUnlocked === true);
}

export function getBuildingsByCategory(category) {
  return buildingDefinitions.filter((definition) => definition.category === category);
}
