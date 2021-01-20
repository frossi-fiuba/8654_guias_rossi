%% Ejercicio 3:b capacidad de la red de hopfield a medida que baja % sinapsis
clear all;
close all;
clc

N = 100;
perror = 0.01;
porc_eliminado = [0:5:100];
%porc_eliminado = 20;
samples = 10;
%samples = 1;

for n = 1:samples
    for k = 1:length(porc_eliminado)

        p = 0;
        err = 0;

        while(err < perror)
            p = p + 1;

            % Construyo la matriz de pesos sinapticos
            P = 2*binornd(1,1/2,N,p)-1;
            W = P*P' - p*eye(N);

            % elimino %
            vector = randperm(N*N);
          
            W(vector(1:round(porc_eliminado(k)*N^2/100))) = 0; 
           
            % Error global
            err = mean(mean((signo(W*P)-P)~=0)); % #bits incorrectos/(N*p)

        end
        
        pmax(k,n) = p;
        C(k,n) = (pmax(k,n)-1)/N;

    end
end

%%
figure(1)
plot(porc_eliminado,mean(C,2))
grid minor

