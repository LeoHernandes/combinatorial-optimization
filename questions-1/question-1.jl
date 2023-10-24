using JuMP
using GLPK

m = Model(GLPK.Optimizer)

@variable(m, ab >= 0)
@variable(m, ac >= 0)
@variable(m, bc >= 0)
@variable(m, bd >= 0)
@variable(m, ce >= 0)
@variable(m, de >= 0)
@constraint(m, ab == bc + bd)
@constraint(m, ac + bc == ce)
@constraint(m, bd == de)
@constraint(m, ce + de == 1)
@objective(m, Max, 8ab + 3ac + 8bc + 3bd + 7ce + 5de)

optimize!(m)
@show value(ab)
@show value(ac)
@show value(bc)
@show value(bd)
@show value(ce)
@show value(de)
@show objective_value(m)
@show termination_status(m)

# ******** Resultados ********
#
# value(ab) = 1.0
# value(ac) = 0.0
# value(bc) = 1.0
# value(bd) = 0.0
# value(ce) = 1.0
# value(de) = 0.0
# objective_value(m) = 23.0
#
# Caminho máximo: A -> B -> C -> E
#                    8    8    7   