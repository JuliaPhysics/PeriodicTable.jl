"""
Isotope Composite Type
"""
struct Isotope
	name::String
	symbol::String
	atomic_number::Int
	mass_number::Int
	abundance::Float64
	mass::typeof(1.0u)
	mass_uncertainty::typeof(1.0u)
	spin::Rational{Int}
	gfactor::Float64
	quadrupole_moment::typeof(1.0b)
	is_radioactive::Bool
	half_life::typeof(1.0s)
	half_life_uncertainty::typeof(1.0s)
end

Base.show(io::IO, istp::Isotope) = print(io, "Isotope(", istp.name, ", ",istp.mass_number, ')')

function Base.show(io::IO, ::MIME"text/plain", istp::Isotope)
	println(io, istp.name, ' ', istp.atomic_number, istp.symbol, istp.mass_number,':')
	printpresent(io, "atomic number", istp.atomic_number; pad=28)
	printpresent(io, "mass number", istp.mass_number; pad=28)
	printpresent(io, "natural abundance", istp.abundance; pad=28)
	printpresent(io, "mass", istp.mass, " u"; pad=28)
	printpresent(io, "mass uncertainty", istp.mass_uncertainty, " u"; pad=28)
	printpresent(io, "spin", istp.spin; pad=28)
	printpresent(io, "g-factor", istp.gfactor; pad=28)
	printpresent(io, "electric quadrupole moment", istp.quadrupole_moment, " barn"; pad=28)
	printpresent(io, "is radioactive", istp.is_radioactive; pad=28)
	printpresent(io, "half-life", istp.half_life, " s"; pad=28)
	printpresent(io, "half_life uncertainty", istp.half_life_uncertainty; pad=28)
end

"""
Isotopes composite type
"""
struct Isotopes
	data::Vector{Isotope}
	bynumber::Dict{NTuple{2,Int}, Isotope}
	byname::Dict{String, Isotope}
	bysymbol::Dict{Symbol, Isotope}
	byelement::Dict{Symbol, Vector{Isotope}}
	function Isotopes(data::Vector{Isotope})
		sort!(data, by = istp->(istp.atomic_number,istp.mass_number))
		bynumber = Dict{NTuple{2,Int},Isotope}((istp.atomic_number,istp.mass_number)=>istp for istp in data)
		byname = Dict{String,Isotope}(string(istp.name,istp.mass_number)=>istp for istp in data)
		bysymbol = Dict{Symbol,Isotope}(Symbol(istp.symbol,istp.mass_number)=>istp for istp in data)
		byelement = Dict{Symbol,Vector{Isotope}}()
		for istp in data
			s = Symbol(istp.symbol)
			if haskey(byelement, s)
				push!(byelement[s], istp)
			else
				byelement[s] = [istp,]
			end
		end
		new(data, bynumber, byname, bysymbol, byelement)
	end
end

# Indexing stuff

Base.getindex(i::Isotopes, atomic_number::Int, mass_number::Int)= i.bynumber[(atomic_number, mass_number)]

Base.getindex(i::Isotopes, full_name::AbstractString) = i.byname[full_name |> lowercase]
Base.getindex(i::Isotopes, name::AbstractString, mass_number::Int) = i.byname[string(name|>lowercase, mass_number)]

Base.getindex(i::Isotopes, full_symbol::Symbol) = i.bysymbol[full_symbol]
Base.getindex(i::Isotopes, symbol::Symbol, mass_number::Int) = i.bysymbol[Symbol(symbol, mass_number)]

Base.getindex(i::Isotopes, el::Element) = i.byelement[Symbol(el.symbol)]
Base.getindex(e::Elements, istp::Isotope) = elements[Symbol(istp.symbol)]

Base.haskey(i::Isotopes, atomic_numer::Int, mass_number::Int) = haskey(i.bynumber, (atomic_number, mass_number))
Base.haskey(i::Isotopes, full_name::AbstractString) = haskey(i.byname, full_name|>lowercase)
Base.haskey(i::Isotopes, name::AbstractString, mass_number::Int) = haskey(i.byname, string(name|>lowercase, mass_number))
Base.haskey(i::Isotopes, full_symbol::Symbol) = haskey(i.bysymbol, full_symbol)
Base.haskey(i::Isotopes, symbol::Symbol, mass_number::Int) = haskey(i.bysymbol, Symbol(symbol, mass_number))

# Comparison stuff

get_numtuple(istp::Isotope) = (istp.atomic_number, istp.mass_number)

Base.isequal(istp1::Isotope, istp2::Isotope) = get_numtuple(istp1)==get_numtuple(istp2)
Base.isless(istp1::Isotope, istp2::Isotope) = isless(get_numtuple(istp1), get_numtuple(istp2))
