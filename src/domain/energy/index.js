export { getEnergySummary, getGridDistance, powersBlock, recalculateEnergyState } from "./energy-service.js";

export const energyModule = Object.freeze({
  name: "domain/energy",
  responsibility: "Owns energy production, energy radius and powered/unpowered building state.",
  exports: ["recalculateEnergyState", "getEnergySummary", "powersBlock", "getGridDistance"]
});
