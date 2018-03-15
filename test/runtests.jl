using PeriodicTable
using Base.Test

@test eltype(elements) == Element
@test length(elements) == 119

# test get_element
O = elements[8]
@test O === elements["oxygen"] == elements[:O]
@test O.name == "Oxygen"
@test O.symbol == "O"
@test nfields(O) == 21
