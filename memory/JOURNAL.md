# Journal

Log chronologique des sessions, **le plus récent en haut**. Sortie de `/save`.
Préfixe d'entrée constant pour pouvoir grep : `grep "^## \[" memory/JOURNAL.md | head -5`.

Format :

```
## [AAAA-MM-JJ] Titre court
- Fait : ...
- Décisions : ... (renvoie à memory/DECISIONS.md si formalisé)
- En suspens : ...
```

---

## [2026-06-13] Prompts de bootstrap Claude (méta, via /prompt-master)
**Fait :** `/catchup` pour reprendre le contexte. Puis, via `/prompt-master`, production de deux prompts Claude Code réutilisables (livrés en conversation, pas écrits dans le repo) : (1) un template « audit/mise en place de l'échafaudage d'optimisation Claude » sur un projet existant ; (2) un **bootstrap from scratch** qui réplique le pattern Atlas à 3 couches (index Graphify → `memory/` → code brut, + couche `wiki/`, commandes `/catchup`·`/save`·`/wiki`, `.gitignore`/README/`git init`). Tous deux structurés en Template M (état initial/cible, scope lock, checkpoints, conditions d'arrêt, garde anti-sur-ingénierie d'Opus, git/dépendances/symlinks derrière approbation humaine).
**Décisions :** aucune décision d'archi sur le projet lui-même — session méta (ingénierie de prompt). Pas de fichier projet modifié.
**En suspens :** le prompt « bootstrap from scratch » codifie le pattern Atlas en réutilisable mais n'existe que dans l'historique de conversation → à persister comme artefact (`docs/`) si on veut le garder. Fils bootstrap inchangés (copy de démo, déploiement, test `/wiki lint`/`query`, push `adf1ffe`).

## [2026-06-13] Initialisation git du projet
**Fait :** `/catchup` pour reprendre le contexte, puis `git init -b main`. Complété le `.gitignore` (ajout `.venv/` du virtualenv Python Graphify et `*.tsbuildinfo` des caches TS incrémentaux). Commit initial `19207ca` : 43 fichiers suivis (front-end, `memory/`, `wiki/`, `.claude/`, export Graphify versionné `graph.json`+`GRAPH_REPORT.md`). Vérifié que `node_modules/`, `dist/`, `.venv/` et `graphify-out/cache/` sont bien exclus.
**Décisions :** repo versionné en git, branche par défaut `main` (voir DECISIONS.md).
**En suspens :** `graphify-out/.graphify_python` versionné contient un chemin absolu machine-spécifique (à dé-suivre si clonage ailleurs). Rebascule possible de la détection de fraîcheur du wiki sur `git diff` (lève le blind spot mtime intra-journée). Fils bootstrap toujours ouverts : copy de démo « Atlas », déploiement, test `/wiki lint`/`query`.

## [2026-06-13] Wiki LLM implémenté de bout en bout
**Fait :** spec écrit (`docs/superpowers/specs/2026-06-13-wiki-llm-design.md`) puis implémentation complète — commande `/wiki` (`.claude/commands/wiki.md`, sous-commandes update/lint/query), amorçage de `wiki/` (12 pages : overview, architecture/{stack,memory-system,graphify,session-loop,wiki}, components/{app,graph-mark}, concepts/{token-economy,three-layer-navigation}, + index/log), symlink `vault/wiki/homepage/` → `../../homepage/wiki`, section « Wiki » ajoutée au `CLAUDE.md`. Premier `/wiki update` : création de la page du wiki lui-même + cross-refs (tous les wikilinks résolvent). Corrigé une divergence repérée par le wiki : `src/App.tsx` affichait `/resume` → remplacé par `/catchup` (typecheck OK), wiki resynchronisé.
**Décisions :** wiki = couche de synthèse implémentée (voir DECISIONS.md, statut passé à actif).
**En suspens :** tester `/wiki lint` et `/wiki query` en conditions réelles. Fils bootstrap restants : remplacer le copy de démo « Atlas », choisir le déploiement. Projet pas sous git → commit `/save` sauté.

## [2026-06-13] Rebuild graphe + design d'un wiki LLM (en cours)
**Fait :** rebuild graphify complet (90 nodes, 8 communautés ; forçage `to_json(force=True)` pour passer la garde anti-régression), communautés labellisées, HTML régénéré et ouvert dans le navigateur. Lancé un brainstorming pour un **wiki LLM du projet** (pattern « LLM Wiki / Memex »).
**Décisions :** wiki = couche de synthèse au-dessus des sources immuables (code + `memory/` + `graphify`) ; vit dans `homepage/wiki/` versionné + symlink `vault/wiki/homepage/` pour la graph view ; piloté par une commande `/wiki` (sous-commandes update/lint/query) ; conventions Zettelkasten du vault + frontmatter `sources:`/`updated:` ; détection des changements par mtime. Voir DECISIONS.md.
**En suspens :** design pas encore finalisé (Section 3 « commande /wiki » à valider, puis écriture du spec + plan d'implémentation). Création effective du wiki et de `.claude/commands/wiki.md` à faire. Fils du bootstrap toujours ouverts. Projet pas sous git → commit `/save` sauté.

## [2026-06-12] Commandes de session réelles (/catchup, /save)
- Fait : transformé les conventions en prose du CLAUDE.md en vraies slash commands → `.claude/commands/save.md` et `.claude/commands/catchup.md`. Aligné le CLAUDE.md (section `### /resume` → `### /catchup` + note sur la collision) et nettoyé le lint markdown (blancs autour des titres/listes).
- Décisions : voir DECISIONS.md (commandes de session en fichiers, nommage anglais).
- En suspens : reste les fils du bootstrap (Graphify, vault Obsidian, copy de démo, déploiement). Projet toujours pas sous git → étape commit de `/save` sautée.

## [2026-06-12] Bootstrap du projet
- Fait : échafaudage Vite + React + TS, page d'accueil (header, hero avec signature graphe, boucle de session, footer), tokens CSS, build vérifié.
- Décisions : voir DECISIONS.md (stack, styles).
- En suspens : brancher Graphify (`scripts/setup-graphify.sh`), pointer Obsidian sur le vault, remplacer le copy de démo par le vrai contenu.
