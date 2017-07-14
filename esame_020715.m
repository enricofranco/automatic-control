clear all, close all
s = tf('s');
F1 = (1+s/0.1)/(1+s/0.2)/(1+s/10);
F2 = 1/s;
Kf1 = dcgain(F1);
Kf2 = dcgain(F2*s);

epar = 0.16;
Kc_min = 1/(epar*Kf1*Kf2);
bode(F1*F2/s) % stabilita regolare
Kc = Kc_min;

Ga1 = Kc/s*F1*F2;
wb = 4; smax = .25;
wcd = 2.35; % 2.52

mr_db = 20*log10((1+smax)/.9)
mfi_min = 60-5*mr_db % 45 °

figure, bode(Ga1), grid
[m,f] = bode(Ga1, wcd)
% recuperare 57°
% attenuare modulo

% 2 reti attenuatrici
md = 4; xd = 1.4;
td = xd/wcd;
Rd1 = (1+td*s)/(1+td/md*s);
Rd = Rd1^2;
Ga2 = Rd*Ga1;
figure, bode(Ga2), grid
[m,f] = bode(Ga2, wcd)

% anticipatrice
mi = 6.2;
figure, bode((1+s/mi)/(1+s)), grid
xi= 100; ti = xi/wcd;
Ri = (1+ti*s/mi)/(1+ti*s);
Ga3 = Ri*Ga2;
figure, bode(Ga3), grid
figure, margin(Ga3)

C = Kc/s*Rd*Ri;
W = feedback(C*F1*F2, 1);
figure, bode(W), grid
figure, step(W), grid

Wu = C*feedback(1,Ga3);
figure, step(Wu), grid % 1.25 picco

wB = 4.28;
T = 0.05;
Gazoh = Ga3/(1+s*T/2);
figure, margin(Ga3)
Cz1 = c2d(C, T, 'tustin');
Cz2 = c2d(C, T, 'zoh');
Cz3 = c2d(C, T, 'matched');
