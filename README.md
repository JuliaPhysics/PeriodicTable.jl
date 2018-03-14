[![Build Status](https://travis-ci.org/rahulkp220/PeriodicTable.jl.svg?branch=master)](https://travis-ci.org/rahulkp220/PeriodicTable.jl)
[![codecov.io](http://codecov.io/github/rahulkp220/PeriodicTable.jl/coverage.svg?branch=master)](http://codecov.io/github/rahulkp220/PeriodicTable.jl?branch=master)

# PeriodicTable
A very simple package for accessing elements in the Periodic Table! :fire:

## Installation
```julia
julia> Pkg.clone("https://github.com/rahulkp220/PeriodicTable.jl.git")
```

## Update
```julia
julia> Pkg.update("PeriodicTable")
```

## How it works?
PeriodicTable.jl includes a `data.json` file which acts like a database for this small library.
Working with it is very simple, indeed its just 2 steps before you see the actual data.

```julia

# Initialise the object
julia> p = PeriodicTable.PT()

# get the information for any element in the periodic table
# all you need to pass is a ATOMIC NUMBER of the element.
julia> ele = PeriodicTable.get_element(p, 8)

# to get the complete data
julia> ele.data
Dict{String,Any} with 21 entries:
  "number"        => 8
  "appearance"    => ""
  "name"          => "Oxygen"
  "boil"          => 90.188
  "atomic_mass"   => 15.999
  "period"        => 2
  "melt"          => 54.36
  "shells"        => Any[2, 6]
  "summary"       => "Oxygen is a chemical element with symbol O and atomic number 8. It is a member of the chalcogen group on the periodic …
  "molar_heat"    => ""
  "named_by"      => "Antoine Lavoisier"
  "xpos"          => 16
  "symbol"        => "O"
  "discovered_by" => "Carl Wilhelm Scheele"
  "ypos"          => 2
  "category"      => "diatomic nonmetal"
  "density"       => 1.429
  "source"        => "https://en.wikipedia.org/wiki/Oxygen"
  "color"         => ""
  "phase"         => "Gas"
  "spectral_img"  => "https://en.wikipedia.org/wiki/File:Oxygen_spectre.jpg"

# exploring these properties via fieldnames
julia> println("$(ele.name) with mass $(ele.atomic_mass)")
Oxygen with mass 15.999

julia> fieldnames(ele)
22-element Array{Symbol,1}:
 :data         
 :name         
 :appearance   
 :atomic_mass  
 :boil         
 :category     
 :color        
 :density      
 :discovered_by
 :melt         
 :molar_heat   
 :named_by     
 :number       
 :period       
 :phase        
 :source       
 :spectral_img 
 :summary      
 :symbol       
 :xpos         
 :ypos         
 :shells 

```

## Data by
* [Periodic-Table-JSON](https://github.com/Bowserinator/Periodic-Table-JSON)

## Facing issues? :scream:
* Open a PR with the detailed expaination of the issue
* Reach me out [here](https://www.rahullakhanpal.in)
