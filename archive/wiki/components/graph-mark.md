---
title: Composant GraphMark
type: component
sources:
  - src/components/GraphMark.tsx
  - src/App.tsx
updated: 2026-06-13
---

# Composant `GraphMark`

`GraphMark` est **l'élément signature** de la page (`src/components/GraphMark.tsx`) : une
petite constellation de nœuds reliés, en clin d'œil au knowledge graph que [[graphify]]
construit à partir du code. Il est affiché dans le hero par [[app]] (`src/App.tsx`).

## Rendu

Composant SVG pur, sans état (`src/components/GraphMark.tsx`) :

- `NODES` — 8 nœuds positionnés à la main ; trois sont `accent: true` et portent un label.
- `EDGES` — 10 arêtes reliant les nœuds par id ; un helper `byId` résout les coordonnées.
- Le `<svg>` a un `role="img"` et un `aria-label` décrivant la constellation
  (accessibilité).

## Détail signifiant

Les trois nœuds mis en avant sont **les artefacts mémoire du projet** :
`graph.json`, `DECISIONS`, `JOURNAL` (`src/components/GraphMark.tsx`) — c'est-à-dire la
sortie de [[graphify]] et deux fichiers du [[memory-system]]. La signature visuelle
*illustre* donc directement l'architecture du projet.

## Liens

- Où il est rendu → [[app]]
- Le vrai graphe qu'il évoque → [[graphify]]
