# Council Transcript — 2026-06-13 09:09

## Question d'origine

> J'ai vu une tendance sur les projets informatiques qui est de mettre en place des agents pour piloter le projet, qu'est-ce que tu en penses ?

## Question cadrée (soumise aux 5 conseillers)

Tendance observée : sur les projets informatiques, on met de plus en plus d'agents IA pour « piloter » le projet — orchestrer, suivre l'avancement, préparer/prendre des décisions, maintenir le contexte, automatiser la coordination et une partie du dev. Qu'en penser ? Bonne direction, mode, ou piège ? Quand est-ce pertinent, quand est-ce dangereux ?

Contexte : l'utilisateur construit lui-même « Atlas » (landing page Vite/React/TS) qui sert de banc d'essai au pattern — un agent Claude Code navigue via 3 couches de contexte (graphe de code Graphify → fichiers mémoire `memory/` → code brut) + une couche wiki de synthèse + des commandes de session `/catchup` et `/save` qui maintiennent la mémoire entre sessions. Question mi-personnelle (suis-je sur la bonne voie ?), mi-générale (valeur réelle vs hype ?). En jeu : du temps investi dans l'outillage agentique plutôt que dans le produit, le risque de sur-ingénierie, mais un gain potentiel de productivité et de continuité.

## Mapping d'anonymisation (peer review)

- Réponse A = **L'Expansionniste**
- Réponse B = **Le Contrarian**
- Réponse C = **L'Exécutant**
- Réponse D = **Le Penseur Premiers Principes**
- Réponse E = **L'Outsider**

---

## Réponses des conseillers

### Le Contrarian

Les agents de pilotage IA ont une faille structurelle que personne n'avoue : ils déplacent le travail, ils ne le suppriment pas. Tu n'écris plus de notes de décision, tu écris des prompts pour que l'agent écrive des notes de décision — puis tu relis ses notes pour vérifier qu'il n'a pas halluciné le contexte. Le coût de vérification ne disparaît jamais. Sur un projet à un seul humain (toi), c'est pire : la coordination qu'ils automatisent... n'existe pas. Tu construis une tour de contrôle pour un aéroport à un avion.

Atlas trahit le piège. Tu as 5 fichiers `memory/`, une couche wiki de synthèse, un graphe Graphify, deux commandes de session — pour une landing page. Question brutale : combien de lignes dans `src/` versus combien dans l'outillage de contexte ? Si le ratio penche vers le méta, tu n'as pas construit un produit, tu as construit un musée de ta propre méthodologie. Le `git log` le crie : tes commits récents parlent de « versioning », de « cabler l'effort de raisonnement », de « session prompts de bootstrap » — métadonnées sur métadonnées. Où est la fonctionnalité utilisateur ?

Le danger réel n'est pas le gaspillage de temps. C'est que ces couches **pourrissent en silence**. Un wiki qui ment est pire qu'absent : tu lui fais confiance. La mémoire dérive du code, `/save` capture une version idéalisée de ce que tu crois avoir fait, et dans trois mois tu débogues l'écart entre la carte et le territoire au lieu du produit.

Quand est-ce légitime ? Quand le contexte dépasse ce qu'un humain retient — équipe réelle, codebase de 100k lignes, rotation. Là, le pilotage paie. Sur Atlas, tu apprends l'outil, ce qui est honnête — mais ne confonds pas « j'ai monté un banc d'essai impressionnant » avec « je livre ». Le test : supprime la moitié de l'outillage demain. Si le produit n'avance pas plus lentement, c'était du théâtre.

### Le Penseur Premiers Principes

Tu poses la mauvaise question. « Mettre des agents pour piloter le projet » présuppose que le pilotage est le goulot d'étranglement. Sur la plupart des projets solo ou petits, il ne l'est pas. Le vrai goulot, c'est la perte de contexte entre deux moments de travail, et la difficulté à décider quoi faire ensuite. Reformule : « comment réduire le coût de re-rentrer dans le problème ? »

Une fois reformulé, ta question « bonne direction ou piège ? » se dissout. Ce que tu as construit dans Atlas (3 couches de contexte, `/catchup`, `/save`, mémoire persistante) n'est pas du « pilotage par agent ». C'est de la **gestion de contexte**. Et ça, c'est primitif, pas accessoire : tu attaques la cause racine, pas le symptôme. Garde-le.

Le piège n'est pas « agent oui/agent non ». Le piège, c'est de confondre deux choses que la hype empaquette ensemble :
1. **L'agent qui se souvient et resitue** — réduit l'entropie, gain réel, composable.
2. **L'agent qui décide et coordonne** — ajoute une couche d'indirection entre toi et le problème. Tu pilotes maintenant le pilote.

