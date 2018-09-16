using PeriodicTable, Compat, Unitful
import Unitful: u, g, cm, K, J, mol
using Compat.Test
using Compat.Base64

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
@test nfields(O) == 22

# Unitful units
H = elements[1]
@test unit(H.density) === g/cm^3
@test unit(H.boil) === K
@test unit(H.melt) === K
@test unit(H.molar_heat) === J/(mol*K)
@test unit(H.atomic_mass) === u

# iteration protocol
if VERSION < v"0.7-"
    @test start(elements) == 1
    @test next(elements, 1) == (elements[:H], 2)
    @test done(elements, length(elements)+1)
else
    @test iterate(elements) == (elements[:H], 2)
    @test iterate(elements, 4) == (elements[:Be], 5)
    @test iterate(elements, length(elements)+1) == nothing
end

# 2-argument show functions
@test repr(elements) == "Elements(…119 elements…)"
if VERSION < v"0.7-"
    @test repr([O, F]) == "PeriodicTable.Element[Element(Oxygen), Element(Fluorine)]"
else
    @test repr([O, F]) == "Element[Element(Oxygen), Element(Fluorine)]"
end

@test stringmime("text/plain", elements) == "Elements(…119 elements…):\nH                                                  He \nLi Be                               B  C  N  O  F  Ne \nNa Mg                               Al Si P  S  Cl Ar \nK  Ca Sc Ti V  Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr \nRb Sr Y  Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I  Xe \nCs Ba    Hf Ta W  Re Os Ir Pt Au Hg Tl Pb Bi Po At Rn \nFr Ra    Rf Db Sg Bh Hs Mt Ds Rg Cn Nh Fl Mc Lv Ts Og \nUue                                                   \n      La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu    \n      Ac Th Pa U  Np Pu Am Cm Bk Cf Es Fm Md No Lr    \n"
@test stringmime("text/plain", O) == "Oxygen (O), number 8:\n        category: diatomic nonmetal\n     atomic mass: 15.999 u\n         density: 1.429 g/cm³\n   melting point: 54.36 K\n   boiling point: 90.188 K\n           phase: Gas\n          shells: [2, 6]\ne⁻-configuration: 1s² 2s² 2p⁴\n         summary: Oxygen is a chemical element with symbol O and atomic number 8. It is a member of the chalcogen group on the periodic table and is a highly reactive nonmetal and oxidizing agent that readily forms compounds (notably oxides) with most elements. By mass, oxygen is the third-most abundant element in the universe, after hydrogen and helium.\n   discovered by: Carl Wilhelm Scheele\n        named by: Antoine Lavoisier\n          source: https://en.wikipedia.org/wiki/Oxygen\n  spectral image: https://en.wikipedia.org/wiki/File:Oxygen_spectre.jpg\n"
@test stringmime("text/html", O) == "<style>\nth{text-align:right; padding:5px;}td{text-align:left; padding:5px}\n</style>\nOxygen (O), number 8:\n<table>\n<tr><th>category</th><td>diatomic nonmetal</td></tr>\n<tr><th>atomic mass</th><td>15.999 u</td></tr>\n<tr><th>density</th><td>1.429 g/cm³</td></tr>\n<tr><th>melting point</th><td>54.36 K</td></tr>\n<tr><th>boiling point</th><td>90.188 K</td></tr>\n<tr><th>phase</th><td>Gas</td></tr>\n<tr><th>shells</th><td>[2, 6]</td></tr>\n<tr><th>electron configuration</th><td>1s² 2s² 2p⁴</td></tr>\n<tr><th>summary</th><td>Oxygen is a chemical element with symbol O and atomic number 8. It is a member of the chalcogen group on the periodic table and is a highly reactive nonmetal and oxidizing agent that readily forms compounds (notably oxides) with most elements. By mass, oxygen is the third-most abundant element in the universe, after hydrogen and helium.</td></tr>\n<tr><th>discovered by</th><td>Carl Wilhelm Scheele</td></tr>\n<tr><th>named by</th><td>Antoine Lavoisier</td></tr>\n<tr><th>source</th><td><a href=\"https://en.wikipedia.org/wiki/Oxygen\">https://en.wikipedia.org/wiki/Oxygen</a></td></tr>\n</table>\n<img src=\"https://commons.wikimedia.org/w/index.php?title=Special:Redirect/file/Oxygen_spectre.jpg&width=500\" alt=\"Oxygen_spectre.jpg\">\n"

@test_throws ErrorException O.name = "Issue21"
@test O.name == "Oxygen"
