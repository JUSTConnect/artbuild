export const gameModules = Object.freeze([
  Object.freeze({
    name: "game/commands",
    responsibility: "Coordinates player commands before they enter domain logic."
  }),
  Object.freeze({
    name: "game/services",
    responsibility: "Coordinates application services such as build, choice, progression and session flow."
  }),
  Object.freeze({
    name: "game/session",
    responsibility: "Owns the active play session lifecycle."
  })
]);
