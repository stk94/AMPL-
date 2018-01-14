# Tomato Production Mix problem WITHOUT 80,000

reset;

#set-up options
option solver cplex;
option cplex_options 'sensitivity';

#Set amd Parameters
set I;        #Types of products
set J;        #Grades of tomatoes

param d{I} >=0; #Demand for each product in CASES.
param tc{I} >=0; #Number of pounds in a case of product i.
param p{I}; #Profit per case of product of i.

#Decisions Varibles
var X{I}>=0;      #Number of cases of product i produced.
var T{I,J}>=0;    #Number of tomatoes of type j used in i.

#Objective Function
maximize profit: p[1]*X[1]+p[2]*X[2]+p[3]*X[3] - 0.06*(2400000 - sum{i in I} T[i,2]) - (0.085 - 0.06)*(sum{i in I} T[i,1] - 600000 ); #chan

#Constraints:
subject to Supply: sum {i in I,j in J}T[i,j] >= 0; # need to be changed
subject to AGrade: sum{i in I}T[i,1] >= 600000;  # need to be changes
subject to BGrade: sum{i in I}T[i,2] <= 2400000;
subject to demand {i in I}: X[i] <= d[i];
subject to Whole_Rating: T[1,1] >= 3*T[1,2];
subject to Juice_rating: 3*T[2,1] >= T[2,2];
#subject to Paste: T[3,1]=0;
subject to case_conversion {i in I}: tc[i]*X[i]=(sum{j in J}T[i,j]);

#Commands
data "E:\Masters\Avanced Analytics\Assignments\Assignment-1\A1Q5c.dat";
#data "E:\Masters\Avanced Analytics\Assignments\Assignment-1\A1Q5d2.dat";
solve;

display X,T;
display AGrade,AGrade.up,AGrade.down;

