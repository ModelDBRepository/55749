function [E,t,APs] = electrotonus(I,M)
%ELECTROTONUS Simulate the electrotonic response to a 100ms rectangular pulse
%   [E,t,APs] = electrotonus(I,M)
S = pulse(-I,100e-3);
S = setDC(S,0);
[APs,t,E] = resp([0 100]*1e-3,500,M,S);


