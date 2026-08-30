---
description: Summarize the current project state from the .ai knowledge base, verifying freshness against code
argument-hint: [optional area, e.g. billing, database, security]
---

Report where the project stands, grounded in the knowledge base — for the area
"$ARGUMENTS" if given, otherwise overall.

1. Read `.ai/README.md`, then `.ai/reports/project-health.md`,
   `.ai/reports/initialization-complete.md`, and the completeness gap report in
   the profile's review directory (whichever exist). If none exist, say the
   knowledge base hasn't been built yet and point to
   `.claude/team/charter-project-intelligence.md` + `.claude/team/kickoff.md`.
2. Spot-check freshness: pick 3–4 load-bearing claims relevant to the question
   and verify them against current code (`git log --oneline -15` for what changed
   recently). Flag anything stale as STALE rather than repeating it as fact.
3. Answer with: current state, top risks by severity, open gaps, and what changed
   since the reports were written. Cite files. Do not modify anything.
