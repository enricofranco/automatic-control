clear all, close all
s = tf('s');
F1 = 30/(s+15);
F2 = (3*s+3)/(s^3+10*s^2+24*s);
Kf1 = dcgain(F1);
Kf2 = dcgain(F2*s);

Kca = 1/(.1*Kf1*Kf2);
Kcb = 1/(.05*Kf1);
nyquist(F1*F2)
Kc = max(Kca,Kcb)

wb = 20; % 10 %
wcd = .63*wb; % 12.6
smax = .2;
mr_db = 20*log10((1+smax)/.9); % 2.5
mfi_min = 60-5*mr_db; % 47.5

Ga1 = Kc*F1*F2;
figure, bode(Ga1), grid
[m1,f1] = bode(Ga1, wcd) % recuperare 50°

md = 4; xd = .85;
taud = xd/wcd;
Rd = ((1+taud*s)/(1+taud/md*s))^2;
Ga2 = Ga1*Rd;
figure, bode(Ga2), grid
[m2,f2] = bode(Ga2, wcd)

mi = 1.65;
figure, bode((1+s/mi)/(1+s)), grid
xi = 20; taui = xi/wcd;
Ri = (1+taui/mi*s)/(1+taui*s);
Ga3 = Ga2*Ri;
figure, margin(Ga3)

C = Kc*Rd*Ri;
W = feedback(C*F1*F2,1);
figure, bode(W), grid
figure, step(W), grid

sens = feedback(1,Ga3);
err = bode(sens, .2)