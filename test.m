t0 = 0;
t1 = 120e-3;
h = 1e-6;
Fs = 20;
EarlyStop = 0;
save = 0;

Is = -0.5e-9;
Ts = 48.5e-3;
TAU = 48.5e-3;
Ip = -0.4e-9;
Tp = 100e-3;
Td = 20e-3;

P = parameters(t0,t1,h,Fs,EarlyStop,save);
%S = cpulse(Is,Ts,Td,Ip,Tp);
S = expr(Is,Ts);
M = defPatch(14);

TD = [20 40]*1e-3;
TS = [1 5 10 25 50 100]*1e-3;
P = [0.4];
tic
%[R,T,ts,i] = SDstat(M);
%[AC,E] = slope(M,TAU,R);
%[A,S,E] = acurve(M,TS,R);
%[X0] = x0patch([t0 t1],S,M)
%[E,E0,T,V] = te(M,TD,P);
%[APs,t,En,Ei,Is,Xn,Xi,In,Ii] = resp([t0 t1],25,M,S);
T = testm(M);
time = toc
fprintf('Time: %.2fms\n',(time)*1e3);
%plotTest(T);
% plot(TS,A);

% figure(1);
% plot(TD,-100*(E-E0)/E0,'b');
% APs
% figure(1);
% plot(t,En,'b',t,Ei,'r');
%figure(2);
%plot(t,-Is);
