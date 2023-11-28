function [P2,E1,E2] = fitIS(P,M1,M2,TS)
%FITTE Fit the TE of two models together so their electrotonic responses are as close as possible
%   [P2] = fitIS(P,M1,M2)
Imax = 10e-9; Nmsi = 5; Itol = 0.0001e-9; noAP = 1; 

[S] = pulse(0,1e-3);  
S = setDC(S,0);
E02 = excitation(Imax,Nmsi,Itol,noAP,[0 2e-3],M2,S);
E01 = excitation(Imax,Nmsi,Itol,noAP,[0 2e-3],M1,S);        

X0 = x0patch([0 TS],pulse(-P*E01,100e-3),M1);
%Match the electrotonic response of model 2 to model 1
OPTIONS = optimset('MaxIter',10000,'LevenbergMarquardt','off','TolX',0.01);

[I02] = FMINBND(@erre,0,2,OPTIONS,X0(1),M2,TS)*1e-9;
P2 = I02/E02;

X02 = x0patch([0 TS],pulse(-E02*P2,100e-3),M2);
E1 = X0(1); E2 = X02(1);

function [err] = erre(I,E1,M2,TS)
X02 = x0patch([0 TS],pulse(-I*1e-9,100e-3),M2);
err = 1e6*(E1-X02(1)).^2;
fprintf('TEST I = %5.4fnA = %f: E1 = %6.3fmV, E2 = %6.3fmV\n',I,err,E1*1e3,X02(1)*1e3);
end;