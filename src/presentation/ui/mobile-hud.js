import { getChoiceOptions } from "../../game/index.js";
import { createSaveSummary } from "../../infrastructure/index.js";

export function createMobileHudState(session, { saveSnapshot = null } = {}) {
  const tower = session.tower;
  const choices = getChoiceOptions(tower, { limit: 3 });

  return Object.freeze({
    sessionId: session.id,
    turn: session.turn,
    towerId: tower.id,
    header: Object.freeze({
      height: tower.height,
      blocks: tower.placedBlocks.length,
      residents: tower.population ?? 0,
      capacity: tower.capacity ?? 0
    }),
    meters: Object.freeze({
      energy: `${tower.energyProduced ?? 0}/${tower.energyRequired ?? 0}`,
      comfort: `${tower.comfort ?? 0}/${tower.comfortDemand ?? 0}`,
      beauty: tower.beauty ?? 0,
      technology: tower.technology ?? 0
    }),
    choiceTray: Object.freeze(choices.map((choice) => Object.freeze({
      id: choice.id,
      title: choice.title,
      category: choice.category,
      validSlotCount: choice.validSlotIds.length
    }))),
    save: saveSnapshot ? createSaveSummary(saveSnapshot) : null
  });
}

export function renderMobileHudText(hudState) {
  const choices = hudState.choiceTray
    .map((choice, index) => `${index + 1}. ${choice.title} (${choice.validSlotCount})`)
    .join(" | ");
  const save = hudState.save ? `save=${hudState.save.slotId}@turn${hudState.save.turn}` : "save=none";

  return [
    `HUD ${hudState.sessionId} turn=${hudState.turn}`,
    `Tower ${hudState.towerId}: h=${hudState.header.height} blocks=${hudState.header.blocks} residents=${hudState.header.residents}/${hudState.header.capacity}`,
    `Energy ${hudState.meters.energy} Comfort ${hudState.meters.comfort} Beauty ${hudState.meters.beauty} Tech ${hudState.meters.technology}`,
    `Choices: ${choices || "none"}`,
    save
  ].join("\n");
}
