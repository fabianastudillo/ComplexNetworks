using Graphs, StatsBase, Plots

# --- Cargar edgelist 0-indexado ---
function load_edgelist(filename::String)
    edge_set = Set{Tuple{Int,Int}}()
    max_node = 0
    open(filename, "r") do io
        for line in eachline(io)
            parts = split(strip(line))
            length(parts) >= 2 || continue
            u = parse(Int, parts[1]) + 1
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

# Cargar el dataset de Facebook
println("Cargando grafo...")
g = load_edgelist("facebook_combined.txt")
println("Nodos: ", nv(g), "  Aristas: ", ne(g))

# Calcular distribución de grados
grados = degree(g)
hist = fit(Histogram, grados)
freq = hist.weights

# Filtrar bins vacíos para evitar log(0)
idx = findall(f -> f > 0, freq)
ks = collect(1:length(freq))[idx]
fs = freq[idx]

# Visualizar en escala logarítmica
println("Generando grafico log-log...")
scatter(log.(ks), log.(fs),
        xlabel="log(k)", ylabel="log(P(k))",
        title="Distribución de grados (escala log-log)",
        legend=false,
        markersize=4)

savefig("scale_free_loglog.png")
println("  -> scale_free_loglog.png generado")
println("Listo!")
