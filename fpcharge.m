function [C] = fpcharge(I,T,Pi,Pt)
%FPCHAR The charge of fixed prepulsed
%   [C] = fpcharge(I,T,Pi,Pt)
C = (Pi*Pt + (1-Pt)) .* I .* T;