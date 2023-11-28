function [A,S,E] = rcurve(M,TS,Idc)
%ACURVE Accommodation curve
%   [A,S,E] = rcurve(M,TS,R,Idc) this function simulate the accommodation curve [A]
%   for the durations [TS] of ramp. [A] has the same 
%   length as [TS]. The rheobase [R] is used for calculating the accommodation
%   curve [A] and the accommodation slopes [S]. The raw excitation thresholds are
%   returned in [E].

%Create the parameters for the excitation function
Imax = 10e-9; Nmsi = 5; Itol = 0.0001e-9; noAP = 1; 

S = pulse(0,100e-3);
S = setDC(S,Idc);

R = excitation(Imax,Nmsi,Itol,1,[0 101e-3],M,S);

for n = 1:length(TS)
    stim = ramp(0,TS(n));
    stim = setDC(stim,Idc);
    tspan = [0 TS(n)+1e-3];
    E(n) = excitation(Imax,Nmsi,Itol,noAP,tspan,M,stim);
    S(n) = (E(n) / TS(n)) / R;
    %fprintf('.');
end
A = E / R;
