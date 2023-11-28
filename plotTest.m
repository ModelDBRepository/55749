function plotTest(T)
%PLOTTEST
%   plotTest(T)

fprintf('Characteristics of the model\n');
fprintf('Chronaxie = %.2fus \n',T.SD.T*1e6);
fprintf('Rheobase  = %.3fnA \n',T.SD.R*1e9);
fprintf('AC Slope  = %.2f   \n',T.SLOPE.AC);

TE_td = [-10 0 0 10 20 30 40 50 60 70 80 90 100 100 110 120 130 140 150];
TEd1 = 100*[0 0 1.55 2.7 2.9 2.65 2.35 2.05 1.95 1.9 1.85 1.8 1.75 -0.4 -1 -1.45 -1.4 -1.35 -1.15]/5;
TEd2 = 100*[0 0 2.3 3.6  4   3.75 3.35 3  2.8 2.65 2.6 2.6 2.65 0.8 -0.2 -0.55 -0.6 -0.5 -0.4]/5;

Tisi = [2 3 4 5 6 7 8 9 10 20 30 40 50 60 70 80 90 100];
RE1  = [0 -19.3 -27.9 -30.5 -30.5 -29.8   -29.1 -26.3 -24.6 -7.5  1.9  4.2 1.7 0  -1.6   -2 -3.2 -3.4];
RE2  = [103.8 48.9  19.3     0  -6.1  -4.9  -3.3  -0.7  0.7 13.9 20.5  21 20 19.4 17.7 14.8 12.2 10.8];
    
SI_P = [0 20 40 60 80];
SI_MEAN =  [0 -9.46 -7.796 1.75 14.8];
SI_ERROR = [0 0.8   1.25   2.68  4.38]*3.96;


TO = (40-(TEd1(3)+TEd2(3))/2)*0;

figure(2);
clf;
subplot(2,2,1);
plot(T.TE.TD*1e3,-100*(T.TE.E-T.TE.E0)/T.TE.E0,'k.-');
hold on
plot(TE_td,TEd1,'b:',TE_td,TEd2,'b:');
te_valid

axis([-10 150 -50 100]);
title(sprintf('Threshold Electrotonus: %.2f  %.2f  %.2f  %.2f  %.2f',T.M.PAR(1),T.M.PAR(2),T.M.PAR(3),T.M.PAR(4),T.M.PAR(5)));
xlabel('Delay [ms]');
ylabel('Threshold reduction [%]');

subplot(2,2,2);
semilogx(Tisi,RE1,'r-',Tisi,RE2,'r-',T.RE.Tisi,T.RE.R,'k-');
axis([1 100 -40 40]);
title('Recovery Curve');
xlabel('Delay [ms]');
ylabel('Excitation Threshold');


 subplot(2,2,3);
 plot(T.AC.TS*1e3,T.AC.A,'k.-');
 title(sprintf('Accommodation Curve: Chronaxie %.2f',T.SD.T*1e6));
 xlabel('Time-constant of current rise');
 ylabel('Relative Current threshold');
 
subplot(2,2,4);
plot(T.SI.P,100*(T.SI.T-T.SI.E0)/T.SI.E0,'k.-',...
     SI_P,SI_MEAN-SI_ERROR,'b:',...
     SI_P,SI_MEAN+SI_ERROR,'b:',...
     SI_P,SI_MEAN,'b.-');
title('Strength-Intensity Curve');
xlabel('Prepulse intensity [Rheobase]');
ylabel('Threshold [E0]');

figure(1);
subplot(2,1,1);
plot(T.RESP.t,T.RESP.En,'k');

subplot(2,1,2);
plot(T.EXPR.t,T.EXPR.En,'k');
