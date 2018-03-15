using PeriodicTable
using Base.Test

@test eltype(elements) == Element
@test length(elements) == 119 == length(collect(elements))

# test element lookup
O = elements[8]
F = elements[9]
@test O === elements["oxygen"] == elements[:O]
@test haskey(elements, 8) && haskey(elements, "oxygen") && haskey(elements, :O)
@test !haskey(elements, -8) && !haskey(elements, "ooxygen") && !haskey(elements, :Oops)
@test F === get(elements, 9, O) === get(elements, "oops", F) === get(elements, :F, O)
@test elements[8:9] == [O, F]
@test O.name == "Oxygen"
@test O.symbol == "O"
@test nfields(O) == 21

# 2-argument show functions
@test repr(elements) == "Elements(…119 elements…)"
@test repr([O, F]) == "PeriodicTable.Element[Element(Oxygen), Element(Fluorine)]"

@test stringmime("text/plain", elements) == "Elements(…119 elements…):\nH                                                  He \nLi Be                               B  C  N  O  F  Ne \nNa Mg                               Al Si P  S  Cl Ar \nK  Ca Sc Ti V  Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr \nRb Sr Y  Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I  Xe \nCs Ba    Hf Ta W  Re Os Ir Pt Au Hg Tl Pb Bi Po At Rn \nFr Ra    Rf Db Sg Bh Hs Mt Ds Rg Cn Nh Fl Mc Lv Ts Og \nUue                                                   \n      La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu    \n      Ac Th Pa U  Np Pu Am Cm Bk Cf Es Fm Md No Lr    \n"
@test stringmime("text/plain", O) == "Oxygen (O), number 8:\n        category: diatomic nonmetal\n     atomic mass: 15.999 u\n         density: 1.429 g/cm³\n   melting point: 54.36 K\n   boiling point: 90.188 K\n           phase: Gas\n          shells: [2, 6]\n         summary: Oxygen is a chemical element with symbol O and atomic number 8. It is a member of the chalcogen group on the periodic table and is a highly reactive nonmetal and oxidizing agent that readily forms compounds (notably oxides) with most elements. By mass, oxygen is the third-most abundant element in the universe, after hydrogen and helium.\n   discovered by: Carl Wilhelm Scheele\n        named by: Antoine Lavoisier\n          source: https://en.wikipedia.org/wiki/Oxygen\n  spectral image: https://en.wikipedia.org/wiki/File:Oxygen_spectre.jpg\n"
