---
title: Système de mémoire (memory/)
type: architecture
sources:
  - CLAUDE.md
  - memory/DECISIONS.md
  - memory/JOURNAL.md
  - memory/LEARNINGS.md
  - memory/TODO.md
  - README.md
updated: 2026-06-13
---

# Système de mémoire (`memory/`)

La **mémoire du projet** vit dans le repo, sous `memory/` (`CLAUDE.md`, `README.md`).
C'est le log brut et structuré que l'agent relit pour savoir où en est le projet sans
relire tout le code. Quatre fichiers, lus **à la demande** (jamais auto-importés via `@`,
voir [[token-economy]]) :

- `memory/DECISIONS.md` — registre des décisions d'archi (ADR léger) + le *pourquoi*.
  À consulter avant tout choix structurant.
- `memory/JOURNAL.md` — log chronologique des sessions, le plus récent en haut. Préfixe
  d'entrée constant `## [AAAA-MM-JJ]` pour grep.
- `memory/LEARNINGS.md` — pièges rencontrés et leur résolution.
- `memory/TODO.md` — fils ouverts en cours.

## Maintien

Les fichiers sont alimentés par les [[commandes de session|session-loop]] : `/save`
écrit le journal, met à jour décisions/pièges/todo en fin de session ; `/catchup` les
relit en début de session (`CLAUDE.md`).

## Articulation avec les autres couches

`memory/` est une **source immuable** du point de vue du wiki : ce wiki en synthétise le
contenu sans le dupliquer (voir [[three-layer-navigation]]). La structure du code, elle,
vit dans [[graphify]]. La distinction transverse/projet (le vault vs le repo) est
détaillée dans [[graphify]] et le `vault/CLAUDE.md`.

## Liens

- Comment ces fichiers sont écrits/relus → [[session-loop]]
- Pourquoi la lecture à la demande → [[token-economy]]
