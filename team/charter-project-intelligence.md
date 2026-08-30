# Charter — Project Intelligence + Completeness Audit

Mission: transform this repository into an AI-optimized, self-documenting project by
building a **validated knowledge base** (`.ai/`) and an **evidence-based gap map** —
then report where the application actually stands. This charter is knowledge
discovery, not feature work.

**Read `.claude/team/project-profile.md` before anything else.** It is the single
adaptation point: stack, layout, commands, invariants, requirement sources, and —
above all — the Data safety section. Where the profile says `UNKNOWN`, W0's first
job is to fill it from evidence (mark such entries `AUTO`).

Two truths, one diff:
- The project's **requirement sources** (per profile: a specs directory, an issue
  tracker, a README feature list) are the product truth — what SHOULD exist.
- Source code is the engineering truth — what DOES exist.
- `.ai/` records validated engineering knowledge; the completeness matrix records
  the diff. A requirements-vs-code divergence is a **finding**, never a "doc fix".
- If the project has no requirement source at all, the audit inverts: document what
  the code actually does, and record "no requirements source" as the #1 gap.

## Prime rules

1. Never guess when the repository can provide evidence. Every claim carries
   `file:line` (or migration / requirement id) citations.
2. Hierarchy for behavior claims:
   `SOURCE CODE > TESTS > CONFIGURATION > DOCUMENTATION > AI-GENERATED KNOWLEDGE`.
3. Preserve existing knowledge; reconcile it, never delete it. "Existing knowledge"
   = every instruction/docs file the profile lists (CLAUDE.md, README, specs, ADRs,
   wikis checked into the repo).
4. Contradictions — between docs and code, or between two implementations — are
   reported, never silently resolved.
5. KNOWLEDGE DISCOVERY ONLY: no refactors, renames, API changes, schema changes,
   config changes, or dependency upgrades. Writable paths: `.ai/**`, the profile's
   review-output directory, the project's instructions file (evidence-cited
   corrections only), `.claude/team/heartbeats/**`, and `.claude/agents/**` for the
   W2 specialization step. No commits, no pushes.
6. Never copy secrets or env-file values into any document. Variable NAMES only.
7. No placeholder docs: a `.ai/` file exists only when verified content exists.
   Small, single-topic files.
8. Record WHY for every architectural decision uncovered.
9. Prefer real examples from this repository over generic explanations.
10. **Data safety is absolute.** Before any command that touches a database, queue,
    or external service, re-read the profile's Data safety section. If it is
    UNKNOWN, assume every datastore is PRODUCTION: read-only, no migrations, no
    deletes, no message sends.

## Known failure modes (standing rules, learned the hard way)

- **Counting claims are the most-wrong claim type.** Any recorded count (endpoints,
  tables, keys, call sites) must be derived by two independent methods first.
- **KB cross-check:** before recording a new claim, check it against what the KB
  already says. A later agent once contradicted an earlier *correct* fact and the
  lead propagated the error.
- **Stubs look real.** Read function bodies; follow every "sent/success/done" status
  to the code that sets it. A stub provider makes whole dashboards lie.
- **The verifier is not ceremony.** In the original run all 6 of its disputes were
  upheld — two against the lead itself. Nothing enters the final report unverified.
- **Cleanup code is code.** Tests that pass while their teardown fails or leaks are
  findings, not noise.

## Team topology (agent teams)

- **intel-lead** — the session the user talks to. Owns the shared task list (one
  task per workstream, in order), batches work, merges results, writes the reports.
- **verifier** teammate — spawned at kickoff. Every cycle (~20–30 min): re-derive
  2–3 newly recorded claims/verdicts chosen at random; mark disagreements
  `DISPUTED(<reason>)` where they live and message the lead. Liveness partner: if
  the peer is silent and its heartbeat is >45 min stale, alert the user (outer net:
  `team/watchdog.sh`). Gate: W11 does not close without the verifier's final pass.
- **Fan-out ICs** — subagents from `.claude/agents/`: `architect`,
  `database-expert`, `migration-expert`, `backend-auditor`, `frontend-auditor`,
  `e2e-verifier`, `documentation-agent`, `reviewer`. 3–4 in parallel, background;
  `e2e-verifier` strictly one at a time.
- Heartbeats: every lead/teammate writes `date > .claude/team/heartbeats/<name>`
  after each batch/cycle.
- Durable state lives in files (scan-progress, matrix, task list) — any agent may be
  killed at any time and must resume from files alone.

## Workstreams (in order; append to `.ai/reports/scan-progress.md` after each)

**W0 — Safety & inventory** (read-only). Repo root, git state, generated vs source
dirs, build systems, existing docs & AI instructions, risks. Fill every `UNKNOWN`
in the project profile from evidence, marked `AUTO`.
→ `.ai/reports/initial-repository-state.md`

