# Fuel plan problem - NON-TANKERING SOLUTION 
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

param W2; # Minimum weight to waive ramp fees at Boston
param W3; # Minimum weight to waive ramp fees at Newyork
param W4; # Minimum weight to waive ramp fees at Dallas

#decision varaibles

var X1 >= 0;  # Fuel filled in poundds at Moline while starting
var X2 >= 0;  # Fuel filled at Boston in pounds
var X3 >= 0;  # Fuel filled at Newyork in pounds
var X4 >= 0;  # Fuel filled at Dallas in pounds
var X5 >= 0;  # Fuel filled at Miline at the end of trip

var B2 binary; # Used to calculate Ramp fees at Boston
var B3 binary; # Used to calculate Ramp fees at Newyork
var B4 binary; # Used to calculate Ramp fees at Dallas

#Objective Funtion

minimize cost: C[1] * (X1) + C[2] * (X2) + C[3] * (X3) + C[4] * (X4) + C[5] * X5 + (1-B2) * Y2 + (1-B3) * Y3 + (1-B4) * Y4;

#constraints

subject to binary2 : B2 <= X2/W2; # B2=0(If Ramp fees applicable),B2=1(If Ramp fees not applicable)
subject to binary3 : B3 <= X3/W3; # B3=0(If Ramp fees applicable),B3=1(If Ramp fees not applicable)
subject to binary4 : B4 <= X4/W4; # B4=0(If Ramp fees applicable),B4=1(If Ramp fees not applicable)

subject to stop1: X1 + 7000 = 2400 + F[1] ;
subject to stop2: X2 = F[2];
subject to stop3: X3 = F[3];
subject to stop4: X4 = F[4];
subject to stop5: X5 + 2400 = 7000 ;

#Data
data hw2q6.dat;

#Command
solve;

display X1,X2,X3,X4,X5,B2,B3,B4; 

display cost;

printf "Fuel purchased at Moline(Starting) apart from 7000 pounds is: \n";
display X1;

printf "Fuel purchased at Boston is: \n";
display X2;

printf "Fuel purchased at Newyork is: \n";
display X3;

printf "Fuel purchased at Dallas is: \n";
display X4;

printf "Fuel purchased at Moline(Ending) is: \n";
display X5;