---
description: Reconcile the .ai knowledge base after code changes (run after merging work)
argument-hint: [optional commit range, e.g. HEAD~5..HEAD]
---

Reconcile `.ai/` with reality for the changes in "$ARGUMENTS" (default: commits
since the newest timestamp in `.ai/reports/scan-progress.md`, else `HEAD~10..HEAD`).

1. List the changed files (`git diff --stat <range>`); map them to affected
   `.ai/` docs via `.ai/README.md`'s structure table.
2. For each affected doc: verify its claims against the new code. Correct stale
   claims (log was → is → evidence in `.ai/reports/legacy-knowledge-audit.md`),
   add new validated knowledge, and update `.ai/development/patterns.md` if a new
   canonical example emerged.
3. New architectural decisions (and their WHY) go to
   `.ai/decisions/decision-log.md`; new debt or contradictions to
   `.ai/technical-debt/known-issues.md`.
4. If the change closed a gap, update the completeness matrix and gap report in
   the profile's review directory with the new evidence.
5. Rules: evidence-cited claims only, no secrets, write only under `.ai/` and the
   review directory, keep files small. Finish with a one-line-per-file change list.
