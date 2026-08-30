#!/usr/bin/env bash
# Install the multi-agent kit into a target repository.
#
#   ./install.sh /path/to/your-repo [--force]
#
# No-clobber by default: existing files are skipped and reported, so re-running
# after a kit update is safe. --force overwrites everything EXCEPT the project
# profile, which holds your answers and is never overwritten.
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-}"
FORCE="${2:-}"

[ -n "$TARGET" ] || { echo "usage: install.sh <target-repo> [--force]"; exit 1; }
TARGET="$(cd "$TARGET" && pwd)" || { echo "no such directory: $1"; exit 1; }
[ -d "$TARGET/.git" ] || { echo "not a git repository: $TARGET"; exit 1; }
[ "$TARGET" != "$KIT" ] || { echo "target is the kit itself — pick your project repo"; exit 1; }

copy() { # copy <src> <dst> [never-force]
  local src="$1" dst="$2" never="${3:-}"
  if [ -e "$dst" ] && { [ "$FORCE" != "--force" ] || [ "$never" = "never-force" ]; }; then
    echo "  skip (exists): ${dst#"$TARGET"/}"
  else
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    echo "  installed:     ${dst#"$TARGET"/}"
  fi
}

echo "Installing agent kit into $TARGET"

for f in "$KIT"/agents/*.md;   do copy "$f" "$TARGET/.claude/agents/$(basename "$f")"; done
for f in "$KIT"/commands/*.md; do copy "$f" "$TARGET/.claude/commands/$(basename "$f")"; done

copy "$KIT/team/charter-project-intelligence.md" "$TARGET/.claude/team/charter-project-intelligence.md"
copy "$KIT/team/kickoff.md"                      "$TARGET/.claude/team/kickoff.md"
copy "$KIT/team/watchdog.sh"                     "$TARGET/.claude/team/watchdog.sh"
chmod +x "$TARGET/.claude/team/watchdog.sh" 2>/dev/null || true
copy "$KIT/team/project-profile.template.md"     "$TARGET/.claude/team/project-profile.md" never-force
copy "$KIT/ai/README.md"                         "$TARGET/.ai/README.md"
mkdir -p "$TARGET/.claude/team/heartbeats"

# Enable agent teams in project settings. Merge with jq when possible; otherwise
# create the file if absent, or print manual instructions.
SETTINGS="$TARGET/.claude/settings.json"
SNIPPET="$KIT/settings/settings.snippet.json"
if [ ! -e "$SETTINGS" ]; then
  cp "$SNIPPET" "$SETTINGS"
  echo "  installed:     .claude/settings.json (agent teams enabled)"
elif command -v jq >/dev/null; then
  tmp="$(mktemp)"
  jq -s '.[0] * .[1]' "$SETTINGS" "$SNIPPET" > "$tmp" && mv "$tmp" "$SETTINGS"
  echo "  merged:        .claude/settings.json (agent teams enabled)"
else
  echo "  ACTION NEEDED: merge settings/settings.snippet.json into .claude/settings.json (jq not found)"
fi

# .ai/ is sometimes globally gitignored; warn so the brain doesn't stay invisible.
if git -C "$TARGET" check-ignore -q .ai/README.md 2>/dev/null; then
  echo
  echo "  WARNING: .ai/ is gitignored for this repo (check global gitignore)."
  echo "           Add '!.ai/' to $TARGET/.gitignore if you want the knowledge base in git."
fi

echo
echo "Done. Next steps:"
echo "  1. Fill .claude/team/project-profile.md — automated prompt in .claude/team/kickoff.md (Step 0), or edit by hand"
echo "  2. Launch from the target repo — prompts in .claude/team/kickoff.md"
