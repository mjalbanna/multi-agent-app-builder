# .ai — the project's AI knowledge base ("project brain")

Validated engineering knowledge about this repository, built and maintained by AI
agents under `.claude/team/charter-project-intelligence.md`. Purpose: let a new AI
(or human) understand this codebase quickly, safely, and accurately — without
re-reading the repository from scratch.

## Source of truth

```
SOURCE CODE > TESTS > CONFIGURATION > DOCUMENTATION > AI-GENERATED KNOWLEDGE
```

- For **what exists and how it behaves**: the code wins. Every factual claim here
  must cite evidence (`file:line`, migration id, or requirement id).
- For **what should exist**: the project's requirement sources (see
  `.claude/team/project-profile.md`) are the product truth. A divergence between
  requirements and code is a *finding* (recorded in the completeness matrix), not
  a documentation error.
- When documentation conflicts with code: investigate → report → correct the
  documentation. Never silently trust stale docs. Never copy secrets (env values)
  into any file here — variable names only.

## How an AI should use this knowledge base

Before implementing ANY feature:

1. Read the project's instructions file (CLAUDE.md or equivalent), then
   `.claude/team/project-profile.md`, then this file.
2. Identify the affected module/domain.
3. Read the relevant `architecture/` + `business/` docs.
4. Read `development/coding-standards.md` and `development/patterns.md`.
5. Find the closest existing implementation in the repo and follow its pattern.
6. Plan → implement test-first → run the profile's gates.
7. After merge: update the docs your change invalidated (`/update-knowledge`).

## Structure

| Area | Contents |
|---|---|
| `architecture/` | architecture, module map, canonical request flow, integration map, runtime |
| `business/` | domain model, business rules, workflows, terminology, permissions |
| `backend/` | entry-point inventory, business-logic layer, validation, persistence, error handling |
| `frontend/` | architecture, components, routing, state, UI patterns |
| `database/` | schema, relationships, access-control policies, indexes, migration policy & history |
| `development/` | coding standards, patterns (canonical examples), testing, security, configuration |
| `infrastructure/` | how code reaches production, environments, scheduled jobs |
| `integrations/` | external systems and their real status (stub vs live) |
| `migration/` | legacy parity map & import notes (only if the profile names a legacy system) |
| `decisions/` | decision log — every decision records WHY |
| `technical-debt/` | known issues, risks, deprecated code, contradictions |
| `reports/` | repository state, legacy-knowledge audit, health, missing knowledge, scan progress, final reports |

Files are created only when verified content exists — an empty or speculative doc
is worse than a missing one. Keep files small and single-topic.

## Maintenance rules

- Every change that alters architecture, schema, patterns, or behavior updates
  the affected `.ai/` files in the same effort (`/update-knowledge`).
- Contradictory implementations are reported, never silently resolved.
- Unknowns go to `reports/missing-knowledge.md` (what / why it matters / where
  evidence may exist / how to investigate) — never filled with guesses.
- Counting claims are recorded only after two independent derivations.
