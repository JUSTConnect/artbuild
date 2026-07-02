import { buildingDefinitions } from "../buildings/index.js";

export const prototypeContentGoals = Object.freeze({
  minBuildingDefinitions: 10,
  requiredCategories: Object.freeze([
    "Residential",
    "Recreation",
    "Knowledge",
    "Technology",
    "Art",
    "Energy",
    "Decor",
    "Foundation"
  ]),
  requiredConnectionTypes: Object.freeze([
    "Top",
    "SideLeft",
    "SideRight",
    "Bridge",
    "Decor",
    "Utility"
  ])
});

export function getPolishContentSummary(catalog = buildingDefinitions) {
  const categories = [...new Set(catalog.map((definition) => definition.category))].sort();
  const connectionTypes = [...new Set(catalog.flatMap((definition) => definition.allowedConnections))].sort();
  const missingCategories = prototypeContentGoals.requiredCategories.filter((category) => !categories.includes(category));
  const missingConnectionTypes = prototypeContentGoals.requiredConnectionTypes.filter((connection) => !connectionTypes.includes(connection));

  return Object.freeze({
    totalDefinitions: catalog.length,
    categories: Object.freeze(categories),
    connectionTypes: Object.freeze(connectionTypes),
    initiallyUnlockedCount: catalog.filter((definition) => definition.unlockRequirements.initiallyUnlocked).length,
    gatedCount: catalog.filter((definition) => !definition.unlockRequirements.initiallyUnlocked).length,
    missingCategories: Object.freeze(missingCategories),
    missingConnectionTypes: Object.freeze(missingConnectionTypes),
    isPrototypeReady: catalog.length >= prototypeContentGoals.minBuildingDefinitions
      && missingCategories.length === 0
      && missingConnectionTypes.length === 0
  });
}
