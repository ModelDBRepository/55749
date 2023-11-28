function [E,V] = depolarize(I,M,S,TSPAN)
%DEPOLARIZE Estimate the threshold to a stimulus during depolarization
%   [E] = depolarize(I,M,S,TSPAN)
Imax = 10e-9; Nmsi = 10; Itol = 0.0001e-9; noAP = 1; 

MSAVE = M;
SSAVE = S;
for n = 1:length(I)
    M = MSAVE;
    M.X0 = x0patch([0 500e-3],ramp(-I(n),500e-3),M); 
    V(n) = M.X0(1);
    S = setDC(SSAVE,-I(n));
    E(n) = excitation(Imax,Nmsi,Itol,noAP,TSPAN,M,S);     
    fprintf('.');
end
    