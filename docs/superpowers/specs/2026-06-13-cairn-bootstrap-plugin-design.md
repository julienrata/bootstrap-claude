# Cairn — plugin de bootstrap « cœur mémoire » pour Claude Code

> Design validé le 2026-06-13. Issu du brainstorming de transformation du projet Atlas
> (`homepage/`) en outil réutilisable d'amorçage de projets.

## Contexte & motivation

Le projet `homepage/` (nom de code **Atlas**) était une landing page Vite/React servant
de banc d'essai à un échafaudage d'optimisation de contexte pour Claude Code (système
`memory/`, Graphify, wiki LLM, commandes de session). Un LLM Council (2026-06-13) a rendu
un verdict 4-contre-1 : le **pattern mémoire/contexte est valide**, mais l'instrumentation
d'Atlas est **prématurée** — une landing page ne génère jamais le problème de perte de
contexte que la mémoire résout. Recommandation : **garder le cœur (`/catchup` + `/save` +
`memory/`), geler le reste, et valider sur de vrais projets**.

Ce design répond à cette recommandation : transformer Atlas en un **plugin Claude Code**
qui pose le **cœur mémoire seul** dans n'importe quel nouveau projet. Le pattern devient
ainsi réutilisable et se valide par l'usage réel, au lieu de rester collé à une démo.

## Décisions cadrantes (issues du brainstorming)

| # | Décision | Choix |
|---|----------|-------|
| Forme | Comment le pattern est livré | **Pack de prompts + commandes** (piloté par conversation) |
| Distribution | Comment on l'installe/déclenche | **Plugin Claude Code** (commandes globales dans tous les projets) |
| Périmètre | Quelles couches sont posées | **Cœur mémoire seul** (Graphify + wiki gelés, hors périmètre) |
| Sort du repo | Devenir de `homepage/` | **Converti en repo-plugin pur** (front-end React retiré) |
| Mécanisme | Comment `/bootstrap` pose les fichiers | **A — templates statiques + substitution légère** (déterministe, testable) |
| Nom | Identité du plugin | **`cairn`** (balise un sentier pour ne pas perdre le chemin) |
| Archivage | Sort de l'échafaudage gelé | `graphify-out/`, `wiki/`, `scripts/setup-graphify.sh` → `archive/` ; `concil/`, `dist/`, `.venv/` supprimés |

## Architecture cible

`homepage/` devient le repo-plugin **`cairn`**, qui est à la fois le plugin et un
**marketplace local mono-plugin** (installable depuis le disque, sans GitHub requis).

```
homepage/  (→ repo-plugin "cairn")
├── .claude-plugin/
│   ├── plugin.json          # manifeste du plugin (name: cairn, description, version, author)
│   └── marketplace.json     # marketplace local mono-plugin (source: "." )
├── commands/
│   ├── bootstrap.md         # NOUVEAU — pose le cœur mémoire dans le projet courant
│   ├── catchup.md           # porté depuis .claude/commands/, dégraissé (sans Graphify/wiki)
│   └── save.md              # porté, dégraissé
├── templates/               # gabarits copiés tels quels par /bootstrap
│   ├── CLAUDE.md
│   └── memory/
│       ├── DECISIONS.md
│       ├── JOURNAL.md
│       ├── LEARNINGS.md
│       └── TODO.md
├── archive/                 # échafaudage gelé, conservé pour référence
│   ├── graphify-out/
│   ├── wiki/
│   └── scripts/setup-graphify.sh
├── memory/                  # mémoire DU projet-plugin (historique conservé, réécrit au besoin)
├── CLAUDE.md                # instructions du projet-plugin (réécrit : décrit le plugin)
└── README.md                # réécrit : "plugin de bootstrap cairn"
```

**Retiré** (front-end de démo, hors sujet) : `src/`, `index.html`, `vite.config.ts`,
`tsconfig*.json` + `*.tsbuildinfo`, `package.json` / `package-lock.json`, `node_modules/`.
**Supprimé** : `concil/`, `dist/`, `.venv/`.
**Conservé tel quel** : `.git/`, `.gitignore` (mis à jour).

### Installation (flux utilisateur)

```
/plugin marketplace add ~/work/bootstrap-claude/homepage
/plugin install cairn
```

Après installation, les commandes `/bootstrap`, `/catchup`, `/save` sont disponibles dans
tous les projets (avec, en cas de collision, le préfixe `/cairn:<commande>`).

## Composants

### `.claude-plugin/plugin.json`
Manifeste minimal validé sur les plugins installés :
```json
{
  "name": "cairn",
  "description": "Pose le cœur mémoire (CLAUDE.md + memory/ + /catchup + /save) dans n'importe quel projet, pour ne jamais perdre le contexte entre sessions.",
  "version": "0.1.0",
  "author": { "name": "julien rata", "email": "julien.rata@protonmail.com" },
  "keywords": ["memory", "context", "bootstrap", "session", "scaffolding"]
}
```

### `.claude-plugin/marketplace.json`
Marketplace local mono-plugin pointant le plugin à la racine du repo :
```json
{
  "name": "cairn-local",
  "owner": { "name": "julien rata" },
  "plugins": [
    { "name": "cairn", "source": ".", "description": "Bootstrap du cœur mémoire Claude Code" }
  ]
}
```

