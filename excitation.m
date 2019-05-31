function [E,NOI] = excitation(Imax,Nmsi,Itol,noAP,tspan,model,stim)
%EXCITATION Estimate the excitation threshold
%   [E,NOI,y1] = excitation(Imax,Nmsi,Itol,noAP,tspan,model,stim) this function
%   estimates the excitation threshold for a nerve fiber [model] to a stimulus
%   [stim]. The timespand for the simulations are [tspan] = [tstart tend]. 
%
%   The threshold is estimated by a binary search algorithm, where the Itop 
%   first are determined. The intial guess for Itop are [Imax], and this 
%   value are used unless it fails to evoke an action potential (AP). If it fails
%   to evoke an AP a linear downwards seach are used, with [Nmsi] steps. If none
%   of these evokes an AP the function returns NaN. The excitation thresholds 
%   are estimated with an precision of [Itol], and the number of simulations
%   are returned in NOI (No of iterations).


%Find the value which produce an action potential.
Etest = Imax:-Imax/Nmsi:Imax/Nmsi;
Et = NaN;
NOI = 0;
n = Nmsi;

%fprintf('Excitation determination: ');
while isnan(Et) & n > 0
    NOI = NOI + 1;
    if isAP(-Etest(n),noAP,tspan,model,stim)
        Et = Etest(n);
    end
    %fprintf('#');
    n = n-1;
end

Eb = 0;

if ~isnan(Et)
    while (Et - Eb) > Itol
        NOI = NOI + 1;
        Etest = Eb+(Et-Eb)/2;
        if isAP(-Etest,noAP,tspan,model,stim)
           Et = Etest;
        else
           Eb = Etest;
        end
    end   
    E = Et;
    %fprintf(' = %.2fnA\n',E*1e9);
else
    E = NaN;
    %fprintf(' = failed\n');
end



