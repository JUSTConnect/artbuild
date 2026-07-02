import { getBuildingDefinitionById } from "../../content/buildings/index.js";
import { getResidentsSummary } from "../../domain/residents/index.js";

export function getResidentsPanel(tower) {
  const summary = getResidentsSummary(tower);

  return Object.freeze({
    ...summary,
    mood: getComfortMood(summary),
    homes: Object.freeze(tower.placedBlocks
      .filter((block) => block.residentCount > 0 || getHousingCapacity(block) > 0)
      .map((block) => {
        const definition = getBuildingDefinitionById(block.definitionId);

        return Object.freeze({
          instanceId: block.instanceId,
          title: definition?.name ?? block.definitionId,
          capacity: getHousingCapacity(block),
          residentCount: block.residentCount,
          isPowered: block.isPowered
        });
      }))
  });
}

export function renderResidentsPanelText(tower) {
  const panel = getResidentsPanel(tower);
  const homes = panel.homes.map((home) => {
    const marker = home.isPowered ? "home" : "empty";
    return `${marker} ${home.title}: ${home.residentCount}/${home.capacity}`;
  });

  return [
    `Residents: ${panel.population}/${panel.capacity} comfort=${panel.comfort}/${panel.comfortDemand} mood=${panel.mood}`,
    ...homes
  ].join("\n");
}

export function getComfortMood(summary) {
  if (summary.population === 0) return "quiet";
  if (summary.isComfortable) return "cozy";
  return "strained";
}

function getHousingCapacity(block) {
  const definition = getBuildingDefinitionById(block.definitionId);
  return definition?.baseStats.housing ?? 0;
}
