#!/usr/bin/env bash
# Install plain-writing for Wizard: the skill and one slash command. Idempotent.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"   # .../plugins/plain-writing/wizard
PLUGIN_DIR="$(cd "$HERE/.." && pwd)"    # .../plugins/plain-writing
WZ="${WIZARD_HOME:-$HOME/.wizard}"

mkdir -p "$WZ/skills/plain-writing" "$WZ/commands"

# Wizard reads ~/.wizard/skills/<name>/SKILL.md with the same frontmatter
# convention Claude Code uses, so the skill copies over unchanged.
cp "$PLUGIN_DIR/skills/plain-writing/SKILL.md" "$WZ/skills/plain-writing/SKILL.md"
cp "$HERE/plain-writing.md" "$WZ/commands/plain-writing.md"

echo "Installed plain-writing for Wizard:"
echo "  skill   -> $WZ/skills/plain-writing/SKILL.md"
echo "  command -> /plain-writing"
echo
echo "Run /reload in Wizard (or restart) to activate."
