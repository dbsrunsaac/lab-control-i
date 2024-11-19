% Define la función compleja
% Por ejemplo, z = 3 + 4i
s = -8 + 9i;
G = (s^2 + 20*s + 325)*(s + 10.18)/(325*(s+8))
% Calcula el módulo
modulo = abs(G);
% Muestra el resultado
disp(['El módulo de la función compleja es: ', num2str(modulo)]);
