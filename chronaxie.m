function [C] = chronaxie(Tmax,Ttol,M,Is,Idc)
%CHRONAXIE Estimates the chronaxie
%   [C] = chronaxie(Tmax,Ttol,M,Is)

Tb = 0; Tt = Tmax;
while (Tt - Tb) > Ttol
    Ttest = Tb+(Tt-Tb)/2;
    S = pulse(0,Ttest); S = setDC(S,Idc);
    if isAP(-Is,1,[0 Ttest+1e-3],M,S)
        Tt = Ttest;
    else
        Tb = Ttest;
    end
end   
C = Tt;


