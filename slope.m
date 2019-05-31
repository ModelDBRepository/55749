function [AC,E] = slope(M,TAU,R,Idc)
%SLOPE This function estimates the accommodation slope
%   [AC,E] = slope(M,TAU,R,Idc) this function estimates the accommodation slope [AC]
%   of a nerve model [M]. The slope is calculated for a exponentially rising 
%   stimulus with a time constant [TAU], and with a rheobase [R].

%Create the variables needed for the computations, that does not change with diameter
S = expr(0,TAU);
S = setDC(S,Idc);

%tspan = [0 -TAU*log(0.001)]
tspan = [0 -TAU*log(0.05)];

Imax = 10e-9; Nmsi = 5; Itol = 0.01e-9; noAP = 1; 

[E,NOI] = excitation(Imax,Nmsi,Itol,noAP,tspan,M,S);

AC = (E/R)/TAU;