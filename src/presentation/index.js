export {
  renderAvailableSlotsText,
  renderPrototypeRun,
  renderPrototypeSnapshot,
  renderTowerText
} from "./tower-view/text-tower-view.js";
export { getEnergyFeedback, renderEnergyFeedbackText } from "./animation/energy-feedback.js";
export { renderChoiceCardsText, renderChoiceCardText } from "./ui/choice-cards.js";
export { getComfortMood, getResidentsPanel, renderResidentsPanelText } from "./ui/residents-panel.js";

export const presentationModules = Object.freeze([
  Object.freeze({
    name: "presentation/tower-view",
    responsibility: "Renders tower state and placement feedback without owning game rules.",
    exports: ["renderTowerText", "renderAvailableSlotsText", "renderPrototypeRun"]
  }),
  Object.freeze({
    name: "presentation/ui",
    responsibility: "Renders selection cards, stats and player-facing prompts.",
    exports: [
      "renderChoiceCardsText",
      "renderChoiceCardText",
      "getResidentsPanel",
      "renderResidentsPanelText",
      "getComfortMood"
    ]
  }),
  Object.freeze({
    name: "presentation/animation",
    responsibility: "Owns visual transitions such as building pop-in, window light and camera movement.",
    exports: ["getEnergyFeedback", "renderEnergyFeedbackText"]
  })
]);
