import { getBuildingDefinitionById } from "../../content/buildings/index.js";

const categoryGlyphs = Object.freeze({
  Foundation: "___",
  Residential: "[H]",
  Recreation: "[C]",
  Knowledge: "[L]",
  Technology: "[T]",
  Art: "[A]",
  Energy: "[W]",
  Decor: "[*]",
  Commerce: "[$]"
});

export function renderTowerText(tower) {
  const rows = new Map();

  for (const block of tower.placedBlocks) {
    const definition = getBuildingDefinitionById(block.definitionId);
    const glyph = categoryGlyphs[definition?.category] ?? "[?]";
    const row = rows.get(block.position.y) ?? new Map();
    row.set(block.position.x, glyph);
    rows.set(block.position.y, row);
  }

  const ys = [...rows.keys()].sort((a, b) => b - a);
  const lines = ys.map((y) => {
    const row = rows.get(y);
    const xs = [...row.keys()].sort((a, b) => a - b);
    const minX = Math.min(...xs, 0);
    const maxX = Math.max(...xs, 2);
    const cells = [];

    for (let x = minX; x <= maxX; x += 1) {
      cells.push(row.get(x) ?? " . ");
    }

    return `${String(y).padStart(2, "0")}: ${cells.join(" ")}`;
  });

  return [
    `Tower ${tower.id}`,
    `height=${tower.height} blocks=${tower.placedBlocks.length} slots=${tower.availableSlots.length}`,
    ...lines
  ].join("\n");
}

export function renderAvailableSlotsText(tower) {
  return tower.availableSlots
    .map((slot) => `${slot.id} @ (${slot.position.x}, ${slot.position.y}) ${slot.connectionType}`)
    .join("\n");
}

export function renderPrototypeSnapshot(snapshot) {
  if (snapshot.skipped) {
    return `Step ${snapshot.step + 1}: skipped (${snapshot.reason})`;
  }

  return [
    `Step ${snapshot.step + 1}: selected ${snapshot.selected.name}`,
    `Options: ${snapshot.options.map((option) => option.name).join(" | ")}`,
    renderTowerText(snapshot.session.tower)
  ].join("\n");
}

export function renderPrototypeRun(result) {
  return result.snapshots.map(renderPrototypeSnapshot).join("\n\n");
}
