export function createPlacementSlot({
  id,
  position,
  connectionType,
  supportedSize = { w: 1, h: 1 },
  ownerBuildingId = null,
  isOccupied = false
}) {
  if (!id) throw new Error("PlacementSlot requires id");
  if (!position || !Number.isInteger(position.x) || !Number.isInteger(position.y)) {
    throw new Error("PlacementSlot requires integer position { x, y }");
  }
  if (!connectionType) throw new Error("PlacementSlot requires connectionType");

  return Object.freeze({
    id,
    position: Object.freeze({ x: position.x, y: position.y }),
    connectionType,
    supportedSize: Object.freeze({ w: supportedSize.w, h: supportedSize.h }),
    ownerBuildingId,
    isOccupied
  });
}

export function createSlotId({ x, y, connectionType, ownerBuildingId }) {
  return `slot:${x}:${y}:${connectionType}:${ownerBuildingId ?? "root"}`;
}
