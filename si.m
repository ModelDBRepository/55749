function [T,V,E0] = si(Tp,M,I)
%SI Strength-Intensity test
%   [T,V,E0] = si(Tp,M,I)

Imax = 10e-9; Nmsi = 10; Itol = 0.0001e-9; noAP = 1; 

[Spls] = pulse(0,1e-3);  
Spls = setDC(Spls,0);
E0 = excitation(Imax,Nmsi,Itol,noAP,[0 2e-3],M,Spls);        

MSAVE = M;
for n = 1:length(I)
    M = MSAVE;
    S = ramp(-I(n),Tp);
    S = setDC(S,0);
    M.X0 = x0patch([0 Tp],S,M); 
    V(n) = M.X0(1);
    T(n) = excitation(Imax,Nmsi,Itol,noAP,[0 2e-3],M,Spls);     
    fprintf('.');
end