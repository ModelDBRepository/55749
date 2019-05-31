function [APs,t,En,Ei,Is,Xn,Xi,In,Ii] = resp(tspan,Fs,M,S)
%RESP Test the response to a stimulus
%   [APs,t,En,Ei,Is,Xn,Xi,In,Ii] = resp(tspan,Fs,M,S)
h = 2e-6;
P = parameters(tspan(1),tspan(2),h,Fs,0,1);


tspan = [0e-3 2e-3];
h = 1e-6;
APs = simPatch(P,S,M.E,M.GN,M.GI,M.A,M.B,M.X0);
load data.out
t  = data(:,1);
En = data(:,2);
Ei = data(:,3);
Is = data(:,4);
Xn = data(:,5:9);
Xi = data(:,10:12);
In = data(:,13:16);
Ii = data(:,17:18);