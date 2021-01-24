%% 
%%%%% Francisco Rossi - 99540 %%%%%%%%
%%%%% Redes Neuronales - Guia 2 %%%%%%
%%%%%%%%%%%%% Ejercicio 2 %%%%%%%%%%%%
clear all;
close all;
clc

N = 20; % largo del vector x
pmax = 4*N;
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

            %recorro 1 vez el vector
            v_rand = randperm(p);

            for i=1:p
                h = w'*x(v_rand(i),:)';
                y = signo(h);
                y_res(v_rand(i),1) = y;
                w = w + eta * x(v_rand(i),:)'*(z(v_rand(i))-y);
            end    

            E = 1/2 * (z-y_res)'*(z-y_res);

            i = 2;

            while(1)
                idx = randi(p);
                h = w'*x(idx,:)';
                y_res(idx,1) = signo(h);
                w = w + eta *x(idx,:)'*(z(idx)-y_res(idx,1));

                E = 1/2 * (z-y_res)'*(z-y_res);

                i = i + 1;
                if (i > iter_max)
                    break;
                end

                if (E == 0)
                    Nap(p) = Nap(p) + 1;
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
title("Capacidad del Perpeptron Simple N = 20")
xlabel("p")
ylabel("Nap/Nrep")
grid minor