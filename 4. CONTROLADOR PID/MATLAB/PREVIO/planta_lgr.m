clear, clc;
Kp = 1;
num = [Kp*65];
den = [1 2 65]; 
sys = tf(num,den);

% Gráficando el LGR de la planta
rlocus(sys);
grid on;
title('Lugar Geométrico S. Subamortiguado');