clear, clc;
Kp = 1;
num = [Kp*325];
den = [1 20 325]; 
sys = tf(num,den);

% Gráficando el LGR de la planta
rlocus(sys);
grid on;z
title('Lugar Geométrico S. Subamortiguado');