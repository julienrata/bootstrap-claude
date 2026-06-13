# À faire

Fils ouverts en cours. Coche ou retire quand c'est traité.

- [x] Lancer la génération du graphe Graphify (fait : rebuild 2026-06-13, 90 nodes).
- [ ] Ouvrir le vault `../vault` dans Obsidian et vérifier la graph view.
- [ ] Remplacer le copy de démo (« Atlas ») par le vrai contenu du site.
- [ ] Décider du déploiement (Vercel / Netlify / Pages) et le consigner dans DECISIONS.md.
- [x] **Wiki LLM** : design + spec + implémentation complète (commande `/wiki`, 12 pages, symlink, section CLAUDE.md). Fait le 2026-06-13. Voir DECISIONS.md.
- [ ] Tester `/wiki lint` et `/wiki query` en conditions réelles.
- [x] Initialiser git (`main`, `.gitignore` complété, commit initial `19207ca`). Fait le 2026-06-13. Voir DECISIONS.md.
- [ ] Dé-suivre `graphify-out/.graphify_python` (chemin absolu machine-spécifique) + l'ajouter au `.gitignore`.
- [ ] Migrer la détection de fraîcheur du wiki des mtime vers `git diff` (lève le blind spot intra-journée — voir LEARNINGS).
- [ ] Persister (ou non) le prompt « bootstrap from scratch » du pattern Atlas comme artefact réutilisable (`docs/`) — produit en conversation le 2026-06-13, voir JOURNAL.
- [ ] Trancher la reco du LLM Council (2026-06-13, `concil/`) : geler l'outillage d'Atlas et valider la couche mémoire (`/catchup`+`/save`+`memory/`) sur un vrai projet non-trivial, métrique d'usage à l'appui, avant toute industrialisation. Voir LEARNINGS (instrumentation prématurée).
