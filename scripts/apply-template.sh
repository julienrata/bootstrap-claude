#!/usr/bin/env bash
# Pose le cœur mémoire (CLAUDE.md + memory/) dans un projet cible — déterministe.
# Usage: apply-template.sh <target-dir> <project-name> <date> <stack>
set -euo pipefail

TARGET="${1:?usage: apply-template.sh <target-dir> <project-name> <date> <stack>}"
PROJECT_NAME="${2:?project name requis}"
DATE="${3:?date requise}"
STACK="${4:-projet}"

# Racine du plugin = dossier parent de scripts/
PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES="$PLUGIN_ROOT/templates"

# Garde anti-écrasement
if [ -e "$TARGET/CLAUDE.md" ] || [ -e "$TARGET/memory" ]; then
  echo "REFUS: $TARGET contient déjà CLAUDE.md ou memory/ — bootstrap annulé." >&2
  exit 1
fi

mkdir -p "$TARGET/memory"

# Échappe les caractères spéciaux du *remplacement* sed : `\`, `&` et le
# délimiteur `|`. Sans ça, une stack comme « C & C++ » corromprait la sortie.
esc() {
  local s=$1
  s=${s//\\/\\\\}   # \ -> \\  (en premier, sinon on ré-échapperait)
  s=${s//&/\\&}     # & -> \&
  s=${s//|/\\|}     # | -> \|
  printf '%s' "$s"
}

PROJECT_NAME_E=$(esc "$PROJECT_NAME")
DATE_E=$(esc "$DATE")
STACK_E=$(esc "$STACK")

subst() {
  sed -e "s|{{PROJECT_NAME}}|$PROJECT_NAME_E|g" \
      -e "s|{{DATE}}|$DATE_E|g" \
      -e "s|{{STACK}}|$STACK_E|g"
}

subst < "$TEMPLATES/CLAUDE.md" > "$TARGET/CLAUDE.md"
for f in DECISIONS JOURNAL LEARNINGS TODO; do
  subst < "$TEMPLATES/memory/$f.md" > "$TARGET/memory/$f.md"
done

echo "OK: cœur mémoire posé dans $TARGET"
