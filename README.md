[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Build Status](https://travis-ci.org/rahulkp220/PeriodicTable.jl.svg?branch=master)](https://travis-ci.org/rahulkp220/PeriodicTable.jl)
[![codecov.io](http://codecov.io/github/rahulkp220/PeriodicTable.jl/coverage.svg?branch=master)](http://codecov.io/github/rahulkp220/PeriodicTable.jl?branch=master)
[![GitHub contributors](https://img.shields.io/github/contributors/rahulkp220/PeriodicTable.jl.svg)](https://github.com/rahulkp220/PeriodicTable.jl/graphs/contributors)
[![GitHub issues](https://img.shields.io/github/issues/rahulkp220/PeriodicTable.jl.svg)](https://github.com/rahulkp220/PeriodicTable.jl/issues/)
[![GitHub version](https://badge.fury.io/gh/rahulkp220%2FPeriodicTable.jl.svg)](https://github.com/rahulkp220/PeriodicTable.jl)

[![ForTheBadge built-with-science](http://ForTheBadge.com/images/badges/built-with-science.svg)](https://github.com/rahulkp220/)


# PeriodicTable.jl
A very simple package for accessing elements in the Periodic Table! :fire:

### Installation
Since PeriodicTable is registered in Julia's [General Registry](https://github.com/JuliaRegistries/General), you can readily install it with
```julia
] add PeriodicTable
```


### Usage
PeriodicTable.jl provides a Julia interface to a small database of element
properties for all of the elements in the periodic table. In particular `PeriodicTable` exports a global variable called `elements`, which is a collection of
`Element` data structures.

```julia
julia> using PeriodicTable

julia> elements
Elements(…119 elements…):
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

You can look up elements by name (case-insensitive)
via `elements["oxygen"]`, by symbol via `elements[:O]`, or by number via
`elements[8]`, for example.

Each element has fields `name`, `appearance`, `atomic_mass`, `boil`, `category`, `color`, `density`, `discovered_by`, `melt`, `molar_heat`, `named_by`, `number`, `period`, `phase`, `source`, `spectral_img`, `summary`, `symbol`, `xpos`, `ypos`, `shells`.

All physical quantities are [unitful](https://github.com/ajkeller34/Unitful.jl).

The data is pretty-printed when you look up an element in the Julia REPL.
For example:
```julia
julia> elements["oxygen"]
Oxygen (O), number 8:
        category: diatomic nonmetal
     atomic mass: 15.999 u
         density: 1.429 g/cm³
   melting point: 54.36 K
   boiling point: 90.188 K
           phase: Gas
          shells: [2, 6]
e⁻-configuration: 1s² 2s² 2p⁴
         summary: Oxygen is a chemical element with symbol O and atomic number 8. It is a member of the chalcogen group on the periodic table and is a highly reactive nonmetal and oxidizing agent that readily forms compounds (notably oxides) with most elements. By mass, oxygen is the third-most abundant element in the universe, after hydrogen and helium.
   discovered by: Carl Wilhelm Scheele
        named by: Antoine Lavoisier
          source: https://en.wikipedia.org/wiki/Oxygen
  spectral image: https://en.wikipedia.org/wiki/File:Oxygen_spectre.jpg
 
```
Alternatively, you may want to get a list of elements,
```julia
julia> elements[1:4]
4-element Array{PeriodicTable.Element,1}:
 Element(Hydrogen) 
 Element(Helium)   
 Element(Lithium)  
 Element(Beryllium)
 ```
 
 A nice interactive visualization of the periodic table, based on PeriodicTable.jl, can be found [here](https://github.com/lancebeet/julia-scripts#periodictabletoyjl).

### Data by
The data used for this package has been pulled up in parts from [here](https://github.com/Bowserinator/Periodic-Table-JSON).
Some information has been (and will be) added over time.

### Developed together with
* [Steven G. Johnson](https://github.com/stevengj)
* [Jacob Wikmark](https://github.com/lancebeet)
* [Carsten Bauer](https://github.com/crstnbr)

### Facing issues? :scream:
* Open a PR with the detailed expaination of the issue
* Reach me out [here](https://www.rahullakhanpal.in)
