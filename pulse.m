function [S] = pulse(Is,Ts)
%PULSE Creates a pulse
%   [S] = pulse(Is,Ts)
S = [0 Is Ts 0 0 0 0];