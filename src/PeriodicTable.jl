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
    cpk_hex::String
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
          cpk_hex::AbstractString="",
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
    Element(name, appearance, atomic_mass, boil, category, color, cpk_hex, density,
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

_clrs = Dict(
    "diatomic nonmetal" => ("#e2eeff", "#0060f0"),
    "noble gas" => ("#ffe7eb", "#cd1d5e"),
    "alkali metal" => ("#d8f8ff", "#00758c"),
    "alkaline earth metal" => ("#ffe7e7", "#d60024"),
    "metalloid" => ("#fef7e0", "#945700"),
    "polyatomic nonmetal" => ("#e2eeff", "#0060f0"),
    "post-transition metal" => ("#d6f9e8", "#227754"),
    "transition metal" => ("#f3e8fd", "#6232ec"),
    "lanthanide" => ("#dff3ff", "#003355"),
    "actinide" => ("#ffe6d4", "#c73200"),
    "unknown, probably transition metal" => ("#e7e7ea", "#3f374f"),
    "unknown, probably post-transition metal" => ("#e7e7ea", "#3f374f"),
    "unknown, probably metalloid" => ("#e7e7ea", "#3f374f"),
    "unknown, predicted to be noble gas" => ("#e7e7ea", "#3f374f"),
    "unknown, but predicted to be an alkali metal" => ("#e7e7ea", "#3f374f"),
)

function _fill_element_data(el::Element)
    clr = _clrs[el.category]
    return """
    <td class="element" style="background-color:$(clr[1]);color:$(clr[2]);">
        <div class="top">
            <div>$(el.number)</div>
            <div>$(round(el.atomic_mass.val; digits=3))</div>
        </div>
        <div class="symbol">$(el.symbol)</div>
        <div>$(el.name)</div>
    </td>
    """
end

# rich html periodic table
function Base.show(io::IO, ::MIME"text/html", e::PeriodicTable.Elements)
    table = fill("<td></td>\n", 10, 18)
    for el in e
        table[el.ypos, el.xpos] = _fill_element_data(el)
    end
    print(
        io,
        """
<table style="width:100%;empty-cells:hide;border:0px;background-color:#ffffff">
        <style>
            .element {
                border: 5px solid #ffffff;
                min-width: 100px;
                height: 100%;
                text-align: center;
                font-size: 10px;
                border-radius: 10px;
                border-collapse: collapse;
            }
            .top {
                display: flex;
                justify-content: space-between;
            }

            .symbol {
                text-align: center;
                font-weight: bold;
                # font-size: 5px;
            }
        </style>
"""
    )
    s = size(table)
    for i = 1:s[1]
        println(io, "\n<tr>")
        for j = 1:s[2]
            print(io, table[i, j])
        end
        print(io, "</tr>")
    end
    print(io, "\n</table>")
end

# For Vscode
function Base.show(io::IO, ::MIME"juliavscode/html", e::PeriodicTable.Elements)
    show(io, MIME"text/html"(), e)
end

# Since Element equality is determined by atomic number alone...
Base.:(==)(elm1::Element, elm2::Element) = elm1.number == elm2.number

# There is no need to use all the data in Element to calculated the hash
# since Element equality is determined by atomic number alone.
Base.hash(elm::Element, h::UInt) = hash(elm.number, h)

# Compare elements by atomic number to produce the most common way elements
# are sorted.
Base.isless(elm1::Element, elm2::Element) = elm1.number < elm2.number

# Provide a simple way to iterate over all elements.
Base.eachindex(elms::Elements) = eachindex(elms.data)

include("elements.jl")
const elements = Elements(_elements_data)

end
