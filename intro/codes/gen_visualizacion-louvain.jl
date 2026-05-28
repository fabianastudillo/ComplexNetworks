using Graphs, GraphPlot, Compose, Colors, Statistics, GraphCommunities

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

println("Cargando grafo...")
g = load_edgelist("facebook_combined.txt")
println("Nodos: ", nv(g), "  Aristas: ", ne(g))

# --- Detectar comunidades con Louvain (con cache en data.txt) ---
const COMMUNITIES_CACHE = "data.txt"

function save_communities(filename::String, dict::Dict{Int,Int})
    open(filename, "w") do io
        entries = ["$k => $v" for (k, v) in dict]
        print(io, join(entries, ", "))
    end
end

function load_communities(filename::String)
    dict = Dict{Int,Int}()
    content = read(filename, String)
    for entry in split(content, ',')
        entry = strip(entry)
        isempty(entry) && continue
        parts = split(entry, "=>")
        length(parts) >= 2 || continue
        k = parse(Int, strip(parts[1]))
        v = parse(Int, strip(parts[2]))
        dict[k] = v
    end
    return dict
end

if isfile(COMMUNITIES_CACHE)
    println("Cargando comunidades desde $COMMUNITIES_CACHE...")
    communities_dict = load_communities(COMMUNITIES_CACHE)
else
    println("Detectando comunidades con Louvain...")
    communities_dict = compute(Louvain(), g)
    save_communities(COMMUNITIES_CACHE, communities_dict)
    println("  -> $COMMUNITIES_CACHE generado")
end

communities = [communities_dict[i] for i in 1:nv(g)]

println("Comunidades detectadas por nodo: ", communities_dict)
println("Modularidad: $(graph_modularity(g, communities_dict))")

# --- Degree distribution CSV ---
println("Generando distribucion de grado...")
degs = degree(g)
deg_counts = Dict{Int,Int}()
for d in degs
    deg_counts[d] = get(deg_counts, d, 0) + 1
end
sorted_degs = sort(collect(deg_counts), by=x->x[1])
open("degree_distribution.csv", "w") do io
    println(io, "degree,count")
    for (d, c) in sorted_degs
        println(io, d, ",", c)
    end
end
println("  -> degree_distribution.csv generado")

# --- Visualizacion ---
println("Calculando layout spring (esto tarda)...")
deg_cent = degree_centrality(g)

# Node sizes proportional to degree
max_deg = maximum(degs)
min_deg = minimum(degs)
node_sizes = [0.2 + 1.8 * (d - min_deg) / (max_deg - min_deg) for d in degs]

# Colors by degree centrality: blue tones with RGBA
max_cent = maximum(deg_cent)
min_cent = minimum(deg_cent)
node_colors = [RGBA(0.1, 0.2 + 0.6 * (c - min_cent) / (max_cent - min_cent), 0.9, 0.7) for c in deg_cent]

# Edge color: very transparent
edge_color = RGBA(0.4, 0.4, 0.4, 0.05)

println("Generando visualizacion PDF...")
p = gplot(g,
    nodefillc=node_colors,
    nodesize=node_sizes,
    edgestrokec=edge_color,
    NODESIZE=0.02,
    EDGELINEWIDTH=0.3
)

draw(SVG("facebook_network.svg", 20cm, 20cm), p)
println("  -> facebook_network.svg generado")
println("Convirtiendo a PDF con inkscape...")
run(`inkscape facebook_network.svg --export-type=pdf --export-filename=facebook_network.pdf`)
println("  -> facebook_network.pdf generado")
println("Listo!")
