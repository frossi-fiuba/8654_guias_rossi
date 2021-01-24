%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |2| |-| |E|J|E|R|C|I|C|I|O| |1|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Implementacion de un Perceptron Simple AND y OR de 4 entradas

% Cleaning
clear all;
close all;
clc

% constante de aprendizaje
eta = 10;
%

% defino ambas tablas de verdad

X = 2*[0,0,0,0;
     0,0,0,1;
     0,0,1,0;
     0,0,1,1;
     0,1,0,0;
     0,1,0,1;
     0,1,1,0;
     0,1,1,1;
     1,0,0,0;
     1,0,0,1;
     1,0,1,0;
     1,0,1,1;
     1,1,0,0;
     1,1,0,1;
     1,1,1,0;
     1,1,1,1]-1; % vector de entrada

V_d = 2*[0;1;1;0;1;0;0;1;1;0;0;1;0;1;1;0]-1; % Salidas deseada
x = [ones(16,1),X];
y_and = -ones(16,1);
y_and(16) = 1;
y_or = ones(16,1);
y_or(1) = -1;

% inicializo w

w = [0; -1; 1; -1; 1];

% elegir si se quiere aprender AND u OR
z = y_and;
%z = y_or;

% recorro 1 vez los patrones y computo el error inicial
for i=randperm(16)
    h = w'*x(i,:)';
    y = signo(h);
    y_res(i,1) = y;
    w = w + eta * x(i,:)'*(z(i)-y);
end    

E = 1/2 * (z-y_res)'*(z-y_res);

E_vec = E;

%% proceso de entrenamiento
i = 2;
while(E > 0)
    idx = randi(16);
    h = w'*x(idx,:)';
    y_res(idx,1) = signo(h);
    w = w + eta *x(idx,:)'*(z(idx)-y_res(idx,1));
    
    E = 1/2 * (z-y_res)'*(z-y_res);
    E_vec(i) = E;
    i = i + 1;
end

%% Graficos

figure()
scatter([1:i-1],E_vec,'x','linewidth',5)
xticks([1,5:5:i])
yticks(0:(E_vec(1) + 0.5))
xlim([0.5,i])
ylim([0,(E_vec(1) + 0.5)])
ax = gca;
ax.FontSize = 20; 
xlabel("Iteracion",'fontsize',20)
ylabel("Error",'fontsize',20)
grid on
