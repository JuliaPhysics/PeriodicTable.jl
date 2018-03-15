__precompile__(true)

"""
The PeriodicTable module exports an `elements` variable that stores
data (of type `Element`) on every element in the periodic table.

The data can be looked up by atomic number via `elements[n]`, by name
(case-insensitive) via e.g. `elements["oxygen"]`, or by symbol via
e.g. `elements[:O]`.
"""
module PeriodicTable
export Element, elements

"""
Element composite type
"""
mutable struct Element
    name::String
    appearance::String
    atomic_mass::Float64
    boil::Float64
    category::String
    color::String
    density::Float64
    discovered_by::String
    melt::Float64
    molar_heat::Float64
    named_by::String
    number::Int
    period::Int
    phase::String
    source::String # url
    spectral_img::String # url
    summary::String
    symbol::String
    xpos::Int
    ypos::Int
    shells::Vector{Int}
end

Element(; name::AbstractString="",
          appearance::AbstractString="",
          atomic_mass::Real=NaN,
          boil::Real=NaN,
          category::AbstractString="",
          color::AbstractString="",
          density::Real=NaN,
          discovered_by::AbstractString="",
          melt::Real=NaN,
          molar_heat::Real=NaN,
          named_by::AbstractString="",
          number::Integer=-1,
          period::Integer=-1,
          phase::AbstractString="",
          source::AbstractString="",
          spectral_img::AbstractString="",
          summary::AbstractString="",
          symbol::AbstractString="",
          xpos::Integer=-1,
          ypos::Integer=-1,
          shells::AbstractVector{<:Integer}=Int[]) =
    Element(name, appearance, atomic_mass, boil, category, color, density,
        discovered_by, melt, molar_heat, named_by, number, period, phase,
        source, spectral_img, summary, symbol, xpos, ypos, shells)

Base.show(io::IO, el::Element) = print(io, "Element(", el.name, ')')

ispresent(s) = !isempty(s)
ispresent(x::Float64) = !isnan(x)
ispresent(n::Int) = n ≥ 0
function printpresent(io::IO, name, val, suffix=""; pad=16)
    if ispresent(val)
        println(io, lpad(name, pad), ": ", val, suffix)
    end
end

function Base.show(io::IO, ::MIME"text/plain", el::Element)
    println(io, el.name, " (", el.symbol, "), number ", el.number, ':')
    printpresent(io, "category", el.category)
    printpresent(io, "atomic mass", el.atomic_mass, " u")
    printpresent(io, "density", el.density, " g/cm³")
    printpresent(io, "molar heat", el.molar_heat, " J/mol⋅K")
    printpresent(io, "melting point", el.melt, " K")
    printpresent(io, "boiling point", el.boil, " K")
    printpresent(io, "phase", el.phase)
    printpresent(io, "shells", el.shells)
    printpresent(io, "appearance", el.appearance)
    printpresent(io, "color", el.color)
    printpresent(io, "summary", el.summary)
    printpresent(io, "discovered by", el.discovered_by)
    printpresent(io, "named by", el.named_by)
    printpresent(io, "source", el.source)
    printpresent(io, "spectral image", el.spectral_img)
end

"""
Elements composite type
"""
struct Elements
    data::Vector{Element}
    bynumber::Dict{Int,Element}
    byname::Dict{String,Element}
    bysymbol::Dict{Symbol,Element}
    Elements(data::Vector{Element}) = new(
        sort!(data, by=d->d.number),
        Dict{Int,Element}(d.number=>d for d in data),
        Dict{String,Element}(lowercase(d.name)=>d for d in data),
        Dict{Symbol,Element}(Symbol(d.symbol)=>d for d in data))
end
Base.getindex(e::Elements, i::Integer) = e.bynumber[i]
Base.getindex(e::Elements, i::AbstractString) = e.byname[lowercase(i)]
Base.getindex(e::Elements, i::Symbol) = e.bysymbol[i]
Base.getindex(e::Elements, v::AbstractVector) = Element[e[i] for i in v]
Base.haskey(e::Elements, i::Integer) = haskey(e.bynumber, i)
Base.haskey(e::Elements, i::AbstractString) = haskey(e.byname, lowercase(i))
Base.haskey(e::Elements, i::Symbol) = haskey(e.bysymbol, i)
Base.get(e::Elements, i::Integer, default) = get(e.bynumber, i, default)
Base.get(e::Elements, i::AbstractString, default) = get(e.byname, lowercase(i), default)
Base.get(e::Elements, i::Symbol, default) = get(e.bysymbol, i, default)

# support iterating over elements
Base.eltype(e::Elements) = Element
Base.length(e::Elements) = length(e.data)
Base.start(e::Elements) = start(e.data)
Base.next(e::Elements, i) = next(e.data, i)
Base.done(e::Elements, i) = done(e.data, i)

# compact one-line printing
Base.show(io::IO, e::Elements) = print(io, "Elements(…", length(e), " elements…)")

# pretty-printing as a periodic table
function Base.show(io::IO, ::MIME"text/plain", e::Elements)
    println(io, e, ':')
    table = fill("   ", 10,18)
    for el in e
        table[el.ypos, el.xpos] = rpad(el.symbol, 3)
    end
    for i = 1:size(table,1)
        for j = 1:size(table, 2)
            print(io, table[i,j])
        end
        println(io)
    end
end

include("elements.jl")
const elements = Elements(_elements_data)

end
