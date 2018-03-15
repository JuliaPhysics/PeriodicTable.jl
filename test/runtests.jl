using PeriodicTable
using Base.Test

# testing elements
el = PeriodicTable.elements["hydrogen"]
@test el.name == "hydrogen"
@test el.number == 1

# testing getindex gives the write results
@test PeriodicTable.elements[1] == PeriodicTable.elements["hydrogen"]