Le test premier-principe, à appliquer à chaque brique d'outillage : *est-ce que ça réduit l'entropie que je dois gérer, ou est-ce que ça en ajoute une que je dois maintenant gérer ?* Mémoire, graphe, wiki de synthèse : réduisent. Orchestration multi-agents, prise de décision déléguée : ajoutent — sauf à une échelle que ta landing page n'a pas.

Donc : pas une mode, pas un piège. Le danger réel et unique pour toi, c'est de continuer à raffiner l'outillage parce que c'est plus intéressant que la landing page. L'outil n'a de valeur que reporté contre le produit. Construis Atlas. Si l'outillage ne se paie pas en pages livrées, c'est un jouet, pas un levier.

### L'Expansionniste

La direction est juste, mais tu sous-estimes massivement ce que tu es en train de construire. Tu crois faire de l'outillage pour une landing page. En réalité, le produit n'est pas Atlas — c'est le système de navigation à 3 couches + mémoire persistante + commandes de session. La landing page est jetable ; le harnais, lui, est réplicable sur *tous* tes futurs projets, et celui des autres.

Vois l'upside : ce que tu bâtis est un **substrat cognitif réutilisable**. Graphify + memory + wiki + /catchup forment un format de contexte portable. Le vrai gain n'est pas « 20 % de productivité » — c'est que la connaissance d'un projet cesse de mourir à la fin de chaque session. Tu attaques le coût marginal le plus cher du dev assisté par IA : ré-expliquer le contexte. Résous-le proprement une fois, et tu détiens un actif qui compose sur la durée.

Adjacences sous-évaluées :
- **Onboarding humain** : `/catchup` + wiki = la doc qui se maintient seule. Un nouveau dev (ou un client) entre par la même porte que l'agent.
- **Multi-agent** : un graphe + une mémoire partagés, c'est l'infra pour faire tourner plusieurs agents en parallèle sans qu'ils se marchent dessus. Tu as déjà la couche d'état commune.
- **Effet réseau de format** : si tes wikis/graphes deviennent ta convention par défaut, chaque projet enrichit ta méthode. Tu te construis un avantage cumulatif que personne ne peut copier-coller.

Quand c'est pertinent : projets longs, repris en pointillé, multi-sessions — exactement ton cas. Le seul vrai gâchis serait de traiter ça comme un accessoire d'Atlas au lieu de le durcir en produit autonome. Sors le harnais du repo, versionne-le seul, teste-le sur un 2e projet cette semaine. L'asymétrie est énorme : downside = quelques heures ; upside = ton multiplicateur sur dix ans de projets.

### L'Outsider

Sans contexte produit, voici ce que je vois quand je regarde Atlas de l'extérieur : **une landing page**. Un seul écran, peut-être deux. Du HTML, du CSS, quelques composants React. C'est un projet qu'un dev livre en deux ou trois jours.

Et autour, il y a : un graphe de code, trois couches de contexte, une couche wiki de synthèse, des fichiers mémoire à quatre catégories (décisions, journal, learnings, todo), deux commandes de session, un symlink vers Obsidian. La machinerie pèse manifestement plus lourd que la chose qu'elle pilote.

Voilà mon angle, et personne d'autre ne vous le dira aussi crûment : **vous avez confondu le banc d'essai avec le produit.** Vous dites qu'Atlas « sert de banc d'essai au pattern ». Mais un banc d'essai n'a de valeur que s'il teste le pattern dans des conditions réalistes. Or une landing page ne génère jamais le problème que toute cette mémoire est censée résoudre. Le problème — perdre le contexte, l'avancement, le pourquoi des décisions — n'apparaît que sur les gros projets longs, à plusieurs intervenants, sur des mois. Vous testez un airbag sur un vélo.

Conséquence : vous ne saurez jamais si le système marche. Il ne sera jamais sous tension. Tout « fonctionnera » parce que rien ne le sollicite vraiment. C'est le piège : un outillage qui se valide lui-même par l'absence de friction, pas par la résolution d'une vraie douleur.

Deux questions simples, sans jargon :
1. Sur ce projet précis, qu'est-ce que vous auriez oublié sans cette mémoire ? Si la réponse est « rien », vous avez votre verdict.
2. Si demain vous deviez livrer la landing page à un client, combien de cette machinerie toucherait-il ? S'il s'en moque, c'est un loisir, pas de l'outillage — ce qui est légitime, mais nommez-le honnêtement.

Le pattern est bon. Le banc d'essai est trop petit pour le prouver.

### L'Exécutant

