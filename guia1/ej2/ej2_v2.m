%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |1| |-| |E|J|E|R|C|I|C|I|O| |2|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Capacidad de la red de Hopfield (82')

%% Cleaning
clear all;
close all;
clc
%caso general
%% Definicion de var
N = [1:10:510]; 
perror = [0.001,0.0036,0.01,0.05,0.1];
% caso 0.001 para mejor aproximacion
%N = [1:1:510];
%perror = 0.001;

%% Realizacion para cada 1 de las p_error calculo el maximo de patrones previo a alcanzar dicho valor de error
for k=1:length(perror)
    for i=1:length(N)
        p = 0;
        err = 0;
        while(err < perror(k))
            p = p + 1; % incremento la # de patrones
            
            % Construyo la matriz de pesos sinapticos
            P = 2*binornd(1,1/2,N(i),p)-1;
            W = P*P' - p*eye(N(i));

            % Computo el error global
            err = mean(mean((signo(W*P)-P)~=0)); % #bits incorrectos/(N*p)
            
            end
        % guardo los valores
        pmax(i,k) = p;
        C(i,k) = (pmax(i,k)-1)/N(i);  % -1, ya que queremos un error menor al p_error
        
    end
end
%% Grafico
figure(1);
leyendas = string([]);
for k=1:length(perror)
    hold on;
    scatter(N,pmax(:,k))
    leyendas(k) = sprintf("P_{error} : %f",perror(k));
end
xlabel("Cantidad de Nueronas (N)")
ylabel("Max cantidad de patrones  (p_{max})")
legend(leyendas,'location','northwest')
xlim([0,520])
ylim([0,320])
xticks([0:50:550])
grid on
grid minor
%% Tabla de valores de capacidad
mean(C)




