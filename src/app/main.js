import { createArtbuildApp, describeRuntime } from "./bootstrap.js";

const app = createArtbuildApp();

console.log(describeRuntime(app));
