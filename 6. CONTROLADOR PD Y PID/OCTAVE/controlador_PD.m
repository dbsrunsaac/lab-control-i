clear, clc;
pkg load control;
% Planta del sistema
num = [325];
den = [1 20 325];
planta = tf(num, den);


% Parámetros deseados
mp = 6; % sobreimpulso
ts = 1; % sobreimpulso
errorTs =  abs(0.4-ts)*100/0.4; % El porcentaje de error entre los Ts (inicial y experimental)

% Calculo de los nuevos parámetros
xi = -log(mp/100)/( sqrt(log(mp/100)^2 + pi^2) );
wn = 4/(xi*ts);
disp(["Xi: ", num2str(xi)]);
disp(["Freq Natural: ", num2str(wn)]);

% Calculo de los polos deseados

pd = -xi*wn +j*wn*sqrt(1 - xi^2);
disp("Polo deseado: ", pd);
