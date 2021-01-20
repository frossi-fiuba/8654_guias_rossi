%% Ejercicio 2: capacidad de la red de hopfield
clear all;
close all;
clc
%N = [1:10:510];
N = [1:1:510];
%perror = [0.001,0.0036,0.01,0.05,0.1];
perror = 0.001;

%% ej2
for k=1:length(perror)
    for i=1:length(N)
        p = 0;
        err = 0;
        while(err < perror(k))
            p = p + 1;
            
            % Construyo la matriz de pesos sinapticos
            P = 2*binornd(1,1/2,N(i),p)-1;
            W = P*P' - p*eye(N(i));

            % Error global
            err = mean(mean((signo(W*P)-P)~=0)); % #bits incorrectos/(N*p)
            
            end
        pmax(i,k) = p;
        C(i,k) = (pmax(i,k)-1)/N(i); 
        
    end
end
%%
%figure(1);
%scatter(N,pmax)
%grid minor
%%
mean(C)




