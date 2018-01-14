# Facility Location Problem
# Minimizing Worst Case 
reset;

#setup options
##option solver cplex;

#parameters and sets
set I;               #Number of districts 
set J;               #Number of Fire places

param p{I};          #population in each district
param d{I,J};        #distance in km from district to site
param B;             #Budjet
param f{J};          #fixed cost of site
param c{J};          #var cost associated with site     

#decision varaibles

var X{I,J} binary;    # Disctrict I served by Site J
var Y{J} binary;      # 1 if firestation in site J
var S{J} integer;     # Total population served by each site
var Z binary;         # To select site 1&2 or site 3&4
var D;                # Maximum Distance

#Objective Funtion

minimize distances: D;

#constraints

subject to exactly_1_firehouse {i in I} : sum{j in J} X[i,j] = 1;
subject to no_district_assigned {j in J}: sum{i in I} X[i,j] <= Y[j] *45;#No district is assigned to a site where there is no fire station
subject to selection1: Y[1] + Y[2] >= 2*Z; 
subject to selection2: Y[3] + Y[4] >= 2*(1-Z);
subject to each_site {j in J}: sum{i in I} p[i]*X[i,j]=S[j];
subject to Budjet : sum{j in J} (c[j]*S[j] + f[j]*Y[j]) <= B;
subject to max_distance {i in I}: sum{j in J} d[i,j]* X[i,j] <= D;

#Data
##data "E:\Masters\Avanced Analytics\Assignments\Assignment-3\firehouse-d2.dat";

#Command

#solve;

#display X[I][J];
#display D;