clear all, close all
s = tf('s');
F1 = 5/s;
F2 = (s+20)/(s+1)/(s+5)^2;
Kf1 = dcgain(F1*s)
Kf2 = dcgain(F2)

Kc1 = 1/(0.05*Kf1*Kf2);
Kc3 = .1/(.01*Kf1*Kf2);
Kc_min = max(Kc1,Kc3)

bode(F1*F2) % stabilita regolare
Kc = Kc_min;

ts = 1;
wcd = 3*.63/ts; % 1.89
wcd = 1.9;
mr_db = 2.5;
mfi_min = 60-5*mr_db; % 47.5

Ga1 = Kc*F1*F2;
figure, bode(Ga1), grid
[m1,f1] = bode(Ga1, wcd)
% attenuare modulo - recuperare > 55

% 2 reti attenuatrici
md1 = 4; xd1 = 1.1;
taud1 = xd1/wcd;
Rd1 = (1+taud1*s)/(1+taud1/md1*s);
md2 = 3; xd2 = sqrt(md2);
taud2 = xd2/wcd;
Rd2 = (1+taud2*s)/(1+taud2/md2*s);
Rd = Rd1*Rd2;
Ga2 = Ga1*Rd;
figure, bode(Ga2), grid
[m2,f2] = bode(Ga2, wcd)
% attenuare 10.68 - perdere < 6

mi = 10.7;
figure, bode((1+s/mi)/(1+s)), grid
xi = 180; taui = xi/wcd;
Ri = (1+taui/mi*s)/(1+taui*s);
Ga3 = Ga2*Ri;
figure, margin(Ga3)

C = Kc*Rd*Ri;
W = feedback(C*F1*F2, 1);
figure, bode(W), grid
figure, step(W), grid

Wu = C*feedback(1,Ga3);
figure, step(Wu), grid

% discretizzazione
wB = 3.7;
T = 0.005;
Gazoh = Ga3/(1+s*T/2);
figure, margin(Gazoh)

Cz1 = c2d(C, T, 'tustin');
Cz2 = c2d(C, T, 'zoh');
Cz3 = c2d(C, T, 'matched');