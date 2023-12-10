using JuMP
using GLPK

model = Model(GLPK.Optimizer)

# Variables:
# A 16x4 matrix representing which classes should be chosen in each of the 4 semesters
@variable(model, x[1:16, 1:4], Bin)
# An auxiliar variable to represent the upper limit of classes by semester
@variable(model, classes_by_semester >= 0, Int)

# Constraints:
# Each class should be chosen exactly once
for i in 1:16
    @constraint(model, sum([x[i, j] for j in 1:4]) == 1)
end
# The size of each semester must be smaller then the upper limit
for j in 1:4
    @constraint(model, sum([x[i, j] for i in 1:16]) <= classes_by_semester)
end
# Classes with prerequisites cannot be lectured in first semester
@constraint(model, sum([x[i, 1] for i in 6:16]) <= 0)
# Class 6 has class 1 as prerequisite
for j in 2:4
    @constraint(model, x[6, j] <= sum([x[1, i] for i in 1:(j-1)]))
end
# Class 6 has class 3 as prerequisite
for j in 2:4
    @constraint(model, x[6, j] <= sum([x[3, i] for i in 1:(j-1)]))
end
# Class 7 has class 2 as prerequisite
for j in 2:4
    @constraint(model, x[7, j] <= sum([x[2, i] for i in 1:(j-1)]))
end
# Class 7 has class 3 as prerequisite
for j in 2:4
    @constraint(model, x[7, j] <= sum([x[3, i] for i in 1:(j-1)]))
end
# Class 8 has class 4 as prerequisite
for j in 2:4
    @constraint(model, x[8, j] <= sum([x[4, i] for i in 1:(j-1)]))
end
# Class 9 has class 4 as prerequisite
for j in 2:4
    @constraint(model, x[9, j] <= sum([x[4, i] for i in 1:(j-1)]))
end
# Class 9 has class 5 as prerequisite
for j in 2:4
    @constraint(model, x[9, j] <= sum([x[5, i] for i in 1:(j-1)]))
end
# Class 10 has class 5 as prerequisite
for j in 2:4
    @constraint(model, x[10, j] <= sum([x[5, i] for i in 1:(j-1)]))
end
# Class 11 has class 6 as prerequisite
for j in 2:4
    @constraint(model, x[11, j] <= sum([x[6, i] for i in 1:(j-1)]))
end 
# Class 12 has class 7 as prerequisite
for j in 2:4
    @constraint(model, x[12, j] <= sum([x[7, i] for i in 1:(j-1)]))
end 
# Class 13 has class 7 as prerequisite
for j in 2:4
    @constraint(model, x[13, j] <= sum([x[7, i] for i in 1:(j-1)]))
end 
# Class 14 has class 8 as prerequisite
for j in 2:4
    @constraint(model, x[14, j] <= sum([x[8, i] for i in 1:(j-1)]))
end 
# Class 15 has class 7 as prerequisite
for j in 2:4
    @constraint(model, x[15, j] <= sum([x[7, i] for i in 1:(j-1)]))
end 
# Class 15 has class 8 as prerequisite
for j in 2:4
    @constraint(model, x[15, j] <= sum([x[8, i] for i in 1:(j-1)]))
end 
# Class 15 has class 9 as prerequisite
for j in 2:4
    @constraint(model, x[15, j] <= sum([x[9, i] for i in 1:(j-1)]))
end 
# Class 16 has class 11 as prerequisite
for j in 2:4
    @constraint(model, x[16, j] <= sum([x[11, i] for i in 1:(j-1)]))
end 

# Objective: Minimize the number of classes by semester
@objective(model, Min, classes_by_semester)

optimize!(model)

@show objective_value(model)
@show value.(x)
@show value(classes_by_semester)

# Results:
#
# Maximum number of classes by semester: 4.0
#
# Classes chosen in each semester:
#
# Id | Sem 1 | Sem 2 | Sem 3 | Sem 4
#  1 |   x   |       |       | 
#  2 |   x   |       |       | 
#  3 |   x   |       |       | 
#  4 |   x   |       |       | 
#  5 |       |   x   |       | 
#  6 |       |   x   |       | 
#  7 |       |   x   |       | 
#  8 |       |   x   |       | 
#  9 |       |       |   x   | 
# 10 |       |       |       |   x
# 11 |       |       |   x   | 
# 12 |       |       |   x   | 
# 13 |       |       |   x   | 
# 14 |       |       |       |   x 
# 15 |       |       |       |   x
# 16 |       |       |       |   x