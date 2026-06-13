---
title: Journal du wiki
type: log
sources: []
updated: 2026-06-13
---

# Journal du wiki

Append-only, le plus récent en haut. Format : `## [AAAA-MM-JJ] update|lint|query | <résumé>`.
Grep des dernières entrées : `grep "^## \[" wiki/log.md | head -5`.

---

## [2026-06-13] update | Divergence /resume résolue à la source
`src/App.tsx` corrigé (`/resume` → `/catchup`). Resync de `components/app` et
`architecture/session-loop` : la note de divergence devient une note de cohérence.

## [2026-06-13] update | Page du wiki lui-même + cross-refs
Nouveau sous-système détecté (commande `/wiki`, dossier `wiki/`, symlink, décision du
jour) → création de `architecture/wiki.md`. Liens `[[wiki]]` ajoutés depuis `overview`,
`session-loop`, `three-layer-navigation` et `index`. Note ajoutée dans
`three-layer-navigation` : `CLAUDE.md` nomme désormais le wiki dans la règle des 3 couches.
Autres pages revues vs sources (même jour, contenu inchangé) — non modifiées.

## [2026-06-13] update | Amorçage du wiki
Création initiale : `overview`, architecture (`stack`, `memory-system`, `graphify`,
`session-loop`), composants (`app`, `graph-mark`), concepts (`token-economy`,
`three-layer-navigation`), plus `index` et ce `log`. Synthèse depuis l'état courant des
sources (code, `memory/`, `graphify-out/`). Divergence relevée : `src/App.tsx` affiche
encore `/resume` au lieu de `/catchup` (notée dans `session-loop` et `app`).
