import { buildingDefinitions } from "../../content/buildings/index.js";
import { canPlaceBuilding } from "../../domain/placement/index.js";
import { createGameSession } from "../session/game-session.js";
import { selectAndBuild } from "./build-command-service.js";

export function getPrototypeBuildOptions(tower, { limit = 3 } = {}) {
  return buildingDefinitions
    .filter((definition) => !definition.placementRules.startOnly)
    .filter((definition) => tower.availableSlots.some((slot) => canPlaceBuilding(tower, definition, slot.id).ok))
    .slice(0, limit);
}

export function runPrototypeBuildLoop({ steps = 10, session = createGameSession() } = {}) {
  let currentSession = session;
  const snapshots = [];

  for (let step = 0; step < steps; step += 1) {
    const options = getPrototypeBuildOptions(currentSession.tower, { limit: 3 });

    if (options.length === 0) {
      snapshots.push(Object.freeze({ step, options, skipped: true, reason: "no_valid_options", session: currentSession }));
      break;
    }

    const selected = options[step % options.length];
    currentSession = selectAndBuild(currentSession, selected.id);

    snapshots.push(Object.freeze({
      step,
      options,
      selected,
      skipped: false,
      session: currentSession
    }));
  }

  return Object.freeze({
    session: currentSession,
    snapshots: Object.freeze(snapshots)
  });
}
