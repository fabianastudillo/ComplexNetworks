using Graphs, SimpleWeightedGraphs
using Statistics, GraphCommunities

# --- Cargar edgelist 0-indexado desde archivo ---
function load_edgelist(filename::String)
    edge_set = Set{Tuple{Int,Int}}()
    max_node = 0
    open(filename, "r") do io
        for line in eachline(io)
            parts = split(strip(line))
            length(parts) >= 2 || continue
            u = parse(Int, parts[1]) + 1   # 0-indexed → 1-indexed
            v = parse(Int, parts[2]) + 1
            push!(edge_set, (min(u,v), max(u,v)))
            max_node = max(max_node, u, v)
        end
    end
    g = SimpleGraph(max_node)
    for (u, v) in edge_set
        add_edge!(g, u, v)
    end
    return g
end

# Cargar dataset
g = load_edgelist("facebook_combined.txt")

println("Red cargada: $(nv(g)) nodos, $(ne(g)) aristas")

# Extraer subgrafo de nodos con mayor grado para análisis más rápido
degrees = degree(g)
threshold = quantile(degrees, 0.75)  # Nodos en el 25% superior
high_degree_nodes = findall(d -> d >= threshold, degrees)
subg = induced_subgraph(g, high_degree_nodes)[1]

println("Subgrafo de análisis: $(nv(subg)) nodos, $(ne(subg)) aristas")

# Detectar comunidades usando algoritmo FastLPA (más rápido)
communities_dict = compute(FastLPA(), subg)

println("\nComunidades detectadas: $(number_of_communities(communities_dict))")
println("Modularidad: $(graph_modularity(subg, communities_dict))")