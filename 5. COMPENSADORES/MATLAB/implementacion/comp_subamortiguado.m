clear, clc;
% Planta del sistema
num = [325];
den = [1 20 325];

planta = tf(num, den);

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

% Valores de compensación
mp = mpInicial/2; % Reducir el sobrepico
xi = -log(mp/100)/(sqrt(log(mp/100)^2 + pi^2));

ts = 0.2; % Tiempo de establecimiento [s]
wn = 4/(xi*ts);
fprintf("Nuevos parámetros\n\n");
disp(["Xi: ", xi]);
disp(["Freq Natural: ", wn]);
disp(["Sobre Impulso deseado: ", mp]);
raices_den = roots(den);

% Polo deseado
ps = raices_den(1);
pd = -xi*wn + wn*sqrt(1-xi^2)*i;
disp(["Polos Sistema: ",ps]);

disp(["Polo deseado: ", pd]);

% ================== COMPENSADOR ADELANTO ====================
disp("COMPENSADOR ADELANTO");
distanciaAbscisas = abs( real(pd) - real(ps));
angP1 = 180 - atan(abs( imag(pd) - imag(ps))/(distanciaAbscisas))*180/pi;
angP2 = 180 - atan(abs(imag(pd) + imag(ps))/(distanciaAbscisas))*180/pi;
angZ1 = 180 - atan(abs(imag(pd))/(distanciaAbscisas))*180/pi;
angComp = -180 - angZ1 + angP1 + angP2;
disp(["Ang. Comp: ", angComp]);

% Determinando el cero y el polo del compensador
poloAdelanto = abs(real(pd)) + abs(imag(pd))/(tan((90 - abs(angComp))*pi/180));
ceroAdelanto = [1, -real(ps)];
poloAdelanto = [1, poloAdelanto];

fprintf("Zero Comp. Adelanto:");
disp(ceroAdelanto);
fprintf("Polo Comp. Adelanto:");
disp(poloAdelanto);

% Ganancia del compensador en adelanto

ka = abs(evalfr(tf(conv(den, poloAdelanto), num*ceroAdelanto), pd));
disp(["Gan. Comp. Adelanto: ", ka]);

% FUNCIÓN DE TRANSFERENCIA DEL COMPENSADOR EN ADELANTO

plantaAdelanto = tf(ka*num*ceroAdelanto, conv(poloAdelanto, den));
plantaAdelantoRetro = feedback(plantaAdelanto, 1);
compAdelanto = tf(ceroAdelanto, poloAdelanto)


% ================== COMPENSADOR RETRASO ====================
disp("COMPENSADOR RETRASO");
% Parámetros iniciales Comp. Retraso
T = 0.8;
kpInicial = ka*ceroAdelanto(2)*num/(poloAdelanto(2)*den(3));
essInicial = 1/(1 + kpInicial);
disp(["ess Inicial: ", essInicial]);
disp(["Kp Inicial: ", kpInicial]);
disp(["Constante de Tiempo: ", T]);

% Parámetros en retraso deseados
fprintf("Parámetros deseados para el compensador en atras\n\n");

ess = 0.01;
kp = (1 - ess)/ess;
B = kp/kpInicial;
essError =  (abs(essInicial - ess)*100)/essInicial;
disp(["kp: ", kp]);
disp(["B: ", B]);
disp(["Error ess: ", essError+"%"]);

% Cero y Polo del Comp. Atraso

ceroAtraso = [1 abs(real(pd))/T];
poloAtraso = [1 abs(real(pd))/(B*T)];
compAtraso = tf(ceroAtraso, poloAtraso);

% Angulo agregado al LGR - Comp. Atraso
angRP1 = 180 - atan( abs(imag(pd))/( abs( abs(real(pd)) - poloAtraso(2))))*180/pi;
angRZ1 = 180 - atan( abs(imag(pd))/( abs( abs(real(pd)) - ceroAtraso(2))))*180/pi;

angCompR = angRP1 - angRZ1;
disp(["Angulo adicional retraso: ", angCompR]);

% Ganancia del compensador atraso

kat = abs( evalfr( tf( conv( conv(poloAdelanto, poloAtraso), den), ka*num*conv(ceroAdelanto, ceroAtraso))  , pd));
disp(["Gan. Comp. Atraso: ", kat]);

% Mostrando los ceros y los polos
fprintf("Cero Comp. Atraso");
disp(ceroAtraso);
fprintf("Polo Comp. Atraso");
disp(poloAtraso);
compAtraso

% PLANTA DEL SISTEMA ATRASO - ADELANTO

plantaAtrasoAdelanto = tf(kat*ka*num*conv(ceroAdelanto, ceroAtraso), conv( conv(poloAdelanto, poloAtraso), den));

plantaAtrasoAdelantoRetro = feedback(plantaAtrasoAdelanto, 1);

% PLANTA, SISTEMA COMPENSADO
planta
plantaAdelanto
plantaAtrasoAdelanto

% GRAFICANDO EL LGR DEL SISTEMA
figure(1);
subplot(2, 2, 1);
rlocus(planta);
subplot(2, 2, 2);
rlocus(plantaAdelantoRetro);
subplot(2, 2, 3);
rlocus(plantaAtrasoAdelantoRetro);


% RESPUESTA DEL SISTEMA
tiempo_simulacion = 2;

figure(2);
subplot(2, 1, 1);
[resp_escalon_comp, t_escalon] = step(plantaAtrasoAdelantoRetro, tiempo_simulacion);
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

% Subgráfica 2: Respuesta al impulso 
subplot(2, 1, 2); 
[resp_impulso_comp, t_escalon] = impulse(plantaAtrasoAdelantoRetro, tiempo_simulacion);
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