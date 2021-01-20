%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |1| |-| |E|J|E|R|C|I|C|I|O| |4|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Temperatura critica en el modelo de Ising 1D

%% Cleaning
clear all;
close all;
clc

% Grid de 35x35 spines
N = 35*35;
h_ext = 0; % campo externo nulo
K = 1;
T = [4:-0.1:0.5]; 
samples = 35;

% 
v = ones(N,1);
W = diag(v(1:N-1),1) + diag(v(1:N-1),-1);

S = 2*binornd(1,1/2,N,1)-1; % inicio en temperaturas altas de manera que empiezo aleatoriamente
H = -1/2 * S'*W*S; %+ h_ext*mean(S)*N; % energia inicial


%%
%disp("GO")

for j = 1:length(T)
    %tic
    for p = 1:samples
        
        vector = randperm(N);
        for i = 1:N
            S(vector(i)) = - S(vector(i));
            %disp("S nuevo"+S(vector(i)))
            %pause; 
            H_prima = -1/2 * S'*W*S; %+ h_ext*mean(S)*N;
            Delta_H = H_prima-H;
            %disp("DeltaH"+Delta_H)
            %pause;
            if (Delta_H <=0)
                H = H_prima; % acepto el cambio
            else
                p = exp(-Delta_H/(K*T(j))); % probabilidad de aceptar el cambio
                B = binornd(1,p);
                if (B==1)
                    H = H_prima;% acepto el cambio
                else
                    S(vector(i)) = - S(vector(i)); %no acepto el cambio
                    %disp("S rechazado")
                    %pause;
                    
                end 

            end

        end

    end
    
    mean_S(j) = mean(S);
    %toc
end

%%

figure(1)
s = scatter(T,mean_S,'x');
hold on
s.LineWidth = 0.6;
sigm_fit(T,mean_S)
xlabel("Temperatura")
ylabel("<S>")
set(gca,'xdir','reverse')

title('<S> a diferentes temperaturas')
grid minor

%%


