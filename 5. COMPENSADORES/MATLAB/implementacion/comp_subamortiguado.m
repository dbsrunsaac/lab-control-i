clear, clc;

% PLANTA
num = [325];
den = [1 20 325];
planta  = tf(num, den);
% Valores de compensación
mp = 6.18; % Reducir el sobrepico
xi = -log(mp/100)/(sqrt(log(mp/100)^2 + pi^2));
disp(["Xi: ", xi]);
ts = 0.5; % Tiempo de establecimiento [s]
wn = 4/(xi*ts);
disp(["Freq Natural: ", wn]);
raices_den = roots(den);

% POLO DESEADO
po = raices_den(1);

disp(["Polos Sistema: ",po]);
ps = -xi*wn + wn*sqrt(1-xi^2)*i;

disp(["Polo deseado: ", ps]);

% ================== COMPENSADOR ADELANTO ====================
theta1 = atan((imag(ps)+imag(po))/(abs(real(po)) - abs(real(ps))))*180/pi;
theta2 = 180 - atan( (imag(po) - imag(ps)) / (abs(real(po)) - abs(real(ps))))*180/pi;
theta3 = atan(imag(ps)/(abs(real(po)) - abs(real(ps))))*180/pi;
theta_com = 180 + theta3 - theta1 - theta2;
disp(["Ang. Comp: ", theta_com]);

cero_com = [1, -real(po)];
polo_com = [1, -real(ps) + imag(ps)/(tan(theta_com*pi/180))];

% Ganancia del compensador Kc
kc = abs(evalfr(tf(conv(den, polo_com), conv(num, cero_com)), ps));
disp(["Gan. Comp. Adelanto: ", kc]);

% FUNCIÓN DE TRANSFERENCIA DEL COMPENSADOR EN ADELANTO
Gc = tf(cero_com, polo_com);
Gc
planta

% ================== COMPENSADOR ATRASO ====================
cero_catr = [1 -real(ps)*20];
polo_catr = [1 0.0002];

ka = abs(evalfr(tf( conv(conv(polo_catr,polo_com), den), conv(num*kc*cero_com,cero_catr)), ps));
disp(["Gan. Comp. Atr: ", ka]);

% FUNCIÓN DE TRANSFERENCIA DEL COMPENSADOR EN ATRASO
Gatr = tf(cero_catr, polo_catr);
Gatr

k=1.36;
kt = kc*ka*k
% LGR DEL SISTEMA
sys_comp = tf( conv(kt*cero_catr,conv(cero_com, num)), conv(polo_catr, conv(polo_com,den)));
sys_comp
% rlocus(sys_comp);


% Gráficando la respuesta del sistema
figure;
sys_comp_retro = feedback(sys_comp, 1);
tiempo_simulacion = 2;
subplot(2, 1, 1);
[resp_escalon_comp, t_escalon] = step(sys_comp_retro, tiempo_simulacion);
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
[resp_impulso_comp, t_escalon] = impulse(sys_comp_retro, tiempo_simulacion);
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



