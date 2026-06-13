---
title: Wiki LLM du projet
type: architecture
sources:
  - .claude/commands/wiki.md
  - CLAUDE.md
  - memory/DECISIONS.md
  - docs/superpowers/specs/2026-06-13-wiki-llm-design.md
updated: 2026-06-13
---

# Wiki LLM du projet

Le **wiki** (`wiki/`) est une couche de synthèse markdown, maintenue par le LLM, posée
**au-dessus** des sources du projet sans les dupliquer (`docs/superpowers/specs/2026-06-13-wiki-llm-design.md`).
Il répond au *pourquoi* et donne la vue d'ensemble ; le code, [[memory-system]] et
[[graphify]] restent les sources de vérité. C'est la 4ᵉ ressource de la
[[three-layer-navigation]], lue à la demande (`CLAUDE.md`).

## Emplacement

Pages réelles dans le repo (`wiki/`, versionné avec le code) ; exposées à Obsidian via
le symlink `vault/wiki/homepage/` → `wiki/` pour la graph view (`memory/DECISIONS.md`).
Ce choix respecte la règle « mémoire projet = repo » du `vault/CLAUDE.md` tout en gardant
la graph view — voir la décision du 2026-06-13 dans `memory/DECISIONS.md`.

## Structure

`index.md` (catalogue), `log.md` (chrono), `overview.md`, puis trois dossiers :
`architecture/`, `components/`, `concepts/` — calqués sur les communautés détectées par
[[graphify]]. Chaque page porte un frontmatter `sources:`/`updated:` qui sert de pivot à
la maintenance (`.claude/commands/wiki.md`).

## Commande `/wiki`

Pilotée par `.claude/commands/wiki.md`, trois sous-commandes :

- **`update`** (défaut) — détecte les sources modifiées (mtime vs `updated:`), resynthétise
  les pages concernées, met à jour `index.md` et `log.md`. Ne modifie aucune source.
- **`lint`** — audit (orphelines, concepts sans page, cross-refs manquants, pages périmées,
  contradictions) ; propose sans réécrire.
- **`query "<question>"`** — réponse synthétisée avec citations ; peut être classée en
  nouvelle page.

Délimitation : `/wiki query` = le *pourquoi* / la synthèse ; `graphify query` = la
structure du code (`CLAUDE.md`). Maintenu à la main dans la [[session-loop]], distinct de
`/save`.

## Liens

- Où il s'insère dans la navigation → [[three-layer-navigation]]
- Le principe qui le justifie → [[token-economy]]
- Comment il est maintenu → [[session-loop]]
