import { validateBuildingCatalog, validateBuildingDefinition } from "./validators/building-definition-validator.js";

export { validateBuildingCatalog, validateBuildingDefinition };

export const toolModules = Object.freeze([
  Object.freeze({
    name: "tools/validators",
    responsibility: "Validates content data, placement anchors and balance assumptions.",
    validators: ["building-definition-validator"]
  }),
  Object.freeze({
    name: "tools/prototypes",
    responsibility: "Hosts development-only sandboxes and debug helpers."
  })
]);
