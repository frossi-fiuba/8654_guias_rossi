%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |2| |-| |E|J|E|R|C|I|C|I|O| |4|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Algoritmo Genético

% Cleaning

clear all;
close all;
clc

N_indv = 11; % cantidad de individuos (perceptrones multicapa)
N_neu = 4; % cantidad de neuronas por capa
N_capas = 3;

fitness_ths = 0.99; % Threshold para cortar la reproduccion
p_cross = 0.05; % Probabilidad de crossover.
mu = 0; % Media de las gaussianas con las que se generan los pesos iniciales
var = 0.5; % Varianza de "      "   "   "   "   "   "   "
mu_mut = mu;
var_mut = var;

% Defino tabla de verdad de XOR de 2 entradas
X = [[-1;1;-1;1],[-1;-1;1;1]];
y_d = [-1;1;1;-1]; % salida x-or

size_in = size(X, 2);
size_out = size(y_d, 2);
size_w_in = (size_in+1)*N_neu;
size_w_mid = N_neu*(N_neu+1)*(N_capas-2);
size_w_out = size_out*(N_neu+1);

% creo poblacion
for i = 1:N_indv
    W(:, i) = crear_individuo(mu, var, size_w_in, size_w_out,size_w_mid);
    F(i,1) = fitness(W(:,i), X, y_d, N_neu, N_capas, size_in, size_out) ;
end
z = 1;
F_vec(:,z) = F;
[fitness_elite, elite_index] = max(F);
fitness_elite_vec (:,z) = fitness_elite;
W_next = zeros(size(W));
while ( fitness_elite < fitness_ths)
    
    % copio elite descendencia inmediata
    W_next(:,N_indv) = W(:,elite_index);
    
    % Reproduccion + CrossOver
    % Armo intervalo de probas
    p_rep = F/sum(F);
    k = 1;
    % descendencia
    while k < N_indv

        % elegir el duo de reproduccion devuelvo los indices
        couple = find(mnrnd(2,p_rep) == 1);

        while (length(couple) ~= 2)
            couple = find(mnrnd(2,p_rep) == 1);
        end
        
        W_next(:, k) = W(:, couple(1));
        W_next(:, k+1) = W(:, couple(2));
        
        if (binornd(1, p_cross) && couple(1) ~= elite_index && couple(2) ~= elite_index)
            index_cross = unidrnd(size(W,1));
            W_next(index_cross:end, k) = W(index_cross:end, couple(2));
            W_next(index_cross:end, k + 1) = W(index_cross:end, couple(1));
        end
        
        k = k + 2;    
      
    end
    
    % Mutacion
    M = normrnd(mu_mut, var_mut, size(W));
    M(:, N_indv) = 0; % No muto el elite
    W_next = W_next + M;
    
    % Aca recaulculamos el fitness y volvemos a correrlo
    W = W_next;
    
    for i = 1:N_indv
        F(i,1) = fitness(W(:,i), X, y_d, N_neu, N_capas, size_in, size_out);
    end
    
    z = z + 1;
    F_vec(:, z) = F;
    
    [fitness_elite, elite_index] = max(F);
    fitness_elite_vec (:,z) = fitness_elite;
    
end

% elite final
 [fitness_elite, elite_index] = max(F);
 fitness_elite_vec (:, z + 1) = fitness_elite;
disp(F_vec) % aca vemos la evolucion
%%

figure(1)
stem(fitness_elite_vec,'p','k', 'linewidth', 2)
xlabel("Generaci�n", 'fontsize', 15)
ylabel("Fitness del elite", 'fontsize', 15)
xlim([0, z + 2])
ylim ([ 0,1.05])
xticks([1:1:z+1])
grid on
grid minor



