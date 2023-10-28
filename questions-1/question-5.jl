using JuMP
using GLPK

model = Model(GLPK.Optimizer)

monstersRate = [6 1 0 1; 0 0 3 1; 0 4 0 1; 2 1 0 1; 0 2 0 1; 1 0 2 1]

# Variables:
# Time spended by bot in one area when the next is open.
# For example, if A = 1.5, it means that in the interval [10h, 12h], the bot changed
# from area A to B at 11:30
@variable(model, A >= 0)
@variable(model, B >= 0)
@variable(model, C >= 0)
# Threshold for the amount of the monster type that has been captured the least
@variable(model, threshold >= 0)

# Constraints:
# Bot must travel before its current area closes
@constraint(model, A <= 2)
@constraint(model, B <= 4)
@constraint(model, C <= 4)
# Bot spends at least 30 minutes navigating in one area
@constraint(model, B >= 0.5)
@constraint(model, C >= 0.5)
# Bot must respect the open/close time of areas
@constraint(model, A + B + C <= 6)
@constraint(model, A + B + C >= 4)
# The amount of monster of each type must be bigger than the threshold
@constraint(model, [i = 1: 6], sum(monstersRate[i,:] .* [A + 2, B, C, 8 - (A + B + C)]) >= threshold )


# Objective:
# Maximize the minimum threshold
@objective(model, Max, threshold)

optimize!(model)
@show value(A)
@show value(B)
@show value(C)
@show value(threshold)
@show objective_value(model)
@show termination_status(model)

# ******** Results ********
# 
# value(A) = 0.0
# value(B) = 3.0
# value(C) = 2.0
# value(threshold) = 9.0
# objective_value(model) = 9.0
# termination_status(model) = MathOptInterface.OPTIMAL
#
# Visualization of time spent in each area:
#
# |_______A_______|___________B___________|______ C_______|___________D___________|
#
# |-------|-------|-------|-------|-------|-------|-------|-------|-------|-------|
# 8               10              12              14              16              18
#
# Quantity of monster colected in each area:
#
# | A  | B  | C | D |
# |-----------------|
# | 12 | 3  | 0 | 4 | => 19 
# | 0  | 0  | 6 | 4 | => 10
# | 0  | 12 | 0 | 4 | => 16
# | 4  | 3  | 0 | 4 | => 11
# | 0  | 6  | 0 | 4 | => 10
# | 2  | 0  | 4 | 4 | => 10
# |-----------------|
#
# Group of monsters sold: 10