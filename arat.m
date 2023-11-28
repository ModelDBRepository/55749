function [AR,R,T,A1,A2] = arat(M,Idc)
%ARATIO Accommodation Ratio
%   [R] = aratio(M)
TS = [10 100 200]*1e-3;

[R,T] = SDstat(M,Idc)
[A,S,E] = acurve(M,TS,R,Idc);
A1 = (A(2)-A(1))/(TS(2)-TS(1));
A2 = (A(3)-A(2))/(TS(3)-TS(2));


AR = A2/A1;

plot(TS*1e3,A);