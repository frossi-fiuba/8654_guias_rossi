% Ejercicio 5 - Guia 3
% Rossi Francisco - 99540

%%
clear all;
close all;
clc
alpha = 0.99;
mu = 0;
var = 0.5;
k = 1;
T_max = 20;
T_min = 1e-6;
E_target = 1e-4;
N = 4; % cantidad de neuronas x capa
size_X = 3; % cantidad de entradas
%
%%
X = [ones(4,1),[-1;1;-1;1],[-1;-1;1;1]];
y_d = [-1;1;1;-1]; % salida x-or
% inicializo w

% Pesos sinapticos iniciales
W_10 = normrnd(mu,var,N,size_X); 
W_21 = normrnd(mu,var,N,N); 
W_32 = normrnd(mu,var,N,N);
W_43 = normrnd(mu,var,1,N);

%defino los pesos sinapticos de los bias
b_10 = normrnd(mu,var,N,1);
b_21 = normrnd(mu,var,N,1);
b_32 = normrnd(mu,var,N,1);
b_43 = normrnd(mu,var,1,1);

T = T_max; % temperatura maxima es la incial
j = 2;
% primer recorrido
for i = randperm(length(X)) 
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
        V4 = tanh(h4);
        %pause()
end
    
    E = 1/2 *(y_d - V4)'* (y_d - V4);
    E_vec(1) = E;
    
while(E > E_target)
    
    W_10_ast = W_10 + normrnd(0,var,N,size_X);
    W_21_ast = W_21 + normrnd(mu,var,N,N); 
    W_32_ast = W_32 + normrnd(mu,var,N,N); 
    W_43_ast = W_43 + normrnd(mu,var,N,N); 
    
    b_10_ast = b_10 + normrnd(mu,var,N,1);
    b_21_ast = b_21 + normrnd(mu,var,N,1);
    b_32_ast = b_32 + normrnd(mu,var,N,1);
    b_43_ast = b_43 + normrnd(mu,var,N,1);
    
    for i = randperm(length(X)) 
        % out 1 capa
        h1 = W_10_ast*X(i,:)' + b_10_ast;
        V1 = tanh(h1); 
        % out 2 capa
        h2 =  W_21_ast*V1 + b_21_ast;
        V2 = tanh(h2) ;
        % out 3 capa
        h3 = W_32_ast*V2 + b_32_ast;
        V3 = tanh(h3) ;
        % out final
        h4 = W_43_ast*V3 + b_43_ast;
        V4_ast = tanh(h4);
        %pause()
    end
    
    E_ast = 1/2 * (y_d - V4_ast)' * (y_d - V4_ast);

    delta_E  = E - E_ast

    if (delta_E < 0 || binornd(1,exp(-delta_E/(k*T))))
        W_10 = W_10_ast;
        W_21 = W_21_ast; 
        W_32 = W_32_ast;
        W_43 = W_43_ast;
        
        b_10 = b_10_ast;
        b_21 = b_21_ast;
        b_32 = b_32_ast;
        b_43 = b_43_ast;
        E = E_ast;
        
    end
    E_vec(j) = E;
    j = j + 1;
    %disp("E = ")
    
    if(T < T_min)
        disp("No convergio, llego a Tmin");
        break;
    end
    
    T = T*alpha;
end
    
%%

figure()
plot(1:j-1,E_vec)
xlabel("Iteraciones")
ylabel("Error")
title("Error en funcion de las iteraciones")
grid on