using PeriodicTable
using Base.Test

# test PT 
p = PeriodicTable.PT()
@test typeof(p.data) == Array{Any,1}
@test typeof(p.data[1]) == PeriodicTable.Element
@test length(p.data) == 119

# test get_element
pget = PeriodicTable.get_element(p, 8)
@test pget.name == "Oxygen"
@test pget.symbol == "O"
@test length(fieldnames(pget)) == 22
@test length(fieldnames(pget.data)) == 8
