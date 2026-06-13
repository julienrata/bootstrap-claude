---
title: Économie de tokens
type: concept
sources:
  - CLAUDE.md
  - README.md
  - memory/LEARNINGS.md
updated: 2026-06-13
---

# Économie de tokens

Le principe directeur du projet : **ne jamais recharger ce qui n'est pas nécessaire**.
L'agent doit retrouver son contexte sans relire toute la codebase à chaque session
(`CLAUDE.md`).

## Deux leviers

1. **Interroger le graphe plutôt que le code.** [[graphify]] expose `graph.json`, que
   l'agent consulte pour comprendre l'architecture et les liens entre modules — au lieu
   de relire les fichiers (`CLAUDE.md`). C'est l'essentiel du gain.
2. **Lire la mémoire à la demande, jamais en auto-import.** Les fichiers de
   [[memory-system]] ne sont **pas** importés via la syntaxe `@` dans `CLAUDE.md` : un
   import déplie le contenu en ligne et le recompte à chaque session, ce qui annule le
   gain (`memory/LEARNINGS.md`, `CLAUDE.md`). On les lit ponctuellement.

## Piège associé

Les imports `@fichier.md` dans `CLAUDE.md` n'économisent **pas** de tokens — pour des
règles localisées, préférer un `CLAUDE.md` de sous-dossier, chargé seulement quand on
touche ce sous-arbre (`memory/LEARNINGS.md`).

## Liens

- La règle d'ordre de lecture qui opérationnalise ce principe → [[three-layer-navigation]]
- Les outils concernés → [[graphify]], [[memory-system]]
