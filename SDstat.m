function [R,T] = SDstat(M,Idc)
%SDstat Strength-Duration Statistics (Rheobase and SD-Time)
%   [R,T] = SDstat(M,Idc) this function estimates the statistics of the strength-
%   duration curve with Weiss's law. It returns the rheobase [R] and the 
%   strength-duration time constant (SD-Time). These are estimated for a 
%   model [M].

%Definition of the two stimulus durations
%ts = [25e-6 50e-6 100e-6 200e-6 400e-6 800e-6 1600e-6 10e-3 20e-3 100e-3]';

%Create the parameters for the excitation function
Imax = 10e-9; Nmsi = 5; Itol = 0.0001e-9; noAP = 1; tspan = [0 1e-3];

S = pulse(0,10e-3);
S = setDC(S,Idc);
R = excitation(Imax,Nmsi,Itol,noAP,[0 11e-3],M,S);
T = chronaxie(1e-3,1e-6,M,2*R,0);
disp(sprintf('Rheobase: %.3fnA  / SD-Time Constant : %.2fus',R*1e9,T*1e6));