function [I] = SDcurve(T,M,Idc)
%SDCurve this function simulates the strength-duration curve
%   [I] = SDcurve(T,M,Idc) this function estimate the excitation thresholds
%   [I] for rectangular pulses with durations [T], for the model [M] and the
%   constant polarizing current [Idc].

%Create the parameters for the excitation function
Imax = 10e-9; Nmsi = 5; Itol = 0.0001e-9; noAP = 1; 

for n = 1:length(T)
    S = pulse(0,T(n));
    S = setDC(S,Idc);
    I(n) = excitation(Imax,Nmsi,Itol,noAP,[0 T(n)+1e-3],M,S);
    fprintf('.');
end    