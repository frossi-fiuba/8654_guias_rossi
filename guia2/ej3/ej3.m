clear all;
close all;
clc

%% Guia 2: Ejercicio 3 perceptron 1 capa intermedia de 16 neu

N = 10e3;
Nneu = 32;
M = 400;
k = 1;

size_X = 3; % cantidad de entradas
mu = 0; % media de las Normales estandares utilizadas para inicializar
var = 0.5; % varianza de las Normales estandares utilizadas para inicializar
E_max = 2e-3; % error maximo aceptable
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

while (E > E_max)
    
    for i = randperm(length(X)) 
        % out 1 capa
        h1 = W_10*X(i,:)' + b_10;
        V1 = tanh(h1); 
        % out final
        h4 = W_43*V1 + b_43;
        V4(i) = tanh(h4);
        %pause()

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


       % Testeo
    for j = randperm(length(X_t))
        
         % out 1 capa
        h1 = W_10*X_t(j,:)' + b_10;
        V1 = tanh(h1); 
        % out final
        h4 = W_43*V1 + b_43;
        f_out(j,1) = tanh(h4);
        %pause()
    end
    
    E= 1/2*sum((f_d_t - f_out).^2)
    E_vec(k) = E;
    k = k + 1;
    
    if k > 1500
        break;
    end
 
end
