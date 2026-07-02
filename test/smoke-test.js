import assert from "node:assert/strict";

import { createArtbuildApp } from "../src/app/bootstrap.js";

const app = createArtbuildApp();

assert.equal(app.runtime.name, "engine-agnostic-js-prototype");
assert.equal(app.runtime.engine, "none");
assert.ok(app.runtime.modules.domain.some((module) => module.name === "domain/tower"));
assert.ok(app.runtime.modules.domain.some((module) => module.name === "domain/placement"));
assert.ok(app.runtime.modules.game.some((module) => module.name === "game/services"));
assert.ok(app.runtime.modules.presentation.some((module) => module.name === "presentation/tower-view"));
assert.ok(app.runtime.modules.infrastructure.some((module) => module.name === "infrastructure/save"));

console.log("Artbuild smoke test passed.");
