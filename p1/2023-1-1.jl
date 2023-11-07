using JuMP
using GLPK

model = Model(GLPK.Optimizer)

@variable(model, i1 >= 0)
@variable(model, i2 >= 0)

@constraint(model, i1 <= 1)
@constraint(model, i2 <= 1)
@constraint(model, i1*5000 + i2*4000 <= 6000)
@constraint(model, i1*200 + i2*250 <= 300)

@objective(model, Max, i1 * 9500 + i2 * 9000)

optimize!(model)
@show value(i1)
@show value(i2)
@show objective_value(model)
@show termination_status(model)