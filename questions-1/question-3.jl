using JuMP
using GLPK

m = Model(GLPK.Optimizer)

@variable(m, p[1:24] >= 0)
@constraint(m, [i=2:6], sum(p[Mod(j, 24)] for j in (i-8 + 1):i) >= 22)
@constraint(m, [i=6:10], sum(p[Mod(j, 24)] for j in (i - 8 + 1):i) >= 55)
@constraint(m, [i=10:14], sum(p[j] for j in (i - 8 + 1):i) >= 88)
@constraint(m, [i=14:18], sum(p[j] for j in (i - 8 + 1):i) >= 110)
@constraint(m, [i=18:22], sum(p[j] for j in (i - 8 + 1):i) >= 44)
@constraint(m, [i=22:2], sum(p[j] for j in (i - 8 + 1):i) >= 33)
@objective(m, Min, sum(p))

optimize!(m)
@show value(p)
@show objective_value(m)
@show termination_status(m)

# ******** Resultados ********
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
# No tempo:
#                                                                      E9
# E1          E2    E3       E5    E4          E6    E8                E7
# |-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
# 0     1     2     3     4     5     6     7     8     9     10    11    12