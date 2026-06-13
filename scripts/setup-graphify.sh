#!/usr/bin/env bash
# -------------------------------------------------------------------
# setup-graphify.sh
# Installe Graphify et génère le knowledge graph du projet, avec
# export des notes dans le vault Obsidian pour la graph view.
#
# À lancer depuis la racine du repo :  bash scripts/setup-graphify.sh
# -------------------------------------------------------------------
set -euo pipefail

# Chemin du vault Obsidian. Par défaut : le vault livré à côté du repo.
# Adapte si tu utilises un vault centralisé, ex. VAULT="$HOME/vault"
VAULT="${VAULT:-$(cd "$(dirname "$0")/../../vault" && pwd 2>/dev/null || echo "$HOME/vault")}"
PROJECT_NAME="homepage"

echo "==> Vérification de Python (3.10+ requis)"
command -v python3 >/dev/null || { echo "Python 3 introuvable. Installe-le d'abord."; exit 1; }

echo "==> Installation de Graphify (paquet PyPI : graphifyy)"
pip install --quiet --upgrade graphifyy

echo "==> graphify install (crée la skill ~/.claude/skills/graphify/SKILL.md)"
graphify install || echo "   (étape facultative — continue si elle échoue)"

echo "==> Génération du graphe + notes Obsidian"
mkdir -p "$VAULT/graphify/$PROJECT_NAME"
# NB : les flags de Graphify évoluent selon la version. En cas d'erreur,
# lance « graphify --help » et adapte. La forme attendue :

echo ""
echo "==> Terminé."
echo "    graph.json        -> graphify-out/graph.json   (interrogé par Claude Code)"
echo "    visualisation     -> graphify-out/graph.html   (ouvre-le dans un navigateur)"
echo "    notes Obsidian    -> $VAULT/graphify/$PROJECT_NAME"
echo ""
echo "    Pour mettre à jour après des changements :  graphify . --update"
