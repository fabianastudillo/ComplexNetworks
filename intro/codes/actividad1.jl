using Graphs

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

# --- Cargar grafo ---
g = load_edgelist("facebook_combined.txt")
println("Nodos: ", nv(g), "  Aristas: ", ne(g))

# --- Métricas de centralidad ---
println("\nCalculando centralidad de grado...")
deg_cent = degree_centrality(g)

println("Calculando centralidad de intermediación (puede tardar)...")
bet_cent = betweenness_centrality(g)

println("Calculando centralidad de cercanía...")
clo_cent = closeness_centrality(g)

# --- Top 10 por cada métrica ---
function top_k(values, k=10)
    idx = sortperm(values, rev=true)
    return [(i - 1, values[i]) for i in idx[1:k]]  # mostrar nodo original 0-indexed
end

println("\n=== Top 10 — Centralidad de Grado ===")
for (node, val) in top_k(deg_cent)
    println("  Nodo $node: grado=$(degree(g, node+1)), centralidad=$(round(val, digits=6))")
end

println("\n=== Top 10 — Centralidad de Intermediación ===")
for (node, val) in top_k(bet_cent)
    println("  Nodo $node: centralidad=$(round(val, digits=6))")
end

println("\n=== Top 10 — Centralidad de Cercanía ===")
for (node, val) in top_k(clo_cent)
    println("  Nodo $node: centralidad=$(round(val, digits=6))")
end

# --- Estadísticas generales ---
degs = degree(g)
println("\n=== Estadísticas Generales ===")
println("  Grado promedio: ", round(mean(degs), digits=2))
println("  Grado máximo:   ", maximum(degs))
println("  Grado mínimo:   ", minimum(degs))
println("  Densidad:       ", round(density(g), digits=6))
println("  Componentes:    ", length(connected_components(g)))
