export { createGameSession, selectBuilding, updateSessionTower } from "./session/game-session.js";
export { buildSelectedBuilding, getFirstValidTopSlot, selectAndBuild } from "./services/build-command-service.js";
export { getPrototypeBuildOptions, runPrototypeBuildLoop } from "./services/prototype-loop.js";

export const gameModules = Object.freeze([
  Object.freeze({
    name: "game/commands",
    responsibility: "Coordinates player commands before they enter domain logic."
  }),
  Object.freeze({
    name: "game/services",
    responsibility: "Coordinates application services such as build, choice, progression and session flow.",
    exports: ["buildSelectedBuilding", "selectAndBuild", "getPrototypeBuildOptions", "runPrototypeBuildLoop"]
  }),
  Object.freeze({
    name: "game/session",
    responsibility: "Owns the active play session lifecycle.",
    exports: ["createGameSession", "selectBuilding", "updateSessionTower"]
  })
]);
