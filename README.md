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
