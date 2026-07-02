# Content Format

## BuildingDefinition

`BuildingDefinition` is the data-driven contract for a building, decorative element or starting foundation.

Required fields:

| Field | Purpose |
| --- | --- |
| `id` | Stable unique identifier used by gameplay state and saves. |
| `name` | Human-readable name for debug UI and future localization keys. |
| `category` | High-level content category such as `Residential`, `Energy` or `Decor`. |
| `size` | Logical grid footprint: `{ w, h }`. |
| `allowedConnections` | Placement connections that can accept this building. |
| `functionOptions` | Gameplay functions this building can provide. |
| `baseStats` | Initial gameplay stats used by balance systems. |
| `unlockRequirements` | Conditions that make the building available. |
| `visualPrefabId` | Engine-independent placeholder for a future prefab/scene/asset id. |
| `rarity` | Early rarity bucket used by option generation. |
| `placementRules` | Content-side placement metadata. |

## Initial catalog

The first catalog lives in `src/content/buildings/building-definitions.js` and includes:

- `foundation_island_01`
- `residential_small_01`
- `cafe_small_01`
- `library_small_01`
- `workshop_small_01`
- `art_studio_small_01`
- `windmill_small_01`
- `decor_balcony_01`
- `roof_garden_01`

This covers the first prototype categories: `Residential`, `Recreation`, `Knowledge`, `Technology`, `Art`, `Energy`, `Decor` and `Foundation`.

## Validation

Building data is checked by `validateBuildingCatalog` in `src/tools/validators/building-definition-validator.js`.

Run:

```bash
npm run test
```

The validator checks required fields, unique ids, known categories, valid connection types, valid function options, rarity values, positive size and finite base stats.

## Placeholder assets

`visualPrefabId` values currently point to `placeholder/...` ids. They are not final assets. They allow gameplay and presentation code to agree on stable visual references before real engine prefabs or scenes exist.
