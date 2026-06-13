---
title: Intégration Graphify
type: architecture
sources:
  - scripts/setup-graphify.sh
  - CLAUDE.md
  - README.md
  - graphify-out/graph.json
  - graphify-out/GRAPH_REPORT.md
updated: 2026-06-13
---

# Intégration Graphify

**Graphify** transforme le code en un *knowledge graph* persistant que Claude Code
interroge au lieu de relire la codebase — c'est le pivot de l'[[token-economy]]
(`CLAUDE.md`, `README.md`).

## Sorties

Le pipeline produit, dans `graphify-out/` :

- `graph.json` — données du graphe, interrogées par l'agent (`scripts/setup-graphify.sh`).
- `graph.html` — visualisation interactive autonome (à ouvrir dans un navigateur).
- `GRAPH_REPORT.md` — rapport d'audit (god nodes, communautés, connexions surprenantes).

Au dernier rebuild, le graphe comptait **90 nœuds / 8 communautés**
(`graphify-out/GRAPH_REPORT.md`).

## Génération et mise à jour

`scripts/setup-graphify.sh` installe Graphify (paquet PyPI `graphifyy`) et génère le
graphe + des notes Obsidian dans le vault (`scripts/setup-graphify.sh`). Mise à jour
incrémentale après un changement structurel : `graphify . --update` (`CLAUDE.md`).
Le graphe est persistant — pas besoin de le régénérer à chaque session.

> Piège connu : `graphify` refuse d'écraser `graph.json` si le nouveau graphe a moins de
> nœuds ; sur un rebuild complet légitime, forcer avec `to_json(..., force=True)`
> (`memory/LEARNINGS.md`).

## Vault Obsidian

Le `vault/` (à côté du repo) sert de cerveau transverse et de lentille de visualisation ;
les notes de code générées vont dans `vault/graphify/homepage/`. La mémoire *du projet*,
elle, reste dans `memory/` (voir [[memory-system]]). Ce wiki est exposé au même vault via
le symlink `vault/wiki/homepage/`.

## Délimitation avec ce wiki

`graphify query` répond sur la **structure du code** (qui appelle quoi) ; `/wiki query`
répond sur la **synthèse / le pourquoi**. Les deux sont complémentaires — voir
[[three-layer-navigation]].
