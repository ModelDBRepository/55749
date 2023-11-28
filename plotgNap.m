function [E] = plotgNap(M)
%FITGKS Fit the kinetics of gKs to the Bostock and Baker model
%   [E] = fitgKs(X,V)
%
%X = [q10 asC asB]
%
%Defualt [3.0 23.6 21.6]

E = -100:1:40;

I = find(E == -60);


for n = 1:length(E)
am(n) = type1(E(n),M.A(1,1),M.A(1,2),M.A(1,3)); %23.6
bm(n) = type2(E(n),M.B(1,1),M.B(1,2),M.B(1,3)); %23.6
ap(n) = type1(E(n),M.A(3,1),M.A(3,2),M.A(3,3)); %23.6
bp(n) = type2(E(n),M.B(3,1),M.B(3,2),M.B(3,3)); %23.6
end

t_m = 1 ./ (am + bm);
t_p = 1 ./ (ap + bp);
x_m = am .* t_m;
x_p = ap .* t_p;

    figure(1);
    clf;
    subplot(1,2,1);
    plot(E,t_m,'r',E,t_p,'b');
    subplot(1,2,2);
    plot(E,x_m,'r',E,x_p,'b');

%----------------------------------------------------------------------------------------
%
%   LOCAL FUNCTIONS
%
%----------------------------------------------------------------------------------------

function [k] = q10(q,Th)
%Q10 Caculate the Q10 Factor
%   [k] = q10(q,Th,Tl) this function returns the q10 factor with
%   which the gating coefficients should be scaled in order to 
%   obtain a model for a higher temperatures than the original data
%   was recorded with.

k = q^((Th-20)/10);
return

function [x] = type1(E,A,B,C)
DIV = 1 - exp((B-E)/C); MASK = DIV == 0;
x = A*(~MASK.*(E-B)/(DIV+MASK) + MASK*C);
return

function [x] = type2(E,A,B,C)
DIV = 1 - exp((E-B)/C); MASK = DIV == 0;
x = A*(~MASK.*(B-E)/(DIV+MASK) + MASK*C);
return

function [x] = type3(E,A,B,C)
x = A./(1+exp((B-E)/C));
return

function [x] = type4(E,A,B,C)
x = A*exp((E-B)/C);
return

function [x] = type5(E,A,B,C)
x = A./exp((E-B)/C);
return
