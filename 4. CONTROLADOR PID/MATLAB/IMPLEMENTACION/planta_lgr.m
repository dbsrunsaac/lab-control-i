clear, clc;
Kp = 1;
num = [Kp*325];
den = [1 20 325]; 
sys = tf(num,den);

% Gráficando el LGR de la planta
rlocus(sys);
grid on;
title('Lugar Geométrico S. Subamortiguado');
Kc = 0.4822;
num_com = [Kc*325 Kc*2600]
den_com = [1 0.0302 0.5286 3.3085]
sys_com = tf(num_com, den_com);

rlocus(sys_com);
grid on;

% LGR de la planta con el compensador
