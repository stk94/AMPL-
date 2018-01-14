#Financial Investment for 6 months

reset;

#setup options
#option solver cplex;

#parameters and sets
set P;                #investment plan number 
set M;                #num of months

param e{M};           #given exoendiure for each month
param ir{P}>=0;       #interest rates for each plan  

#decision varaibles
var i{M,P}>=0;

#Objective Funtion
#maximize returns: sum{m in M,p in P} ir[p]*i[m,p];
maximize final_return: 1.005*i[6,1]+1.021*i[4,3]+1.035*i[1,6];

#constraints

subject to month1_constraints: sum{p in P} i[1,p] =300000+e[1];
subject to month2_constraints: sum{p in P} i[2,p] =e[2]+ir[1]*i[1,1];
subject to month3_constraints: sum{p in P} i[3,p] =e[3]+ir[1]*i[2,1];
subject to month4_constraints: sum{p in P} i[4,p] =e[4]+ir[1]*i[3,1]+ir[3]*i[1,3];
subject to month5_constraints: sum{p in P} i[5,p] =e[5]+ir[1]*i[4,1]+ir[3]*i[2,3];
subject to month6_constraints: sum{p in P} i[6,p] =e[6]+ir[1]*i[5,1]+ir[3]*i[3,3];

#Data
data "E:\Masters\Avanced Analytics\Assignments\Assignment-1\A1Q3.dat";

#Command
solve;

display i;