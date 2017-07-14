clear all, close all
s = tf('s');
Gp = -0.65/(s^3+4*s^2+1.75*s);
A = 9;
F = A*Gp; Kf = dcgain(F*s);

einf = 0.2;
Kc1 = 1/(einf*Kf);

A1 = 5.5e-3;
d1 = 6e-4;
Kc2 = A1/A/d1;

A2 = A1;
d1 = 1.5e-3;
Kc3 = A2/Kf/d1;

bode(F)
figure, nyquist(F)

Kc = Kc1;

ts = 1;
wcd = .63*3/ts; % 1.89
wcd = 1.95;
smax = 0.3;
mr_db = 20*log10((1+smax)/0.9);
% margine di fase di 44°

Ga1 = Kc*F;
figure, bode(Ga1), grid
[m,f] = bode(Ga1, wcd)
% recuperare almeno 58°

% 2 reti anticipatrici
md = 4; xd = 1.25;
td = xd/wcd;
Rd = ((1+td*s)/(1+td/md*s))^2;
Ga2 = Ga1*Rd;
figure, bode(Ga2), grid
[m,f] = bode(Ga2, wcd)

% attenuazione di 1.4
% perdita di 10°
% attenuatrice
mi = 1.4;
figure, bode((1+s/mi)/(1+s)), grid
xi = 40; ti = xi/wcd;
Ri = (1+s*ti/mi)/(1+s*ti);
Ga3 = Ga2*Ri;
figure, margin(Ga3)

C = Kc*Rd*Ri;
W = feedback(C*F, 1);
figure, step(W), grid
figure, bode(W), grid

Wu = -C*feedback(1,Ga3);
[m,f] = bode(Wu, 30);
udp_inf = m*1e-3

T = 0.08;
Gazoh = Ga3/(1+s*T/2);
figure, margin(Gazoh)

Cz1 = c2d(C, T, 'tustin');
Cz2 = c2d(C, T, 'zoh');
Cz3 = c2d(C, T, 'matched');