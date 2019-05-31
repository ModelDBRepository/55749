function [t,En,E0] = testresp(tspan,M)
%TESTRESP Test the response of a model
%   [t,En] = testresp(M)
Ts = 0.1e-3;


Imax = 10e-9; Nmsi = 5; Itol = 0.01e-9; noAP = 1; 
E0 = excitation(Imax,Nmsi,Itol,noAP,[0 1e-3],M,pulse(0,Ts));
[APs,t,En,Ei,Is,Xn,Xi,In,Ii] = resp(tspan,2,M,pulse(-E0,Ts));

fprintf('Action potentials: %d\n',APs);

figure(1);
clf;
%subplot(3,1,1);
plot(t,En,'b',t,Ei,'r',tspan*1e3,[M.X0(1) M.X0(1)]*1e3,'b:',tspan*1e3,[M.X0(2) M.X0(2)]*1e3,'r:');
legend('E_n','E_i');

