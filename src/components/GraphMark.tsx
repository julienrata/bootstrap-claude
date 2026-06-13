/**
 * GraphMark — l'élément signature de la page.
 * Une petite constellation de nœuds reliés, en clin d'œil au knowledge graph
 * que Graphify construit à partir du code. Trois nœuds sont mis en avant :
 * les artefacts mémoire du projet (graph.json, DECISIONS, JOURNAL).
 */

type Node = {
  id: string;
  x: number;
  y: number;
  label?: string;
  accent?: boolean;
};

const NODES: Node[] = [
  { id: "graph", x: 150, y: 90, label: "graph.json", accent: true },
  { id: "dec", x: 250, y: 175, label: "DECISIONS", accent: true },
  { id: "jrn", x: 95, y: 215, label: "JOURNAL", accent: true },
  { id: "a", x: 60, y: 120 },
  { id: "b", x: 215, y: 60 },
  { id: "c", x: 285, y: 95 },
  { id: "d", x: 175, y: 250 },
  { id: "e", x: 35, y: 175 },
];

const EDGES: [string, string][] = [
  ["graph", "dec"],
  ["graph", "jrn"],
  ["graph", "a"],
  ["graph", "b"],
  ["graph", "c"],
  ["dec", "c"],
  ["dec", "d"],
  ["jrn", "e"],
  ["jrn", "d"],
  ["a", "e"],
];

const byId = (id: string) => NODES.find((n) => n.id === id)!;

export default function GraphMark() {
  return (
    <svg
      className="graph-mark"
      viewBox="0 0 320 300"
      role="img"
      aria-label="Constellation de nœuds reliés représentant un knowledge graph"
    >
      <g>
        {EDGES.map(([from, to]) => {
          const a = byId(from);
          const b = byId(to);
          return (
            <line
              key={`${from}-${to}`}
              className="graph-edge"
              x1={a.x}
              y1={a.y}
              x2={b.x}
              y2={b.y}
            />
          );
        })}
      </g>
      <g>
        {NODES.map((n) => (
          <g
            key={n.id}
            className={`graph-node${n.accent ? " is-accent" : ""}`}
          >
            <circle cx={n.x} cy={n.y} r={n.accent ? 9 : 5} />
            {n.label && (
              <text x={n.x + 14} y={n.y + 4}>
                {n.label}
              </text>
            )}
          </g>
        ))}
      </g>
    </svg>
  );
}
