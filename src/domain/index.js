import { towerModule } from "./tower/index.js";
import { buildingModule } from "./building/index.js";
import { placementModule } from "./placement/index.js";
import { energyModule } from "./energy/index.js";
import { residentsModule } from "./residents/index.js";
import { progressionModule } from "./progression/index.js";
import { balanceModule } from "./balance/index.js";

export const domainModules = Object.freeze([
  towerModule,
  buildingModule,
  placementModule,
  energyModule,
  residentsModule,
  progressionModule,
  balanceModule
]);
