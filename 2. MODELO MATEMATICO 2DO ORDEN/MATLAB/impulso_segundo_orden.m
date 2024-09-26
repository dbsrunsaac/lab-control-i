% Definición de la función de transferencia (ejemplo: sistema subamortiguado)
num = [65];
den = [1 2 65]; % Factor de amortiguamiento = 0.5, frecuencia natural = 1 rad/s
sys = tf(num,den);

% Generación de la señal de entrada (impulso unitario)
% La función impulse calcula automáticamente la respuesta al impulso
% No es necesario generar la señal de entrada explícitamente

% Cálculo de la respuesta al impulso
impulse(sys)

% Personalizar la gráfica (opcional)
% Si deseas personalizar la gráfica, puedes usar:
% t = linspace(0,10,1000); % Vector de tiempo
% y = impulse(sys,t);
% plot(t,y)
% xlabel('Tiempo (s)')
% ylabel('Amplitud')
% title('Respuesta al impulso de un sistema de segundo orden')
% grid on