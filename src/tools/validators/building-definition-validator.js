import {
  buildingCategories,
  connectionTypes,
  functionOptions,
  rarityLevels
} from "../../content/rules/building-taxonomy.js";

const requiredFields = Object.freeze([
  "id",
  "name",
  "category",
  "size",
  "allowedConnections",
  "functionOptions",
  "baseStats",
  "unlockRequirements",
  "visualPrefabId",
  "rarity",
  "placementRules"
]);

const requiredStats = Object.freeze([
  "housing",
  "energyProduced",
  "energyRequired",
  "beauty",
  "technology",
  "comfort"
]);

export function validateBuildingDefinition(definition) {
  const errors = [];

  for (const field of requiredFields) {
    if (!(field in definition)) {
      errors.push(`Missing required field: ${field}`);
    }
  }

  if (typeof definition.id !== "string" || definition.id.length === 0) {
    errors.push("id must be a non-empty string");
  }

  if (typeof definition.name !== "string" || definition.name.length === 0) {
    errors.push("name must be a non-empty string");
  }

  if (!buildingCategories.includes(definition.category)) {
    errors.push(`Unknown category: ${definition.category}`);
  }

  if (!definition.size || !Number.isInteger(definition.size.w) || !Number.isInteger(definition.size.h)) {
    errors.push("size must contain integer w and h values");
  } else {
    if (definition.size.w <= 0) errors.push("size.w must be positive");
    if (definition.size.h <= 0) errors.push("size.h must be positive");
  }

  if (!Array.isArray(definition.allowedConnections) || definition.allowedConnections.length === 0) {
    errors.push("allowedConnections must be a non-empty array");
  } else {
    for (const connection of definition.allowedConnections) {
      if (!connectionTypes.includes(connection)) {
        errors.push(`Unknown connection type: ${connection}`);
      }
    }
  }

  if (!Array.isArray(definition.functionOptions) || definition.functionOptions.length === 0) {
    errors.push("functionOptions must be a non-empty array");
  } else {
    for (const option of definition.functionOptions) {
      if (!functionOptions.includes(option)) {
        errors.push(`Unknown function option: ${option}`);
      }
    }
  }

  if (!definition.baseStats || typeof definition.baseStats !== "object") {
    errors.push("baseStats must be an object");
  } else {
    for (const stat of requiredStats) {
      if (!Number.isFinite(definition.baseStats[stat])) {
        errors.push(`baseStats.${stat} must be a finite number`);
      }
    }
  }

  if (!definition.unlockRequirements || typeof definition.unlockRequirements !== "object") {
    errors.push("unlockRequirements must be an object");
  }

  if (typeof definition.visualPrefabId !== "string" || definition.visualPrefabId.length === 0) {
    errors.push("visualPrefabId must be a non-empty string");
  }

  if (!rarityLevels.includes(definition.rarity)) {
    errors.push(`Unknown rarity: ${definition.rarity}`);
  }

  if (!definition.placementRules || typeof definition.placementRules !== "object") {
    errors.push("placementRules must be an object");
  }

  return errors;
}

export function validateBuildingCatalog(definitions) {
  const errors = [];
  const ids = new Set();

  if (!Array.isArray(definitions)) {
    return ["Building catalog must be an array"];
  }

  for (const definition of definitions) {
    const definitionErrors = validateBuildingDefinition(definition);

    if (ids.has(definition.id)) {
      definitionErrors.push(`Duplicate building id: ${definition.id}`);
    }

    ids.add(definition.id);

    for (const error of definitionErrors) {
      errors.push(`${definition.id ?? "<unknown>"}: ${error}`);
    }
  }

  return errors;
}
