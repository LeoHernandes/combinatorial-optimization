using JuMP
using GLPK

m = Model(GLPK.Optimizer)

# Variables:
# Array of size 24 representing how many cops started working at each hour of the day
@variable(m, p[1:24] >= 0)

# Constraints:
# The sum of p[i] for i in [i - 8 + 1 : i] represents how many cops in total are working at hour 'i' of the day
# considering their work shift lasts 8 hours
# We use mod(j, 24) + 1 to rotate correctly on array indexes from 1 to 24
@constraint(m, [i =  2 :  5], sum( p[mod(j, 24) + 1] for j in (i - 8) : (i - 1) ) >= 22)
@constraint(m, [i =  6 :  9], sum( p[mod(j, 24) + 1] for j in (i - 8) : (i - 1) ) >= 55)
@constraint(m, [i = 10 : 13], sum( p[mod(j, 24) + 1] for j in (i - 8) : (i - 1) ) >= 88)
@constraint(m, [i = 14 : 17], sum( p[mod(j, 24) + 1] for j in (i - 8) : (i - 1) ) >= 110)
@constraint(m, [i = 18 : 21], sum( p[mod(j, 24) + 1] for j in (i - 8) : (i - 1) ) >= 44)
@constraint(m, [i = 22 : 25], sum( p[mod(j, 24) + 1] for j in (i - 8) : (i - 1) ) >= 33)

# Objective:
# Quantity of cops hired must be minimal
@objective(m, Min, sum(p))

optimize!(m)
@show value.(p)
@show objective_value(m)
@show termination_status(m)

# ******** Results ********
#
# value.(p) = [
#     22.0,  0.0,  0.0,  0.0,
#      0.0, 33.0,  0.0,  0.0,
#     22.0, 77.0,  0.0,  0.0,
#      0.0, 11.0,  0.0,  0.0,
#     22.0, 11.0,  0.0,  0.0,
#      0.0,  0.0,  0.0,  0.0
# ]
# objective_value(m) = 198.0
#
# Accumulation of cops by hour:
# hour | cops:
# ------------
#  1   |  33   
#  2   |  22   
#  3   |  22  
#  4   |  22   
#  5   |  22   
#  6   |  55   
#  7   |  55   
#  8   |  55  
#  9   |  55   
#  10  |  132  
#  11  |  132  
#  12  |  132
#  13  |  132    
#  14  |  110    
#  15  |  110    
#  16  |  110    
#  17  |  110    
#  18  |  110    
#  19  |  44     
#  20  |  44     
#  21  |  44     
#  22  |  33     
#  23  |  33     
#  24  |  33
     
     
     
     
     
     
     
     
     
     
     
