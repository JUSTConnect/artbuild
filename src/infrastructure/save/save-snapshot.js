import { createSharePayload, restoreTowerFromSharePayload } from "../sharing/replay-pipeline.js";

export const saveFormatVersion = 1;

export function createSaveSnapshot(session, options = {}) {
  const slotId = options.slotId ?? "slot-1";
  const savedAt = options.savedAt ?? "prototype-time";
  const title = options.title ?? "Artbuild Save";

  return Object.freeze({
    version: saveFormatVersion,
    slotId,
    savedAt,
    session: Object.freeze({
      id: session.id,
      turn: session.turn,
      selectedBuildingId: session.selectedBuildingId
    }),
    sharePayload: createSharePayload(session.tower, { title }),
    events: Object.freeze(session.events.map((event) => Object.freeze({ ...event })))
  });
}

export function serializeSaveSnapshot(snapshot) {
  return JSON.stringify(snapshot, null, 2);
}

export function restoreSessionFromSaveSnapshot(snapshot) {
  if (!snapshot || snapshot.version !== saveFormatVersion) {
    throw new Error("Unsupported save snapshot version");
  }

  const tower = restoreTowerFromSharePayload(snapshot.sharePayload);

  return Object.freeze({
    id: snapshot.session?.id ?? "restored-session",
    turn: snapshot.session?.turn ?? Math.max(tower.history.length - 1, 0),
    selectedBuildingId: snapshot.session?.selectedBuildingId ?? null,
    tower,
    events: Object.freeze(snapshot.events ?? [])
  });
}

export function createSaveSummary(snapshot) {
  const stats = snapshot.sharePayload.finalStats;

  return Object.freeze({
    version: snapshot.version,
    slotId: snapshot.slotId,
    savedAt: snapshot.savedAt,
    sessionId: snapshot.session.id,
    turn: snapshot.session.turn,
    towerId: snapshot.sharePayload.towerId,
    blocks: stats.blocks,
    height: stats.height,
    population: stats.population,
    capacity: stats.capacity,
    beauty: stats.beauty,
    technology: stats.technology
  });
}
