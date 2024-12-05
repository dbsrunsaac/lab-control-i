clear, clc;
% Planta del sistema
num = [325];
den = [1 20 325];

planta = tf(num, den)

% Raices del sistema a lazo abierto
raicesPlanta = roots(den);
disp("Raices Planta:"+raicesPlanta);

wnInicial = sqrt(num(1));
xiInicial = den(2)/(2*wnInicial);
tsInicial = 4/(wnInicial*xiInicial);
fprintf("Parámetros Iniciales\n\n");
disp(["Freq. Natural Inicial: ", wnInicial]);
disp(["Xi inicial: ", xiInicial]);
disp(["Ts inicial: ", tsInicial]);

fprintf("Nuevos parámetros\n\n");
% Parámetros deseados
mp = 6; % sobreimpulso
ts = 0.20; % sobreimpulso
errorTs =  abs(tsInicial-ts)*100/tsInicial; % El porcentaje de error entre los Ts (inicial y experimental)
disp(["Error en el Ts: ", errorTs+"%"]);
% Calculo de los nuevos parámetros
xi = -log(mp/100)/( sqrt(log(mp/100)^2 + pi^2) );
wn = 4/(xi*ts);
disp(["Xi: ", num2str(xi)]);
disp(["Freq Natural: ", num2str(wn)]);

% Calculo de los polos deseados
pd = -xi*wn +i*wn*sqrt(1 - xi^2);
disp(["Polo deseado: ", pd]);

% Definiendo el Controlador PD
zeroPID = [1 382.89];
poloPID = [1 0];
zeroPID1 = [1 10];

gcZero = num*conv(zeroPID, zeroPID1);
gcPolo = conv(poloPID, den);

% Calculo de la ganancia
ka = abs(evalfr(tf(gcPolo,gcZero), pd));
disp(["Ganancia PD: ", ka]);

% Definiendo ganancia

sistema = tf(0.66*ka*gcZero, gcPolo )

sistemaRetro = feedback(sistema,1)

% Dibujando el LGR del sistema a lazo abierto
figure(1); % Creando una figura
subplot(2, 2, 1);
rlocus(planta);
subplot(2, 2, 2);
rlocus(sistema);
subplot(2, 2, 3);
rlocus(sistemaRetro);

% ================ =================== ================
% ================ PROBANDO EL SISTEMA ================
% ================ =================== ================
figure(2); %
tiempo_simulacion = 2;
subplot(2, 1, 1);
[resp_escalon_comp, t_escalon] = step(sistemaRetro, tiempo_simulacion);
plot(t_escalon, resp_escalon_comp, 'b', 'DisplayName', 'Sistema Compensado');
hold on;
[resp_escalon_planta, t_escalon] = step(planta, tiempo_simulacion);
plot(t_escalon, resp_escalon_planta, 'r', 'DisplayName', 'Planta');

title('Respuesta al Escalón Unitario - Subamortiguado');
xlabel('Tiempo (s)');
ylabel('Amplitud');
legend show;
grid on; 
hold off;

% ============= =========== =========
% Subgráfica 2: Respuesta al impulso
% ============= =========== =========
subplot(2, 1, 2); 
[resp_impulso_comp, t_escalon] = impulse(sistemaRetro, tiempo_simulacion);
plot(t_escalon, resp_impulso_comp, 'b', 'DisplayName', 'Sistema Compensado');
hold on;
[resp_impulso_planta, t_escalon] = impulse(planta, tiempo_simulacion);
plot(t_escalon, resp_impulso_planta, 'r', 'DisplayName', 'Planta');

title('Respuesta al Impulso Unitario  - Subamortiguado');
xlabel('Tiempo (s)');
ylabel('Amplitud'); 
legend show;
grid on; 
hold off;
% Añadir título general 
sgtitle('Respuestas Sistema subamortiguado con Retroalimentación Unitaria');













