export function createPlacedBuilding({
  instanceId,
  definitionId,
  position,
  rotationOrSide = "Center",
  selectedFunction = null,
  isPowered = false,
  residentCount = 0,
  connectedSlots = []
}) {
  if (!instanceId) throw new Error("PlacedBuilding requires instanceId");
  if (!definitionId) throw new Error("PlacedBuilding requires definitionId");
  if (!position || !Number.isInteger(position.x) || !Number.isInteger(position.y)) {
    throw new Error("PlacedBuilding requires integer position { x, y }");
  }

  return Object.freeze({
    instanceId,
    definitionId,
    position: Object.freeze({ x: position.x, y: position.y }),
    rotationOrSide,
    selectedFunction,
    isPowered,
    residentCount,
    connectedSlots: Object.freeze([...connectedSlots])
  });
}
