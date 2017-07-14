clear all, close all
s = tf('s');
F = (100*s+1000)/(s^5+38*s^4+481*s^3+2280*s^2+3600*s);
margin(F)
Kps = 10^(27.1/20);
Kp = 0.6*Kps;
T = 2*pi/(3.54);
ti = 0.5*T;
td = 0.125*T;
n = 10;
Rpid = Kp*(1+1/(ti*s)+td*s/(1+td*s/n));
figure, margin(Rpid*F)
W = feedback(F*Rpid, 1);
figure, step(W), grid
figure, bode(W), grid