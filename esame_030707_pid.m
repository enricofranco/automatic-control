clear all, close all
s = tf('s');
F = (3*s+6)/(s^4+6.5*s^3+12*s^2+4.5*s);
bode(F), grid
figure, step(F), grid
figure, margin(F)
mg = 10^(12.1/20);
T = 2*pi/1.59;
kp = 0.6*mg;
ti = 0.5*T;
td = 0.125*T;
n = 10;
Rpid = kp*(1+1/ti/s+td*s/(1+td/n*s));

W = feedback(Rpid*F, 1);
figure, step(W), grid