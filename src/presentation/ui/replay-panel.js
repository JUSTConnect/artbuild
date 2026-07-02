import { createReplayTimeline } from "../../infrastructure/index.js";

export function renderReplayTimelineText(tower, { msPerStep = 700 } = {}) {
  const timeline = createReplayTimeline(tower, { msPerStep });

  return timeline.map((event) => {
    const time = `${event.atMs}ms`;

    if (event.type === "tower_started") {
      return `${event.step}. ${time} start ${event.title}`;
    }

    return `${event.step}. ${time} place ${event.title} at ${event.position.x},${event.position.y} via ${event.connectionType ?? "unknown"}`;
  }).join("\n");
}

export function renderShareSummaryText(payload) {
  return [
    `${payload.title} (${payload.towerId})`,
    `steps=${payload.timeline.length}`,
    `blocks=${payload.finalStats.blocks}`,
    `height=${payload.finalStats.height}`,
    `population=${payload.finalStats.population}/${payload.finalStats.capacity}`,
    `beauty=${payload.finalStats.beauty}`,
    `technology=${payload.finalStats.technology}`
  ].join("\n");
}
