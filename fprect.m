function [S] = fprect(Is,Ts,Pi,Pt)
%FPRECT Creates a fixed prepulse
%   [S] = fprect(Is,Ts,P,Tp)
S = [5 Is Ts Pi Pt 0 0];