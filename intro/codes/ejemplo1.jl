# Ejemplo básico
using Graphs, GraphPlot, Compose

# Crear un grafo no dirigido
g = SimpleGraph(5)  # Grafo con 5 vértices

# Añadir aristas
add_edge!(g, 1, 2)
add_edge!(g, 1, 3)
add_edge!(g, 2, 4)
add_edge!(g, 3, 5)

# Visualizar y exportar a SVG
draw(SVG("grafo.svg", 16cm, 16cm), gplot(g))
