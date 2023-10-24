using JuMP
using GLPK

m = Model(GLPK.Optimizer)

# Variables:
# All the edges connecting the graph
@variable(m, ab >= 0)
@variable(m, ac >= 0)
@variable(m, bc >= 0)
@variable(m, bd >= 0)
@variable(m, ce >= 0)
@variable(m, de >= 0)

# Constrains:
# The value of edges reaching and exiting a node have to be equal,
# except when it's the final node, where the edges leading to it have a sum of exactly 1,
# forcing the path to reach the destination
@constraint(m, ab == bc + bd)
@constraint(m, ac + bc == ce)
@constraint(m, bd == de)
@constraint(m, ce + de == 1)

# Objective:
# The choice of edges maximize the cargo
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

# ******** Results ********
#
# value(ab) = 1.0
# value(ac) = 0.0
# value(bc) = 1.0
# value(bd) = 0.0
# value(ce) = 1.0
# value(de) = 0.0
# objective_value(m) = 23.0
#
# Optimal path: A -> B -> C -> E
#                 8    8    7   