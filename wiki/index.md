---
title: Index du wiki
type: index
sources: []
updated: 2026-06-13
pages: 13
---

# Index du wiki — Atlas

Catalogue de toutes les pages. Mis à jour par `/wiki update`. Pour la procédure et les
conventions, voir `.claude/commands/wiki.md`.

## Point d'entrée

- [[overview]] — vue d'ensemble du projet (les deux faces : site + système de mémoire).

## Architecture

- [[stack]] — Vite + React 18 + TypeScript, scripts et conventions.
- [[memory-system]] — les quatre fichiers de `memory/` et leur rôle.
- [[graphify]] — knowledge graph du code, sorties `graphify-out/`, vault Obsidian.
- [[session-loop]] — la boucle `/catchup` → travailler → `/save` (+ `/wiki`).
- [[wiki]] — le wiki LLM lui-même : couche de synthèse, structure, commande `/wiki`.

## Composants

- [[app]] — composant racine de la landing page, données `STEPS`.
- [[graph-mark]] — signature visuelle SVG (constellation du knowledge graph).

## Concepts

- [[token-economy]] — ne jamais recharger l'inutile : graphe + lecture à la demande.
- [[three-layer-navigation]] — Structure → Contexte → Code, dans l'ordre.
