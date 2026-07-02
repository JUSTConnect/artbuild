export const presentationModules = Object.freeze([
  Object.freeze({
    name: "presentation/tower-view",
    responsibility: "Renders tower state and placement feedback without owning game rules."
  }),
  Object.freeze({
    name: "presentation/ui",
    responsibility: "Renders selection cards, stats and player-facing prompts."
  }),
  Object.freeze({
    name: "presentation/animation",
    responsibility: "Owns visual transitions such as building pop-in, window light and camera movement."
  })
]);
