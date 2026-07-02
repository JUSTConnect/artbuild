export {
  createSaveSnapshot,
  createSaveSummary,
  restoreSessionFromSaveSnapshot,
  saveFormatVersion,
  serializeSaveSnapshot
} from "./save/save-snapshot.js";
export {
  createReplayTimeline,
  createSharePayload,
  findReplaySlotId,
  replayFormatVersion,
  restoreTowerFromSharePayload,
  serializeSharePayload
} from "./sharing/replay-pipeline.js";

export const infrastructureModules = Object.freeze([
  Object.freeze({
    name: "infrastructure/save",
    responsibility: "Persists and restores tower/session state.",
    exports: [
      "createSaveSnapshot",
      "serializeSaveSnapshot",
      "restoreSessionFromSaveSnapshot",
      "createSaveSummary"
    ]
  }),
  Object.freeze({
    name: "infrastructure/assets",
    responsibility: "Loads visual assets through the selected engine adapter."
  }),
  Object.freeze({
    name: "infrastructure/sharing",
    responsibility: "Integrates replay and future platform share/export flows.",
    exports: [
      "createReplayTimeline",
      "createSharePayload",
      "serializeSharePayload",
      "restoreTowerFromSharePayload",
      "findReplaySlotId"
    ]
  })
]);
