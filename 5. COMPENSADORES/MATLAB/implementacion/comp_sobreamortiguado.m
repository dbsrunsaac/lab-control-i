clear, clc;

% PLANTA
num = [440.75];
den = [1 42 440.75];
planta  = tf(num, den);
% Valores de compensación
xi = 0.8;
ts = 0.19; % Reducir ts
disp(["Xi: ", xi]);
wn = 4/(xi*ts);
disp(["Freq Natural: ", wn]);
po = roots(den);
disp("Polos Sistema: ")
disp(po);

% POLO DESEADO
ps = -xi*wn + wn*sqrt(1-xi^2)*i;

disp(["Polo deseado: ", ps]);

% ================== COMPENSADOR ADELANTO ====================
theta1 = 180 - atan(imag(ps)/( abs(real(ps)) - abs(po(2)) ))*180/pi;
theta2 = atan( imag(ps)/ ( abs(po(1)) - abs(real(ps)) ) )*180/pi;
distancia = 190;
theta3 = atan(imag(ps)/( distancia - abs(real(ps)) ))*180/pi;
theta_com = 180 + theta3 - theta1 - theta2;
disp(["Ang. Comp: ", theta_com]);

cero_com = [1, distancia];
polo_com = [1, -real(ps) + imag(ps)/(tan( theta_com*pi/180 )) ];

% Ganancia del compensador Kc
kc = abs(evalfr(tf(conv(den, polo_com), conv(num, cero_com)), ps));
disp(["Gan. Comp. Adelanto: ", kc]);

% FUNCIÓN DE TRANSFERENCIA DEL COMPENSADOR EN ADELANTO
Gc = tf(cero_com, polo_com);
Gc
planta

% ================== COMPENSADOR ATRASO ====================
beta = 100;
cero = 15;
cero_catr = [1, -po(2)-cero];
polo_catr = [1, (-po(2)-cero)/beta];

ka = abs(evalfr(tf( conv(conv(polo_catr,polo_com), den), conv(num*kc*cero_com,cero_catr)), ps));
disp(["Gan. Comp. Atr: ", ka]);

% FUNCIÓN DE TRANSFERENCIA DEL COMPENSADOR EN ATRASO
Gatr = tf(cero_catr, polo_catr);
Gatr

k=100;
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

title('Respuesta al Escalón Unitario - Sobreamortiguado');
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

title('Respuesta al Impulso Unitario  - Sobreamortiguado');
xlabel('Tiempo (s)');
ylabel('Amplitud'); 
legend show;
grid on; 
hold off;
% Añadir título general 
sgtitle('Respuestas Sistema Sobreamortiguado con Retroalimentación Unitaria');

% 

