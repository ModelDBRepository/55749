function [E,E0] = recovery(Tisi,M,Idc,Irel,Ts)
%RECOVERY Simulate the recovery cycle
%   [E,E0] = recovery(Tisi,M,Idc,Irel)

%PART 1: Find the excitation threshold for the conditioning pulse
%Ts = 1e-3;
Imax = 10e-9; Nmsi = 10; Itol = 1e-14;
S = pulse(0,Ts);
S = setDC(S,Idc);
E0 = excitation(Imax,Nmsi,Itol,1,[0 2e-3],M,S);        

%PART 2: Simulate the recovery cycle
MSAVE = M;
for n = 1:length(Tisi)
    M = MSAVE;
    S = pulse(-E0*Irel,Ts);
    S = setDC(S,Idc);
    if Tisi(n) ~= 0
        M.X0 = x0patch([0 Tisi(n)],S,M);
    end
   
    E(n) = excitation(Imax,Nmsi,Itol,1,[0 2e-3],M,S);      
    %fprintf('.');
end 