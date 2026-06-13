---
title: Composant App
type: component
sources:
  - src/App.tsx
  - src/main.tsx
  - index.html
updated: 2026-06-13
---

# Composant `App`

`App` est le composant racine de la landing page (`src/App.tsx`). Il est monté sur
`#root` via `createRoot` dans `src/main.tsx`, sous `<StrictMode>`, le point d'entrée
étant chargé par `index.html` (`<script src="/src/main.tsx">`).

## Structure

`App` rend trois zones (`src/App.tsx`) :

- **header** — marque « Atlas » + nav (« Comment ça marche », « Démarrer »).
- **hero** — accroche « Votre agent oublie tout. Atlas s'en souvient. » et la signature
  visuelle [[graph-mark]] (`<GraphMark />`).
- **section `loop`** — « La boucle de session » : une liste rendue depuis le tableau
  `STEPS` (trois étapes), puis le footer.

## Donnée `STEPS`

`STEPS` est un tableau typé `Step[]` décrivant la boucle en trois temps : `/catchup`
(Reprendre) / build (Travailler) / `/save` (Consigner) (`src/App.tsx`) — c'est la version
*éditoriale* de la [[session-loop]]. Les clés affichées correspondent aux vraies commandes.

## Liens

- Signature visuelle du hero → [[graph-mark]]
- Stack qui porte le composant → [[stack]]
