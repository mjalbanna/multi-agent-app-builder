---
description: Review a diff/branch against the project's invariants and requirements using the reviewer agent
argument-hint: [target: PR number, branch, or blank for working tree]
---

Review the changes in "$ARGUMENTS" (or the current working tree if blank).

1. Collect the diff (`git diff` / `gh pr diff`) and identify affected modules and
   their requirement sources.
2. Spawn the `reviewer` agent with the diff scope. It checks, in severity order:
   data-safety hazards, missing auth gates, profile-invariant breaks, stub
   handlers / false success paths, missing states and tests, leaking cleanup.
3. Cross-check findings against the requirement source — flag
   implemented-but-off-spec behavior with the requirement id.
4. Report findings ranked by severity with `file:line` evidence; report
   contradictions rather than picking one side. Do not fix anything unless
   explicitly asked afterwards.
