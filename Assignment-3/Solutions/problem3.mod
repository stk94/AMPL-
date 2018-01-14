# GIZMOS & GADGETS

reset;

#setup options
option solver cplex;

#decision varaibles

var X1 >= 0 integer;  # Number of widgets bought from WII
var X2 >= 0 integer;  # Number of widgets bought from WRS
var X3 >= 0 integer;  # Number of widgets bought from WU
var X4 >= 0 integer;  # Number of widgets bought from WOW

var d1 >= 0 integer;  # Number of widgets bought from WOW at 5.50$
var d2 >= 0 integer;  # Number of widgets bought from WOW at 3.50$
var d3 >= 0 integer;  # Number of widgets bought from WOW at 2 $

var B1 binary;  # Used to control X2 to be 0 or >7500 
var B2 binary;  # Used to calculate cost associated with X3
var y1 binary;  # Used to calculate d1,d2
var y2 binary;  # Used to calculate d2,d3

#Objective Funtion

minimize cost: 4.25*X1 + 3.15*X2 + (1.90*X3+15000)*B2 + 5.50*d1 + 3.50*d2 + 2*d3;

#constraints

subject to WII: X1 <= 10000;
subject to WRS: X2 <= 15000;
subject to WU: X3 <= 9000;
subject to WOW: X4 <= 25000;

subject to demand: X1+X2+X3+X4 = 17000;#17k,18k,19k,28k,32k


subject to B1_1: X2 <= 15000*B1; # B1=0(If X2=0),B1=1(If X2>=7500)
subject to B1_2: X2 >= 7500*B1; # B1=0(If X2=0),B1=1(If X2>=7500)

subject to B2_1: X3 <= 9000*B2; # B2=0(If X3=0),B2=1(If X3>0)
subject to B2_2: X3 >= B2; # B2=0(If X3=0),B2=1(If X3>0)

subject to d1_delta1 : 5000*y1 <= d1;
subject to d1_delta2 : d1 <= 5000;

subject to d2_delta1 : 7500*y2 <= d2;
subject to d2_delta2 : d2 <= 7500*y1;

subject to d3_delta1 : 0 <= d3;
subject to d3_delta2 : d3 <= 12500*y2;
subject to WOW_SUM: X4 = d1+d2+d3;


#Command
solve;

display X1,X2,X3,X4; 

display cost;

printf "Widgets bought from WII is: \n";
display X1;

printf "Widgets bought from WRS is: \n";
display X2;

printf "Widgets bought from WU is: \n";
display X3;

printf "Widgets bought from WOW is: \n";
display X4;
display d1,d2,d3;
