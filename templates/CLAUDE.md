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
