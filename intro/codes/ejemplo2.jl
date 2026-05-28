# Ejemplo básico
using Graphs, GraphPlot, Compose

# Crear un grafo no dirigido
g = SimpleDiGraph(5)  # Grafo con 5 vértices

println("Grafo Dirigido")

# Añadir aristas
add_edge!(g, 1, 2)
add_edge!(g, 1, 3)
add_edge!(g, 2, 4)
add_edge!(g, 3, 5)

# Obtener matriz de adyacencia
A = adjacency_matrix(g)
display(Matrix(A))

# Exportar a formato Pajek NET
function export_pajek_net(grafo, filename)
    open(filename, "w") do io
        nv_ = nv(grafo)
        println(io, "*Vertices $nv_")
        for i in 1:nv_
            println(io, "$(i) \"$(i)\"")
        end
        if isa(grafo, SimpleDiGraph)
            println(io, "*Arcs")
        else
            println(io, "*Edges")
        end
        for e in edges(grafo)
            println(io, "$(src(e)) $(dst(e))")
        end
    end
end

# Exportar grafo dirigido
export_pajek_net(g, "grafo_dirigido.net")

println("Grafo no dirigido")

h = SimpleGraph(5)  # Grafo con 5 vértices
add_edge!(h, 1, 2)
add_edge!(h, 1, 3)
add_edge!(h, 2, 4)
add_edge!(h, 3, 5)

B = adjacency_matrix(h)
display(Matrix(B))

# Exportar grafo no dirigido
export_pajek_net(h, "grafo_no_dirigido.net")