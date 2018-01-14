# Fuel plan problem - IF YOU BUY ANY GAS, YOU MUST BUY ATLEAST 100 GALLONS.
# All calculations in pounds
reset;

#setup options
option solver cplex;

#parameters and sets
set T;              # set of journeys
set S;              # set of stops

param Y2;           # ramp fees at Boston
param Y3;           # ramp fees at Newyork 
param Y4;           # ramp fees at Dallas

param P{T} >= 0;  # Number of passengers in each trip
param F{T} >= 0;  # Fuel consumed for each trip
param C{S} >= 0;  # Cost of fuel per pound at each stop

param PassWt;    # Average wt of each passenger
param BOW;       # Basic Operating Wt
param Max_Rmp_Wt; # Maximum Ramp weight
param Max_Land_Wt; # Maximum Landing weight

param W2; # Minimum weight to waive ramp fees at Boston.
param W3; # Minimum weight to waive ramp fees at Newyork.
param W4; # Minimum weight to waive ramp fees at Dallas.

#decision varaibles

var X1 >= 0 integer;  # Fuel filled in poundds at Moline while starting
var X2 >= 0 integer;  # Fuel filled at Boston in pounds
var X3 >= 0 integer;  # Fuel filled at Newyork in pounds
var X4 >= 0 integer;  # Fuel filled at Dallas in pounds
var X5 >= 0 integer;  # Fuel filled at Miline at the end of trip

var B2 binary; # Used to calculate Ramp fees at Boston
var B3 binary; # Used to calculate Ramp fees at Newyork
var B4 binary; # Used to calculate Ramp fees at Dallas

var Q2 binary; # Used to restrict to buy fuel in required range at Boston
var Q3 binary; # Used to restrict to buy fuel in required range at Newyork
var Q4 binary; # Used to restrict to buy fuel in required range at Dallas

#Objective Funtion

minimize cost: C[1] * (X1) + C[2] * (X2) + C[3] * (X3) + C[4] * (X4) + C[5] * X5 + (1-B2) * Y2 + (1-B3) * Y3 + (1-B4) * Y4;

#constraints

subject to stop1: 2400 + F[1] <= X1+7000 <= 13000;

subject to binary2 : B2 <= X2/W2; # B2=0(If Ramp fees applicable),B2=1(If Ramp fees not applicable)
subject to binary3 : B3 <= X3/W3; # B3=0(If Ramp fees applicable),B3=1(If Ramp fees not applicable)
subject to binary4 : B4 <= X4/W4; # B4=0(If Ramp fees applicable),B4=1(If Ramp fees not applicable)

subject to min_2_1 : X2 <= 13000 * Q2; # To determine value of Q2
subject to min_2_2 : X2 >= 670 * Q2;   # To determine value of Q2
subject to min_3_1 : X3 <= 13000 * Q3; # To determine value of Q3
subject to min_3_2 : X3 >= 670 * Q3;   # To determine value of Q3
subject to min_4_1 : X4 <= 13000 * Q4; # To determine value of Q4
subject to min_4_2 : X4 >= 670 * Q4;   # To determine value of Q4

subject to takeoff_at_1: 7000 + X1 + BOW + PassWt * P[1] <= Max_Rmp_Wt ;
subject to landing_at_2: 2400 <= 7000 + X1 - F[1]  <= Max_Land_Wt - BOW - PassWt * P[1];
subject to takeoff_at_2: 7000 + X1 - F[1] + X2 + BOW + PassWt * P[2]<= Max_Rmp_Wt;
subject to landing_at_3: 2400 <= 7000 + X1 - F[1] + X2 - F[2] <= Max_Land_Wt - BOW - PassWt * P[2];
subject to takeoff_at_3: 7000 + X1 - F[1] + X2 - F[2] + X3 + BOW + PassWt * P[3] <= Max_Rmp_Wt;
subject to landing_at_4: 2400 <= 7000 + X1 - F[1] + X2 - F[2] + X3 - F[3]  <= Max_Land_Wt - BOW - PassWt * P[3];
subject to takeoff_at_4: 7000 + X1 - F[1] + X2 - F[2] + X3 - F[3] + X4 + BOW + PassWt * P[4] <= Max_Rmp_Wt;
subject to landing_at_5: 2400 <= 7000 + X1 - F[1] + X2 - F[2] + X3 - F[3] + X4 - F[4] <= Max_Land_Wt - BOW - PassWt * P[4];
subject to immediate_Refill: 7000 <= 7000 + X1 - F[1] + X2 - F[2] + X3 - F[3] + X4 - F[4] + X5;

#Data
data hw2q6.dat;

#Command
solve;

display X1,X2,X3,X4,X5,B2,B3,B4; 

display cost;

printf "Fuel filled at Moline(Starting) apart from 7000 pounds is: \n";
display X1;

printf "Fuel filled at Boston is: \n";
display X2;

printf "Fuel filled at Newyork is: \n";
display X3;

printf "Fuel filled at Dallas is: \n";
display X4;

printf "Fuel filled at Moline(Ending) is: \n";
display X5;

#printf "Value of Q is";
display Q2,Q3,Q4;