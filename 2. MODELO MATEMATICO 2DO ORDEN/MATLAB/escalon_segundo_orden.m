clear all;
num = [65];
den = [1 2 65]; 
sys = tf(num,den);

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