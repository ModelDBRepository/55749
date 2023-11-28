function rmp_resp(Is)

Xwo = [41 5 0 -83.5 1000];
Mwo = model_v3(Xwo);

Swo = ramp(-Is*1e-9,20e-3);
[APs,t,En,Ei] = resp([0 22e-3],20,Mwo,Swo);

figure(1);
clf;
plot(t,En);