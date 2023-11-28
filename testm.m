function [T] = testm(M)
%TEST Test the model
tic
fprintf('Testing response ... ');
[T.RESP.t,T.RESP.En,T.RESP.E0] = testresp([0 1.5e-3],M);
fprintf('done.\n');

fprintf('Strength-Duration Curce ');
T.M = M;
[T.SD.R,T.SD.T] = SDstat(M,0);
fprintf('done.\n');

fprintf('Threshold Electrotonus ');
T.TE.TD = 1e-3*[0 10 20 30 40 50 60 70 80 99 101 110 120 130 140 150];
T.TE.P  = [0.4];
[T.TE.E,T.TE.E0,T.TE.T,T.TE.V] = te(M,T.TE.TD,T.TE.P,0);
fprintf('done.\n');

fprintf('Strength-Intensity ');
T.SI.P = [0 0.2 0.4 0.6 0.8]*100;
T.SI.R0 = ramp_thr(100e-3,M);
T.SI.I = T.SI.R0*T.SI.P/100;
[T.SI.T,T.SI.V,T.SI.E0] = si(100e-3,M,T.SI.I);
fprintf('done.\n');

fprintf('Recovery Curve ');
T.RE.Tisi = [2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100];
[T.RE.E,T.RE.E0] = recovery(T.RE.Tisi*1e-3,M,0,3.1,1e-3);
T.RE.R = 100*(T.RE.E-T.RE.E0)/T.RE.E0;

fprintf('Accommodation curve ');
T.AC.TS = 1e-3*[10 25 48.5 100 200];
[T.AC.A,T.AC.S,T.AC.E] = acurve(M,T.AC.TS,0);
fprintf('done.\n');

fprintf('Accommodation slope ');
T.SLOPE.TAU = 48.5e-3;
T.SLOPE.AC = T.AC.A(3)/48.5e-3;
T.SLOPE.E = T.AC.E(3);
fprintf('done.\n');

fprintf('Response to 200ms expr ...');
tspan = [0 -T.AC.TS(length(T.AC.TS))*log(0.05)];
[APs,T.EXPR.t,T.EXPR.En] = resp(tspan,50,M,expr(-T.AC.E(length(T.AC.E)),T.AC.TS(length(T.AC.TS))));

fprintf('Response to 100ms rectangular ...');
Imax = 10e-9; Nmsi = 5; Itol = 0.00001e-9; noAP = 1; 
Srheo = pulse(0,100e-3); Sdc = setDC(Srheo,0);
T.RHEO.R = excitation(Imax,Nmsi,Itol,noAP,[0 102e-3],M,Srheo);

[APs,T.RHEO.t,T.RHEO.En] = resp([0 102e-3],4,M,pulse(-T.RHEO.R,100e-3));
[TMP,I] = max(T.RHEO.En);
T.RHEO.L = T.RHEO.t(I);

time = toc;
fprintf('\nTime: %.0fs\n',time);
plotTest(T)
        
