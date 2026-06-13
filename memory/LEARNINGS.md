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

## `/wiki update` : le champ `updated:` est au grain du JOUR, pas de l'heure
- Cause : la détection de péremption compare le mtime des sources au champ `updated:` (AAAA-MM-JJ). Une source éditée le même jour que la dernière resync n'est donc PAS détectée comme périmée par la règle officielle.
- Solution : ne pas se fier qu'au champ pour les changements intra-journée — comparer aussi au mtime réel du fichier de page, et tenir compte des fichiers édités pendant la session courante. Quand le repo sera sous git, basculer la détection sur `git diff` (plus fin et fiable).

## `graphify` refuse d'écraser `graph.json` si le nouveau graphe a moins de nœuds
- Cause : garde anti-régression dans `to_json` — protège contre les `--update` accidentels qui perdent des chunks. Au rebuild complet, une nouvelle passe sémantique peut légitimement produire moins de nœuds conceptuels (100 → 90), ce qui déclenche le refus.
- Solution : si la réduction est légitime (rebuild complet volontaire, pas de chunk perdu), réécrire avec `to_json(G, communities, 'graphify-out/graph.json', force=True)`. Ne pas forcer à l'aveugle sur un `--update`.

## Une procédure « `/xxx` » décrite en prose dans CLAUDE.md n'est PAS une slash command
- Cause : seules les entrées de `.claude/commands/*.md` sont de vraies slash commands. Une section `### /resume` en prose est juste de la doc ; taper `/resume` lance la commande native du harness (reprise de conversation), pas la procédure décrite.
- Solution : créer un fichier `.claude/commands/<nom>.md`. Attention aux collisions : éviter les noms réservés par le harness (`/resume`) ou déjà pris par un skill (`/recall`).

## Les imports `@fichier.md` dans CLAUDE.md n'économisent PAS de tokens
- Cause : le contenu importé est déplié en ligne et compte dans le contexte à chaque session.
- Solution : ne jamais importer JOURNAL/DECISIONS dans CLAUDE.md ; les laisser lus à la demande. Pour des règles localisées, utiliser un `CLAUDE.md` de sous-dossier (chargé seulement quand on touche ce sous-arbre).
