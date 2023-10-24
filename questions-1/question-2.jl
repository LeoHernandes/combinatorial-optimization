using JuMP
using GLPK

m = Model(GLPK.Optimizer)

# Variables:
# Time when each step is finished, from step 1 (E1) to step 9 (E9)  
@variable(m, E1 >= 0)
@variable(m, E2 >= 0)
@variable(m, E3 >= 0)
@variable(m, E4 >= 0)
@variable(m, E5 >= 0)
@variable(m, E6 >= 0)
@variable(m, E7 >= 0)
@variable(m, E8 >= 0)
@variable(m, E9 >= 0)

# Constraints:
# Each step needs to be finished after their requirements end time plus its own duration  
@constraint(m, E2 >= E1 + 2)
@constraint(m, E3 >= E1 + 3)
@constraint(m, E4 >= E3 + 2.5)
@constraint(m, E5 >= E3 + 1.5)
@constraint(m, E6 >= E2 + 2)
@constraint(m, E6 >= E4 + 2)
@constraint(m, E7 >= E5 + 4)
@constraint(m, E7 >= E6 + 4)
@constraint(m, E8 >= E2 + 3)
@constraint(m, E8 >= E4 + 3)
@constraint(m, E9 >= E7)
@constraint(m, E9 >= E8)

# Objective
# Final step end time must be minimal
@objective(m, Min, E9)

optimize!(m)
@show value(E1)
@show value(E2)
@show value(E3)
@show value(E4)
@show value(E5)
@show value(E6)
@show value(E7)
@show value(E8)
@show value(E9)
@show objective_value(m)
@show termination_status(m)

# ******** Results ********
#
# value(E1) = 0.0
# value(E2) = 2.0
# value(E3) = 3.0
# value(E4) = 5.5
# value(E5) = 4.5
# value(E6) = 7.5
# value(E7) = 11.5
# value(E8) = 8.5
# value(E9) = 11.5
#
# Display in time:
#                                                                      E9
# E1          E2    E3       E5    E4          E6    E8                E7
# |-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
# 0     1     2     3     4     5     6     7     8     9     10    11    12