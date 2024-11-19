clear, clc;
num = [440.75];
den = [1 42 440.75]; 
sys = tf(num,den);

% Gráficando el LGR de la planta
rlocus(sys);
grid on;
title('Lugar Geométrico S. Subamortiguado');