clear, clc;
% Planta del sistema
num = [65];
den = [1 2 65];

planta = tf(num, den)

% Raices del sistema a lazo abierto
raicesPlanta = roots(den);
disp("Raices Planta:"+raicesPlanta);

wnInicial = sqrt(num(1));
xiInicial = den(2)/(2*wnInicial);
tsInicial = 4/(wnInicial*xiInicial);
mpInicial = 100*exp(-pi*xiInicial/(sqrt(1 - xiInicial^2)) );
fprintf("Parámetros Iniciales\n\n");
disp(["Freq. Natural Inicial: ", wnInicial]);
disp(["Xi inicial: ", xiInicial]);
disp(["Ts inicial: ", tsInicial]);
disp(["Mp inicial: ", mpInicial]);

fprintf("Nuevos parámetros\n\n");
% Parametros deseados
mp = mpInicial/2; % sobreimpulso
ts = 0.2; % sobreimpulso
errorTs =  abs(tsInicial-ts)*100/tsInicial; % El porcentaje de error entre los Ts (inicial y experimental)
disp(["Error en el Ts: ", errorTs+"%"]);
% Calculo de los nuevos parametros
xi = -log(mp/100)/( sqrt(log(mp/100)^2 + pi^2) );
wn = 4/(xi*ts);
disp(["Xi: ", num2str(xi)]);
disp(["Mp deseado: ", mp]);
disp(["Freq Natural: ", num2str(wn)]);

% Calculo de los polos deseados
pd = -xi*wn +i*wn*sqrt(1 - xi^2);
disp(["Polo deseado: ", pd]);

% Definiendo el Controlador PD
zeroPD = [1 63.52];
% Calculo de la ganancia
ka = abs(evalfr(tf(den,zeroPD*num), pd));
disp(["Ganancia PD: ", ka]);
% Definiendo ganancia
Gr = ka*zeroPD

sistema = tf( 0.66*Gr*num , den )

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

% Subgrafica 2: Respuesta al impulso 
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
% Anadir titulo general 
sgtitle('Respuestas Sistema subamortiguado con Retroalimentacion Unitaria');













