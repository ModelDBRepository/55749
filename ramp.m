function [S] = ramp(Is,Ts)
%RAMP Creates a ramp stimuli
%   [S] = ramp(Is,Ts)
S = [1 Is Ts 0 0 0 0];