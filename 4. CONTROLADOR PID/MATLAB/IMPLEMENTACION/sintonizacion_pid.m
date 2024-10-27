clear, clc;
% Definir la función de transferencia del sistema
numerador = [325];
denominador = [1 20 325];
G = tf(numerador, denominador);

% Diseño del controlador PID inicial
Kp = 8; % Ajustar manualmente
Ki = 2;   % Ajustar manualmente
Kd = 0.1;  % Ajustar manualmente

% Crear el controlador PID
C = pid(Kp, Ki, Kd);
T = C*G
% Sistema en lazo cerrado
T = feedback(C*G, 1);

% Graficar la respuesta al escalón
step(T);
grid on;
title('Respuesta al Escalón con Controlador PID para Reducción del Sobreimpulso');
