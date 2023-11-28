function [R0] = ramp_thr(Ts,M)
%RAMP_THR Excitation threshold to a ramp
%   [R0] = ramp_thr(Ts,M)
Imax = 10e-9; Nmsi = 10; Itol = 0.0001e-9; noAP = 1; 

[S] = ramp(0,Ts);  
S = setDC(S,0);
R0 = excitation(Imax,Nmsi,Itol,noAP,[0 Ts+2e-3],M,S);     