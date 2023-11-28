function [k] = kin(V,A,B)
%KIN The kinetics of the channels
%   [k] = kin(V,A,B)
%
% X:
%    X(1)    Ril
%    X(2)    nKs_i
%    X(3)    pNap
%    X(4)    Vr
%    X(5)    Nna
%
% default: [21 11 0 -84 1000]
% model:
%    E  GN GI A B X0
k.V = V;
for n = 1:length(V)
    k.m0(n) = m0(V(n),A,B);
    k.h0(n) = h0(V(n),A,B);
    k.p0(n) = p0(V(n),A,B);
    k.n0(n) = n0(V(n),A,B);
    k.s0(n) = s0(V(n),A,B);
end

for n = 1:length(V)
    k.m_tau(n) = m_tau(V(n),A,B);
    k.h_tau(n) = h_tau(V(n),A,B);
    k.p_tau(n) = p_tau(V(n),A,B);
    k.n_tau(n) = n_tau(V(n),A,B);
    k.s_tau(n) = s_tau(V(n),A,B);
end


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

function [x] = m_tau(E,A,B)
alpha = type1(E,A(1,1),A(1,2),A(1,3));
beta  = type2(E,B(1,1),B(1,2),B(1,3));
x     = 1/(alpha+beta);
return

function [x] = p_tau(E,A,B)
alpha = type2(E,A(2,1),A(2,2),A(2,3));
beta  = type3(E,B(2,1),B(2,2),B(2,3));
x     = 1/(alpha+beta);
return

function [x] = h_tau(E,A,B)
alpha = type1(E,A(3,1),A(3,2),A(3,3));
beta  = type2(E,B(3,1),B(3,2),B(3,3));
x     = 1/(alpha+beta);
return

function [x] = n_tau(E,A,B)
alpha = type1(E,A(4,1),A(4,2),A(4,3));
beta  = type2(E,B(4,1),B(4,2),B(4,3));
x     = 1/(alpha+beta);
return

function [x] = s_tau(E,A,B)
alpha = type1(E,A(5,1),A(5,2),A(5,3));
beta  = type2(E,B(5,1),B(5,2),B(5,3));
x     = 1/(alpha+beta);
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
