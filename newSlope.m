function S = newSlope(T)
%NEWSLOPE
%   S = newSlope(T)
X1 = T.AC.TS(1);
X2 = T.AC.TS(2);
Y1 = T.AC.A(1);
Y2 = T.AC.A(2);

a = (Y2-Y1)/(X2-X1);
b = Y2-a*X2;
S = a + b;
