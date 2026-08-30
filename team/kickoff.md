# Kickoff prompts

Run from the target repo's root, in a terminal. `--permission-mode acceptEdits`
lets agents write their reports without prompting; Bash commands still honor your
allowlist. Add `--model opus` (or your strongest model) for the first full run.

## Fresh run (full charter, W0–W11)

    claude --permission-mode acceptEdits "You are intel-lead. Read .claude/team/project-profile.md and .claude/team/charter-project-intelligence.md, then execute the charter: create the shared task list from its workstreams, spawn the verifier teammate, and begin with W0. Proceed in order without asking."

## Resume after a crash or restart

    claude --permission-mode acceptEdits "You are intel-lead (resuming). Read .claude/team/project-profile.md, the charter, .ai/reports/scan-progress.md and the task list, then continue from where the files say the run stopped. Re-verify nothing that is already recorded unless the verifier disputed it."

## Audit only (skip the knowledge base; just find gaps)

    claude --permission-mode acceptEdits "You are qa-lead. Read .claude/team/project-profile.md and the charter's W9/W10 sections, then run only the completeness audit: per module spawn backend-auditor + frontend-auditor, sample-verify, write the matrix and the ranked gap report. Obey the Data safety rules; no e2e unless the profile allows it."

## Monitoring cheatsheet

- Type "status?" in the lead pane any time — it answers and continues.
- `tail -f .ai/reports/scan-progress.md` — durable progress log.
- `ls -l .claude/team/heartbeats/` — stale mtime = stuck agent.
- From any other Claude session: "list agents", then message the lead by name.
- `/usage` in the lead pane — plan/token burn. `caffeinate -dims` keeps a Mac awake.

## Optional outer safety net

Install the watchdog (checks heartbeats, respawns a dead lead pane in tmux):

    (crontab -l 2>/dev/null; echo "*/10 * * * * /bin/bash $(pwd)/.claude/team/watchdog.sh") | crontab -
