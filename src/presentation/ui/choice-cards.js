export function renderChoiceCardsText(choiceOptions) {
  if (choiceOptions.length === 0) {
    return "No valid choices available.";
  }

  return choiceOptions.map((choice, index) => renderChoiceCardText(choice, index)).join("\n");
}

export function renderChoiceCardText(choice, index = 0) {
  const stats = Object.entries(choice.baseStats)
    .filter(([, value]) => value !== 0)
    .map(([key, value]) => `${key}:${value}`)
    .join(" ");

  return [
    `${index + 1}. ${choice.title}`,
    `   id=${choice.id}`,
    `   category=${choice.category} rarity=${choice.rarity}`,
    `   functions=${choice.functionOptions.join(", ")}`,
    `   validSlots=${choice.validSlotIds.length}`,
    stats ? `   stats=${stats}` : null
  ].filter(Boolean).join("\n");
}
