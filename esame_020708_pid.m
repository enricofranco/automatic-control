clear all, close all
s = tf('s');
F = (4*s^2+1200*s+90000)/(s^3+154*s^2+5600*s+20000);
step(F), grid
tf = 0.3;
tetaf = 0.01;
kf = 4.5;
kp = 1.2*tf/(kf*tetaf);
ti = 2*tetaf;
td = 0.5*tetaf;
n = 10;
R = kp*(1+1/(ti*s)+td*s/(1+td*s/n));
W = feedback(R*F,1);
figure, step(W), grid