# Atlas — Instructions pour Claude Code

> Fichier chargé à CHAQUE session : garde-le court et dense (< 200 lignes).
> Le détail vit dans `memory/` et n'est lu qu'à la demande.

## Projet
Page d'accueil — échafaudage **Vite + React + TypeScript**.

## Commandes
- `npm run dev` — serveur de dev
- `npm run build` — typecheck + build de production
- `npm run typecheck` — vérifie les types sans émettre

## Conventions
- Composants en PascalCase, un composant par fichier dans `src/components/`.
- Styles : un seul `src/index.css` piloté par variables CSS (tokens en haut du fichier). Pas de styles inline sauf cas ponctuel.
- TypeScript strict : ne désactive pas `strict`, n'utilise pas `any` sans raison consignée.
- Plancher qualité UI : responsive mobile, focus clavier visible, `prefers-reduced-motion` respecté.

---

## Navigation du contexte (Graphify) — À RESPECTER avant de lire du code

Règle des 3 couches, dans l'ordre :
1. **Structure** → interroge `graphify-out/graph.json` (ou `graphify-out/GRAPH_REPORT.md`) pour comprendre l'architecture et les liens entre modules.
2. **Contexte projet** → lis `memory/` (décisions, avancement, pièges).
3. **Code brut** → seulement en dernier recours : quand tu édites, ou quand 1 et 2 n'ont pas la réponse.

Couche de synthèse optionnelle : `wiki/` répond au *pourquoi* et donne la vue d'ensemble (voir section Wiki). À consulter quand la question porte sur l'intention/l'archi plutôt que sur la structure brute.

Objectif : ne relis JAMAIS toute la codebase si le graphe a déjà l'info — c'est l'essentiel de l'économie de tokens.

Reconstruire le graphe après un changement structurel : `graphify . --update` (ne traite que les fichiers modifiés). Le graphe est persistant, pas besoin de le régénérer chaque session.

Ne modifie jamais à la main les fichiers de `graphify-out/`.

---

## Fichiers mémoire (`memory/`) — lus à la demande, pas auto-chargés

- `memory/DECISIONS.md` — décisions d'archi + le *pourquoi*. À CONSULTER avant tout choix structurant ; à mettre à jour quand une décision est prise.
- `memory/JOURNAL.md` — log chronologique des sessions (sortie de `/save`).
- `memory/LEARNINGS.md` — pièges et « on a essayé X, ça casse à cause de Y ».
- `memory/TODO.md` — fils ouverts en cours.

> N'IMPORTE PAS ces fichiers via `@` dans ce CLAUDE.md : ils seraient rechargés en entier à chaque session, ce qui annule le gain. On les lit ponctuellement.

---

## Wiki (`wiki/`) — couche de synthèse, lue à la demande

Wiki maintenu par le LLM : synthèse interconnectée **au-dessus** du code, de `memory/` et
de `graphify` — il les résume, ne les duplique pas. Les sources restent la vérité ; le wiki
répond au *pourquoi* et donne la vue d'ensemble.

- Point d'entrée : `wiki/index.md` (catalogue) puis les pages pertinentes.
- Exposé à Obsidian via le symlink `vault/wiki/homepage/` → `wiki/`.
- Maintenu par la commande `/wiki` (`update` | `lint` | `query`) — voir `.claude/commands/wiki.md`.
- Comme `memory/`, lu à la demande : ne l'auto-importe PAS via `@`.

> `/wiki query` = le *pourquoi* / la synthèse ; `graphify query` = la structure du code.

---

## Commandes de session

> Note : `/resume` est réservé par Claude Code (reprise de conversation). La reprise de contexte projet s'appelle donc `/catchup`.

### /catchup

1. Lis les 3 dernières entrées de `memory/JOURNAL.md`.
2. Lis `memory/DECISIONS.md` et `memory/TODO.md`.
3. Interroge `graphify-out/graph.json` plutôt que de relire le code.
4. Résume l'état courant et ce qui reste à faire. Ne touche à rien tant que je n'ai pas validé.

### /save

1. Ajoute une entrée en tête de `memory/JOURNAL.md` au format :
   `## [AAAA-MM-JJ] <titre court>` puis : *Fait*, *Décisions*, *En suspens*.
2. Si une décision d'archi a été prise, ajoute-la à `memory/DECISIONS.md`.
3. Si un piège a été rencontré, ajoute-le à `memory/LEARNINGS.md`.
4. Mets à jour `memory/TODO.md`.
5. Si on est dans un dépôt git : `git add -A && git commit`.

---

## À NE PAS faire

- Ne pas supprimer de fichier mémoire sans demander.
- Ne pas relire toute la codebase si `graph.json` contient déjà l'info.
- Ne pas committer `graphify-out/cache/` (voir `.gitignore`).
