%Test threshold electrotonus

fprintf('Strength-Duration Curce ...');
T.M = M;
[T.SD.R,T.SD.T,T.SD.ts,T.SD.i] = SDstat(M,0);
fprintf('done.\n');

fprintf('Threshold Electrotonus ...');
T.TE.TD = 1e-3*[0 10 20 30 40 50 60 70 80 99 101 110 120 130 140 150];
T.TE.P  = [0.4];
[T.TE.E,T.TE.E0,T.TE.T,T.TE.V] = te(M,T.TE.TD,T.TE.P,0);
fprintf('done.\n');

T.AC.TS = [];
T.AC.A = [];
T.AC.S = [];
T.AC.E = [];

T.SLOPE.TAU = 48.5e-3;
T.SLOPE.AC = NaN;
T.SLOPE.E = NaN; 

plotTest(T);