Kt = 0.0436;
Kb = 0.0436;
Ra = 17;
L = 9.35e-3;
J = 1.6e-6;
b = 1.4e-6;

numerador = [Kt];
denominador = [J*L (J*Ra + L*b) (b*Ra + Kb*Kt)];

H = tf(numerador, denominador)

t = linspace(0,10,10000);    
u = ones(size(t));

y1 = lsim(H,u,t);
figure;
plot(t,y1,'b',t,u,'r--')
xlabel('Tiempo (s)')
ylabel('Amplitud')
title('Respuesta transitoria')
legend('Salida del sistema','Escalón unitario')
grid on