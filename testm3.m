function [T] = testm(M)
%TEST Test the model

fprintf('Strength-Duration Curce ...');
T.M = M;
tic
[T.SD.R,T.SD.T,T.SD.ts,T.SD.i] = SDstat(M,0);
fprintf('done (%.1fs).\n',toc);

fprintf('Threshold Electrotonus ...');
T.TE.TD = 1e-3*[0 10 20 30 40 60 99 101 110 120 150];
T.TE.P  = [0.4];
tic
[T.TE.E,T.TE.E0,T.TE.T,T.TE.V] = te2(M,T.TE.TD,T.TE.P,0);
fprintf('done (%.1fs).\n',toc);

fprintf('Strength-Intensity Curve ...');
T.SI.P = 0:0.2:0.8;
tic
[T.SI.T,T.SI.V,T.SI.E0] = si(M,T.SI.P);
fprintf('done (%.1fs).\n',toc);

fprintf('Accommodation curve ...');
T.AC.TS = 1e-3*[10 48.5 100 200 300];
tic
[T.AC.A,T.AC.S,T.AC.E] = acurve(M,T.AC.TS,T.SD.R,0);
fprintf('done (%.1fs).\n',toc);

fprintf('Recovery curve ...');
T.RE.Tisi = [3 4 5 6 7 8 9 10 20 30 40 50 60 70 100 200]*1e-3;
tic
[T.RE.E,T.RE.E0] = recovery(T.RE.Tisi,M,0);
fprintf('done (%.1fs).\n',toc);

fprintf('Accommodation slope ...');
T.SLOPE.TAU = 48.5e-3;
T.SLOPE.AC = T.AC.S(2);
T.SLOPE.E = T.AC.E(2);
%[T.SLOPE.AC,T.SLOPE.E] = slope(M,T.SLOPE.TAU,T.SD.R,0);
fprintf('done.\n');

plotTest3(T)
        
