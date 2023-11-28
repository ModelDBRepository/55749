function [G] = geometry(D)
%GEOMETRY The geometry of a myelinated motor axon
%   [G] = geometry(D)
%
%Note D in um
di = -0.468*D/(0.018*D-1);

G.D  = D*1e-6;
G.di = (-0.468*D/(0.018*D-1))*1e-6;
G.dn = 1e-6*(di + 0.67)/2.72;
G.nl = round(23.13 - 1.89*di + 142.79*log10(di));
G.l  = 1e-6;
G.L  = 1e-6*(-91.1 - 20.2*di + 1745.9*log10(di));