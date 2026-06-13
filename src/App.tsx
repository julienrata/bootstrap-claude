import GraphMark from "./components/GraphMark";

type Step = { key: string; title: string; body: string };

const STEPS: Step[] = [
  {
    key: "/catchup",
    title: "Reprendre",
    body: "L'agent relit le journal et les décisions, puis interroge le graphe. Il sait où vous en êtes sans relire tout le code.",
  },
  {
    key: "build",
    title: "Travailler",
    body: "Features, correctifs, refactors. Le contexte est déjà chargé, donc chaque échange va droit au but.",
  },
  {
    key: "/save",
    title: "Consigner",
    body: "L'agent écrit un log de session, met à jour les décisions et relie les notes. Rien ne se perd entre deux sessions.",
  },
];

export default function App() {
  return (
    <>
      <header className="wrap site-header">
        <span className="brand">
          <span className="brand-dot" aria-hidden="true" />
          Atlas
        </span>
        <nav className="site-nav" aria-label="Principale">
          <a href="#loop">Comment ça marche</a>
          <a href="#start">Démarrer</a>
        </nav>
      </header>

      <main>
        <section className="wrap hero">
          <div>
            <p className="eyebrow reveal">Mémoire persistante pour agents de code</p>
            <h1 className="reveal d1">
              Votre agent oublie tout.
              <br />
              <em>Atlas s'en souvient.</em>
            </h1>
            <p className="reveal d2">
              Décisions, avancement, pièges rencontrés : tout est consigné dans
              des fichiers que l'agent relit à chaque session. Fini la
              réexplication du projet à chaque ouverture.
            </p>
            <div className="cta-row reveal d3">
              <a className="btn btn-primary" href="#start">
                Démarrer
              </a>
              <a className="btn btn-ghost" href="#loop">
                Voir la boucle
              </a>
            </div>
          </div>
          <figure className="graph-figure reveal d2" style={{ margin: 0 }}>
            <GraphMark />
          </figure>
        </section>

        <section className="loop" id="loop">
          <div className="wrap">
            <div className="loop-head">
              <p className="eyebrow">La boucle de session</p>
              <h2>Trois temps, répétés à chaque session de travail.</h2>
            </div>
            <ol className="steps">
              {STEPS.map((s) => (
                <li className="step" key={s.key}>
                  <span className="step-key">{s.key}</span>
                  <h3>{s.title}</h3>
                  <p>{s.body}</p>
                </li>
              ))}
            </ol>
          </div>
        </section>
      </main>

      <footer className="wrap site-footer" id="start">
        <span className="brand">
          <span className="brand-dot" aria-hidden="true" />
          Atlas
        </span>
        <span>Échafaudage Vite + React + TypeScript — à façonner à votre projet.</span>
      </footer>
    </>
  );
}
