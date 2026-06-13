---
title: Boucle de session
type: architecture
sources:
  - CLAUDE.md
  - .claude/commands/catchup.md
  - .claude/commands/save.md
  - .claude/commands/wiki.md
  - src/App.tsx
  - memory/JOURNAL.md
updated: 2026-06-13
---

# Boucle de session

Le travail sur Atlas suit une boucle en trois temps, matérialisée par des **slash
commands** réelles dans `.claude/commands/` :

1. **Reprendre — `/catchup`** : relit les 3 dernières entrées de `memory/JOURNAL.md`,
   les décisions et le TODO, interroge le graphe plutôt que le code, puis résume l'état
   courant sans rien modifier (`.claude/commands/catchup.md`).
2. **Travailler** : features, correctifs, refactors — le contexte est déjà chargé.
3. **Consigner — `/save`** : écrit une entrée de journal, met à jour décisions, pièges
   et TODO (`.claude/commands/save.md`). Commit git si le repo est versionné.

Optionnellement, **`/wiki update`** resynthétise le [[wiki]] après des changements
(`.claude/commands/wiki.md`).

## Vraies commandes vs commande native

`/resume` est réservé par Claude Code (reprise de conversation) ; la reprise de contexte
projet s'appelle donc **`/catchup`** (`CLAUDE.md`). Une procédure décrite *en prose* dans
`CLAUDE.md` n'est pas une vraie commande — seuls les fichiers `.claude/commands/*.md` le
sont (`memory/LEARNINGS.md`).

## Cohérence du copy

Depuis 2026-06-13, la landing page affiche bien `/catchup` comme clé de la première étape
(`src/App.tsx`, tableau `STEPS`) — le copy du site est aligné sur les vraies commandes.

## Liens

- Ce que ces commandes écrivent/lisent → [[memory-system]]
- Pourquoi interroger le graphe plutôt que le code → [[token-economy]], [[graphify]]
