%TEST The function for determining the recovery cycle

Tisi = [1 1.5 2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 100 200]*1e-3;
load model2_x
M = defPatch2(X);
[E,E0] = recovery(Tisi,M,0);

Tre1 = 100*[NaN NaN NaN -2.2 -3.5 -3.7 -3.85 -3.7 -3.5  -3.25 -2.9 -0.75 0.3 0.55 0.65 0.6 0.4 -0.15 -0.35]/9.9;
Tre2 = 100*[NaN NaN NaN 3.9  0   -1.2 -1.45 -1.3  -1.1 -0.8  -0.5 1.1   2   2.4  2.45 2.3 2.1  1.2   0.35]/9.9;
Tre = (Tre1+Tre2)/2;

figure(1);
plot(Tisi,100*(E-E0)/E0,'k',...
     Tisi,Tre,'b',...
     Tisi,Tre1,'b:',...
     Tisi,Tre2,'b:');