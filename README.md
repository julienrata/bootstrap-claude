# Atlas — page d'accueil + mémoire pour Claude Code

Échafaudage **Vite + React + TypeScript** d'une page d'accueil, livré avec une
couche mémoire prête pour **Claude Code**, **Obsidian** et **Graphify**.

Le but : que ton agent reparte de là où il s'est arrêté, sans relire tout le code
ni te faire réexpliquer le projet à chaque session — donc moins de tokens.

## Arborescence

```
.
├── homepage/        ← le projet de code (ce que tu déploies)
│   ├── CLAUDE.md            ← lu auto à chaque session (lean, < 200 lignes)
│   ├── memory/             ← mémoire du projet, lue À LA DEMANDE
│   │   ├── DECISIONS.md        décisions d'archi + pourquoi
│   │   ├── JOURNAL.md          log des sessions (sortie de /save)
│   │   ├── LEARNINGS.md        pièges rencontrés
│   │   └── TODO.md             fils ouverts
│   ├── scripts/setup-graphify.sh
│   └── src/                ← le code de la page
└── vault/           ← le vault Obsidian (cerveau transverse + graphes)
```

## 1. Lancer le site

```bash
cd homepage
npm install
npm run dev        # http://localhost:5173
npm run build      # typecheck + build de prod
```

## 2. Comprendre la mémoire (le point clé)

Claude Code ne lit **automatiquement** que `homepage/CLAUDE.md`. Tout le reste
(`memory/*.md`) n'est lu que quand `CLAUDE.md` lui dit de le faire. C'est voulu :

- `CLAUDE.md` reste court → faible coût en tokens à chaque session.
- Les fichiers `memory/` portent le détail → lus seulement au bon moment.

Deux commandes définies dans `CLAUDE.md` orchestrent ça :
- **`/resume`** en début de session : relit le journal + les décisions, interroge
  le graphe, et résume où on en est.
- **`/save`** en fin de session : écrit le log, met à jour décisions/pièges, commit.

> ⚠️ N'importe jamais `memory/*.md` via la syntaxe `@` dans `CLAUDE.md` : le contenu
> serait rechargé en entier à chaque session, ce qui annule l'économie.

## 3. Brancher Obsidian

1. Installe Obsidian (gratuit) : https://obsidian.md
2. « Open folder as vault » → choisis le dossier `vault/`.
3. La graph view montrera les notes générées par Graphify (étape 4).

Le `vault/` sert de cerveau transverse à tes projets et de lentille de
visualisation. La mémoire *du projet*, elle, reste dans `homepage/memory/`.

## 4. Brancher Graphify

```bash
cd homepage
bash scripts/setup-graphify.sh
```

Le script installe Graphify (`pip install graphifyy`), génère le graphe du code
et exporte des notes dans `vault/graphify/homepage/`. Résultats :
- `graphify-out/graph.json` → ce que Claude Code interroge au lieu de relire le code
- `graphify-out/graph.html` → visualisation interactive (ouvre-la dans un navigateur)

Mise à jour après des changements : `graphify . --update`.

> Les flags de Graphify évoluent selon la version. En cas d'erreur, lance
> `graphify --help` et adapte la commande dans le script.

## 5. Boucle de travail type

```
ouvrir Claude Code dans homepage/
  └─ /resume        → l'agent charge le contexte (journal, décisions, graphe)
  └─ travailler     → features, correctifs…
  └─ /save          → log + mise à jour mémoire + commit
```

---

Tout le copy de la page (« Atlas ») est du contenu de démo : remplace-le par le
tien. Le reste de la structure est faite pour grandir avec le projet.
