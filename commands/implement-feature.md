---
description: Implement a feature the repo's way — profile and knowledge base first, closest existing pattern, gates before done
argument-hint: <feature description or requirement id>
---

Implement: $ARGUMENTS

Follow this order — do not skip steps:

1. Read `.claude/team/project-profile.md` and `.ai/README.md`. Identify the
   affected module and its requirement source.
2. Read the relevant `.ai/architecture/`, `.ai/business/`, and
   `.ai/development/` docs that exist. Note the requirement ids you implement.
3. Find the closest existing implementation (`.ai/development/patterns.md` names
   canonical examples) and follow its shape — the profile's canonical chain with
   every listed invariant. Reuse existing components/helpers before writing new.
4. Plan briefly (files to touch, migration needed?, i18n keys for all locales),
   then implement test-first in the style of neighboring tests.
5. Guards: obey §Data safety (never apply migrations against shared/production
   data; never trigger real messaging/payment paths); cite requirement ids in
   code comments where the codebase does.
6. Verify: run the profile's gates (typecheck, lint, conventions, relevant tests).
7. Update the `.ai/` docs your change invalidated (`/update-knowledge`).
