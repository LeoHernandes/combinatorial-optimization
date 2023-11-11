using JuMP
using GLPK

model = Model(GLPK.Optimizer)

@variable(model, r1 >= 0)
@variable(model, r2 >= 0)
@variable(model, p1 >= 0)
@variable(model, p2 >= 0)

@constraint(model, p1 + p2 <= 40)
@constraint(model, r1 + r2 + p1 + p2 >= 100)
@constraint(model, 0.15*r1 + 0.075*r2 + 0.050*p1 + 0.010*p2 <= 10)

@objective(model, Min, 10*r1 + 30*r2 + 40*p1 + 55*p2)

optimize!(model)
@show value(r1)
@show value(r2)
@show value(p1)
@show value(p2)
@show objective_value(model)
@show termination_status(model)