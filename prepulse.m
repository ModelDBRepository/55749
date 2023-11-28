function [E0p,E0,E,R] = prepulse(Type,P,Tp,Ts,M)
%PREPULSET Estimate the effect of prepulses, where the prepulse duration and intensity is changed
%   [E0p,E0,E,P] = prepulse(Type,P,Tp,Ts,M)

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
        E0p(k,j) = excitation(Imax,Nmsi,Itol,noAP,[0 Tp(j)+1e-3],M,Sp);
        if Type == 1 
            Sp = pulse(-P(k)*E0p(k,j),Tp(j)); Sp = setDC(Sp,0);
        else
            Sp = ramp(-P(k)*E0p(k,j),Tp(j)); Sp = setDC(Sp,0);      
        end   
        M.X0 = x0patch([0 Tp(j)],Sp,M); 
        E(k,j) = excitation(Imax,Nmsi,Itol,noAP,[0 Ts+1e-3],M,Spls);        
        R(k,j) = 100*(E(k,j)-E0)/E0;
        fprintf('%d / %d : %d / %d percent complete.\n',k,length(P),j,length(Tp));
    end
end
   
   
   
    
    
