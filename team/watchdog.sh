#!/usr/bin/env bash
# Optional outer safety net: respawn a lead tmux pane whose heartbeat went stale.
# Configure via env or edit: TEAM_SESSION (tmux session), NAMES (heartbeat files,
# pane 0..N-1 order). State lives in the report files, so a fresh session resumes
# from disk — no --resume bookkeeping needed.
set -euo pipefail

SESSION="${TEAM_SESSION:-agent-team}"
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
HB="$REPO/.claude/team/heartbeats"
MAX_MIN="${MAX_MIN:-45}"
NAMES=(${NAMES:-intel-lead verifier})

tmux has-session -t "$SESSION" 2>/dev/null || exit 0

now=$(date +%s)
for i in "${!NAMES[@]}"; do
  name="${NAMES[$i]}"
  f="$HB/$name"
  mtime=$(stat -f %m "$f" 2>/dev/null || stat -c %Y "$f" 2>/dev/null || echo 0)
  age=$(( (now - mtime) / 60 ))
  if (( age >= MAX_MIN )); then
    tmux respawn-pane -k -t "$SESSION:0.$i" \
      "claude --permission-mode acceptEdits 'You are $name (restarted by the watchdog). Read .claude/team/project-profile.md, the charter, and .ai/reports/scan-progress.md, then continue your role from where the files say it left off.'" \
      2>/dev/null || true
    date > "$f"
    echo "$(date): respawned $name (heartbeat ${age}m stale)" >> "$HB/watchdog.log"
  fi
done
