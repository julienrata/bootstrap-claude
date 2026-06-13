---
title: Stack technique
type: architecture
sources:
  - package.json
  - vite.config.ts
  - CLAUDE.md
  - memory/DECISIONS.md
  - index.html
updated: 2026-06-13
---

# Stack technique

Atlas est un échafaudage **Vite + React 18 + TypeScript** (`package.json`,
`memory/DECISIONS.md`). Choix retenu pour un démarrage rapide, le HMR et un écosystème
standard ; Next.js a été écarté (SSR superflu pour une landing statique) — voir la
décision dans `memory/DECISIONS.md`.

## Dépendances

- Runtime : `react` ^18.3.1, `react-dom` ^18.3.1 (`package.json`).
- Build/dev : `vite` ^6, `@vitejs/plugin-react`, `typescript` ~5.6 (`package.json`).
- La config Vite est minimale : juste le plugin React (`vite.config.ts`).

## Scripts (`package.json`)

- `npm run dev` — serveur de dev (Vite).
- `npm run build` — `tsc -b && vite build` (typecheck *puis* build de production).
- `npm run typecheck` — `tsc -b --noEmit` (types sans émettre).
- `npm run preview` — prévisualise le build.

## Conventions

TypeScript **strict** (ne pas désactiver, pas de `any` sans raison consignée) ; composants
en PascalCase, un par fichier dans `src/components/` ; styles pilotés par variables CSS
dans un `src/index.css` unique — voir la décision « styles via variables CSS » dans
`memory/DECISIONS.md`. Le point d'entrée HTML monte l'app sur `#root` (`index.html`),
rendu par [[app]] (voir [[graph-mark]] pour la signature visuelle).

## Liens

- Workflow de travail sur cette stack → [[session-loop]]
- Pourquoi pas d'import `@` de mémoire lourde → [[token-economy]]
