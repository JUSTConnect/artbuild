export const infrastructureModules = Object.freeze([
  Object.freeze({
    name: "infrastructure/save",
    responsibility: "Persists and restores tower/session state."
  }),
  Object.freeze({
    name: "infrastructure/assets",
    responsibility: "Loads visual assets through the selected engine adapter."
  }),
  Object.freeze({
    name: "infrastructure/sharing",
    responsibility: "Integrates replay and future platform share/export flows."
  })
]);
