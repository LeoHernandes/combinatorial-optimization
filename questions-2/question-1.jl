using JuMP
using GLPK

model = Model(GLPK.Optimizer)

# Variables:
# A 3x3 matrix with integer numbers between 1 and 9
@variable(model, 1 <= x[1:3, 1:3] <= 9, Int)

# Constraints:
# Each row, column, and diagonal sum to 15
for i in 1:3
    # Row sum
    @constraint(model, sum(x[i, :]) == 15)  
    # Column sum
    @constraint(model, sum(x[:, i]) == 15)  
end

# Main diagonal
@constraint(model, sum(x[i, i] for i in 1:3) == 15)  
# Secondary diagonal
@constraint(model, sum(x[i, 4 - i] for i in 1:3) == 15)

# Ensures that all variables are different
for i in 1:3
    for j in 1:3
        for l in j : 3
            for k in i + 1 : 3    
                @constraint(model, 3 <= x[i, j] + x[k, l] <= 17)
            end
        end
    end
end

# Objective: Minimize a dummy variable (not really needed for this problem)
@objective(model, Min, sum(x))

optimize!(model)

@show objective_value(model)
@show value.(x)

# Results:
# The magic matrix is:
#
# ---------
# | 6 1 8 |
# | 7 5 3 |
# | 2 9 4 |
# ---------