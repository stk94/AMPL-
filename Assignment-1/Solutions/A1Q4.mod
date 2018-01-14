# Scheduling of Sandal Production

reset;

#setup options
option solver cplex;

#parameters and sets
set I circular;                # Number of Seasons
 
param D{I};           #Demand in each season  

#Decision Varaibles
var P{I}>=0;        #Sandals Produced in Season i 
var C{I}>=0;        #Inverntory stored at end of season i

#Objective Funtion
minimize Inventory_Costs: sum{i in I} 0.15 * C[i];

#constraints

subject to Demand {i in I}: P[i]+C[prev(i)]=D[i]+C[i];
subject to Production {i in I}:P[i]<=1200;

#Data
data "E:\Masters\Avanced Analytics\Assignments\Assignment-1\A1Q4.dat";

#Command
solve;

display P,C;