export { getHabitableBlocks, getResidentsSummary, recalculateResidentsState } from "./residents-service.js";

export const residentsModule = Object.freeze({
  name: "domain/residents",
  responsibility: "Owns resident capacity, population and comfort-driven settlement rules.",
  exports: ["recalculateResidentsState", "getResidentsSummary", "getHabitableBlocks"]
});
