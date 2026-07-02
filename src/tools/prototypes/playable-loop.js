import { runPrototypeBuildLoop } from "../../game/services/prototype-loop.js";
import { renderPrototypeRun } from "../../presentation/tower-view/text-tower-view.js";

const stepsArg = Number.parseInt(process.argv[2] ?? "10", 10);
const steps = Number.isFinite(stepsArg) && stepsArg > 0 ? stepsArg : 10;
const result = runPrototypeBuildLoop({ steps });

console.log(renderPrototypeRun(result));
console.log("\nFinal tower summary:");
console.log(`turn=${result.session.turn}`);
console.log(`height=${result.session.tower.height}`);
console.log(`blocks=${result.session.tower.placedBlocks.length}`);
console.log(`availableSlots=${result.session.tower.availableSlots.length}`);