**W1 — Legacy-knowledge audit.** Verify every significant claim in the existing
instruction/docs files against current code. Classify VALID / STALE / INCORRECT /
PARTIALLY_VALID / UNVERIFIED / MISSING. Correct the instructions file only with
cited evidence; requirements-vs-code divergences route to W9, not to spec edits.
→ `.ai/reports/legacy-knowledge-audit.md`

**W2 — Knowledge structure + role specialization.** Populate `.ai/` per
`.ai/README.md` (files only where verified content exists). Then **specialize the
generic agent roles**: edit `.claude/agents/*.md` to name this project's canonical
pattern, gates, invariants and hazards discovered so far — specificity is where
audit quality comes from.

**W3 — Technology & architecture reverse-engineering.** Exact versions from the
manifest/lockfile; every meaningful dependency (version, purpose, where used,
upgrade risk). The canonical request/mutation flow, module map, runtime
architecture, integration map. Explain WHY, not just what.
→ `.ai/architecture/*`, `.ai/reports/technology-analysis.md`

**W4 — Business domain discovery.** Domains, entities, relationships, workflows,
state machines, calculations, permission model, terminology (all user-facing
languages). Business rules only with source evidence — never invented.
→ `.ai/business/*`

**W5 — Deep dives.** Backend: inventory of every entry point (routes, actions,
handlers, jobs), business-logic layer, validation map, error handling. Frontend:
routes, component patterns, state, i18n coverage, conventions. Database: every
table/relation/index cross-checked against migrations; access-control policies;
migration policy.
→ `.ai/backend/*`, `.ai/frontend/*`, `.ai/database/*`

**W6 — Legacy modernization** (only if the profile names a legacy system). Map:
legacy feature → requirement → implementation status. Document any data-import
path: behavior, assumptions, idempotency, risks. Never assume 1:1 mappings.
→ `.ai/migration/*`

**W7 — Standards, testing, security, delivery.** Infer real coding standards from
the code (document inconsistencies, don't rewrite). Testing: how suites run, what
CI actually exercises, weakly-tested areas. Security: auth stack, authorization
layering, secret handling, upload/input surfaces. Delivery: exactly how code
reaches production, with ordering hazards.
→ `.ai/development/*`, `.ai/infrastructure/*`

**W8 — Pattern library.** Recurring patterns with canonical in-repo examples: one
mutation end-to-end, one page/view, one migration, one background job. For each:
example path, purpose, when to use / when NOT.
→ `.ai/development/patterns.md`

**W9 — Functionality-completeness audit** (the gap engine). Per module/requirement
source: spawn `backend-auditor` + `frontend-auditor` in parallel; the lead
sample-verifies 2 IMPLEMENTED verdicts per module before recording. Order modules
highest-risk first (money, patient/user safety, isolation, legal). Verdicts:
IMPLEMENTED / PARTIAL / STUB / MISSING / UNREACHABLE / KNOWN (= already tracked in
the project's own backlog — pointer, not re-discovery). E2E flows (per profile,
only for modules whose static audit passed; `e2e-verifier`, serial, under the Data
safety rules).
→ `<review-dir>/completeness-matrix.md` (`| Requirement | Backend | Frontend | E2E
| Evidence | Severity |` per module + `## Status log`)

**W10 — Health check & knowledge gaps.** Rate Critical/High/Medium/Low across:
architecture, code quality, technical debt, security, testing, performance,
dependencies, documentation, delivery. List what could NOT be determined (what /
why it matters / where evidence may exist / how to investigate) — no guesses.
→ `.ai/reports/project-health.md`, `.ai/reports/missing-knowledge.md`,
`<review-dir>/completeness-gaps.md` (ranked; UNREACHABLE/STUB above PARTIAL)

**W11 — Validation & final report** (verifier-gated). Second pass: docs match code,
paths valid, no lost knowledge, no secrets copied, contradictions reported. Then
the executive summary — where the application is now, knowledge corrected/rejected,
technical debt, high-risk areas, recommended next steps — plus a plain-language
version for non-engineers.
→ `.ai/reports/initialization-complete.md`, `.ai/reports/PLAIN-REPORT.md`

## Reading the results (for the user)

- Where the app is now → `.ai/reports/initialization-complete.md` + `project-health.md`
- The gaps → `<review-dir>/completeness-gaps.md` + `.ai/reports/missing-knowledge.md`
- The evidence → `<review-dir>/completeness-matrix.md`
- The brain → `.ai/` (start at `.ai/README.md`)
- Live progress → `.ai/reports/scan-progress.md` + the shared task list
