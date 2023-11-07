using JuMP
using GLPK

model = Model(GLPK.Optimizer)

@variable(model, e14 >= 50000000)
@variable(model, e15 >= 80000000)
@variable(model, e16 >= 320000000)
@variable(model, e17 >= 200000000)

@objective(model, Min, (e14*2.2 + e15*1.8 + e16*1.65 + e17*1.4) - ((((e14 - 50000000)*1.17 + e15 - 80000000)*1.17 + e16 - 320000000)*1.17 + e17 - 200000000)*1.17*1.17*1.17 )

optimize!(model)
@show value(e14)
@show value(e15)
@show value(e16)
@show value(e17)
@show objective_value(model)
@show termination_status(model)