%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |2| |-| |E|J|E|R|C|I|C|I|O| |2|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Implementacion de un Perceptron Multicapa XOR de 2 entradas

% Cleaning
clear all;
close all;
clc

%% XOR 2 entradas
eta = 0.015; % cte de aprendizaje
mu = 0; % media de las Normales estandares utilizadas para inicializar
var = 0.5; % varianza de las Normales estandares utilizadas para inicializar
E_max = 1e-6; % error maximo aceptable
N = 4; % cantidad de neuronas x capa
size_X = 2; % cantidad de entradas
k = 1;
X = [-1,-1;1,-1;-1,1;1,1];% vector de entrada
V_d = [-1;1;1;-1]; % Salida deseada

% Inicializacion de las variables
E = 1; % para entrar al while una vez
V4 = zeros(4,1);

% Pesos sinapticos iniciales
W_10 = normrnd(0,1,N,size_X); 
W_21 = normrnd(mu,var,N,N); 
W_32 = normrnd(mu,var,N,N);
W_43 = normrnd(mu,var,1,N);

%defino los bias
b_10 = normrnd(mu,var,N,1);
b_21 = normrnd(mu,var,N,1);
b_32 = normrnd(mu,var,N,1);
b_43 = normrnd(mu,var,1,1);

%Inicializo los deltas
delta4 = zeros(1,1);
delta3 = zeros(N,1);
delta2 = zeros(N,1);
delta1 = zeros(N,1);

dW_43 = zeros(1,N);
dW_32 = zeros(N,N);
dW_21 = zeros(N,N);
dW_10 = zeros(N,size_X);

db_43 = zeros(1,1);
db_32 = zeros(N,1);
db_21 = zeros(N,1);
db_10 = zeros(N,1);

while (E > E_max)
    
    for i = randperm(length(X)) 
        % foward
        % out 1 capa
        h1 = W_10*X(i,:)' + b_10;
        V1 = tanh(h1); 
        % out 2 capa
        h2 =  W_21*V1 + b_21;
        V2 = tanh(h2) ;
        % out 3 capa
        h3 = W_32*V2 + b_32;
        V3 = tanh(h3) ;
        % out final
        h4 = W_43*V3 + b_43;
        V4(i) = tanh(h4);
        %pause()

        % back propagation
            
        delta4 = (1 - tanh(h4).^2)*(V_d(i)-V4(i));
        % deltas vectoriales
        delta3 = (1 - tanh(h3).^2).*(W_43'*delta4);
        delta2 = (1 - tanh(h2).^2).*(W_32'*delta3);
        delta1 = (1 - tanh(h1).^2).*(W_21'*delta2);
        
        %Deltas_W
        %capa 4
        
        dW_43 = dW_43 + eta*delta4*V3';
        db_43 = db_43 + eta*delta4; 
        %capa 3
        dW_32 = dW_32 + eta*delta3*V2';
        db_32 = db_32 + eta*delta3;
        %capa 2
        dW_21 = dW_21 + eta*delta2*V1';
        db_21 = db_21 + eta*delta2;
        %capa 1
        dW_10 = dW_10 + eta*delta1*X(i,:);
        db_10 = db_10 + eta*delta1;    
    end
    % acutalizo los pesos
    W_43 = W_43 + dW_43;
    W_32 = W_32 + dW_32;
    W_21 = W_21 + dW_21;
    W_10 = W_10 + dW_10;

    b_43 = b_43 + db_43;
    b_32 = b_32 + db_32;
    b_21 = b_21 + db_21;
    b_10 = b_10 + db_10;
    % computo el error para esta iteracion
    E= 1/2*sum((V_d - V4).^2);
    E_vec(k) = E;
    k= k + 1;
end

V4
E

%%

figure()
plot(1:k-1,E_vec)
xlabel("Iteraciones")
ylabel("Error")
grid minor
