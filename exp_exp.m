
t = (0:5:100)';

S1 = 1- exp(-t/10);
S2 = 1- exp(-t/25);
S3 = 1- exp(-t/50);

DATA = [t S1 S2 S3];
save exp_exp.txt DATA -ASCII