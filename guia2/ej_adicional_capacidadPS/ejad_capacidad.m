%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |2| |-| |E|J|E|R|C|I|C|I|O| |ADICIONAL - Capacidad|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Capacidad del perceptron simple

% Cleaning
clear all;
close all;
clc

N = 20; % largo del vector x
pmax = 4*N; % cantidad maxima de patrones
Nap = zeros(pmax,1); % cantidad de patrones aprendidos
iter_max = 1000;
eta = 10;
Nrep = 500;

%%

for p=1:pmax
        % Genero patrones 2^p patrones posibles
        for j = 1:Nrep
            x = unifrnd(-1,1,p,N);
            z = 2*binornd(1,1/2,p,1)-1;
            w = binornd(1,1/2,N,1)-1;

            %recorro 1 vez el vector de manera aleatoria
           
            for i=randperm(p)
                h = w'*x(i,:)';
                y = signo(h);
                y_res(i,1) = y;
                w = w + eta * x(i,:)'*(z(i)-y);
            end    

            E = 1/2 * (z-y_res)'*(z-y_res);

            i = 2;

            % ahora hasta error nulo o llegar al maximo de iteraciones
            while(i <= iter_max)
                idx = randi(p);
                h = w'*x(idx,:)';
                y_res(idx,1) = signo(h);
                w = w + eta *x(idx,:)'*(z(idx)-y_res(idx,1));

                E = 1/2 * (z-y_res)'*(z-y_res);

                i = i + 1;

                if (E == 0)
                    Nap(p) = Nap(p) + 1; % aprendio 1 patron mas
                    break;
                end
            end
        end
        
end

%%
load('workspace01.mat')
pvec = 1:80;
figure()
plot(pvec,Nap/Nrep)
title("Capacidad del Perceptron Simple N = 20")
xlabel("p")
ylabel("Nap/Nrep")
grid minor