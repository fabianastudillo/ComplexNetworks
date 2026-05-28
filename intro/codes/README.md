# Ejemplos de Grafos en Julia

Este directorio contiene ejemplos de uso de grafos en Julia, incluyendo grafos dirigidos, no dirigidos y ponderados, así como exportación a formatos externos.

## Requisitos

Asegúrate de tener Julia 1.6 o superior y los siguientes paquetes instalados en el entorno del proyecto:

- Graphs
- GraphPlot
- Compose
- LightGraphs
- SimpleWeightedGraphs

Puedes instalar los paquetes ejecutando en el REPL de Julia:

```julia
using Pkg
Pkg.add(["Graphs", "GraphPlot", "Compose", "LightGraphs", "SimpleWeightedGraphs"])
```

## Archivos

- `first.jl`: Grafo simple y exportación a PDF.
- `ejemplo2.jl`: Grafo dirigido y no dirigido, exportación a formato Pajek NET.
- `ejemplo3.jl`: Grafo ponderado y matriz de adyacencia de pesos.

## Ejecución

Ejecuta los ejemplos desde la terminal:

```sh
julia --project=. first.jl
julia --project=. ejemplo2.jl
julia --project=. ejemplo3.jl
```

Los archivos exportados (PDF, .net) se generarán en el mismo directorio.
