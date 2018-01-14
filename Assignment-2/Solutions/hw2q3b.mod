reset;
option solver cplexamp;
option presolve 4;
option show_stats 2;

set FRENCH;
set AMERICAN;

param F {i in FRENCH, j in AMERICAN};
param A {k in FRENCH, z in AMERICAN};

# Variables
var Pair {i in FRENCH, j in AMERICAN} binary;

# Objective
maximize weights: sum {i in FRENCH, j in AMERICAN}
					((Pair[i,j] * F[i,j]) + (Pair[i,j] * A[i,j]));
					
# Constraints
subject to F_Pairs {i in FRENCH}: sum {j in AMERICAN} Pair[i,j] = 1;
subject to A_Pairs {j in AMERICAN}: sum {i in FRENCH} Pair[i,j] = 1;

## Stability Constraint (Ref. DOI: 10.1007/978-3-643-03261-6_1, Bistarelli, Stefano, Santini, Francesco, July 2009)
subject to Stability {i in FRENCH, k in FRENCH, j in AMERICAN, z in AMERICAN: (F[i,z] < F[i,j]) and (A[i,z] < A[k,z])}:
			Pair[i,j] + Pair[k,z] <= 1;

# Data
data hw2q3b.dat;

# Solution
solve;

display Pair; 