Les agents pilotes de projet, c'est défendable. Ton banc d'essai Atlas, non — pas dans sa forme actuelle.

Test concret : qu'est-ce que tu fais lundi matin ? Sur Atlas, la réponse honnête c'est « je maintiens du contexte ». Mais Atlas est une landing page. Le code tient dans ta tête. Tu as construit un système 3 couches + wiki + `/catchup` + `/save` pour un projet qui n'a aucun problème de contexte. Tu testes la solution sur un cas où le problème n'existe pas — donc tu ne peux RIEN apprendre de réel. Le pipeline « marchera » toujours, parce que rien ne le stresse.

Ce qui se passe réellement : tu as deux projets. La landing page (qui n'avance pas) et l'outillage agentique (qui avance). Regarde ton git log — `/save` méta, commandes de raisonnement, init graphify. Combien de commits touchent le produit ? C'est le signe classique : l'outil est devenu le projet.

Quand c'est pertinent : projet réel, multi-mois, plusieurs intervenants, où redonner le contexte coûte cher à chaque reprise. Là, `/catchup` paie. Quand c'est un piège : maintenant, chez toi.

Ce que tu fais lundi : 1) gèle l'outillage, zéro nouvelle couche. 2) Finis la landing page jusqu'à la mise en ligne, en utilisant Atlas tel quel. 3) Note chaque fois que le système t'aide RÉELLEMENT vs chaque fois que tu le nourris pour rien. 4) Au bout d'un projet fini, tu sauras — preuve à l'usage, pas par construction.

Verdict : le pattern est bon, ton instrumentation est prématurée. Un système de mémoire ne se valide que sur un projet assez gros pour avoir besoin de mémoire. Trouve ce projet, ou réduis Atlas à `/save` seul et expédie-le.

---

## Revues par les pairs

### Revue 1
1. **La plus forte : D.** Seule à recadrer proprement le problème : le pilotage n'est pas le goulot sur un projet solo ; la perte de contexte inter-session l'est. Critère discriminant le plus actionnable : par brique, réduit-elle l'entropie à gérer ou en ajoute-t-elle ?
2. **Plus gros angle mort : A.** Veut « durcir le harnais en produit autonome » et le tester sur un 2e projet sans avoir prouvé qu'il marche sur le 1er. Industrialiser un outil non validé compose le risque.
3. **Raté collectif : le coût de maintenance du harnais lui-même.** Personne ne chiffre l'entropie ajoutée par les couches qui doivent rester synchronisées avec le code. Pas de métrique de vérité (fraîcheur, divergence wiki/code) ni de critère de retrait d'une couche devenue passif.

### Revue 2
1. **La plus forte : D.** Seule à recadrer au bon niveau ; distinction agent-mémoire vs agent-décision opératoire ; test « par brique » branché sur l'architecture réelle.
2. **Plus gros angle mort : A.** Vend le « substrat réutilisable » sans demander si le harnais marche. L'« effet réseau de format » rationalise le plaisir d'outiller.
3. **Raté collectif.** Aucune métrique (tokens/session, temps de re-entrée, taux de wiki périmé). Surtout : l'évaluateur EST l'agent jugé — l'outillage se juge lui-même. Coût de maintenance non traité.

### Revue 3
1. **La plus forte : D.** Requalifie le problème ; clivage agent-mémoire / agent-décision actionnable ; nomme le goulot (re-rentrée) et le piège affectif.
2. **Plus gros angle mort : A.** Saute à « le harnais est le produit, sors-le » sans tester. Cas le plus exposé au théâtre, vendu comme asymétrie favorable.
3. **Raté collectif.** Coût de maintenance comme dette. Et : faut-il un banc *réaliste mais jetable* (projet moyen multi-séances) plutôt que débattre landing vs outillage ? Le bon test : frotter à un projet assez gros sans le sanctuariser.

### Revue 4
1. **La plus forte : D.** Attaque le cadrage ; distinction agent-mémoire / agent-décision = outil conceptuel le plus tranchant. C et E touchent la même cible mais s'arrêtent au diagnostic.
2. **Plus gros angle mort : A.** Suppose la valeur déjà prouvée. Extraire/versionner un outil non validé = instrumentation prématurée. Confond activité et validation.
3. **Raté collectif.** Personne ne pose le coût marginal honnête : combien l'outillage a coûté vs économisé, mesuré ? Raisonnements par analogie sans le chiffre qui trancherait.

