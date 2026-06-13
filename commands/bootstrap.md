---
description: Pose le cœur mémoire (CLAUDE.md + memory/) dans le projet courant
---

> Effort de raisonnement : faible — la procédure est déterministe, peu d'inférence.

Amorce le « cœur mémoire » dans le **répertoire courant**. Procédure :

1. **Garde** : si `./CLAUDE.md` ou `./memory/` existe déjà, ARRÊTE-toi et demande
   confirmation explicite à l'utilisateur. N'écrase jamais sans accord. (Le script
   refuse aussi de lui-même, mais vérifie avant pour expliquer clairement.)
2. **Détecte la stack** (indicatif) : repère `package.json` → Node, `Cargo.toml` →
   Rust, `pyproject.toml`/`requirements.txt` → Python, `go.mod` → Go, etc. Compose
   une courte étiquette (ex. « Node.js / npm »). Si rien n'est trouvé, utilise « projet ».
3. **Pose les fichiers** via le moteur déterministe du plugin :
   ```bash
   "${CLAUDE_PLUGIN_ROOT}/scripts/apply-template.sh" "$PWD" "<nom-du-dossier>" "<date>" "<stack>"
   ```
   où `<nom-du-dossier>` est le basename du répertoire courant, `<date>` vient du
   contexte (`currentDate`, format AAAA-MM-JJ) et `<stack>` est l'étiquette de l'étape 2.
4. **Git (uniquement après accord)** : si `./.git` n'existe pas, PROPOSE `git init -b main`
   et n'exécute qu'après confirmation. Ne fais aucun commit automatique dans cette commande.
5. **Récap** : liste les fichiers posés et rappelle les prochaines étapes (« remplis
   `CLAUDE.md` et `DECISIONS.md`, lance `/save` en fin de session »). Aucune action réseau.
