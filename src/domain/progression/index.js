export {
  getProgressionMetrics,
  getProgressionSummary,
  getUnlockPreview,
  isBuildingUnlocked,
  recalculateProgressionState
} from "./progression-service.js";

export const progressionModule = Object.freeze({
  name: "domain/progression",
  responsibility: "Owns unlock conditions, level gates and building option progression rules.",
  exports: [
    "recalculateProgressionState",
    "getProgressionSummary",
    "getProgressionMetrics",
    "isBuildingUnlocked",
    "getUnlockPreview"
  ]
});
