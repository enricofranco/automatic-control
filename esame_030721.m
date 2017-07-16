clear all, close all
s = tf('s');
F = 10*(s+10)/(s^2+0.5*s+25);
Kf = dcgain(F);

Kca = 1/(1.25e-4*Kf);
Kcc = 1/(2.5e-4*Kf);
bode(F/s)
Kc = max(Kca, Kcc);

ts = 0.04;
smax = 0.35;
wcd = .63*3/ts; % 47.25
wcd = 43;
mr_db = 20*log10((1+smax)/0.9); % 3.52
mf_min = 60-5*mr_db; % 42.4

Ga1 = Kc/s*F;
figure, bode(Ga1), grid
[m1,f1] = bode(Ga1,wcd)

figure, bode(1+s), grid
xz = 2.1;
tauz = xz/wcd;
Rz = 1+tauz*s;
Ga2 = Ga1*Rz;
figure, bode(Ga2), grid
[m2,f2] = bode(Ga2,wcd)

mi = 25.4;
figure, bode((1+s/mi)/(1+s)), grid
xi = 600; taui = xi/wcd;
Ri = (1+s*taui/mi)/(1+taui*s);
Ga3 = Ga2*Ri;
figure, bode(Ga3), grid
[m3,f3] = bode(Ga3,wcd)
figure, margin(Ga3)

C = Kc/s*Rz*Ri;
W = feedback(C*F,1);
figure, step(W), grid
figure, bode(W), grid