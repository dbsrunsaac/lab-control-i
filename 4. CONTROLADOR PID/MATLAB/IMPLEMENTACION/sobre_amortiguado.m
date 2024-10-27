clc; clear all;

num_sys = [440.75];
den_sys = [1 42 440.75];

system = tf(num_sys, den_sys);

[response, t] = step(system);

dy_dt = gradient(response, t);

[~, max_slope_idx] = max(dy_dt);
t_tangent = t(max_slope_idx);
y_tangent = response(max_slope_idx);
slope = dy_dt(max_slope_idx);

t_line = linspace(t(1), t(end), 500);
y_line = slope * (t_line - t_tangent) + y_tangent;

figure;
plot(t, response, 'b', 'Nombre a mostrar', 'Respuesta al escalón');
hold on;
plot(t_line, y_line, 'r--', 'Nombre a mostrar', 'Línea tangente');
plot(t_tangent, y_tangent, 'ro', 'Nombre a mostrar', 'Punto de tangencia');
title('Respuesta al escalón del sistema de segundo orden con línea tangente');
xlabel('Tiempo (s)');
ylabel('Respuesta');
ylim([0 1.2]); % Limitar el eje y hasta 1.2
legend;
grid on;

fprintf('Punto de tangencia: (%.4f, %.4f)\n', t_tangent, y_tangent);
fprintf('Pendiente de la tangente: %.4f\n', slope);