using JuMP
using GLPK

model = Model(GLPK.Optimizer)

# Variables:
# Binary variable for each cost to ignoew:
# 1 => ignore
# 0 => consider
@variable(model, ignore_gold, Bin)
@variable(model, ignore_time, Bin)
@variable(model, ignore_mana, Bin)
# How many times an attack was used
@variable(model, mammon >= 0, Int)
@variable(model, arrow >= 0, Int)
@variable(model, flame >= 0, Int)

BIG_VALUE = 10000

# Constraints:
# May ignore at most 1 cost 
@constraint(model, ignore_gold + ignore_time + ignore_mana <= 1)
# Use at most 2000 gold
@constraint(model, mammon * 250 + arrow * 50 <= 2000 + ignore_gold*BIG_VALUE)
# Spend at most 1 minute
@constraint(model, mammon * 7 + arrow * 10 + flame * 15 <= 60 + ignore_time*BIG_VALUE)
# Use at most 1000 magic points
@constraint(model, mammon * 100 + arrow * 150 + flame * 200 <= 1000 + ignore_mana*BIG_VALUE)

# Objective: Do the maximum damage
@objective(model, Max, mammon * 2000 + arrow * 1750 + flame * 1000)

optimize!(model)

@show objective_value(model)
@show value(ignore_gold)
@show value(ignore_time)
@show value(ignore_mana)
@show value(mammon)
@show value(arrow)
@show value(flame)

# Results
# The ignored cost is 'time'
#
# Times the attacks were used:
# - Mammon: 7
# - Arrow: 2
# - Flame: 0
#
# This equals a total of 17_500 points of damage