function [Cn,Ci,Cm] = electrical(G)
%ELECTRICAL The electrical parameters of the patch model
%   [Cn,Ci,Cm] = electrical(G)
cn = 0.020; %F/m^2 nodal capacitance
cm = 0.001; %F/m^2 myelin capacitance
ci = 0.010; %F/m^2 internodal capacitance

tmp = 0;
d = G.di + (1:2*G.nl)/(2*G.nl)*(G.D-G.di);
for n = 1:2*G.nl
    tmp = tmp + 1/(cm*pi*d(n)*G.L);
end

Cm = 1/tmp;
Cn = cn*pi*G.dn*G.l;
Ci = ci*pi*G.di*G.L;





