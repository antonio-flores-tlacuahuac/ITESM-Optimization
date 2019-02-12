
using JuMP, Clp

polymer_plant = Model(solver=ClpSolver())

@variable(polymer_plant, bar1 >= 0, start = 50)
@variable(polymer_plant, bar2 >= 0, start = 50)
@variable(polymer_plant, bar3 >= 0, start = 50)
@variable(polymer_plant, bar4 >= 0, start = 50)
@variable(polymer_plant, bbr1 >= 0, start = 50)
@variable(polymer_plant, bbr2 >= 0, start = 50)
@variable(polymer_plant, bbr3 >= 0, start = 50)
@variable(polymer_plant, bbr4 >= 0, start = 50)
@variable(polymer_plant, bcr1 >= 0, start = 50)
@variable(polymer_plant, bcr2 >= 0, start = 50)
@variable(polymer_plant, bcr3 >= 0, start = 50)
@variable(polymer_plant, bcr4 >= 0, start = 50)

@objective(polymer_plant, Max, 10bar1+8bar2+6bar3+9bar4+18bbr1+20bbr2+15bbr3+17bbr4+15bcr1+6bcr2+13bcr3+7bcr4)

#@constraint(polymer_plant, c1, bar1 + bar2 + bar3 + bar4 >= 100)
#@constraint(polymer_plant, c2, bbr1 + bbr2 + bbr3 + bbr4 >= 150)
#@constraint(polymer_plant, c3, bcr1 + bcr2 + bcr3 + bcr4 >= 100)

@constraint(polymer_plant, c1, bar1 + bar2 + bar3 + bar4 >= 100)
@constraint(polymer_plant, c2, bbr1 + bbr2 + bbr3 + bbr4 >= 150)
@constraint(polymer_plant, c3, bcr1 + bcr2 + bcr3 + bcr4 >= 100)

@constraint(polymer_plant, c4, 5bar1  + 6bbr1  + 13bcr1 <= 2400)
@constraint(polymer_plant, c5, 7bar2  + 12bbr2 + 14bcr2 <= 2400)
@constraint(polymer_plant, c6, 4bar3  + 8bbr3  + 9bcr3  <= 2400)
@constraint(polymer_plant, c7, 10bar4 + 15bbr4 + 17bcr4 <= 2400)

print(polymer_plant)

status_polymer_model = solve(polymer_plant)

println("Objective function value = ", getobjectivevalue(polymer_plant))

println("bar1 =", getvalue(bar1))
println("bar2 =", getvalue(bar2))
println("bar3 =", getvalue(bar3))
println("bar4 =", getvalue(bar4))
println("bbr1 =", getvalue(bbr1))
println("bbr2 =", getvalue(bbr2))
println("bbr3 =", getvalue(bbr3))
println("bbr4 =", getvalue(bbr4))
println("bcr1 =", getvalue(bcr1))
println("bcr2 =", getvalue(bcr2))
println("bcr3 =", getvalue(bcr3))
println("bcr4 =", getvalue(bcr4))
println("Total A Batches : ", getvalue(bar1)+getvalue(bar2)+getvalue(bar3)+getvalue(bar4))
println("Total B Batches : ", getvalue(bbr1)+getvalue(bbr2)+getvalue(bbr3)+getvalue(bbr4))
println("Total C Batches : ", getvalue(bcr1)+getvalue(bcr2)+getvalue(bcr3)+getvalue(bcr4))
println("Objective function value = ", getobjectivevalue(polymer_plant))

