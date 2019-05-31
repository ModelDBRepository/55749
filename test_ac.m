function [T] = test_ac(X,TS)
%TEST_AC Test accommodation curve and the action potential
%   [T] = test_ac(X,TS) this function test the accommodation curve
%   and the shape of the action potential. The parameters to the 
%   model is [X] which contains [pNap Vnap Tau]. The time-constants
%   to be used in the accommodation curve is given in [TS]. If [TS]
%   is [] then a default value is used. 
%
%   Defaults:
%      [X]  = [2.5 -20 0.5].
%      [TS] = [10 20 30 40 50 100 150 200]
%   
%   If TS(1) = 0 then no accommodation curve is determined
TSref = [10 20 30 40 50 100 200];
Aref = [1.11 1.26 1.43 1.58 1.69 1.89 2.01];


Imax = 10e-9; Nmsi = 10; Itol = 0.0001e-9; noAP = 1; 

if length(TS) == 0
    TS = [10 20 30 40 50 100 200]*1e-3;
else
    TS = TS*1e-3;
end

if length(X) == 0
    X = [2.5 -20 0.5];
end

M = model_nap(X);
T.TS = TS*1e3;
T.X = X;

%Estimate the excitation threshold to a 0.1ms stimuli
S = ramp(0,0.05e-3);
S = setDC(S,0);
T.E0 = excitation(Imax,Nmsi,Itol,noAP,[0 2e-3],M,S);     
S = ramp(-T.E0,0.05e-3);
S = setDC(S,0);
[T.AP,T.t,T.En] = resp([0 2e-3],4,M,S);

if TS(1) ~= 0  
   [T.A,T.S,T.E] = acurve(M,TS,0);    
   
    figure(1);
    clf;
    subplot(2,1,1);
    plot(T.t,T.En,'k');
    title('Action Potential');
    xlabel('Time [ms]');
    ylabel('Membrane potential [mV]');   
    
    subplot(2,1,2);
    plot(T.TS,T.A,'k.-',TSref,Aref,'k:');
    title('Accommodation Curve');
    xlabel('Time Constants of current rise [ms]');
    ylabel('Excitation Threshold');
else
    disp('No accommodation curve is determined (TS(1) = 0)');
    figure(1);
    clf;
    plot(T.t,T.En,'k');
    title('Action Potential');
    xlabel('Time [ms]');
    ylabel('Membrane potential [mV]');
end
