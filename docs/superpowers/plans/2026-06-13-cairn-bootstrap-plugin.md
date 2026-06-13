# Cairn — Plugin de bootstrap « cœur mémoire » — Plan d'implémentation

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transformer le repo `homepage/` (landing page Atlas) en plugin Claude Code **cairn** qui pose le cœur mémoire (CLAUDE.md + memory/ + /catchup + /save) dans n'importe quel projet.

**Architecture:** Le repo devient un plugin + marketplace local mono-plugin. `/bootstrap` (commande pilotée par l'agent) délègue la copie/substitution déterministe à `scripts/apply-template.sh`, lui-même couvert par `scripts/test-bootstrap.sh`. `/catchup` et `/save` sont portés depuis les commandes existantes, purgés des références Graphify/wiki. L'échafaudage gelé (Graphify, wiki) part dans `archive/`.

**Tech Stack:** Markdown (commandes/templates Claude Code), Bash (moteur de copie + test), JSON (manifestes plugin/marketplace). Aucune dépendance npm/Python.

**Référence:** spec `docs/superpowers/specs/2026-06-13-cairn-bootstrap-plugin-design.md`.

---

### Task 1: Nettoyer le repo — retirer le front-end, archiver l'échafaudage gelé

**Files:**
- Delete (tracké): `src/`, `index.html`, `vite.config.ts`, `tsconfig.json`, `tsconfig.app.json`, `tsconfig.node.json`, `package.json`, `package-lock.json`, `concil/`
- Delete (non tracké / disque): `dist/`, `.venv/`, `node_modules/`, `*.tsbuildinfo`
- Move → `archive/`: `graphify-out/`, `wiki/`, `scripts/setup-graphify.sh`

- [ ] **Step 1: Supprimer le front-end React et les transcripts council (fichiers trackés)**

Run:
```bash
cd /Users/julien/work/bootstrap-claude/homepage
git rm -r --quiet src index.html vite.config.ts tsconfig.json tsconfig.app.json tsconfig.node.json package.json package-lock.json concil
```
Expected: les fichiers disparaissent de l'index git sans erreur.

- [ ] **Step 2: Supprimer le cruft de build non tracké (disque)**

Run:
```bash
rm -rf dist .venv node_modules tsconfig.app.tsbuildinfo tsconfig.node.tsbuildinfo
```
Expected: aucune sortie ; ces chemins sont gitignorés donc absents de l'index.

- [ ] **Step 3: Archiver l'échafaudage gelé (Graphify, wiki, script setup)**

Run:
```bash
mkdir -p archive/scripts
git mv graphify-out archive/graphify-out
git mv wiki archive/wiki
git mv scripts/setup-graphify.sh archive/scripts/setup-graphify.sh
```
Expected: `archive/graphify-out/`, `archive/wiki/`, `archive/scripts/setup-graphify.sh` existent ; `scripts/` est désormais vide.

- [ ] **Step 4: Vérifier l'état de l'arbre**

Run: `git status --short && echo "---" && ls`
Expected: les suppressions/renommages apparaissent ; à la racine il reste notamment `CLAUDE.md`, `README.md`, `memory/`, `docs/`, `archive/`, `.claude/`, `.gitignore`.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "chore(cairn): retire le front-end React, archive Graphify/wiki

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 2: Manifeste du plugin + marketplace local

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `.claude-plugin/marketplace.json`

- [ ] **Step 1: Créer le manifeste du plugin**

Create `.claude-plugin/plugin.json`:
```json
{
  "name": "cairn",
  "description": "Pose le cœur mémoire (CLAUDE.md + memory/ + /catchup + /save) dans n'importe quel projet, pour ne jamais perdre le contexte entre sessions.",
  "version": "0.1.0",
  "author": { "name": "julien rata", "email": "julien.rata@protonmail.com" },
  "keywords": ["memory", "context", "bootstrap", "session", "scaffolding"]
}
```

- [ ] **Step 2: Créer le marketplace local mono-plugin**

Create `.claude-plugin/marketplace.json`:
```json
{
  "name": "cairn-local",
  "owner": { "name": "julien rata" },
  "plugins": [
    { "name": "cairn", "source": ".", "description": "Bootstrap du cœur mémoire Claude Code" }
  ]
}
```

- [ ] **Step 3: Valider le JSON**

Run: `python3 -c "import json; json.load(open('.claude-plugin/plugin.json')); json.load(open('.claude-plugin/marketplace.json')); print('JSON OK')"`
Expected: `JSON OK`

- [ ] **Step 4: Commit**

```bash
git add .claude-plugin
git commit -m "feat(cairn): manifeste plugin + marketplace local

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 3: Templates (CLAUDE.md générique + squelettes memory/)

**Files:**
- Create: `templates/CLAUDE.md`
- Create: `templates/memory/DECISIONS.md`
- Create: `templates/memory/JOURNAL.md`
- Create: `templates/memory/LEARNINGS.md`
- Create: `templates/memory/TODO.md`

- [ ] **Step 1: Créer `templates/CLAUDE.md` (générique, < 100 lignes, sans Graphify/wiki)**

Create `templates/CLAUDE.md`:
```markdown
# {{PROJECT_NAME}} — Instructions pour Claude Code

> Fichier chargé à CHAQUE session : garde-le court et dense (< 200 lignes).
> Le détail vit dans `memory/` et n'est lu qu'à la demande.

## Projet

{{STACK}}
<!-- Décris en une ou deux phrases ce que fait ce projet. -->

## Commandes

<!-- Liste les commandes de build / test / lint du projet. -->

## Conventions

<!-- Règles de style et contraintes propres au projet. -->

---

## Mémoire de projet (`memory/`) — lue à la demande, pas auto-chargée

Règle d'or : ne RELIS jamais tout le projet si `memory/` a déjà l'info.

- `memory/DECISIONS.md` — décisions d'archi + le *pourquoi*. À CONSULTER avant tout
  choix structurant ; à mettre à jour quand une décision est prise.
- `memory/JOURNAL.md` — log chronologique des sessions (sortie de `/save`).
- `memory/LEARNINGS.md` — pièges et « on a essayé X, ça casse à cause de Y ».
- `memory/TODO.md` — fils ouverts en cours.

> N'IMPORTE PAS ces fichiers via `@` dans ce CLAUDE.md : ils seraient rechargés en
> entier à chaque session, ce qui annule le gain. On les lit ponctuellement.

---

## Commandes de session (fournies par le plugin `cairn`)

### /catchup

1. Lis les 3 dernières entrées de `memory/JOURNAL.md`.
2. Lis `memory/DECISIONS.md` et `memory/TODO.md`.
3. Résume l'état courant et ce qui reste à faire. Ne touche à rien tant que je n'ai pas validé.

### /save

1. Ajoute une entrée en tête de `memory/JOURNAL.md` au format
   `## [AAAA-MM-JJ] <titre court>` puis : *Fait*, *Décisions*, *En suspens*.
2. Si une décision d'archi a été prise, ajoute-la à `memory/DECISIONS.md`.
3. Si un piège a été rencontré, ajoute-le à `memory/LEARNINGS.md`.
4. Mets à jour `memory/TODO.md`.
5. Si on est dans un dépôt git : `git add -A && git commit`.

---

## À NE PAS faire

- Ne pas supprimer de fichier mémoire sans demander.
- Ne pas relire tout le projet si `memory/` contient déjà l'info.
```

- [ ] **Step 2: Créer `templates/memory/JOURNAL.md`**

Create `templates/memory/JOURNAL.md`:
```markdown
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

<!-- Les entrées de session viennent ici, la plus récente en haut. -->
```

- [ ] **Step 3: Créer `templates/memory/DECISIONS.md`**

Create `templates/memory/DECISIONS.md`:
```markdown
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

<!-- Les décisions viennent ici. -->
```

- [ ] **Step 4: Créer `templates/memory/LEARNINGS.md`**

Create `templates/memory/LEARNINGS.md`:
```markdown
# Apprentissages

Les pièges rencontrés et leur résolution, pour ne pas les répéter. Une entrée par
piège. À consulter quand un comportement semble bizarre ; à compléter dès qu'on
perd du temps sur quelque chose.

Format :

```
## Symptôme court
- Cause : ...
- Solution : ...
```

---

<!-- Les pièges viennent ici. -->
```

- [ ] **Step 5: Créer `templates/memory/TODO.md`**

Create `templates/memory/TODO.md`:
```markdown
# À faire

Fils ouverts en cours. Coche ou retire quand c'est traité.

<!-- - [ ] Premier fil ouvert. -->
```

- [ ] **Step 6: Commit**

```bash
git add templates
git commit -m "feat(cairn): templates CLAUDE.md + squelettes memory/

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 4: Moteur déterministe `apply-template.sh` + test bout-en-bout (TDD)

**Files:**
- Create: `scripts/test-bootstrap.sh`
- Create: `scripts/apply-template.sh`

- [ ] **Step 1: Écrire d'abord le test (qui doit échouer)**

Create `scripts/test-bootstrap.sh`:
```bash
#!/usr/bin/env bash
# Test bout-en-bout de apply-template.sh — le contrat observable de /bootstrap.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPLY="$SCRIPT_DIR/apply-template.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

fail() { echo "FAIL: $1" >&2; exit 1; }

# 1. Bootstrap dans un dossier vide
"$APPLY" "$TMP" "mon-projet" "2026-06-13" "Node.js / npm" >/dev/null

# 2. Les fichiers attendus existent
[ -f "$TMP/CLAUDE.md" ] || fail "CLAUDE.md manquant"
for f in DECISIONS JOURNAL LEARNINGS TODO; do
  [ -f "$TMP/memory/$f.md" ] || fail "memory/$f.md manquant"
done

# 3. Plus aucun placeholder résiduel
if grep -rq '{{' "$TMP"; then
  fail "placeholder {{...}} non substitué"
fi

# 4. PROJECT_NAME et STACK substitués dans CLAUDE.md
grep -q "mon-projet" "$TMP/CLAUDE.md" || fail "PROJECT_NAME non substitué"
grep -q "Node.js / npm" "$TMP/CLAUDE.md" || fail "STACK non substitué"

# 5. Sécurité : un 2e passage sur un dossier déjà amorcé doit être REFUSÉ
if "$APPLY" "$TMP" "mon-projet" "2026-06-13" "Node.js / npm" >/dev/null 2>&1; then
  fail "2e bootstrap aurait dû être refusé (anti-écrasement)"
fi

echo "PASS: test-bootstrap OK"
```

- [ ] **Step 2: Lancer le test et vérifier qu'il échoue**

Run: `chmod +x scripts/test-bootstrap.sh && bash scripts/test-bootstrap.sh`
Expected: ÉCHEC — `apply-template.sh` n'existe pas encore (erreur « No such file or directory »).

- [ ] **Step 3: Écrire le moteur `apply-template.sh`**

Create `scripts/apply-template.sh`:
```bash
#!/usr/bin/env bash
# Pose le cœur mémoire (CLAUDE.md + memory/) dans un projet cible — déterministe.
# Usage: apply-template.sh <target-dir> <project-name> <date> <stack>
set -euo pipefail

TARGET="${1:?usage: apply-template.sh <target-dir> <project-name> <date> <stack>}"
PROJECT_NAME="${2:?project name requis}"
DATE="${3:?date requise}"
STACK="${4:-projet}"

# Racine du plugin = dossier parent de scripts/
PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES="$PLUGIN_ROOT/templates"

# Garde anti-écrasement
if [ -e "$TARGET/CLAUDE.md" ] || [ -e "$TARGET/memory" ]; then
  echo "REFUS: $TARGET contient déjà CLAUDE.md ou memory/ — bootstrap annulé." >&2
  exit 1
fi

mkdir -p "$TARGET/memory"

subst() {
  sed -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
      -e "s|{{DATE}}|$DATE|g" \
      -e "s|{{STACK}}|$STACK|g"
}

subst < "$TEMPLATES/CLAUDE.md" > "$TARGET/CLAUDE.md"
for f in DECISIONS JOURNAL LEARNINGS TODO; do
  subst < "$TEMPLATES/memory/$f.md" > "$TARGET/memory/$f.md"
done

echo "OK: cœur mémoire posé dans $TARGET"
```

- [ ] **Step 4: Lancer le test et vérifier qu'il passe**

Run: `chmod +x scripts/apply-template.sh && bash scripts/test-bootstrap.sh`
Expected: `PASS: test-bootstrap OK`

- [ ] **Step 5: Commit**

```bash
git add scripts/apply-template.sh scripts/test-bootstrap.sh
git commit -m "feat(cairn): moteur déterministe apply-template.sh + test bootstrap

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 5: Commande `/bootstrap`

**Files:**
- Create: `commands/bootstrap.md`

- [ ] **Step 1: Créer la commande**

Create `commands/bootstrap.md`:
```markdown
---
description: Pose le cœur mémoire (CLAUDE.md + memory/) dans le projet courant
---

> Effort de raisonnement : faible — la procédure est déterministe, peu d'inférence.

Amorce le « cœur mémoire » dans le **répertoire courant**. Procédure :

1. **Garde** : si `./CLAUDE.md` ou `./memory/` existe déjà, ARRÊTE-toi et demande
   confirmation explicite à l'utilisateur. N'écrase jamais sans accord. (Le script
   refuse aussi de lui-même, mais vérifie avant pour expliquer clairement.)
2. **Détecte la stack** (indicatif) : repère `package.json` → Node, `Cargo.toml` →
   Rust, `pyproject.toml`/`requirements.txt` → Python, `go.mod` → Go, etc. Compose
   une courte étiquette (ex. « Node.js / npm »). Si rien n'est trouvé, utilise « projet ».
3. **Pose les fichiers** via le moteur déterministe du plugin :
   ```bash
   "${CLAUDE_PLUGIN_ROOT}/scripts/apply-template.sh" "$PWD" "<nom-du-dossier>" "<date>" "<stack>"
   ```
   où `<nom-du-dossier>` est le basename du répertoire courant, `<date>` vient du
   contexte (`currentDate`, format AAAA-MM-JJ) et `<stack>` est l'étiquette de l'étape 2.
4. **Git (uniquement après accord)** : si `./.git` n'existe pas, PROPOSE `git init -b main`
   et n'exécute qu'après confirmation. Ne fais aucun commit automatique dans cette commande.
5. **Récap** : liste les fichiers posés et rappelle les prochaines étapes (« remplis
   `CLAUDE.md` et `DECISIONS.md`, lance `/save` en fin de session »). Aucune action réseau.
```

- [ ] **Step 2: Vérifier le frontmatter**

Run: `head -3 commands/bootstrap.md`
Expected: la 1ère ligne est `---`, la 2ᵉ commence par `description:`, la 3ᵉ est `---`.

- [ ] **Step 3: Commit**

```bash
git add commands/bootstrap.md
git commit -m "feat(cairn): commande /bootstrap

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 6: Porter `/catchup` et `/save` ; retirer les anciennes commandes projet

**Files:**
- Create: `commands/catchup.md`
- Create: `commands/save.md`
- Delete: `.claude/commands/catchup.md`, `.claude/commands/save.md`
- Move → archive: `.claude/commands/wiki.md` → `archive/commands/wiki.md`

- [ ] **Step 1: Créer `commands/catchup.md` (dégraissé, sans Graphify)**

Create `commands/catchup.md`:
```markdown
---
description: Reprend le contexte de session depuis memory/ du projet courant
---

> Effort de raisonnement : moyen — synthèse de l'état du projet.

Reprends le contexte de travail. **Ne modifie rien** tant que l'utilisateur n'a pas validé.

1. Lis les **3 dernières entrées** de `memory/JOURNAL.md`.
2. Lis `memory/DECISIONS.md` et `memory/TODO.md`.
3. Résume l'état courant et ce qui reste à faire.

Termine en demandant à l'utilisateur ce qu'il veut faire ensuite.
```

- [ ] **Step 2: Créer `commands/save.md` (porté tel quel — déjà générique)**

Create `commands/save.md`:
```markdown
---
description: Sauvegarde l'état de session dans memory/ (journal, décisions, learnings, todo)
---

Exécute la procédure de sauvegarde de session.

Utilise la date du jour fournie par le contexte (`currentDate`), au format `AAAA-MM-JJ`.

1. Ajoute une entrée **en tête** de `memory/JOURNAL.md` au format :
   ```
   ## [AAAA-MM-JJ] <titre court>
   **Fait :** ...
   **Décisions :** ...
   **En suspens :** ...
   ```
   Résume ce qui a été accompli durant cette session de conversation.

2. Si une décision d'architecture a été prise, ajoute-la à `memory/DECISIONS.md` (avec le *pourquoi*).

3. Si un piège a été rencontré (« on a essayé X, ça casse à cause de Y »), ajoute-le à `memory/LEARNINGS.md`.

4. Mets à jour `memory/TODO.md` (coche le fait, ajoute les nouveaux fils ouverts).

5. Si on est dans un dépôt git : `git add -A && git commit` avec un message décrivant la session. Sinon, ignore cette étape et signale-le.

Ne supprime aucun fichier mémoire. Montre un bref récap de ce que tu as écrit.
```

- [ ] **Step 3: Retirer les anciennes commandes projet et archiver `/wiki`**

Run:
```bash
mkdir -p archive/commands
git rm --quiet .claude/commands/catchup.md .claude/commands/save.md
git mv .claude/commands/wiki.md archive/commands/wiki.md
```
Expected: `.claude/commands/` ne contient plus que rien ; `archive/commands/wiki.md` existe.

- [ ] **Step 4: Vérifier qu'il ne reste pas de doublon de commande**

Run: `ls commands && echo "---" && ls .claude/commands 2>/dev/null || echo ".claude/commands vide/absent"`
Expected: `commands/` contient `bootstrap.md`, `catchup.md`, `save.md` ; `.claude/commands` est vide ou absent.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "feat(cairn): porte /catchup et /save dans le plugin, archive /wiki

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 7: Réécrire le `CLAUDE.md` du projet-plugin et le `README.md`

**Files:**
- Modify (réécriture complète): `CLAUDE.md`
- Modify (réécriture complète): `README.md`

- [ ] **Step 1: Réécrire `CLAUDE.md` (instructions du projet-plugin lui-même)**

Overwrite `CLAUDE.md` with:
```markdown
# Cairn — Instructions pour Claude Code

> Plugin Claude Code qui pose le « cœur mémoire » dans n'importe quel projet.
> Fichier chargé à chaque session : court et dense.

## Projet

Plugin Claude Code **cairn**. Fournit trois commandes — `/bootstrap` (amorce
`CLAUDE.md` + `memory/` dans un projet), `/catchup`, `/save` — pour ne jamais perdre
le contexte entre sessions. Design : `docs/superpowers/specs/2026-06-13-cairn-bootstrap-plugin-design.md`.

## Structure

- `.claude-plugin/` — manifeste (`plugin.json`) + marketplace local (`marketplace.json`).
- `commands/` — les trois slash commands livrées par le plugin.
- `templates/` — gabarits copiés tels quels par `/bootstrap` (`CLAUDE.md` + `memory/`).
- `scripts/apply-template.sh` — moteur déterministe de copie/substitution (testé).
- `scripts/test-bootstrap.sh` — test bout-en-bout du contrat de bootstrap.
- `archive/` — échafaudage gelé (Graphify, wiki) conservé pour référence, hors périmètre.

## Commandes

- `bash scripts/test-bootstrap.sh` — vérifie le contrat de bootstrap (doit afficher `PASS`).

## Installer / dogfooder

`/plugin marketplace add <chemin de ce repo>` puis `/plugin install cairn`.

## Mémoire de projet (`memory/`) — lue à la demande

- `memory/DECISIONS.md` — décisions d'archi + le *pourquoi*.
- `memory/JOURNAL.md` — log des sessions (`/save`).
- `memory/LEARNINGS.md` — pièges.
- `memory/TODO.md` — fils ouverts.

> Ne les importe pas via `@` (ils seraient rechargés en entier). Lecture à la demande.

## Périmètre

Cœur mémoire seul. Graphify et wiki sont GELÉS (dans `archive/`) — ne pas les
réactiver sans décision explicite (voir `memory/DECISIONS.md`, verdict LLM Council
du 2026-06-13).

## À NE PAS faire

- Ne pas supprimer de fichier mémoire sans demander.
- Ne pas réintroduire Graphify/wiki dans le périmètre du plugin sans décision actée.
```

- [ ] **Step 2: Réécrire `README.md`**

Overwrite `README.md` with:
```markdown
# cairn

Plugin Claude Code qui pose un **cœur mémoire** dans n'importe quel projet, pour ne
jamais perdre le contexte entre sessions de travail avec Claude Code.

Un *cairn*, c'est un empilement de pierres qui balise un sentier — pour que le
voyageur (ou ton toi futur) ne perde pas le chemin. C'est ce que fait ce plugin :
laisser des repères entre sessions.

## Ce que le plugin installe

- `CLAUDE.md` — instructions de session, courtes et denses.
- `memory/` — quatre fichiers lus à la demande :
  - `DECISIONS.md` (ADR léger), `JOURNAL.md` (log de sessions),
    `LEARNINGS.md` (pièges), `TODO.md` (fils ouverts).

## Commandes

- `/bootstrap` — pose `CLAUDE.md` + `memory/` dans le projet courant (n'écrase jamais).
- `/catchup` — relit les dernières entrées de `memory/` et résume l'état du projet.
- `/save` — écrit l'entrée de journal, met à jour décisions/pièges/todo, commit si repo git.

## Installation

```bash
/plugin marketplace add <chemin vers ce repo>
/plugin install cairn
```

## Démarrer un projet

Dans un dossier de projet :

```
/bootstrap
```

Puis, en fin de séance, `/save`. À la séance suivante, `/catchup`.

## Périmètre

Volontairement minimal : le **cœur mémoire** seul. Les couches plus lourdes
expérimentées dans l'historique du projet (graphe de structure Graphify, wiki LLM)
sont gelées dans `archive/` — réintroductibles plus tard comme options modulaires,
une fois le cœur validé par l'usage réel.

## Tests

```bash
bash scripts/test-bootstrap.sh
```
```

- [ ] **Step 3: Commit**

```bash
git add CLAUDE.md README.md
git commit -m "docs(cairn): réécrit CLAUDE.md et README pour le projet-plugin

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

### Task 8: `.gitignore` + acter la conversion dans la mémoire du projet

**Files:**
- Modify: `.gitignore`
- Modify: `memory/DECISIONS.md`
- Modify: `memory/TODO.md`

- [ ] **Step 1: Mettre à jour `.gitignore` (le cache Graphify a déménagé dans archive/)**

In `.gitignore`, replace the line:
```
graphify-out/cache/
```
with:
```
archive/graphify-out/cache/
```

- [ ] **Step 2: Acter la décision de conversion dans `memory/DECISIONS.md`**

Insert this entry directly after the `---` separator (line 18), **before** the most
recent existing entry:
```markdown
## [2026-06-13] Conversion d'Atlas en plugin de bootstrap « cairn »
- Statut : actif
- Contexte : Atlas (`homepage/`) était une landing page Vite/React servant de banc
  d'essai à un échafaudage mémoire/contexte. Un LLM Council (2026-06-13) a jugé
  l'instrumentation prématurée sur un projet trivial (voir LEARNINGS). On veut rendre
  le pattern réutilisable et le valider sur de vrais projets.
- Décision : transformer le repo en **plugin Claude Code `cairn`** (+ marketplace local)
  qui pose le **cœur mémoire seul** (`CLAUDE.md` + `memory/` + `/catchup` + `/save`)
  via `/bootstrap`. Front-end React retiré. Graphify et wiki gelés dans `archive/`.
  Mécanisme : templates statiques + substitution déterministe (`scripts/apply-template.sh`,
  testé) — approche choisie pour sa reproductibilité (écarte une génération adaptative
  par l'agent, non déterministe).
- Pourquoi : suit la reco du council (valider le cœur sur l'usage réel, geler le reste) ;
  un plugin rend les commandes disponibles dans tous les projets. Alternatives écartées :
  template à cloner (figé), pack global `~/.claude` (couplé machine), prompt unique à coller
  (non outillé).
- Conséquences : rend caduque la décision « stack Vite + React + TypeScript » pour ce repo
  (Remplace : [2026-06-12] Stack). `memory/` documente désormais le projet-plugin. Prochaine
  étape de validation : dogfooder `cairn` puis l'utiliser sur un vrai projet non-trivial.
```

- [ ] **Step 3: Mettre à jour `memory/TODO.md`**

Append these lines at the end of `memory/TODO.md`:
```markdown
- [ ] **cairn** : dogfooder le plugin (`/plugin marketplace add` + `/plugin install cairn`) puis l'essayer sur un vrai projet non-trivial, avec une métrique d'usage (« recharge de contexte = gain ou perte ? »). Voir DECISIONS 2026-06-13.
- [ ] **cairn** : décider plus tard si Graphify/wiki reviennent comme options modulaires (aujourd'hui gelés dans `archive/`).
```

- [ ] **Step 4: Vérifier le test global après tous les changements**

Run: `bash scripts/test-bootstrap.sh && python3 -c "import json; json.load(open('.claude-plugin/plugin.json')); json.load(open('.claude-plugin/marketplace.json')); print('JSON OK')"`
Expected: `PASS: test-bootstrap OK` puis `JSON OK`.

- [ ] **Step 5: Commit**

```bash
git add .gitignore memory/DECISIONS.md memory/TODO.md
git commit -m "chore(cairn): acte la conversion dans memory/, fixe le .gitignore

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

---

## Notes de fin

- **JOURNAL.md** : laissé à `/save` en fin de session (non dupliqué ici) — il enregistrera
  cette session de conversion.
- **Vérification d'installation réelle** (manuelle, hors plan automatisable) : après le
  dernier commit, `/plugin marketplace add <repo>` puis `/plugin install cairn`, et confirmer
  que `/bootstrap`, `/catchup`, `/save` apparaissent dans un autre dossier de projet.
- Le `${CLAUDE_PLUGIN_ROOT}` utilisé dans `commands/bootstrap.md` est fourni par Claude Code
  au moment de l'exécution d'une commande de plugin ; il pointe la racine du plugin installé.
```
