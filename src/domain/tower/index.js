export { createInitialTopSlots, createTowerState } from "./tower-state.js";

export const towerModule = Object.freeze({
  name: "domain/tower",
  responsibility: "Owns TowerState shape, placed building list, available slots and tower-level counters.",
  exports: ["createTowerState", "createInitialTopSlots"]
});
