function [C,R] = weiss2(T,I)
%WEISS2 Estimate rheobase and chronaxie based on 2 thresholds and Weiss's law
%   [C,R] = weiss2(T,I)
C = (I(2)-I(1))/(I(1)/T(2)-I(2)/T(1));
R = I(1)/(1+C/T(1));