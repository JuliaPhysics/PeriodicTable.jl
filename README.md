[![Build Status](https://travis-ci.org/rahulkp220/PeriodicTable.jl.svg?branch=master)](https://travis-ci.org/rahulkp220/PeriodicTable.jl)
[![codecov.io](http://codecov.io/github/rahulkp220/PeriodicTable.jl/coverage.svg?branch=master)](http://codecov.io/github/rahulkp220/PeriodicTable.jl?branch=master)

# PeriodicTable.jl
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
PeriodicTable.jl provides a Julia interface to a small database of element
properties for all of the elements in the periodic table.    In particular
```jl
using PeriodicTable
```
exports a global variable called `elements`, which is a collection of
`Element` data structures.  You can look up elements by name (case-insensitive)
via `elements["oxygen"]`, by symbol via `elements[:O]`, or by number via
`elements[8]`, for example.

Each element has fields `name`, `appearance`, `atomic_mass`, `boil`, `category`, `color`, `density`, `discovered_by`, `melt`, `molar_heat`, `named_by`, `number`, `period`, `phase`, `source`, `spectral_img`, `summary`, `symbol`, `xpos`, `ypos`, `shells`.

This data is pretty-printed when you look up an element in the Julia REPL.
For example:
```jl
julia> elements["oxygen"]
Oxygen (O), number 8:
        category: diatomic nonmetal
     atomic mass: 15.999 u
         density: 1.429 g/cm³
   melting point: 54.36 K
   boiling point: 90.188 K
           phase: Gas
          shells: [2, 6]
         summary: Oxygen is a chemical element with symbol O and atomic number 8. It is a member of the chalcogen group on the periodic table and is a highly reactive nonmetal and oxidizing agent that readily forms compounds (notably oxides) with most elements. By mass, oxygen is the third-most abundant element in the universe, after hydrogen and helium.
   discovered by: Carl Wilhelm Scheele
        named by: Antoine Lavoisier
          source: https://en.wikipedia.org/wiki/Oxygen
  spectral image: https://en.wikipedia.org/wiki/File:Oxygen_spectre.jpg
```

### View the Periodic Table!
This awesome view was added by [Jacob Wikmark](https://github.com/lancebeet) via [#4](https://github.com/rahulkp220/PeriodicTable.jl/pull/4)
```julia

# Initialise the object
julia> p = PeriodicTable.PT()
H                                                  He
Li Be                               B  C  N  O  F  Ne
Na Mg                               Al Si P  S  Cl Ar
K  Ca Sc Ti V  Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr
Rb Sr Y  Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I  Xe
Cs Ba    Hf Ta W  Re Os Ir Pt Au Hg Tl Pb Bi Po At Rn
Fr Ra    Rf Db Sg Bh Hs Mt Ds Rg Cn Nh Fl Mc Lv Ts Og
Uue                                                   
      La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu    
      Ac Th Pa U  Np Pu Am Cm Bk Cf Es Fm Md No Lr  
```

## Data by
* [Periodic-Table-JSON](https://github.com/Bowserinator/Periodic-Table-JSON)

## Facing issues? :scream:
* Open a PR with the detailed expaination of the issue
* Reach me out [here](https://www.rahullakhanpal.in)
