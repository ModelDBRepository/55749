function [I,TIME] = SDcurveGEN(T,M,S)
%SDCurveGEN this function simulates the strength-duration curve
%   [I] = SDcurve(T,M,S) this function estimate the excitation thresholds
%   [I] for rectangular pulses with durations [T], for the model [M] and the
%   stimulus [S]

%Create the parameters for the excitation function
Imax = 10e-9; Nmsi = 5; Itol = 0.0001e-9; noAP = 1; 

fprintf('PROCESS [');
tic
for n = 1:length(T)
    S(3) = T(n);
    I(n) = excitation(Imax,Nmsi,Itol,noAP,[0 T(n)+1e-3],M,S);
    fprintf('.');
end
TIME = toc;
fprintf('] : %.2fs\n',TIME);