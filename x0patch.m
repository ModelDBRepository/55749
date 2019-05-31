function [x0] = x0patch(tspan,S,M)
%X0PATCH Initial conditions
%   [X0] = x0patch(tspan,S,M)
h = 1e-6;
P = parameters(tspan(1),tspan(2),h,1e12,0,1);
simPatch(P,S,M.E,M.GN,M.GI,M.A,M.B,M.X0);
load x0.out

