function [TAU,TD,S,E,E0] = latent(M)
%LATENT Estimates the latent addition of a model
%   [TAU,TD,S,E,E0,Sf] = latent(M)
P = 90;

TS = 50e-6;
TD = (0:100:1000)*1e-6;
Imax = 10e-9; Nmsi = 5; Itol = 0.0001e-9; noAP = 1; 

Spls = pulse(0,TS);  
Spls = setDC(Spls,0);
E0 = excitation(Imax,Nmsi,Itol,noAP,[0 1e-3],M,Spls);        
Spls = pulse(-E0*P/100,TS);   
Spls = setDC(Spls,0);

S(1) = 100-P;
E(1) = E0*(1-P/100);
MSAVE = M;
for n = 2:length(TD)
    M = MSAVE;
    M.X0 = x0patch([0 TD(n)],Spls,M);
    E(n) = excitation(Imax,Nmsi,Itol,noAP,[0 1e-3],M,Spls);        
    S(n) = 100*E(n)/E0;
    fprintf('.');
end
TD = TD*1e6;
fprintf('\n');

I = find(S > 100);
for n = 1:I
    S(I(n)) = 100;
end

OPTIONS = optimset('MaxIter',1000,'LevenbergMarquardt','on');
[TAU,FEVAL,EXITFLAG] = FMINBND(@errs,1,1000,OPTIONS,P,TD,S);

% figure(1);
% clf;
% plot(TD,S,'k.-',...
%      TD,sfit(P,TD,TAU),'r.-',...
%      TD,sfit(P,TD,139+59),'m-',...
%      TD,sfit(P,TD,139-59),'m-');
% legend('Model','Fit');

function [R2] = errs(TAU,P,TD,S)
Sf = sfit(P,TD,TAU);
R2 = sum((S-Sf).^2)/sum(Sf.^2);
end

