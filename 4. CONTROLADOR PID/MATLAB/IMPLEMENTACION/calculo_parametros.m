clear, clc;

% Planta
num = [325];
den = [1 20 325];
planta  = tf(num, den);
% Valores de compensación
mp = 6.155; % Reducir el sobrepico
xi = -log(mp/100)/(sqrt(log(mp/100)^2 + pi^2));
disp(["Xi: ", xi]);
ts = 0.5; % Tiempo de establecimiento [s]
wn = 4/(xi*ts);
disp(["Freq Natural: ", wn]);
raices_den = roots(den);
po = raices_den(1);
disp(["Polos Sistema: ",po]);
ps = -xi*wn + wn*sqrt(1-xi^2)*i;
disp(["Polo deseado: ", ps]);
theta1 = atan((imag(ps)--imag(po))/(abs(real(po)) - abs(real(ps))))*180/pi;
theta2 = 180 - atan( (imag(po) - imag(ps)) / (abs(real(po)) - abs(real(ps))))*180/pi;
theta_com = theta1 + theta2 - 180;
disp(["Ang. Comp: ", theta_com]);

cero_com = [1, -real(ps)];
polo_com = [1, -real(ps) + tan(theta_com*pi/180)*imag(ps)];
% Ganancia del compensador Kc
kc = abs(evalfr(tf(conv(den, polo_com), conv(num, cero_com)), ps));
disp(["Gan. Comp", kc]);

% Compensador Adelanto 
Gc = tf(cero_com, polo_com);
Gc
planta

% LGR sistema compensado
sys_comp = tf( conv(kc*cero_com, num), conv(polo_com,den));
rlocus(sys_comp);


% Gráficando la respuesta del sistema
figure;
sys_comp_retro = feedback(sys_comp, 1);
tiempo_simulacion = 3;
subplot(2, 1, 1);
step(sys_comp_retro, tiempo_simulacion);
title('Respuesta al Escalón Unitario - Subamortiguado');
xlabel('Tiempo (s)');
ylabel('Amplitud');
grid on; 
% Subgráfica 2: Respuesta al impulso 
subplot(2, 1, 2); 
impulse(sys_comp_retro, tiempo_simulacion);
title('Respuesta al Impulso Unitario  - Subamortiguado');
xlabel('Tiempo (s)');
ylabel('Amplitud'); 
grid on; 
% Añadir título general 
sgtitle('Respuestas Sistema subamortiguado con Retroalimentación Unitaria');



