clc, clear;
C = 100e-6;
R = 1.1e3;
R1 = R;
R2 = R;
R3 = R;
R4 = R;

H = tf([R2*R4], [R1*R2*R3*C R1*R3]);
H
bode(H);
grid on