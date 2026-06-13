# Graph Report - .  (2026-06-12)

## Corpus Check
- Corpus is ~3,137 words - fits in a single context window. You may not need a graph.

## Summary
- 90 nodes · 102 edges · 8 communities (7 shown, 1 thin omitted)
- Extraction: 94% EXTRACTED · 6% INFERRED · 0% AMBIGUOUS · INFERRED: 6 edges (avg confidence: 0.8)
- Token cost: 0 input · 40,031 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Dépendances npm|Dépendances npm]]
- [[_COMMUNITY_Config TypeScript (app)|Config TypeScript (app)]]
- [[_COMMUNITY_Mémoire & commandes de session|Mémoire & commandes de session]]
- [[_COMMUNITY_Config TypeScript (node)|Config TypeScript (node)]]
- [[_COMMUNITY_Rendu UI & Graphify|Rendu UI & Graphify]]
- [[_COMMUNITY_Composant App  étapes|Composant App / étapes]]
- [[_COMMUNITY_tsconfig racine|tsconfig racine]]

## God Nodes (most connected - your core abstractions)
1. `compilerOptions` - 16 edges
2. `compilerOptions` - 13 edges
3. `Couche mémoire (memory/)` - 8 edges
4. `/catchup command` - 7 edges
5. `/save command` - 7 edges
6. `DECISIONS.md (registre ADR)` - 6 edges
7. `scripts` - 5 edges
8. `Knowledge graph (Graphify)` - 4 edges
9. `LEARNINGS.md (pièges)` - 4 edges
10. `CLAUDE.md (instructions agent)` - 4 edges

## Surprising Connections (you probably didn't know these)
- `GraphMark()` --conceptually_related_to--> `Knowledge graph (Graphify)`  [INFERRED]
  src/components/GraphMark.tsx → README.md
- `App component` --conceptually_related_to--> `Boucle de session (catchup / travailler / save)`  [INFERRED]
  src/App.tsx → README.md
- `Décision : stack Vite + React + TypeScript` --rationale_for--> `Vite config`  [INFERRED]
  memory/DECISIONS.md → vite.config.ts
- `index.html root mount point` --references--> `main entry (createRoot render)`  [EXTRACTED]
  index.html → src/main.tsx
- `Piège : les imports @fichier.md n'économisent pas de tokens` --rationale_for--> `Couche mémoire (memory/)`  [INFERRED]
  memory/LEARNINGS.md → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Flux de mémoire persistante entre sessions** — catchup_command, save_command, journal_doc, decisions_doc, memory_layer [EXTRACTED 1.00]
- **Mécanismes d'économie de tokens** — three_layer_navigation, knowledge_graph_concept, memory_layer, token_economy [INFERRED 0.85]
- **Chaîne de rendu front-end** — index_root, main_main, app_app, components_graphmark_graphmark [EXTRACTED 1.00]

## Communities (8 total, 1 thin omitted)

### Community 0 - "Dépendances npm"
Cohesion: 0.11
Nodes (18): dependencies, react, react-dom, devDependencies, @types/react, @types/react-dom, typescript, vite (+10 more)

### Community 1 - "Config TypeScript (app)"
Cohesion: 0.11
Nodes (17): compilerOptions, allowImportingTsExtensions, isolatedModules, jsx, lib, module, moduleDetection, moduleResolution (+9 more)

### Community 2 - "Mémoire & commandes de session"
Cohesion: 0.23
Nodes (16): /catchup command, CLAUDE.md (instructions agent), Décision : styles via variables CSS dans un fichier unique, DECISIONS.md (registre ADR), Décision : commandes de session en fichiers, nommage anglais, Décision : stack Vite + React + TypeScript, JOURNAL.md (log de sessions), Piège : les imports @fichier.md n'économisent pas de tokens (+8 more)

### Community 3 - "Config TypeScript (node)"
Cohesion: 0.13
Nodes (14): compilerOptions, allowImportingTsExtensions, isolatedModules, lib, module, moduleDetection, moduleResolution, noEmit (+6 more)

### Community 4 - "Rendu UI & Graphify"
Cohesion: 0.15
Nodes (10): App component, EDGES, GraphMark(), Node, NODES, index.html root mount point, Knowledge graph (Graphify), main entry (createRoot render) (+2 more)

### Community 5 - "Composant App / étapes"
Cohesion: 0.50
Nodes (3): App(), Step, STEPS

## Knowledge Gaps
- **54 isolated node(s):** `name`, `private`, `version`, `type`, `dev` (+49 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Knowledge graph (Graphify)` connect `Rendu UI & Graphify` to `Mémoire & commandes de session`?**
  _High betweenness centrality (0.052) - this node is a cross-community bridge._
- **Why does `/catchup command` connect `Mémoire & commandes de session` to `Rendu UI & Graphify`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Couche mémoire (memory/)` (e.g. with `Piège : les imports @fichier.md n'économisent pas de tokens` and `setup-graphify.sh`) actually correct?**
  _`Couche mémoire (memory/)` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `name`, `private`, `version` to the rest of the system?**
  _55 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Dépendances npm` be split into smaller, more focused modules?**
  _Cohesion score 0.10526315789473684 - nodes in this community are weakly interconnected._
- **Should `Config TypeScript (app)` be split into smaller, more focused modules?**
  _Cohesion score 0.1111111111111111 - nodes in this community are weakly interconnected._
- **Should `Config TypeScript (node)` be split into smaller, more focused modules?**
  _Cohesion score 0.13333333333333333 - nodes in this community are weakly interconnected._