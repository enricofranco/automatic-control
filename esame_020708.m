clear all, close all
s = tf('s');
F1 = 30/(s+15);
F2 = (3*s+3)/(s^3+10*s^2+24*s);
kf1 = dcgain(F1)
kf2 = dcgain(F2*s)

einf = 0.1;
Kc_min1 = 1/(einf*kf1*kf2);
Kc_min2 = 1/(0.05*kf1);
Kc_min = max(Kc_min1, Kc_min2)

bode(F1*F2) % stabilita regolare
Kc = Kc_min;

wb = 20;
wcd = .63*wb; % 12.6
smax = 0.2;
mr_db = 20*log10((1+smax)/.9);
mf_min = 60-5*mr_db; % 47.5

Ga1 = Kc*F1*F2;
[m,f] = bode(Ga1, wcd)

% 2 reti derivative
md = 3; xd = .9;
td = xd/wcd;
Rd1 = (1+td*s)/(1+td/md*s);
Rd = Rd1^2;
Ga2 = Ga1*Rd;
figure, bode(Ga2), grid
[m,f] = bode(Ga2, wcd)
% attenuare modulo di 1.8
% perdere al più 3.5°

mi = 1.8; xi = 15;
ti = xi/wcd;
Ri = (1+ti/mi*s)/(1+ti*s);
Ga3 = Ga2*Ri;
figure, bode(Ga3), grid
figure, margin(Ga3)

W = feedback(Ga3, 1);
figure, step(W), grid
figure, bode(W), grid

C = Kc*Rd*Ri;
T = 2*pi/(20*20.4) % 0.0154
T = 0.01;
Cd = c2d(C, T, 'tustin');
Fd = c2d(F1*F2, T, 'zoh');
Wd = feedback(Cd*Fd, 1);
figure, step(Wd), grid