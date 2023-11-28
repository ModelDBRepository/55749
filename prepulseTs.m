function [E0p,E0,E] = prepulseTs(Type,P,Tp,Ts,M)
%PREPULSET Estimate the effect of prepulses, where the prepulse duration is changed
%   [E0p,E0,E] = prepulseTs(Type,P,Tp,Ts,M)

Imax = 10e-9; Nmsi = 10; Itol = 0.0001e-9; noAP = 1; 


if Type == 1 
    Sp = pulse(0,Tp); Sp = setDC(Sp,0);
else
    Sp = ramp(0,Tp); Sp = setDC(Sp,0);      
end
E0p = excitation(Imax,Nmsi,Itol,noAP,[0 Tp+1e-3],M,Sp);

MSAVE = M;
if Type == 1 
    Sp = pulse(-P*E0p,Tp); Sp = setDC(Sp,0);
else
    Sp = ramp(-P*E0p,Tp); Sp = setDC(Sp,0);      
end
M.X0 = x0patch([0 Tp],Sp,M); 

for n = 1:length(Ts)
    Spls = pulse(0,Ts(n)); Spls = setDC(Spls,0);
    E0(n) = excitation(Imax,Nmsi,Itol,noAP,[0 Ts(n)+1e-3],MSAVE,Spls);        
    E(n) = excitation(Imax,Nmsi,Itol,noAP,[0 Ts(n)+1e-3],M,Spls); 
    fprintf('.');
end
fprintf('\n');
   
   
   
   
    
    
