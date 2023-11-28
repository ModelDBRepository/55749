function [TE] = fitTE(P,M1,M2)
%FITTE Fit the TE of two models together so their electrotonic responses are as close as possible
%   [TE] = fitTE(P,M1,M2)
Imax = 10e-9; Nmsi = 5; Itol = 0.0001e-9; noAP = 1; 
TD = [0 10 20 30 40 50 60 70 80 90 99 100 110 120 130 140];

[S] = pulse(0,1e-3);  
S = setDC(S,0);
TE.E02 = excitation(Imax,Nmsi,Itol,noAP,[0 2e-3],M2,S);        


TE.TD = TD;
TE.M1 = M1;
TE.M2 = M2;

%Find the threshold electrotonus of model 1
[TE.E1,TE.E01,TE.T1,TE.V1] = te(M1,TD*1e-3,P,0);
fprintf('\n');

%Match the electrotonic response of model 2 to model 1
OPTIONS = optimset('MaxIter',1000,'LevenbergMarquardt','on','TolX',0.001);

[TE.I02] = FMINBND(@erre,0,10,OPTIONS,electrotonus(TE.E01*P,M1),M1,M2)*1e-9;
TE.P2 = TE.I02/TE.E02;

%Find the threshold electrotonus of model 2
[TE.E2,TE.E02,TE.T2,TE.V2] = te(M2,TD*1e-3,TE.P2,0);


function [err] = erre(I,E1,M1,M2)
err = sum((E1-electrotonus(I*1e-9,M2)).^2);
fprintf('TEST I = %.4fnA = %f\n',I,err);
end;