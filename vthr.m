function [V,T,E0] = vthr(M,P)
%VTHR membrane potential-threshold relationship
%

Imax = 10e-9; Nmsi = 5; Itol = 0.0001e-9; noAP = 1; 

E0 = excitation(Imax,Nmsi,Itol,noAP,[0 102e-3],M,ramp(0,100e-3));        

MSAVE = M;
for n=1:length(P)
    M = MSAVE;
    M.X0 = x0patch([0 100e-3],pulse(-E0*P(n),100e-3),M);
    V(n) = M.X0(1);
    T(n) = excitation(Imax,Nmsi,Itol,noAP,[0 2e-3],M,pulse(0,1e-3))-E0*P(n);                
end