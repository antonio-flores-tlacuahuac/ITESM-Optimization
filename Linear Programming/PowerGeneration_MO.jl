using JuMP, Gurobi, Plots, Printf

mpy_carbon = 31000 ; # Maximum Production per year (GWh)
mpy_oil    = 15000 ;
mpy_gas    = 22000 ;
mpy_res    = 10000 ;

cost_carbon = 30 ;  # Production cost ($/Mwh)
cost_oil    = 75 ;
cost_gas    = 60 ;
cost_res    = 90 ;

co2_carbon  = 1.44 ; # CO2 emission coefficient (t/MWh)
co2_oil     = 0.72 ;
co2_gas     = 0.45 ;
co2_res     = 0    ;

y_demand    = 64000 ; # Yearly energy demand (GWh)

base_load   = 0.6 ; # Enery load per production period
medium_load = 0.3 ;
peak_load   = 0.1 ;






power_mo = Model(Gurobi.Optimizer);

@variable(power_mo, carbon_base >= 0, start = base_load*y_demand);


@variable(power_mo, carbon_medium >= 0, start = medium_load*y_demand);

@variable(power_mo, oil_medium >= 0, start = medium_load*y_demand);

@variable(power_mo, oil_peak >=0,  start = medium_load*y_demand);

@variable(power_mo, gas_base >= 0, start = base_load*y_demand);

@variable(power_mo, gas_medium >= 0, start = medium_load*y_demand);

@variable(power_mo, gas_peak>= 0, start = peak_load*y_demand);

@variable(power_mo, res_base >= 0, start = base_load*y_demand);

@variable(power_mo, res_peak >= 0, start = peak_load*y_demand);

@variable(power_mo, carbon >= 0, start = 0.5*mpy_carbon);

@variable(power_mo, oil >= 0, start = 0.5*mpy_oil);

@variable(power_mo, gas >= 0, start = 0.5*mpy_gas);

@variable(power_mo, res >= 0, start = 0.5*mpy_res);

@variable(power_mo, co2 >= 0, start = 50000);

@variable(power_mo, cost >=0, start = 1e06);

@constraint(power_mo, c1, co2 == co2_carbon*carbon + co2_oil*oil + co2_gas*gas + co2_res*res );

@constraint(power_mo, c2,  carbon == carbon_base +carbon_medium);

@constraint(power_mo, c3, oil == oil_medium + oil_peak) ;

@constraint(power_mo, c4, gas == gas_base + gas_medium + gas_peak); 

@constraint(power_mo, c5, res == res_base + res_peak) ;

@constraint(power_mo, c6, carbon_base + gas_base + res_base >= base_load*y_demand) ;

@constraint(power_mo, c7, carbon_medium + oil_medium + gas_medium >= medium_load*y_demand);

@constraint(power_mo, c8, oil_peak + gas_peak + res_peak >= peak_load*y_demand) ;

@constraint(power_mo, c9, carbon <= mpy_carbon);

@constraint(power_mo, c10, oil <= mpy_oil);

@constraint(power_mo, c11, gas <= mpy_gas);

@constraint(power_mo, c12, res <= mpy_res);

@constraint(power_mo, c13, cost == cost_carbon*carbon + cost_oil*oil + cost_gas*gas + cost_res*res)

@objective(power_mo, Min, cost)

optimize!(power_mo)

println("Objective function value = ", JuMP.objective_value(power_mo))
println("CO2 Emissions = ", JuMP.value(co2))

println("-----------------------------\n")
println("    GLOBAL RESULTS\n")
println("Carbon = ", JuMP.value(carbon))
println("Oil    = ", JuMP.value(oil))
println("Gas    = ", JuMP.value(gas))
println("RES    = ", JuMP.value(res))
println("-----------------------------\n")
println("    BASE PERIOD\n")
println("Carbon = ", JuMP.value(carbon_base))
println("Gas    = ", JuMP.value(gas_base))
println("RES    = ", JuMP.value(res_base))
println("-----------------------------\n")

println("    MEDIUM PERIOD\n")
println("Carbon = ", JuMP.value(carbon_medium))
println("OiL    = ", JuMP.value(oil_medium))
println("gas    = ", JuMP.value(gas_medium))
println("-----------------------------\n")

println("    PEAK PERIOD\n")
println("OiL    = ", JuMP.value(oil_peak))
println("gas    = ", JuMP.value(gas_peak))
println("RES    = ", JuMP.value(res_peak))
println("-----------------------------\n")
   



