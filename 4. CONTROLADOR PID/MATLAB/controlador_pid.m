clear, clc;
Kp = 100000;
num = [Kp*325];
den = [1 20 325]; 
sys = tf(num,den);

% Respuesta al escalon unitario
t = linspace(0,10,1000);
u = ones(size(t));

y1 = lsim(sys,u,t);
figure;
plot(t,y1,'b',t,u,'r--')
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Respuesta transitoria')
legend('Salida del sistema','Escalón unitario')
grid on