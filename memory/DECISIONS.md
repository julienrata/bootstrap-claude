# Décisions

Registre des décisions d'architecture (style ADR léger). À consulter avant tout
choix structurant. Une entrée par décision, on n'efface pas : si une décision est
remplacée, on ajoute une nouvelle entrée qui référence l'ancienne (`Remplace : ...`).

Format :

```
## [AAAA-MM-JJ] Titre de la décision
- Statut : actif | remplacé | abandonné
- Contexte : le problème, la contrainte
- Décision : ce qui a été choisi
- Pourquoi : la raison, les alternatives écartées
- Conséquences : ce que ça implique pour la suite
```

---

## [2026-06-13] Projet versionné en git (branche `main`)
- Statut : actif
- Contexte : depuis le bootstrap, le projet n'était pas sous git ; l'étape commit de `/save` était systématiquement sautée, et la détection de fraîcheur du wiki reposait sur les mtime (blind spot intra-journée, voir LEARNINGS).
- Décision : `git init -b main` à la racine `homepage/`. `.gitignore` complété pour exclure `.venv/` (virtualenv Python Graphify) et `*.tsbuildinfo` (caches TS), en plus de `node_modules/`, `dist/`, `graphify-out/cache/`. On VERSIONNE l'export Graphify (`graph.json`, `GRAPH_REPORT.md`) et tout le système mémoire/wiki.
- Pourquoi : aligne le projet sur la règle « mémoire projet = repo » ; débloque le commit dans `/save` ; ouvre la voie à une détection de fraîcheur du wiki par `git diff` plutôt que par mtime.
- Conséquences : `/save` commite désormais. Possibilité de migrer la détection du wiki vers git (à décider). Réserve : `graphify-out/.graphify_python` versionné contient un chemin absolu machine-spécifique — à dé-suivre + ignorer si le repo est cloné ailleurs.

## [2026-06-13] Wiki LLM du projet : couche de synthèse dans le repo + symlink vault
- Statut : actif (implémenté le 2026-06-13 — commande `/wiki`, 12 pages, symlink, section CLAUDE.md)
- Contexte : envie d'un wiki maintenu par le LLM (pattern « LLM Wiki / Memex »). Risque d'empiler un 4e système qui doublonne `memory/`, `graphify` et le vault.
- Décision : le wiki est une **couche de synthèse au-dessus** de sources immuables (code + `memory/` + `graphify`). Il vit dans `homepage/wiki/` (versionné avec le code) avec un **symlink `vault/wiki/homepage/`** pour la graph view Obsidian. Piloté par une commande `/wiki` (sous-commandes `update` / `lint` / `query`). Conventions = Zettelkasten du vault (wikilinks, kebab-case) + frontmatter `sources:`/`updated:` pour la traçabilité. Détection des changements par **mtime** (pas git, projet pas encore versionné).
- Pourquoi : co-localiser avec le code respecte la règle « mémoire projet = repo » du `vault/CLAUDE.md` et fait voyager le wiki avec le projet ; le symlink donne quand même la graph view sans casser la séparation projet/transverse. Alternatives écartées : tout dans le vault (brise la règle, découple du git), système parallèle (divergence/doublon), Zettelkasten atomique complet (surdimensionné), moteur qmd (prématuré — l'index suffit).
- Conséquences : créer `homepage/wiki/` (index.md, log.md, overview.md, architecture/, components/, concepts/), le symlink, et `.claude/commands/wiki.md`. `/wiki query` = le « pourquoi »/synthèse ; `graphify query` = la structure du code. Rebascule possible vers détection par git quand le repo sera initialisé.

## [2026-06-12] Commandes de session en fichiers `.claude/commands/`, nommage anglais
- Statut : actif
- Contexte : le CLAUDE.md décrivait `/resume` et `/save` en prose ; ce ne sont pas de vraies slash commands, et taper `/resume` déclenchait la commande native de Claude Code (reprise de conversation), pas la procédure mémoire.
- Décision : matérialiser chaque procédure dans `.claude/commands/<nom>.md`. `/save` reste `/save` ; la reprise de contexte est renommée `/catchup` (anglais, cohérent avec `/save`).
- Pourquoi : `/resume` est réservé par le harness (un fichier `resume.md` serait masqué) ; `/recall` est déjà pris par un skill (`ruflo-rag-memory:recall`). `/catchup` est libre et explicite.
- Conséquences : la doc CLAUDE.md référence `/catchup`. Si d'autres procédures de session apparaissent, les créer en fichiers de commande plutôt qu'en prose.

## [2026-06-12] Stack : Vite + React + TypeScript
- Statut : actif
- Contexte : besoin d'une page d'accueil simple, moderne, facile à étendre.
- Décision : Vite (build), React 18, TypeScript en mode `strict`.
- Pourquoi : démarrage rapide, HMR, écosystème standard. Alternatives écartées : Next.js (SSR superflu pour une landing statique), TS vanilla (moins d'ergonomie pour grandir).
- Conséquences : pas de SSR pour l'instant ; si du SEO dynamique devient nécessaire, rouvrir la question (migration Astro ou Next).

## [2026-06-12] Styles via variables CSS dans un fichier unique
- Statut : actif
- Contexte : éviter d'introduire une dépendance de styling lourde dès le départ.
- Décision : un seul `src/index.css` avec un bloc de tokens (couleurs, type, layout) en tête.
- Pourquoi : zéro dépendance, lisible, suffisant à cette échelle. Alternatives écartées : Tailwind, CSS-in-JS.
- Conséquences : si le nombre de composants explose, envisager des modules CSS ou Tailwind.
