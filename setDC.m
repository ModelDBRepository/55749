function [Sout] = setDC(Sin,Idc)
%SETDC Set the DC level of a stimulus
%   [Sout] = setDC(Sin,Idc)
Sout = Sin;
Sout(7) = Idc;