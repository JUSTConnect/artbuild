import { domainModules } from "../domain/index.js";
import { gameModules } from "../game/index.js";
import { contentModules } from "../content/index.js";
import { presentationModules } from "../presentation/index.js";
import { infrastructureModules } from "../infrastructure/index.js";
import { toolModules } from "../tools/index.js";

export function createArtbuildApp(options = {}) {
  const runtime = Object.freeze({
    name: "engine-agnostic-js-prototype",
    engine: options.engine ?? "none",
    modules: Object.freeze({
      domain: domainModules,
      game: gameModules,
      content: contentModules,
      presentation: presentationModules,
      infrastructure: infrastructureModules,
      tools: toolModules
    })
  });

  return Object.freeze({ runtime });
}

export function describeRuntime(app) {
  const moduleNames = Object.entries(app.runtime.modules)
    .map(([layer, modules]) => `${layer}: ${modules.map((module) => module.name).join(", ")}`)
    .join("\n");

  return `Artbuild runtime: ${app.runtime.name}\nEngine adapter: ${app.runtime.engine}\n${moduleNames}`;
}
