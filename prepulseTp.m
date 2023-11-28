function [E0p,E0,E] = prepulseTp(Type,P,Tp,Ts,M)
%PREPULSET Estimate the effect of prepulses, where the prepulse duration is changed
%   [E0p,E0,E] = prepulseTp(Type,P,Tp,Ts,M)

Imax = 10e-9; Nmsi = 10; Itol = 0.0001e-9; noAP = 1; 
MSAVE = M;

Spls = pulse(0,Ts); Spls = setDC(Spls,0);
E0 = excitation(Imax,Nmsi,Itol,noAP,[0 Ts+1e-3],M,Spls);        

for k = 1:length(P)
    
    for j = 1:length(Tp)
        M = MSAVE;
        if Type == 1 
            Sp = pulse(0,Tp(j)); Sp = setDC(Sp,0);
        else
            Sp = ramp(0,Tp(j)); Sp = setDC(Sp,0);      
        end
        E0p(j) = excitation(Imax,Nmsi,Itol,noAP,[0 Tp(n)+1e-3],M,Sp);
        if Type == 1 
            Sp = pulse(-P*E0p(j),Tp(j)); Sp = setDC(Sp,0);
        else
            Sp = ramp(-P*E0p(j),Tp(j)); Sp = setDC(Sp,0);      
        end   
        M.X0 = x0patch([0 Tp(j)],Sp,M); 
        E(j) = excitation(Imax,Nmsi,Itol,noAP,[0 Ts+1e-3],M,Spls);        
    end
end
   
   
   
    
    
