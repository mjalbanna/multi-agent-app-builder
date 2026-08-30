# Project Profile — <project name>

The **single adaptation point** of the agent kit. Every agent reads this file
before touching the repository. Fill what you know (five minutes is enough);
write `UNKNOWN` for the rest — workstream W0 fills those from evidence and marks
them `AUTO`. The Data safety section is the one part you should not leave to
inference if you can help it.

## Identity
- Name:
- One-line purpose:
- Who uses it:

## Stack
- Languages / frameworks / versions: UNKNOWN
- Package manager & app directory (monorepo? which folder is the app?): UNKNOWN

## Layout
- Business logic lives in: UNKNOWN
- Routes/UI live in: UNKNOWN
- Database schema / migrations live in: UNKNOWN

## Commands (say from WHERE they run)
- Dev server: UNKNOWN
- Build: UNKNOWN
- Typecheck / lint / other gates: UNKNOWN
- Full test suite: UNKNOWN
- Single test file: UNKNOWN

## Requirement sources (the audit's intent-truth)
- e.g. `specs/*.md`, GitHub issues, a PRD, a README feature list: UNKNOWN
- Review-output directory for the matrix & gap report (default `docs/review/`): docs/review/
- Existing backlog to cross-check so known gaps are marked KNOWN, not re-discovered: UNKNOWN

## Canonical pattern
- The blessed request/mutation flow, as a chain of file roles, with ONE real
  example path an agent can imitate: UNKNOWN

## Invariants (the never-break rules)
- e.g. money as integer minor units; tenancy wrapper required around all DB access;
  every user-facing string through i18n in all locales; icon/CSS conventions: UNKNOWN

## ⚠️ Data safety — READ TWICE
- What does local dev actually touch? (isolated DB / staging / **shared PRODUCTION**): UNKNOWN
  → If UNKNOWN or PRODUCTION: agents treat every datastore as production — read-only,
    no migrations, no deletes, no outbound messages/emails/webhooks.
- Migration policy (who applies, when, ordering vs deploy): UNKNOWN
- Fixture/test-data policy (dedicated tenant? naming prefix? cleanup expectations): UNKNOWN
- Anything that must NEVER be triggered (real payment paths, real messaging, crons): UNKNOWN

## Legacy system (optional — enables migration-expert and W6)
- Name of the system being replaced / parity markers in requirements: NONE

## Delivery
- How code reaches production (auto-deploy? manual command? from where?): UNKNOWN
- Ordering hazards (migrate-before-deploy etc.): UNKNOWN

## Write scope for agents
- Agents may write ONLY under: `.ai/**`, the review-output directory above,
  `.claude/team/heartbeats/**`, and (W2 specialization only) `.claude/agents/**`.
  The instructions file (CLAUDE.md or equivalent) may receive evidence-cited
  corrections. Nothing else — no app code, no schema, no config.
