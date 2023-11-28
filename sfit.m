function [Sf] = sfit(P,TD,TAU)
Sf = 100-P*exp(-TD/TAU);
end
