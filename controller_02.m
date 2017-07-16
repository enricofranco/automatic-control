clear all, close all
s = tf('s');
Gp = -.65/(s^3+4*s^2+1.75*s);
A = 9;
Kg = dcgain(s*Gp);
Kca = abs(1/(Kg*A*2e-1));
Kcb = abs(5.5e-3/(6e-4*A));
Kcc = abs(5.5e-3/(1.5e-3*A*Kg));

nyquist(Gp) % Kc < 0
Kc = -1.5;

ts = 1;
wb = 3/ts;
wcd = .63*wb; % 1.89
wcd = 2.1;
smax = .3;
mr_db = 20*log10((1+smax)/.9); % 3.19
mf_min = 60-5*mr_db; % 44

Ga1 = Kc*A*Gp;
figure, bode(Ga1), grid
[m1,f1] = bode(Ga1, wcd)

md = 4; xd = 1.25;
taud = xd/wcd;
Rd = ((1+taud*s)/(1+taud/md*s))^2;
Ga2 = Ga1*Rd;
figure, bode(Ga2), grid
[m2,f2] = bode(Ga2, wcd)
figure, margin(Ga2)

C = Kc*Rd;
W = feedback(C*A*Gp,1);
figure, bode(W), grid
figure, step(W), grid