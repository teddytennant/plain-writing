#!/usr/bin/env bash
# plain-writing installer. Detects Claude Code and Wizard and installs into
# whichever it finds. Safe to re-run.
#
#   curl -fsSL https://raw.githubusercontent.com/teddytennant/plain-writing/main/install.sh | bash
#
# Env:
#   PLAIN_WRITING_SRC=/path/to/checkout      use a local checkout instead of cloning
#   PLAIN_WRITING_TARGET=claude|wizard|both  default: both, whichever are present
set -euo pipefail

SRC="${PLAIN_WRITING_SRC:-}"
TARGET="${PLAIN_WRITING_TARGET:-both}"
CLONE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/plain-writing"

say()   { printf '  %s\n' "$*"; }
head_() { printf '\n%s\n' "$*"; }
die()   { printf '\nplain-writing: %s\n' "$*" >&2; exit 1; }

head_ "plain-writing installer"

# --- source ------------------------------------------------------------------
if [ -z "$SRC" ]; then
  if [ -f "$(dirname "$0")/.claude-plugin/marketplace.json" ]; then
    SRC="$(cd "$(dirname "$0")" && pwd)"
  else
    command -v git >/dev/null 2>&1 || die "git is required to fetch the skill"
    say "fetching plain-writing into $CLONE_DIR"
    if [ -d "$CLONE_DIR/.git" ]; then
      git -C "$CLONE_DIR" pull --ff-only --quiet
    else
      mkdir -p "$(dirname "$CLONE_DIR")"
      git clone --depth 1 --quiet https://github.com/teddytennant/plain-writing "$CLONE_DIR"
    fi
    SRC="$CLONE_DIR"
  fi
fi
[ -f "$SRC/.claude-plugin/marketplace.json" ] || die "not a plain-writing checkout: $SRC"
say "source: $SRC"

installed_any=0

# --- Claude Code -------------------------------------------------------------
if [ "$TARGET" = "both" ] || [ "$TARGET" = "claude" ]; then
  if command -v claude >/dev/null 2>&1; then
    head_ "Claude Code"
    claude plugin marketplace add "$SRC" >/dev/null 2>&1 \
      || claude plugin marketplace update plain-writing >/dev/null 2>&1 || true
    if claude plugin install plain-writing@plain-writing >/dev/null 2>&1; then
      say "installed plugin plain-writing@plain-writing"
    else
      say "plugin already installed, or install needs a restart"
    fi
    installed_any=1
  else
    say "claude not on PATH, skipping Claude Code install"
  fi
fi

# --- Wizard ------------------------------------------------------------------
if [ "$TARGET" = "both" ] || [ "$TARGET" = "wizard" ]; then
  if command -v wizard >/dev/null 2>&1; then
    head_ "Wizard"
    bash "$SRC/plugins/plain-writing/wizard/install.sh" | sed 's/^/  /'
    installed_any=1
  else
    say "wizard not on PATH, skipping Wizard install"
  fi
fi

# --- neither -----------------------------------------------------------------
if [ "$installed_any" -eq 0 ]; then
  head_ "Neither claude nor wizard is on PATH"
  say "installing the skill into ~/.claude/skills anyway, which most tools read"
  mkdir -p "$HOME/.claude/skills/plain-writing"
  cp "$SRC/plugins/plain-writing/skills/plain-writing/SKILL.md" \
     "$HOME/.claude/skills/plain-writing/SKILL.md"
  say "wrote $HOME/.claude/skills/plain-writing/SKILL.md"
fi

head_ "Done. Restart Claude Code, or run /reload in Wizard."
printf '\n'
