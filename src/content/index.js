import { buildingDefinitions } from "./buildings/index.js";
import { buildingCategories, connectionTypes, functionOptions, rarityLevels } from "./rules/building-taxonomy.js";

export { buildingDefinitions, buildingCategories, connectionTypes, functionOptions, rarityLevels };

export const contentModules = Object.freeze([
  Object.freeze({
    name: "content/buildings",
    responsibility: "Stores data-driven building definitions and test content.",
    itemCount: buildingDefinitions.length
  }),
  Object.freeze({
    name: "content/rules",
    responsibility: "Stores content-side spawn, unlock and validation data.",
    taxonomy: Object.freeze({
      categories: buildingCategories.length,
      connectionTypes: connectionTypes.length,
      functionOptions: functionOptions.length,
      rarityLevels: rarityLevels.length
    })
  }),
  Object.freeze({
    name: "content/palettes",
    responsibility: "Stores visual palette and district metadata."
  })
]);