### `commands/bootstrap.md` (la commande neuve)
Frontmatter `name: bootstrap`, `description: …`. Comportement (approche A, déterministe) :

1. **Garde anti-écrasement** : si le dossier courant contient déjà `CLAUDE.md` ou
   `memory/`, **s'arrêter et demander** confirmation explicite avant tout. Jamais
   d'écrasement silencieux.
2. **Détection de stack** (indicative) : repérer `package.json` / `Cargo.toml` /
   `pyproject.toml` / `go.mod`… pour renseigner `{{STACK}}`.
3. **Copie des templates** : `templates/CLAUDE.md` → `./CLAUDE.md`, `templates/memory/*`
   → `./memory/*`, avec substitution légère des placeholders : `{{PROJECT_NAME}}`
   (nom du dossier), `{{DATE}}` (date du jour), `{{STACK}}`.
4. **Git (derrière accord)** : si pas de repo git, **proposer** `git init` — n'exécuter
   qu'après confirmation. Idem pour une première entrée `JOURNAL.md` d'amorçage.
5. **Récap** : lister les fichiers posés et les prochaines étapes (« remplis
   `DECISIONS.md`, lance `/save` en fin de session »).
6. **Contraintes** : aucune action réseau ; aucun `git` destructif ; tout `git`/
   modification hors copie de templates passe par une confirmation humaine.

### `commands/catchup.md` & `commands/save.md` (portés, dégraissés)
Repris depuis `.claude/commands/{catchup,save}.md` mais **purgés de toute référence à
Graphify et au wiki** (hors périmètre cœur). Ils opèrent sur le `memory/` du **répertoire
courant** :
- `/catchup` : lit les 3 dernières entrées de `memory/JOURNAL.md` + `memory/DECISIONS.md`
  + `memory/TODO.md`, puis résume l'état courant. Ne modifie rien.
- `/save` : ajoute l'entrée de journal (format `## [AAAA-MM-JJ] <titre>` + *Fait* /
  *Décisions* / *En suspens*), met à jour `DECISIONS.md` / `LEARNINGS.md` / `TODO.md` au
  besoin, puis `git add -A && git commit` si le dossier est un repo git.

### `templates/CLAUDE.md`
Version **générique et courte** (< 100 lignes) de l'actuel `CLAUDE.md`, **sans** les
sections « Navigation du contexte (Graphify) » ni « Wiki ». Contient :
- En-tête projet avec placeholders (`{{PROJECT_NAME}}`, `{{STACK}}`).
- Section « Fichiers mémoire (`memory/`) — lus à la demande » décrivant les 4 fichiers et
  l'avertissement de ne pas les `@`-importer.
- Section « Commandes de session » documentant `/catchup` et `/save`.
- Section « À NE PAS faire » (ne pas supprimer de fichier mémoire sans demander, etc.).

### `templates/memory/*.md`
Les quatre fichiers avec leur **en-tête / mode d'emploi** actuel (format des entrées,
astuce grep) mais le **corps vidé** (aucune entrée de contenu Atlas). `JOURNAL.md`,
`DECISIONS.md`, `LEARNINGS.md`, `TODO.md`.

## Stratégie de test

L'approche A est choisie précisément parce qu'elle est **déterministe et vérifiable**
(réponse directe à l'alerte du council sur l'instrumentation qui « marche par absence de
friction »). Test bout-en-bout :

`scripts/test-bootstrap.sh` :
1. Crée un dossier temporaire vide.
2. Y simule le comportement de copie/substitution de `/bootstrap`.
3. **Vérifie** : `CLAUDE.md` + `memory/{DECISIONS,JOURNAL,LEARNINGS,TODO}.md` existent ;
   plus aucun placeholder `{{…}}` résiduel ; `{{PROJECT_NAME}}` = nom du dossier.
4. **Idempotence/sécurité** : un 2ᵉ passage sur un dossier déjà amorcé **n'écrase pas**.
5. Nettoie le dossier temporaire.

> Note : `/bootstrap` étant une commande pilotée par l'agent, le script teste la **logique
> de copie/substitution** (le contrat observable), pas le parsing du prompt. Le test garantit
> que les templates produisent le bon arbre de fichiers.

## Hors périmètre (gelé, archivé)

- **Graphify** (graphe de structure) — `archive/graphify-out/`, `archive/scripts/`.
- **Wiki LLM** (`/wiki`, `wiki/`) — `archive/wiki/`.
- **Symlink vault Obsidian**.
- Génération adaptative de `CLAUDE.md` par l'agent (approche B/C écartées).
- Publication du marketplace sur GitHub (reste local pour l'instant).

Ces couches pourront être réintroduites comme **options modulaires** de `cairn` plus tard,
une fois le cœur validé par l'usage sur de vrais projets — mais pas dans cette itération.

## Conséquences

- Le projet `homepage/` perd sa nature de landing page ; son `package.json` Vite disparaît.
  L'historique git conserve l'intégralité de l'état antérieur.
- `memory/` du projet-plugin documente désormais le projet-plugin lui-même (le bootstrap).
- Une entrée `DECISIONS.md` actera la conversion (remplace implicitement la décision
  « stack Vite + React » qui devient caduque pour ce repo).
- Première occasion de **valider la couche mémoire sur un vrai projet** : `cairn` lui-même,
  puis les futurs projets amorcés via `/bootstrap`.
