function [model] = model_Nap(X)
%MODEL_NAP The model for studying the effects of the persistent sodium current
%   [model] = model_v1(X)
%
% X:
%    X(1)    gNap
%    X(2)    Enap
%    X(3)    Rnap
%
% default: [2.5 -20 0.5]
% model:
%    E  GN GI A B X0
D = 14; %The defualt diameter of the nerve fiber

R = 8.3144;
F = 96485;

%Electrical properties
T     = 37;
NAi   = 0.009;
NAo   = 0.1442;
Ki    = 0.155;
Ko    = 0.003;

eNa = (R*(273.15+T)/F)*log(NAo/NAi);
eK  = (R*(273.15+T)/F)*log(Ko/Ki);

fprintf('Ionic equilibrium potentials: Ena %.1fmV, Ek %.1fmV\n',eNa*1e3,eK*1e3);
G = geometry(D);
[Cn,Ci,Cm] = electrical(G);
Ril = 41e6;

E = [Cn Ci Cm Ril eNa eK];

%Rate constants 
q10m = 2.2;
q10h = 2.9;
q10p = 2.2;
q10n = 3.0;
q10s = 3.0;

Enap = X(2);
A = [ q10(q10m,T)*1.86    -18.4  10.3;...
      q10(q10h,T)*0.0336  -111.0 11;...
 X(3)*q10(q10p,T)*1.86    -18.4+Enap  10.3;...
      q10(q10n,T)*0.00798 -93.2  1.1;...
      q10(q10s,T)*0.00122 -12.5  16.9];
      
B = [ q10(q10m,T)*0.086    -22.7 9.16;...
      q10(q10h,T)*2.3      -28.8 13.4;...
 X(3)*q10(q10p,T)*0.086    -22.7+Enap 9.16;...
      q10(q10n,T)*0.0142   -76   10.5;...
      q10(q10s,T)*0.000739 -80.1 12.6];

%The node
Vr = -83.5e-3;
m0n = m0(Vr*1e3,A,B);
h0n = h0(Vr*1e3,A,B);
p0n = p0(Vr*1e3,A,B);
n0n = n0(Vr*1e3,A,B);
s0n = s0(Vr*1e3,A,B);

area_n = (Cn+Cm)/1.4e-12; 
area_i = Ci/1.4e-12;

gNap_n = 1000*13;

fracNap = X(1)/100;
gNaf_n = (1-fracNap) * gNap_n*2*pi*G.dn*G.l;
gNap_n =    fracNap  * gNap_n*2*pi*G.dn*G.l;
gKs_n  = 800*2*pi*G.dn*G.l;
gKf_n  = area_n * 15e-9;
GN = [gNaf_n gNap_n gKf_n gKs_n];

%The internode
In = Iion_n(Vr,m0n,h0n,p0n,n0n,s0n,eNa,eK,gNaf_n,gNap_n,gKs_n,gKf_n);
Vi = Ril*In+Vr;

m0i = m0(Vi*1e3,A,B);
h0i = h0(Vi*1e3,A,B);
s0i = s0(Vi*1e3,A,B);

gNaf_i = 0;
gKs_i = 5*gKs_n;  
eL_i  = eNa;
Ii = Iion_i(Vi,m0i,h0i,s0i,eNa,eK,gNaf_i,gKs_i,0,0);
gL_i  = -((Vi - Vr)/Ril + Ii)/(Vi-eL_i);

GI = [gNaf_i gKs_i gL_i eL_i];

X0 = [Vr Vi m0n h0n p0n n0n s0n m0i h0i s0i];

%    E  GN GI A B X0
model.PAR = X;
model.E = E;
model.GN = GN;
model.GI = GI;
model.A = A;
model.B = B;
model.X0 = X0;

function [k] = q10(q,T)
%Q10 Caculate the Q10 Factor
%   [k] = q10(q,Th,Tl) this function returns the q10 factor with
%   which the gating coefficients should be scaled in order to 
%   obtain a model for a higher temperatures than the original data
%   was recorded with.

k = q^((T-20)/10);
return

function [x] = type1(E,A,B,C)
x = A*(E-B)/(1 - exp((B-E)/C));
return

function [x] = type2(E,A,B,C)
x = A*(B-E)/(1 - exp((E-B)/C));
return

function [x] = type3(E,A,B,C)
x = A./(1+exp((B-E)/C));
return

function [x] = m0(E,A,B)
alpha = type1(E,A(1,1),A(1,2),A(1,3));
beta  = type2(E,B(1,1),B(1,2),B(1,3));
x     = alpha/(alpha+beta);
return

function [x] = h0(E,A,B)
alpha = type2(E,A(2,1),A(2,2),A(2,3));
beta  = type3(E,B(2,1),B(2,2),B(2,3));
x     = alpha/(alpha+beta);
return

function [x] = p0(E,A,B)
alpha = type1(E,A(3,1),A(3,2),A(3,3));
beta  = type2(E,B(3,1),B(3,2),B(3,3));
x     = alpha/(alpha+beta);
return

function [x] = n0(E,A,B)
alpha = type1(E,A(4,1),A(4,2),A(4,3));
beta  = type2(E,B(4,1),B(4,2),B(4,3));
x     = alpha/(alpha+beta);
return

function [x] = s0(E,A,B)
alpha = type1(E,A(5,1),A(5,2),A(5,3));
beta  = type2(E,B(5,1),B(5,2),B(5,3));
x     = alpha/(alpha+beta);
return

function [I] = Iion_n(E,m,h,p,n,s,eNa,eK,gNaf,gNap,gKs,gKf)
iNaf = gNaf*(m^3)*h*(E-eNa);
iNap = gNap*(p^3)*(E-eNa);
iKs  = gKs*s*(E-eK);
iKf  = gKf*(n^4)*(E-eK);
I = iNaf + iNap + iKs + iKf;
return

function [I] = Iion_i(E,m,h,s,eNa,eK,gNaf,gKs,gL,eL)
iNaf  = gNaf*(m^3)*h*(E-eNa);
iKs   = gKs*s*(E-eK);
iL    = gL*(E-eL);
I = iNaf + iKs + iL;
return