### Revue 5
1. **La plus forte : D.** Reformule au lieu de répondre ; critère opérationnel durable ; valide le primitif (mémoire) en pointant le vrai risque. B et C fortes sur « retire la moitié », mais D fournit le pourquoi du test.
2. **Plus gros angle mort : A.** Déclare le harnais « le vrai produit » et pousse à l'extraire sans test de valeur. Confond ambition et validation.
3. **Raté collectif.** Les cinq jugent sur l'axe productivité. Aucun ne traite le banc comme un *projet d'apprentissage* dont le livrable est le savoir-faire (auquel cas la « disproportion » est le but). Coût d'entretien composé non chiffré.

---

## Verdict du Chairman

### Là où le council est d'accord
- **Le pattern est bon ; l'instrumentation actuelle est prématurée.** 4 conseillers sur 5 (Contrarian, Exécutant, Outsider, Premiers Principes) convergent : la *gestion de contexte / mémoire persistante* attaque un vrai problème, mais une landing page ne le génère pas.
- **Le vrai goulot d'un projet solo n'est pas le « pilotage » mais la perte de contexte entre sessions.** La mémoire et la resituation (`/catchup`, `/save`, `memory/`) sont la partie qui paie ; l'orchestration/décision déléguée est celle qui ajoute de l'indirection.
- **Le test décisif est empirique, pas argumentatif.** « Retire la moitié de l'outillage » (Contrarian) / « note les aides réelles vs le nourrissage » (Exécutant) / « qu'aurais-tu oublié sans la mémoire ? » (Outsider) sont trois formulations du même test à l'usage.

### Là où le council se déchire
- **Que faire du harnais maintenant.** L'Expansionniste veut l'extraire, le versionner seul et l'industrialiser tout de suite (upside décennal). Les 4 autres — et les 5 revues à l'unanimité — disent : tu ne l'as jamais validé, généraliser avant la preuve compose le risque. Désaccord réel parce qu'il oppose deux paris : « l'asymétrie risque/gain justifie d'investir tôt » contre « valide d'abord sur un cas qui sollicite vraiment l'outil ».
- **Faut-il finir la landing page ou changer de banc d'essai.** L'Exécutant dit : finis Atlas tel quel, juge ensuite. L'Outsider et une partie des revues disent : la landing ne sollicitera jamais l'outil, prends plutôt un projet *réaliste mais jetable* (moyen, multi-séances).

### Angles morts attrapés par la revue
- **Le coût de maintenance du harnais est une dette non chiffrée.** Graphe + `memory/` + wiki doivent rester synchrones avec le code à chaque session. Le « pourrissement silencieux » (Contrarian) est constaté mais jamais mesuré. Il manque une métrique de vérité (fraîcheur, divergence wiki↔code) et un critère pour *retirer* une couche devenue passif.
- **L'outil se juge lui-même.** Ce council tourne *dans* Atlas : l'instrumentation valide sa propre existence par absence de friction. Aucune métrique externe (tokens/session, temps de re-entrée) n'existe pour trancher mode vs levier.
- **Le cadrage « productivité » écrase un cadrage légitime : l'apprentissage.** Si le livrable réel est le savoir-faire (apprendre Claude Code + le pattern), alors la « disproportion » outillage/produit est le but, pas un défaut — à condition de le nommer honnêtement.

### La recommandation
**Garde la couche mémoire, gèle le reste, et change de banc d'essai — sans encore industrialiser.**

Le council est net : la mémoire/gestion de contexte (`/catchup`, `/save`, `memory/`) est un primitif qui réduit l'entropie — c'est l'acquis, garde-le. Mais Atlas (landing page) ne pourra jamais prouver la valeur du harnais : le problème n'y existe pas. Donc ni l'extraction prématurée prônée par l'Expansionniste (généraliser avant la preuve), ni l'acharnement à finir la landing (l'Exécutant a raison qu'il faut un cas réel, mais Atlas n'en est pas un). La synthèse : applique la règle premier-principe de D à *chaque* brique — celles qui réduisent l'entropie que tu gères restent, celles qui en ajoutent (wiki, graphe sur un projet trivial, toute orchestration) passent en pause — puis frotte la couche mémoire à un projet assez gros pour générer le besoin. Et instrumente la preuve : une seule métrique simple (« cette session, le contexte rechargé m'a-t-il fait gagner ou perdre du temps ? ») vaut mieux que dix débats.

### La première chose à faire
Sur ton prochain projet **réel et non-trivial** (pas Atlas), utilise **uniquement** `/catchup` + `/save` + `memory/` pendant une semaine, et tiens un compteur en une ligne par session : *« recharge de contexte = gain ou perte de temps ? »*. Au bout de la semaine, tu auras la preuve à l'usage — pas par construction — de ce qui mérite d'être durci, et de ce qui était du théâtre.
