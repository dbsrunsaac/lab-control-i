clear, clc;

% PLANTA
num = [440.75];
den = [1 42 440.75];
planta  = tf(num, den);

% PARÁMETROS INICIALES - SISTEMA
raicesPlanta = roots(den);
disp("Raices Planta:"+raicesPlanta);

wnInicial = sqrt(num(1));
xiInicial = den(2)/(2*wnInicial);
tsInicial = (8*xiInicial)/(wnInicial);
fprintf("Parámetros Iniciales\n\n");
disp(["Freq. Natural Inicial: ", wnInicial]);
disp(["Xi inicial: ", xiInicial]);
disp(["Ts inicial: ", tsInicial]);

% PARÁMETROS DESEADOS
fprintf("Parámetros Deseados \n\n");
xi = 0.8;
ts = tsInicial/4; % Reducir ts
wn = 4/(xi*ts);
mp = 100*exp(-pi*xi/(sqrt(1 - xi^2)));
errorTs = abs(tsInicial - ts)*100/tsInicial;
disp(["Xi: ", xi]);
disp(["Freq Natural: ", wn]);
disp(["Ts: ", ts]);
disp(["Mp: ", mp]);
disp(["Error Ts: ", errorTs + "%"]);

ps = roots(den);
disp("Polos Sistema: ")
disp(ps);

% POLO DESEADO
pd = -xi*wn + wn*sqrt(1-xi^2)*i;

disp(["Polo deseado: ", pd]);

% ================== COMPENSADOR ADELANTO ====================
angP1 = 180 - atan( imag(pd)/ abs(real(pd) - ps(2)))*180/pi;
angP2 = 180 - atan( imag(pd)/ abs(real(pd) - ps(1)))*180/pi;
angComp = -180 + angP1 + angP2;
disp(["Ang. Comp. Adelanto: ", angComp]);

% Cero y polo - Comp. Adelanto

ceroAdelanto = [1 abs(real(pd))];
poloAdelanto = [1 abs(real(pd)) + imag(pd)/(tan( (90 - angComp)*pi/180 ))];

% Ganancia del sistema
ka = abs(evalfr(tf(conv(poloAdelanto, den), num*ceroAdelanto), pd));
disp(["Gan. Comp. Adelanto: ", ka]);

plantaAdelanto = tf(ka*num*ceroAdelanto, conv(poloAdelanto, den));
plantaAdelantoRetro = feedback(plantaAdelanto, 1);

compAdelanto = tf(ceroAdelanto, poloAdelanto)



% ================== COMPENSADOR ATRASO ====================
fprintf("COMPENSADOR RETRASO\n\n");
% Parámetros iniciales Comp. Retraso
T = 2.5;
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

% Angulo agregado al LGR - Comp. Atraso
angRP1 = 180 - atan( abs(imag(pd))/( abs( abs(real(pd)) - poloAtraso(2))))*180/pi;
angRZ1 = 180 - atan( abs(imag(pd))/( abs( abs(real(pd)) - ceroAtraso(2))))*180/pi;

angCompR = angRP1 - angRZ1;
disp(["Angulo adicional retraso: ", angCompR]);

% Ganancia del compensador atraso
kat = abs( evalfr( tf( conv( conv(poloAdelanto, poloAtraso), den), ka*num*conv(ceroAdelanto, ceroAtraso))  , pd));
disp(["Gan. Comp. Atraso: ", kat]);

compAtraso = tf(ceroAtraso, poloAtraso)

plantaAtrasoAdelanto = tf(kat*ka*num*conv(ceroAdelanto, ceroAtraso), conv( conv(poloAdelanto, poloAtraso), den) );
plantaAtrasoAdelantoRetro = feedback(plantaAtrasoAdelanto, 1);

planta
plantaAdelanto
plantaAtrasoAdelanto

% DIBUJANDO EL LGR DEL SISTEMA
% figure(1);
% subplot(2, 2, 1);
% rlocus(planta);
% subplot(2, 2, 2);
% rlocus(plantaAdelantoRetro);
% subplot(2, 2, 3);
% rlocus(plantaAtrasoAdelanto);

% Gráficando la respuesta del sistema
figure(2);
tiempo_simulacion = 2;
subplot(2, 1, 1);
[resp_escalon_comp, t_escalon] = step(plantaAtrasoAdelantoRetro, tiempo_simulacion);
plot(t_escalon, resp_escalon_comp, 'b', 'DisplayName', 'Sistema Compensado');
hold on;
[resp_escalon_planta, t_escalon] = step(planta, tiempo_simulacion);
plot(t_escalon, resp_escalon_planta, 'r', 'DisplayName', 'Planta');

title('Respuesta al Escalón Unitario - Sobreamortiguado');
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

title('Respuesta al Impulso Unitario  - Sobreamortiguado');
xlabel('Tiempo (s)');
ylabel('Amplitud'); 
legend show;
grid on; 
hold off;
% Añadir título general 
sgtitle('Respuestas Sistema Sobreamortiguado con Retroalimentación Unitaria');



