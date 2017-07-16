clear all, close all
s = tf('s');
F1 = (1+s/0.1)/((1+s/0.2)*(1+s/10));
F2 = 1/s;
Kf1 = dcgain(F1);
Kf2 = dcgain(F2*s);

Kcb = 1/(.16*Kf1*Kf2);
bode(F1*F2/s)
Kc = Kcb;
wcd = .63*4; % 2.52
smax = .25;
mr_db = 20*log10((1+smax)/.9); % 2.85
mf_min = 60-5*mr_db; % 45.7

Ga1 = Kc/s*F1*F2;
figure, bode(Ga1), grid
[m1,f1] = bode(Ga1, wcd)

figure, bode(1+s), grid
xz = 3.1; tauz = xz/wcd;
Rz = (1+tauz*s);
Ga2 = Ga1*Rz;
figure, bode(Ga2), grid
[m2,f2] = bode(Ga2, wcd)

mi = 6;
figure, bode((1+s/mi)/(1+s)), grid
xi = 80; taui = xi/wcd;
Ri = (1+s*taui/mi)/(1+taui*s);
Ga3 = Ga2*Ri;
[m3,f3] = bode(Ga3, wcd)
figure, margin(Ga3)

C = Kc/s*Rz*Ri;
W = feedback(C*F1*F2, 1);
figure, bode(W), grid
figure, step(W), grid

Wu = feedback(C,F1*F2);
mu = bode(Wu, .5)