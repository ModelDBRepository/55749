function [S] = fprect2(Is,Ts,P,Tp)
%FPRECT Creates a fixed prepulse
%   [S] = fprect(Is,Ts,P,Tp)
S = [6 Is Ts P Tp 0 0];