#!/usr/bin/env bash
# Test bout-en-bout de apply-template.sh — le contrat observable de /bootstrap.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPLY="$SCRIPT_DIR/apply-template.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail() { echo "FAIL: $1" >&2; exit 1; }

# 1. Bootstrap dans un dossier vide
"$APPLY" "$TMP" "mon-projet" "2026-06-13" "Node.js / npm" >/dev/null

# 2. Les fichiers attendus existent
[ -f "$TMP/CLAUDE.md" ] || fail "CLAUDE.md manquant"
for f in DECISIONS JOURNAL LEARNINGS TODO; do
  [ -f "$TMP/memory/$f.md" ] || fail "memory/$f.md manquant"
done

# 3. Plus aucun placeholder résiduel
if grep -rq '{{' "$TMP"; then
  fail "placeholder {{...}} non substitué"
fi

# 4. PROJECT_NAME et STACK substitués dans CLAUDE.md
grep -q "mon-projet" "$TMP/CLAUDE.md" || fail "PROJECT_NAME non substitué"
grep -q "Node.js / npm" "$TMP/CLAUDE.md" || fail "STACK non substitué"

# 5. Sécurité : un 2e passage sur un dossier déjà amorcé doit être REFUSÉ
if "$APPLY" "$TMP" "mon-projet" "2026-06-13" "Node.js / npm" >/dev/null 2>&1; then
  fail "2e bootstrap aurait dû être refusé (anti-écrasement)"
fi

# 6. Caractères spéciaux sed (`&`, `|`, `\`) dans la stack : remplacement littéral
TMP2="$(mktemp -d)"
trap 'rm -rf "$TMP" "$TMP2"' EXIT
TRICKY='C & C++ | path\to'
"$APPLY" "$TMP2" "proj" "2026-06-13" "$TRICKY" >/dev/null
grep -qF "$TRICKY" "$TMP2/CLAUDE.md" || fail "stack avec caractères spéciaux mal substituée"

echo "PASS: test-bootstrap OK"
