function [E,E0,T,V] = te(M,TD,P,Idc)
%TE Threshold Electrotonus
%   [E,E0,T,V] = te(M,TD,P,Idc)

Imax = 10e-9; Nmsi = 5; Itol = 0.0001e-9; noAP = 1; 

[S] = pulse(0,1e-3);  
S = setDC(S,0);
E0 = excitation(Imax,Nmsi,Itol,noAP,[0 2e-3],M,S);        

V = [];
for n = 1:length(P)
    S = pulse(-E0*P(n),100e-3);  
    S = setDC(S,Idc);
    [APs,T,En] = resp([-20 120]*1e-3,500,M,S);
    V = [V En];
    fprintf('.');
end

MSAVE = M;
for n = 1:length(P)
    for k = 1:length(TD)
        %fprintf('Threshold Electrotonus P = %.2f Tdelay = %.2fms\n',P(n),TD(k)*1e3);
        M = MSAVE;
        S = pulse(-E0*P(n),100e-3);   
        S = setDC(S,Idc);
        if TD(k) ~= 0
            M.X0 = x0patch([0 TD(k)],S,M);
        end
        tspan = [TD(k) TD(k) + 2e-3];
        S = cpulse(0, 1e-3, TD(k), -E0*P(n), 100e-3);
        S = setDC(S,Idc);
        E(n,k) = excitation(Imax,Nmsi,Itol,noAP,tspan,M,S);        
        fprintf('.');
    end
end