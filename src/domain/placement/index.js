export { createPlacementSlot, createSlotId } from "./placement-slot.js";
export { canPlaceBuilding, createTopSlotsForBuilding, getAvailableSlots, placeBuilding } from "./placement-service.js";

export const placementModule = Object.freeze({
  name: "domain/placement",
  responsibility: "Owns placement slots, connection types and validation rules for building placement.",
  exports: [
    "createPlacementSlot",
    "createSlotId",
    "getAvailableSlots",
    "canPlaceBuilding",
    "placeBuilding",
    "createTopSlotsForBuilding"
  ]
});
