---
title: Vue d'ensemble — Atlas
type: overview
sources:
  - README.md
  - CLAUDE.md
  - src/App.tsx
  - index.html
updated: 2026-06-13
---

# Atlas

**Atlas** est une page d'accueil qui présente un échafaudage de *mémoire persistante
pour agents de code* : décisions, avancement et pièges sont consignés dans des fichiers
que l'agent relit à chaque session, pour éviter de réexpliquer le projet à chaque
ouverture (`src/App.tsx`, `index.html`).

Le dépôt joue deux rôles à la fois :

1. **Un site** — une landing page React qui *explique* le concept (voir [[app]] et
   [[graph-mark]]), bâtie sur la [[stack]] Vite + React + TypeScript.
2. **Un système de mémoire** — l'infrastructure qui *incarne* le concept : le
   [[memory-system]], l'intégration [[graphify]], et la [[session-loop]] de travail.

## Les deux faces

- **Côté produit** : le hero affiche une signature visuelle (le composant [[graph-mark]],
  clin d'œil au knowledge graph) et décrit la boucle de session en trois temps.
- **Côté méthode** : le projet applique à lui-même ce qu'il vend — sa propre mémoire vit
  dans `memory/`, sa structure dans `graphify-out/`, et ce [[wiki]] en est la couche de
  synthèse (voir [[three-layer-navigation]]).

## Par où entrer

- Comprendre l'archi → [[stack]], [[memory-system]], [[graphify]]
- Comprendre le workflow → [[session-loop]]
- Comprendre le « pourquoi » de l'économie de contexte → [[token-economy]] et
  [[three-layer-navigation]]
