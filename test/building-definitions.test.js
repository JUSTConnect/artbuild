import assert from "node:assert/strict";

import {
  buildingDefinitions,
  getBuildingDefinitionById,
  getBuildingsByCategory,
  getInitiallyUnlockedBuildings
} from "../src/content/buildings/index.js";
import { validateBuildingCatalog } from "../src/tools/validators/building-definition-validator.js";

const errors = validateBuildingCatalog(buildingDefinitions);
assert.deepEqual(errors, []);

assert.ok(buildingDefinitions.length >= 5);
assert.ok(getBuildingDefinitionById("foundation_island_01"));
assert.ok(getBuildingDefinitionById("windmill_small_01"));
assert.ok(getInitiallyUnlockedBuildings().length >= 5);

const categories = new Set(buildingDefinitions.map((definition) => definition.category));
for (const category of ["Residential", "Recreation", "Knowledge", "Technology", "Art", "Energy", "Decor", "Foundation"]) {
  assert.ok(categories.has(category), `Expected category ${category} in test catalog`);
}

assert.equal(getBuildingsByCategory("Residential").length, 1);
assert.equal(getBuildingDefinitionById("missing"), null);

console.log("Building definition catalog test passed.");
