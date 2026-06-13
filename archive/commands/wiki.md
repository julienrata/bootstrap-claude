---
description: Maintient le wiki LLM du projet (wiki/) — synthèse interconnectée au-dessus du code, de memory/ et de graphify. Sous-commandes : update (défaut) | lint | query
---

Tu maintiens le **wiki du projet** : une couche de synthèse markdown, navigable et
interconnectée, posée **au-dessus** des sources et sans les dupliquer.

Sources immuables (à LIRE, jamais à modifier) : le code (`src/`, configs, `scripts/`),
`memory/` (DECISIONS, JOURNAL, LEARNINGS, TODO) et `graphify-out/graph.json`.
Le wiki vit dans `homepage/wiki/` (versionné) et est exposé à Obsidian via le symlink
`vault/wiki/homepage/`.

Conventions des pages (à respecter pour CHAQUE page créée ou modifiée) :
- Frontmatter YAML : `title`, `type` (overview|architecture|component|concept|index|log),
  `sources:` (liste des fichiers source synthétisés — le pivot), `updated:` (date du jour AAAA-MM-JJ).
- Corps : wikilinks `[[...]]` pour les liens internes (jamais de liens markdown), min. 2 par page.
- Citations de source inline sur chaque affirmation : par ex. `` Build via Vite (`vite.config.ts`) ``.
- Noms de fichiers en kebab-case. Une page = un sujet nommé.
- Synthèse, JAMAIS de copie brute des sources.

Délimitation : `/wiki query` répond sur le « pourquoi » / la synthèse ; `graphify query`
répond sur la structure du code. Complémentaires.

---

Détermine la sous-commande à partir de l'argument (`update` par défaut si vide).

## update  (défaut)

> Effort de raisonnement : **élevé** — *think hard*. C'est la sous-commande de synthèse : interconnecter code + `memory/` + graphify sans dupliquer demande du jugement. L'effort se justifie ici.

1. Lis `wiki/index.md` et le frontmatter (`sources:` / `updated:`) de toutes les pages de `wiki/`.
2. Détecte les sources modifiées : une page est **périmée** si le **mtime** d'un de ses
   fichiers `sources:` est postérieur à son champ `updated:`. Inclus aussi les fichiers
   source édités pendant la session courante. (Bascule vers `git diff` quand le repo sera sous git.)
3. Pour chaque source modifiée : resynthétise les pages qui la citent, mets à jour les
   cross-refs `[[...]]`. Crée une page si un nouveau sous-système/composant/concept est
   apparu ; fusionne ou marque obsolète ce qui a disparu. Mets `updated:` à la date du jour.
4. Mets à jour `wiki/index.md` (catalogue) et ajoute une ligne à `wiki/log.md` au format
   `## [AAAA-MM-JJ] update | <résumé>`.
5. Affiche un récap des pages touchées. Ne modifie AUCUNE source.

## lint  (audit — ne modifie rien, propose)

> Effort de raisonnement : **faible** — défaut, pas de mot-clé. Vérifs surtout mécaniques (wikilinks, frontmatter, orphelins).

Analyse le wiki et sors une **liste de problèmes + questions à creuser**, sans rien réécrire
avant feu vert de l'utilisateur. Vérifie :
- pages orphelines (aucun wikilink entrant) ;
- concepts cités dans plusieurs pages mais sans page dédiée ;
- cross-refs manquants (pages qui devraient se lier) ;
- pages périmées (`updated:` antérieur au mtime d'une source) ;
- contradictions entre pages ;
- frontmatter invalide ou `sources:` pointant un fichier disparu.
Termine en proposant des sources à lire ou des questions à investiguer.

## query "<question>"

> Effort de raisonnement : **moyen** — *think*. Répondre au « pourquoi » demande du raisonnement, pas un simple lookup. Monte à *think hard* si la question est transversale ou ambiguë.

1. Lis `wiki/index.md` pour repérer les pages pertinentes, puis ouvre-les.
2. Réponds par une synthèse **avec citations** vers les pages wiki concernées (`[[...]]`).
3. Propose de **classer la réponse comme nouvelle page** (`wiki/concepts/` ou
   `wiki/architecture/`) si elle a de la valeur — pour que les explorations s'accumulent.
   Si l'utilisateur accepte, crée la page (conventions ci-dessus) et logue-la dans `log.md`.
