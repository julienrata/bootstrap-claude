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

## Déplacer un dossier sous `archive/` casse silencieusement sa règle `.gitignore`
- Cause : `.gitignore` ignorait `graphify-out/cache/`. Après `git mv graphify-out archive/graphify-out`, le chemin réel devient `archive/graphify-out/cache/` — la règle ne matche plus, et le cache (jusque-là non suivi) est devenu suivi et committé par erreur au `git add -A`.
- Solution : quand on déplace un dossier qui a des règles d'ignore, mettre à jour les chemins du `.gitignore` dans le même mouvement. Réparation : `git rm -r --cached archive/graphify-out/cache/` (dé-suit sans effacer le disque) + corriger la règle. Réflexe : après un `git mv` de gros dossier, vérifier `git status` pour des fichiers nouvellement suivis qu'on ne voulait pas.

## Instrumenter un projet trop petit pour générer le problème = outil qui se valide tout seul
- Cause : Atlas (landing page, code qui tient en tête) a été équipé d'un harnais lourd (graphe Graphify + `memory/` 4 catégories + wiki + commandes de session) censé résoudre la perte de contexte. Mais une landing ne sollicite jamais ce problème → le harnais « marche » par absence de friction, pas par résolution d'une douleur. On ne peut donc rien apprendre de réel sur sa valeur (verdict unanime d'un LLM Council, 2026-06-13, voir `concil/`).
- Solution : valider un système de mémoire/contexte sur un projet assez gros pour avoir besoin de mémoire (multi-mois ou multi-séances), pas sur le banc d'essai où on l'a construit. Règle premier-principe par brique : garder ce qui *réduit* l'entropie à gérer (mémoire, resituation), suspecter ce qui en *ajoute* (orchestration, wiki/graphe sur projet trivial). Mesurer la preuve à l'usage (une ligne/session : « recharge de contexte = gain ou perte de temps ? ») plutôt que de la présumer par construction. Corollaire : le coût de maintenance des couches (synchro code↔wiki↔graphe) est une dette réelle — prévoir un critère pour *retirer* une couche devenue passif.

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
