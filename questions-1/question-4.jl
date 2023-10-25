using JuMP
using GLPK
import Random

model = Model(GLPK.Optimizer)
Random.seed!(42)

n = 10 # Clients
m = 10 # Deposits
stock = rand(5:20, m)
demand = rand(1:5, n)
cost = rand(30:50, n, m)

# Variables:
# How many tons will be transported from deposit 'm' to client 'n'
@variable(model, x[1:n, 1:m] >= 0)

# Constraints:
# Tons transported must be less than deposit stock
@constraint(model, [i = 1 : m], sum(x[:, i]) <= stock[i])
# Tons delivered must satisfy the client
@constraint(model, [i = 1 : n], sum(x[i, :]) == demand[i])

# Objective:
# Minimize the transportation cost
@objective(model, Min, sum(sum(x[i, j]  *cost[i, j] for j in 1:m) for i in 1:n))

optimize!(model)
@show value.(stock)
@show value.(demand)
@show value.(cost)
@show value.(x)
@show objective_value(model)
@show termination_status(model)

# ******** Results (example of random values) ********
#
# value.(stock) = [15, 12, 12, 16, 15, 7, 14, 15, 12, 9]
#
# value.(demand) = [4, 4, 2, 2, 3, 1, 2, 1, 3, 3]
#
# value.(cost) = [
#     31 36 41 35 43 37 50 36 35 41;
#     40 33 39 36 35 46 49 41 48 47;
#     34 45 47 41 37 44 45 47 36 48;
#     42 37 33 43 47 46 38 39 43 44;
#     38 30 36 37 44 31 46 32 43 44;
#     36 31 50 32 44 44 42 39 40 47;
#     39 43 37 31 37 32 37 30 33 48;
#     48 40 45 47 31 43 31 46 46 43;
#     36 44 45 50 34 49 44 49 35 36;
#     41 33 43 34 50 39 41 35 30 37
# ]
#
# value.(x) = [
#     4.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
#     0.0 4.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
#     2.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
#     0.0 0.0 2.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
#     0.0 3.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
#     0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
#     0.0 0.0 0.0 0.0 0.0 0.0 0.0 2.0 0.0 0.0;
#     0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0;
#     0.0 0.0 0.0 0.0 3.0 0.0 0.0 0.0 0.0 0.0;
#     0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 3.0 0.0
# ]
#
# objective_value(model) = 794.0