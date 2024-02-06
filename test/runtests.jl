using PeriodicTable, Unitful
import Unitful: u, g, cm, K, J, mol
using Test
using Base64

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
@test nfields(O) == 23

# cpk colors
@test O.cpk_hex == "#ff0d0d"
@test F.cpk_hex == "#90e050"

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
    @test iterate(elements, length(elements)+1) === nothing
end

# 2-argument show functions
@test repr(elements) == "Elements(…119 elements…)"
if VERSION < v"0.7-"
    @test repr([O, F]) == "PeriodicTable.Element[Element(Oxygen), Element(Fluorine)]"
else
    @test repr([O, F]) == "Element[Element(Oxygen), Element(Fluorine)]"
end

@test stringmime("text/plain", elements) == "Elements(…119 elements…):\nH                                                  He \nLi Be                               B  C  N  O  F  Ne \nNa Mg                               Al Si P  S  Cl Ar \nK  Ca Sc Ti V  Cr Mn Fe Co Ni Cu Zn Ga Ge As Se Br Kr \nRb Sr Y  Zr Nb Mo Tc Ru Rh Pd Ag Cd In Sn Sb Te I  Xe \nCs Ba    Hf Ta W  Re Os Ir Pt Au Hg Tl Pb Bi Po At Rn \nFr Ra    Rf Db Sg Bh Hs Mt Ds Rg Cn Nh Fl Mc Lv Ts Og \nUue                                                   \n      La Ce Pr Nd Pm Sm Eu Gd Tb Dy Ho Er Tm Yb Lu    \n      Ac Th Pa U  Np Pu Am Cm Bk Cf Es Fm Md No Lr    \n"
@test stringmime("text/plain", O) == "Oxygen (O), number 8:\n        category: diatomic nonmetal\n     atomic mass: 15.999 u\n         density: 0.001429 g/cm³\n   melting point: 54.36 K\n   boiling point: 90.188 K\n           phase: Gas\n          shells: [2, 6]\ne⁻-configuration: 1s² 2s² 2p⁴\n         summary: Oxygen is a chemical element with symbol O and atomic number 8. It is a member of the chalcogen group on the periodic table and is a highly reactive nonmetal and oxidizing agent that readily forms compounds (notably oxides) with most elements. By mass, oxygen is the third-most abundant element in the universe, after hydrogen and helium.\n   discovered by: Carl Wilhelm Scheele\n        named by: Antoine Lavoisier\n          source: https://en.wikipedia.org/wiki/Oxygen\n  spectral image: https://en.wikipedia.org/wiki/File:Oxygen_spectre.jpg\n"
@test stringmime("text/html", O) == "<style>\nth{text-align:right; padding:5px;}td{text-align:left; padding:5px}\n</style>\nOxygen (O), number 8:\n<table>\n<tr><th>category</th><td>diatomic nonmetal</td></tr>\n<tr><th>atomic mass</th><td>15.999 u</td></tr>\n<tr><th>density</th><td>0.001429 g/cm³</td></tr>\n<tr><th>melting point</th><td>54.36 K</td></tr>\n<tr><th>boiling point</th><td>90.188 K</td></tr>\n<tr><th>phase</th><td>Gas</td></tr>\n<tr><th>shells</th><td>[2, 6]</td></tr>\n<tr><th>electron configuration</th><td>1s² 2s² 2p⁴</td></tr>\n<tr><th>summary</th><td>Oxygen is a chemical element with symbol O and atomic number 8. It is a member of the chalcogen group on the periodic table and is a highly reactive nonmetal and oxidizing agent that readily forms compounds (notably oxides) with most elements. By mass, oxygen is the third-most abundant element in the universe, after hydrogen and helium.</td></tr>\n<tr><th>discovered by</th><td>Carl Wilhelm Scheele</td></tr>\n<tr><th>named by</th><td>Antoine Lavoisier</td></tr>\n<tr><th>source</th><td><a href=\"https://en.wikipedia.org/wiki/Oxygen\">https://en.wikipedia.org/wiki/Oxygen</a></td></tr>\n</table>\n<img src=\"https://commons.wikimedia.org/w/index.php?title=Special:Redirect/file/Oxygen_spectre.jpg&width=500\" alt=\"Oxygen_spectre.jpg\">\n"

@test_throws ErrorException O.name = "Issue21"
@test O.name == "Oxygen"

@test isless(elements[28], elements[29])
@test !isless(elements[88], elements[88])
@test !isless(elements[92], elements[90])
@test isequal(elements[38], elements[38])
@test !isequal(elements[38], elements[39])

@test elements[28] < elements[29]
@test ! (elements[88] < elements[88])
@test ! (elements[92] < elements[90])
@test elements[92] > elements[91]
@test !(elements[92] > elements[92])
@test !(elements[92] > elements[93])
@test elements[90] <= elements[91]
@test elements[91] <= elements[91]
@test !(elements[92] <= elements[91])
@test elements[38] == elements[38]
@test elements[38] ≠ elements[39]

# Ensure that the hashcode works in Dict{}
elmdict = Dict{Element,Int}( elements[z] => z for z in eachindex(elements))
@test length(elmdict) == 119
for z in eachindex(elements)
    @test haskey(elmdict, elements[z])
    @test elmdict[elements[z]] == z
end

# Test data plausibility
for g in [e for e in elements if e.phase=="Gas"]
    @test 5e-5u"g/cm^3" < g.density < 5e-2u"g/cm^3"
end

# Check atomic_mass against values from https://iupac.qmul.ac.uk/AtWt/
a = [ 1.008, 4.002602, 6.94, 9.0121831, 10.81, 12.011, 14.007, 15.999, 18.998403163, 20.1797, 22.98976928, 24.305, 
        26.9815384, 28.085, 30.973761998, 32.06, 35.45, 39.95, 39.0983, 40.078, 44.955907, 47.867, 50.9415, 51.9961, 
        54.938043, 55.845, 58.933194, 58.6934, 63.546, 65.38, 69.723, 72.63, 74.921595, 78.971, 79.904, 83.798, 
        85.4678, 87.62, 88.905838, 91.224, 92.90637, 95.95, 97.0, 101.07, 102.90549, 106.42, 107.8682, 112.414, 
        114.818, 118.71, 121.76, 127.6, 126.90447, 131.293, 132.90545196, 137.327, 138.90547, 140.116, 140.90766, 
        144.242, 145.0, 150.36, 151.964, 157.25, 158.925354, 162.5, 164.930329, 167.259, 168.934219, 173.045, 174.9668, 
        178.486, 180.94788, 183.84, 186.207, 190.23, 192.217, 195.084, 196.96657, 200.592, 204.38, 207.2, 208.9804, 
        209.0, 210.0, 222.0, 223.0, 226.0, 227.0, 232.0377, 231.03588, 238.02891, 237.0, 244.0, 243.0, 247.0, 247.0, 
        251.0, 252.0, 257.0, 258.0, 259.0, 262.0, 267.0, 270.0, 269.0, 270.0, 270.0, 278.0, 281.0, 281.0, 285.0,
        286.0, 289.0, 289.0, 293.0, 293.0, 294.0 ]
@test all(map(z->isequal(ustrip(elements[z].atomic_mass), a[z]), eachindex(a)))