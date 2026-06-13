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
