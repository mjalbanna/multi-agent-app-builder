---
description: Analyze legacy-parity status for a module — what the legacy system requires vs what's built
argument-hint: <module name>
---

Analyze legacy-parity status for module: $ARGUMENTS

1. Read `.claude/team/project-profile.md` §Legacy system. If it says NONE, report
   that this project has no legacy dimension and stop.
2. Spawn the `migration-expert` agent for this module, passing the module's
   requirement source, the profile's parity markers, and
   `.ai/migration/*` if it exists.
3. It maps: legacy behavior → requirement → current implementation status (with
   `file:line` evidence), explicitly noting non-one-to-one mappings and
   deliberate divergences with their recorded reasons.
4. Unknown legacy behavior is recorded as a question in
   `.ai/reports/missing-knowledge.md` — never guessed.
5. Output: parity table (Requirement | Legacy behavior | Status | Evidence |
   Risk), gaps ranked, plus data-import considerations where relevant. Read-only:
   no code changes, never run import scripts or migrations.
