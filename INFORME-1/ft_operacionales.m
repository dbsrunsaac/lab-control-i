clc, clear;
C = 1e-6;
R1 = 1;
R2 = 2;
R3 = 3;
R4 = 4;
H = tf([R2*R4], [R1*R2*R3*C R1*R3]);
H
bode(H);
grid on