function [t,En,E0] = test_fprect(tspan,M,Ts,Pi,Pt)
%TESTRESP Test the response of a model
%   [t,En,E0] = test_fprect(tspan,M,Ts,Tp,P)
Imax = 10e-9; Nmsi = 5; Itol = 0.01e-9; noAP = 1; 

E0 = excitation(Imax,Nmsi,Itol,noAP,[0 1e-3],M,fprect(0,Ts,P,Tp));
%E0 = 0;
[APs,t,En,Ei,Is,Xn,Xi,In,Ii] = resp(tspan,2,M,fprect(-E0,Ts,P,Tp));

fprintf('E0: %.2fpA\n',E0*1e12);
fprintf('Action potentials: %d\n',APs);

figure(1);
clf;

subplot(2,1,1);
plot(t,Is,'b');

subplot(2,1,2);
plot(t,En,'b',t,Ei,'r',tspan*1e3,[M.X0(1) M.X0(1)]*1e3,'b:',tspan*1e3,[M.X0(2) M.X0(2)]*1e3,'r:');
legend('E_n','E_i');

