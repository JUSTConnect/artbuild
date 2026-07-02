import { buildingDefinitions } from "../../content/buildings/index.js";
import { canPlaceBuilding } from "../../domain/placement/index.js";
import { getProgressionMetrics, isBuildingUnlocked } from "../../domain/progression/index.js";

const defaultCategoryWeights = Object.freeze({
  Residential: 100,
  Recreation: 80,
  Knowledge: 70,
  Technology: 70,
  Energy: 65,
  Art: 55,
  Commerce: 50,
  Decor: 35,
  Foundation: 0
});

export function createChoiceCard(definition, tower) {
  const validSlotIds = tower.availableSlots
    .filter((slot) => canPlaceBuilding(tower, definition, slot.id).ok)
    .map((slot) => slot.id);

  return Object.freeze({
    id: definition.id,
    title: definition.name,
    category: definition.category,
    rarity: definition.rarity,
    visualPrefabId: definition.visualPrefabId,
    functionOptions: Object.freeze([...definition.functionOptions]),
    baseStats: Object.freeze({ ...definition.baseStats }),
    unlockRequirements: Object.freeze({ ...(definition.unlockRequirements ?? {}) }),
    validSlotIds: Object.freeze(validSlotIds),
    isPlayable: validSlotIds.length > 0,
    isUnlocked: isBuildingUnlocked(definition, getProgressionMetrics(tower))
  });
}

export function getChoiceOptions(tower, {
  limit = 3,
  catalog = buildingDefinitions,
  categoryWeights = defaultCategoryWeights
} = {}) {
  return catalog
    .filter((definition) => !definition.placementRules.startOnly)
    .map((definition) => createChoiceCard(definition, tower))
    .filter((card) => card.isUnlocked)
    .filter((card) => card.isPlayable)
    .sort((a, b) => compareChoiceCards(a, b, categoryWeights))
    .slice(0, limit);
}

export function compareChoiceCards(a, b, categoryWeights) {
  const weightA = categoryWeights[a.category] ?? 1;
  const weightB = categoryWeights[b.category] ?? 1;

  if (weightA !== weightB) return weightB - weightA;
  if (a.rarity !== b.rarity) return rarityRank(a.rarity) - rarityRank(b.rarity);
  return a.id.localeCompare(b.id);
}

function rarityRank(rarity) {
  if (rarity === "Common") return 0;
  if (rarity === "Uncommon") return 1;
  if (rarity === "Rare") return 2;
  return 3;
}

export function requireChoiceOption(choiceOptions, choiceId) {
  const choice = choiceOptions.find((option) => option.id === choiceId);

  if (!choice) {
    throw new Error(`Choice is not available: ${choiceId}`);
  }

  return choice;
}
