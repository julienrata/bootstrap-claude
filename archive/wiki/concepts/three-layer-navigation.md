---
title: Navigation en 3 couches
type: concept
sources:
  - CLAUDE.md
updated: 2026-06-13
---

# Navigation en 3 couches

La règle de navigation du contexte, à respecter **dans l'ordre** avant de lire du code
(`CLAUDE.md`) :

1. **Structure** → interroger `graphify-out/graph.json` (ou `GRAPH_REPORT.md`) pour
   comprendre l'architecture et les liens entre modules. Voir [[graphify]].
2. **Contexte projet** → lire `memory/` (décisions, avancement, pièges). Voir
   [[memory-system]].
3. **Code brut** → seulement en dernier recours : quand on édite, ou quand 1 et 2 n'ont
   pas la réponse.

L'objectif est de ne jamais relire toute la codebase si le graphe a déjà l'info —
c'est l'opérationnalisation directe de l'[[token-economy]].

## Où s'insère le wiki

Le [[wiki]] ajoute une couche de **synthèse** au-dessus de ces sources : il répond au
« pourquoi » et donne la vue d'ensemble, là où le graphe donne la structure et `memory/`
le log brut. Depuis 2026-06-13, `CLAUDE.md` le nomme explicitement comme couche de
synthèse optionnelle de la règle. La boucle qui maintient le tout est décrite dans
[[session-loop]].

## Liens

- Le principe qui justifie l'ordre → [[token-economy]]
- Les deux premières couches → [[graphify]], [[memory-system]]
