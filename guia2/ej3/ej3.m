%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |2| |-| |E|J|E|R|C|I|C|I|O| |2|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Implementacion de un Perceptron Multicapafuncion de 3 entradas

% Cleaning
clear all;
close all;
clc

N = 1e3;
Nneu = 32;
M = 400;
k = 1;
k2 = 1;
size_X = 3; % cantidad de entradas
mu = 0; % media de las Normales estandares utilizadas para inicializar
var = 0.5; % varianza de las Normales estandares utilizadas para inicializar
E_max = 0.8; % error maximo aceptable
%eta = 1e-3;
eta = 1e-3; 

% vector de entrenamiento
x = unifrnd(0,2*pi,N,1);
y = unifrnd(0,2*pi,N,1);
z = unifrnd(-1,1,N,1);

f = sin(x) + cos(y) + z;
f_d = f/3;

X = [x,y,z];

% vector de testeo
x_t = unifrnd(0,2*pi,M,1);
y_t = unifrnd(0,2*pi,M,1);
z_t = unifrnd(-1,1,M,1);

X_t = [x_t,y_t,z_t];

f_t = sin(x_t) + cos(y_t) + z_t;
f_d_t = f_t/3; 

% Inicializacion de las variables
E=1; % para entrar al while una vez
V4 = zeros(N,1);

% Pesos sinapticos iniciales
W_10 = normrnd(mu,var,Nneu,size_X); 
W_43 = normrnd(mu,var,1,Nneu);

%defino los bias
b_10 = normrnd(mu,var,Nneu,1);

b_43 = normrnd(mu,var,1,1);

%Inicializo los deltas
delta4 = zeros(1,1);

delta1 = zeros(Nneu,1);

dW_43 = zeros(1,Nneu);

dW_10 = zeros(Nneu,size_X);

db_43 = zeros(1,1);

db_10 = zeros(Nneu,1);

max_epocas = 500;

while (E > E_max && k2 < max_epocas)
    
    for i = randperm(length(X)) 
        % out 1 capa
        h1 = W_10*X(i,:)' + b_10;
        V1 = tanh(h1); 
        % out final
        h4 = W_43*V1 + b_43;
        V4(i) = tanh(h4);
        
        % CALCULO EL ERROR PARA LA ITERACION
        h = W_10*X' + repmat(b_10, 1, N);
        V1_mat = tanh(h);

        % capa de salida
        h = W_43*V1_mat + repmat(b_43, 1, N);
        f_out_b = tanh(h);
        
        E_train = 1/2 * sum((f_d - f_out_b').^2);
        E_train_vec(k) = E_train;
        k = k + 1;
        

        % back propagation
            
        delta4 = (1 - tanh(h4).^2)*(f_d(i)-V4(i));
        % deltas vectoriales
        delta1 = (1 - tanh(h1).^2).*(W_43'*delta4);
        
        %Deltas_W
        
        %capa salida
        
        W_43 = W_43 + eta*delta4*V1';
        b_43  = b_43 + eta*delta4;
        %capa 1

        W_10 = W_10 + eta*delta1*X(i,:);
        b_10 = b_10 + eta*delta1;
        
    end

    % CALCULO EL ERROR PARA LA ITERACION
    h = W_10*X_t' + repmat(b_10, 1, M);
    V1_mat = tanh(h);

    % capa de salida
    h = W_43*V1_mat + repmat(b_43, 1, M);
    f_out = tanh(h);
    % cambiar por mean los sum y sacar los divididos a los sum
    E_test = 1/2 * sum((f_d_t - f_out').^2);
    E_test_vec(k2) = E_test;
    k2 = k2 + 1

end

%% Graficos

load('workspace_pruba1.mat')

figure()
plot(1:k2-1,E_test_vec/(M))
xlabel("Epoca")
ylabel("E_{test}")
grid on

%

figure()
plot(1:k-1,E_train_vec/(N))
xlabel("Iteracion")
ylabel("E_{train}")
grid on


%min cuadradados

c = polyfit(f_d_t, f_out', 1);
disp(['la ecuacion es y = ' num2str(c(1)) '*x + ' num2str(c(2))])
x = linspace(-1,1);
y = c(1)*x + c(2);
%
figure()
scatter(f_d_t, f_out,'x')
hold on
plot(x,y, '-r')
plot(x,x,'--k')
xlabel("salida deseada")
ylabel("salida")
legend(["valores f_d vs f_out","fit a minimos cuadrados","x = y"], 'location', 'northwest')
grid on