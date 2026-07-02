# Development Structure

## Runtime choice for the first prototype

The first implementation step uses an engine-agnostic JavaScript runtime scaffold.

This does not decide the final engine. The goal is to keep the core architecture explicit and testable before binding the project to Unity, Godot or another mobile runtime. Engine-specific adapters can be added later inside `presentation` and `infrastructure` without moving domain rules into UI or scene code.

## Layer boundaries

```text
src/
  app/              application entry point and module wiring
  domain/           pure game rules and state models
  game/             application services and player command flow
  content/          data-driven building definitions and content rules
  presentation/     rendering, UI and animation adapters
  infrastructure/   saves, assets, analytics, sharing and platform services
  tools/            validators, debug helpers and prototype sandboxes
test/               smoke tests and future automated checks
```

## Domain modules

The domain layer is split into small namespaces from the beginning:

- `domain/tower` — tower state, placed buildings, available slots and tower counters.
- `domain/building` — building definition contracts and placed building concepts.
- `domain/placement` — placement slots, connection types and validation rules.
- `domain/energy` — energy production, radius and powered state.
- `domain/residents` — resident capacity, population and comfort-driven settlement rules.
- `domain/progression` — unlock conditions, levels and building option progression.
- `domain/balance` — aggregate stats such as housing, beauty, technology and comfort.

## Dependency direction

```text
app -> game -> domain
app -> presentation
app -> infrastructure
content -> domain contracts
presentation -> game/domain read models
infrastructure -> serialized game/domain state
```

Rules:

- Domain code must not import presentation, infrastructure or app code.
- Presentation may render state, but it must not own formulas for placement, energy, residents or progression.
- Content must stay data-driven so adding a building does not require rewriting central gameplay logic.
- Infrastructure can persist state, but it must not decide gameplay outcomes.

## Local commands

```bash
npm run smoke
npm start
```

`npm run smoke` checks that the scaffold can be imported and that the expected module boundaries exist.
