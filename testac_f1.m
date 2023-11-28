function [t,En,Ei] = testac_f1(pNap,TAU,E,n,m)
%TESTAC Test accommodation
%   testac(pNap,TAU,E)

M = defPatch_f1([1 pNap(n) 1 1]); 
tspan = [0 -TAU(m)*log(0.05)];
[APs,t,En,Ei,Is,Xn,Xi,In,Ii] = resp(tspan,50,M,expr(-E(n,m),TAU(m)));

figure(1);
clf;
plot(t,En,'b',t,Ei,'r');

fName = sprintf('ac%dn%dm',n,m);

save(fName,'APs','t','En','Ei','Is','Xn','Xi','In','Ii');