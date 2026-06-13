---
description: Sauvegarde l'état de session dans memory/ (journal, décisions, learnings, todo)
---

Exécute la procédure de sauvegarde de session.

Utilise la date du jour fournie par le contexte (`currentDate`), au format `AAAA-MM-JJ`.

1. Ajoute une entrée **en tête** de `memory/JOURNAL.md` au format :
   ```
   ## [AAAA-MM-JJ] <titre court>
   **Fait :** ...
   **Décisions :** ...
   **En suspens :** ...
   ```
   Résume ce qui a été accompli durant cette session de conversation.

2. Si une décision d'architecture a été prise, ajoute-la à `memory/DECISIONS.md` (avec le *pourquoi*).

3. Si un piège a été rencontré (« on a essayé X, ça casse à cause de Y »), ajoute-le à `memory/LEARNINGS.md`.

4. Mets à jour `memory/TODO.md` (coche le fait, ajoute les nouveaux fils ouverts).

5. Si on est dans un dépôt git : `git add -A && git commit` avec un message décrivant la session. Sinon, ignore cette étape et signale-le.

Ne supprime aucun fichier mémoire. Montre un bref récap de ce que tu as écrit.
