import { getProgressionSummary, getUnlockPreview } from "../../domain/progression/index.js";

export function getProgressionPanel(tower) {
  const summary = getProgressionSummary(tower);
  const preview = getUnlockPreview(tower);

  return Object.freeze({
    ...summary,
    unlockedCount: summary.unlockedBuildingIds.length,
    lockedCount: summary.lockedBuildingIds.length,
    unlockPreview: Object.freeze(preview)
  });
}

export function renderProgressionPanelText(tower) {
  const panel = getProgressionPanel(tower);
  const lockedLines = panel.unlockPreview
    .filter((item) => !item.isUnlocked)
    .map((item) => `locked ${item.title}: ${renderRequirements(item.requirements)}`);
  const unlockedLines = panel.unlockPreview
    .filter((item) => item.isUnlocked)
    .map((item) => `unlocked ${item.title}`);

  return [
    `Progression: beauty=${panel.beauty} technology=${panel.technology} unlocked=${panel.unlockedCount} locked=${panel.lockedCount}`,
    ...unlockedLines,
    ...lockedLines
  ].join("\n");
}

function renderRequirements(requirements) {
  const parts = [];

  if (requirements.initiallyUnlocked) parts.push("start");
  if (requirements.minBeauty) parts.push(`beauty>=${requirements.minBeauty}`);
  if (requirements.minTechnology) parts.push(`technology>=${requirements.minTechnology}`);
  if (requirements.minPopulation) parts.push(`population>=${requirements.minPopulation}`);
  if (requirements.minHeight) parts.push(`height>=${requirements.minHeight}`);
  if (requirements.requiresBuildingIds?.length) {
    parts.push(`requires=${requirements.requiresBuildingIds.join(",")}`);
  }

  return parts.join(" ") || "none";
}
