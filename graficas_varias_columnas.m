% Datos
x = 0:0.1:10;
y1 = sin(x);
y2 = cos(x);
y3 = exp(-x);
y4 = x.^2;

% Crear una disposición de subgráficos flexible
t = tiledlayout(2, 2, 'TileSpacing', 'Compact', 'Padding', 'Compact'); % 2x2 cuadrícula

% Primera gráfica ocupa 2 columnas
nexttile([1 2]); % Ocupa 1 fila y 2 columnas
plot(x, y1, '-r', 'LineWidth', 2);
title('Gráfica 1: Ocupar 2 columnas');
xlabel('Eje X');
ylabel('Eje Y');

% Segunda gráfica
nexttile([1 2]);
plot(x, y2, '--b', 'LineWidth', 2);
title('Gráfica 2');
xlabel('Eje X');
ylabel('Eje Y');

% Título global
sgtitle('Ejemplo: Figura que ocupa 2 columnas');
