import { getBuildingDefinitionById } from "../../content/buildings/index.js";
import { createGameSession } from "../session/game-session.js";
import { selectAndBuild } from "./build-command-service.js";
import { getChoiceOptions } from "./choice-service.js";

export function getPrototypeBuildOptions(tower, { limit = 3 } = {}) {
  return getChoiceOptions(tower, { limit });
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

    const selectedCard = options[step % options.length];
    const selectedDefinition = getBuildingDefinitionById(selectedCard.id);
    currentSession = selectAndBuild(currentSession, selectedCard.id);

    snapshots.push(Object.freeze({
      step,
      options,
      selected: selectedDefinition,
      selectedCard,
      skipped: false,
      session: currentSession
    }));
  }

  return Object.freeze({
    session: currentSession,
    snapshots: Object.freeze(snapshots)
  });
}
