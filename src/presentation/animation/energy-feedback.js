import { getBuildingDefinitionById } from "../../content/buildings/index.js";
import { getEnergySummary } from "../../domain/energy/index.js";

export function getEnergyFeedback(tower) {
  const summary = getEnergySummary(tower);

  return Object.freeze({
    ...summary,
    windowLightMode: summary.unpoweredCount > 0 ? "mixed" : "lit",
    buildingStates: Object.freeze(tower.placedBlocks.map((block) => {
      const definition = getBuildingDefinitionById(block.definitionId);

      return Object.freeze({
        instanceId: block.instanceId,
        definitionId: block.definitionId,
        title: definition?.name ?? block.definitionId,
        category: definition?.category ?? "Unknown",
        isPowered: block.isPowered,
        windowLightMode: block.isPowered ? "lit" : "dark"
      });
    }))
  });
}

export function renderEnergyFeedbackText(tower) {
  const feedback = getEnergyFeedback(tower);
  const lines = feedback.buildingStates.map((state) => {
    const marker = state.isPowered ? "on" : "off";
    return `${marker} ${state.title} (${state.instanceId})`;
  });

  return [
    `Energy: ${feedback.produced}/${feedback.required} unpowered=${feedback.unpoweredCount} mode=${feedback.windowLightMode}`,
    ...lines
  ].join("\n");
}
