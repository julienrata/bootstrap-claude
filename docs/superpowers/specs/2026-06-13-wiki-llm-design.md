# Design — Wiki LLM du projet Atlas

> Date : 2026-06-13 · Statut : validé (design), prêt pour plan d'implémentation
> Pattern de référence : « LLM Wiki / Memex » — couche de synthèse markdown maintenue par le LLM.

## Objectif

Un wiki **maintenu par le LLM** qui documente le projet Atlas lui-même : une couche
de synthèse navigable et interconnectée, posée **au-dessus** des sources existantes,
sans les dupliquer.

## Principe directeur : éviter le 4e système redondant

Le projet a déjà trois couches de connaissance. Le wiki ne les remplace pas, il les
synthétise :

| Couche | Rôle | Mutabilité |
|---|---|---|
| Code (`src/`, configs, `scripts/`) | source de vérité du logiciel | source immuable* |
| `memory/` (DECISIONS, JOURNAL, LEARNINGS, TODO) | log brut + décisions chronologiques | source immuable* |
| `graphify-out/` | graphe structurel du code (qui appelle quoi) | source immuable* |
| **`wiki/`** (nouveau) | **synthèse interconnectée du « pourquoi » et de la vue d'ensemble** | **écrit par le LLM** |

\* immuable *du point de vue du wiki* : `/wiki` lit ces sources, ne les modifie jamais.

Délimitation des requêtes : `graphify query` répond sur la **structure du code** ;
`/wiki query` répond sur la **synthèse / le « pourquoi »** (décisions, intentions,
vue d'ensemble).

## Emplacement

- Pages réelles dans le repo : `homepage/wiki/` (versionné avec le code, voyage avec
  le projet, respecte la règle « mémoire projet = repo » du `vault/CLAUDE.md`).
- Symlink `vault/wiki/homepage/` → `homepage/wiki/` pour la graph view Obsidian,
  à côté des notes `graphify/`, sans casser la séparation projet/transverse.

## Structure des pages

```
homepage/wiki/
├── index.md            # catalogue : chaque page + résumé 1 ligne, par catégorie
├── log.md              # chrono append-only : ## [AAAA-MM-JJ] update|lint|query | <titre>
├── overview.md         # point d'entrée narratif du projet
├── architecture/       # pages de sous-systèmes
│   ├── stack.md            # Vite + React + TS, build/dev
│   ├── memory-system.md    # les 3 couches de memory/
│   ├── graphify.md         # intégration Graphify + vault
│   └── session-loop.md     # /catchup → travailler → /save → /wiki
├── components/         # pages de composants UI
│   ├── app.md
│   └── graph-mark.md
└── concepts/           # concepts transverses
    ├── token-economy.md
    └── three-layer-navigation.md
```

L'arbo est un **point de départ**, pas un gabarit à remplir : le LLM crée/fusionne
les pages selon ce qui existe réellement dans les sources. Les catégories calquent
les communautés détectées par graphify.

## Conventions des pages

Reprises du `vault/CLAUDE.md` (cohérence Obsidian), avec ajout de la traçabilité.

Frontmatter YAML obligatoire :
```yaml
---
title: Composant App
type: component          # overview | architecture | component | concept | index | log
sources:                 # fichiers sources synthétisés — pivot pour update & lint
  - src/App.tsx
  - memory/DECISIONS.md
updated: 2026-06-13       # dernière resync par /wiki
---
```

Corps :
- Wikilinks `[[...]]` pour les liens internes (jamais de liens markdown). Min. 2 par page.
- Citations de source inline sur chaque affirmation : `` Build via Vite (`vite.config.ts`) ``.
- Noms de fichiers en kebab-case. Une page = un sujet nommé.

Le couple `sources:` / `updated:` est le pivot : il pilote la détection des pages à
mettre à jour et la détection des pages périmées.

## Commande `/wiki`

Fichier `.claude/commands/wiki.md` (comme `/save`, `/catchup`). Trois sous-commandes.

### `/wiki update` (défaut)
1. Lit `index.md` + le frontmatter `sources:`/`updated:` de toutes les pages.
2. Détecte les sources modifiées : **mtime du fichier source > `updated:` de la page**
   (robuste entre sessions, indépendant de git). Bascule possible vers `git diff`
   quand le repo sera initialisé.
3. Pour chaque source modifiée : resynthétise les pages qui la citent, met à jour les
   cross-refs. Crée une page si un nouveau sous-système/concept apparaît ; fusionne ou
   marque obsolète ce qui a disparu.
4. Met à jour `index.md`, ajoute une ligne à `log.md`.
5. Affiche un récap des pages touchées. Ne touche rien d'autre.

### `/wiki lint` (audit, ne modifie pas — propose)
Détecte : pages orphelines (aucun wikilink entrant), concepts cités sans page dédiée,
cross-refs manquants, pages périmées (`updated:` < mtime d'une source), contradictions
entre pages. Sort une **liste de problèmes + questions à creuser**, sans rien réécrire
avant feu vert.

### `/wiki query "<question>"`
Lit `index.md` → ouvre les pages pertinentes → réponse synthétisée **avec citations**
des pages wiki. Propose de **classer une bonne réponse comme nouvelle page**
(`concepts/` ou `architecture/`) pour que les explorations s'accumulent.

## Intégration

- `/wiki` est manuel et distinct de `/save` : `/save` logue la session dans `memory/`,
  `/wiki update` resynthétise le wiki. Lancé à la demande.
- `CLAUDE.md` : ajouter une courte section « Wiki » à la navigation du contexte — 4e
  ressource lue **à la demande** (jamais auto-importée, comme `memory/`).
- `.gitignore` : rien de spécial, le wiki est versionné.

## Décisions écartées (YAGNI)

- Tout dans le vault → brise « mémoire projet = repo », découple du git du code.
- Système parallèle indépendant → divergence / doublon.
- Zettelkasten atomique complet (1 note = 1 idée) → surdimensionné à cette échelle.
- Moteur de recherche `qmd` → prématuré ; l'`index.md` suffit (~18 fichiers source).
- Détection par `git diff` → repo pas encore initialisé ; mtime d'abord.

## Critères de succès

- `/wiki update` après un changement de code touche les bonnes pages et seulement
  elles, met à jour `index.md` + `log.md`, et ne modifie aucune source.
- Chaque page a un frontmatter valide avec `sources:` traçables et ≥ 2 wikilinks.
- La graph view Obsidian affiche le wiki via le symlink.
- `/wiki lint` repère une page périmée après modification d'une de ses sources.
- `/wiki query` répond avec citations vers les pages wiki, distinct de `graphify query`.

## Reste à faire (implémentation)

1. Créer `.claude/commands/wiki.md` (les 3 sous-commandes).
2. Amorcer `homepage/wiki/` : `index.md`, `log.md`, `overview.md`, et les pages
   initiales synthétisées depuis l'état actuel des sources.
3. Créer le symlink `vault/wiki/homepage/` → `homepage/wiki/`.
4. Ajouter la section « Wiki » au `CLAUDE.md`.
