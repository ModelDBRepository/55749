function [E0p,E0,E] = prepulseT(Type,P,Tp,Ts,M)
%PREPULSET Estimate the effect of prepulses, where the prepulse duration is changed
%   [E0p,E0,E] = prepulseT(Type,P,Tp,Ts,M)

Imax = 10e-9; Nmsi = 10; Itol = 0.0001e-9; noAP = 1; 

Spls = pulse(0,Ts); Spls = setDC(Spls,0);
E0 = excitation(Imax,Nmsi,Itol,noAP,[0 Ts+1e-3],M,Spls);        

MSAVE = M;
for n = 1:length(Tp)
   M = MSAVE;
   Sp = pulse(0,Tp(n)); Sp = setDC(Sp,0);
   E0p(n) = excitation(Imax,Nmsi,Itol,noAP,[0 Tp(n)+1e-3],M,Sp);
   Sp = pulse(-P*E0p(n),Tp(n)); Sp = setDC(Sp,0);
   M.X0 = x0patch([0 Tp(n)],Sp,M); 
   E(n) = excitation(Imax,Nmsi,Itol,noAP,[0 Ts+1e-3],M,Spls);        
end
   
   
   
   
    
    
