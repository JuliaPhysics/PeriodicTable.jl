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

using Compat: replace
import Unitful: u, g, cm, K, J, mol, Quantity

"""
Element composite type
"""
struct Element
    name::String
    appearance::String
    atomic_mass::typeof(1.0u)
    boil::typeof(1.0K)
    category::String
    color::String
    density::typeof(1.0g/cm^3)
    discovered_by::String
    el_config::String
    melt::typeof(1.0K)
    molar_heat::typeof(1.0J/(mol*K))
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
          atomic_mass::typeof(1.0u)=NaN*u,
          boil::typeof(1.0K)=NaN*K,
          category::AbstractString="",
          color::AbstractString="",
          density::typeof(1.0g/cm^3)=NaN*g/cm^3,
          discovered_by::AbstractString="",
          el_config::AbstractString="",
          melt::typeof(1.0K)=NaN*K,
          molar_heat::typeof(1.0J/(mol*K))=NaN*J/(mol*K),
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
        discovered_by, el_config, melt, molar_heat, named_by, number, period, phase,
        source, spectral_img, summary, symbol, xpos, ypos, shells)

Base.show(io::IO, el::Element) = print(io, "Element(", el.name, ')')

ispresent(s) = !isempty(s)
ispresent(x::Union{Float64, Quantity}) = !isnan(x)
ispresent(n::Int) = n ≥ 0
function printpresent(io::IO, name, val, suffix=""; pad=16)
    if ispresent(val)
        println(io, lpad(name, pad), ": ", typeof(val) <: Quantity ? val.val : val, suffix)
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
    printpresent(io, "e⁻-configuration", el.el_config)
    printpresent(io, "appearance", el.appearance)
    printpresent(io, "color", el.color)
    printpresent(io, "summary", el.summary)
    printpresent(io, "discovered by", el.discovered_by)
    printpresent(io, "named by", el.named_by)
    printpresent(io, "source", el.source)
    printpresent(io, "spectral image", el.spectral_img)
end

function printpresenthtml(io::IO, name, val, suffix="")
    if ispresent(val)
        println(io, "<tr><th>", name, "</th><td>", typeof(val) <: Quantity ? val.val : val, suffix, "</td></tr>")
    end
end

function Base.show(io::IO, ::MIME"text/html", el::Element)
    println(io, "<style>")
    println(io, "th{text-align:right; padding:5px;}td{text-align:left; padding:5px}")
    println(io, "</style>")
    println(io, el.name, " (", el.symbol, "), number ", el.number, ':')
    println(io, "<table>")
    printpresenthtml(io, "category", el.category)
    printpresenthtml(io, "atomic mass", el.atomic_mass, " u")
    printpresenthtml(io, "density", el.density, " g/cm³")
    printpresenthtml(io, "molar heat", el.molar_heat, " J/mol⋅K")
    printpresenthtml(io, "melting point", el.melt, " K")
    printpresenthtml(io, "boiling point", el.boil, " K")
    printpresenthtml(io, "phase", el.phase)
    printpresenthtml(io, "shells", el.shells)
    printpresenthtml(io, "electron configuration", el.el_config)
    printpresenthtml(io, "appearance", el.appearance)
    printpresenthtml(io, "color", el.color)
    printpresenthtml(io, "summary", el.summary)
    printpresenthtml(io, "discovered by", el.discovered_by)
    printpresenthtml(io, "named by", el.named_by)

    link = string("<a href=\"", el.source, "\">", el.source, "</a>")
    printpresenthtml(io, "source", link)
    println(io, "</table>")

    if ispresent(el.spectral_img)
        width = 500
        file = replace(el.spectral_img, "https://en.wikipedia.org/wiki/File:" => "")
        #Wikimedia hotlinking api
        wm = "https://commons.wikimedia.org/w/index.php?title=Special:Redirect/file/"
        imgdomain = string(wm, file, "&width=$width")
        println(io, "<img src=\"", imgdomain, "\" alt=\"", file, "\">")
    end
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
if VERSION < v"0.7-"
    Base.start(e::Elements) = start(e.data)
    Base.next(e::Elements, i) = next(e.data, i)
    Base.done(e::Elements, i) = done(e.data, i)
else
    Base.iterate(e::Elements, state...) = iterate(e.data, state...)
end

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
