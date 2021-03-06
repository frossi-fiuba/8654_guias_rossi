
%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |1| |-| |E|J|E|R|C|I|C|I|O| |1|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Implementación de red de Hopfield (82')

% Cleaning
clear all;
close all;
clc

% Defino cantidad de neuronas y patrones a enseñar de la red
N = 2250; % cant de neuronas
p = 6; % cant de patrones

%% entrenamiento
path =  "imagenes\";
images = [path + "paloma.bmp", path + "panda.bmp", path + "perro.bmp", path + "quijote.bmp", path + "torero.bmp", path + "v.bmp"];

for i=1:length(images)
    P(:,i) = image2vector(char(images(i)),N);
end
    
% imagen 1: paloma
P1 = P(:,1);
% imagen 2: panda
P2 = P(:,2);
% imagen 3: perro
P3 = P(:,3);
%imagen 4: quijote
P4 = P(:,4);
%imagen 5: torero
P5 = P(:,5);
%imagen 6: v
P6 = P(:,6);

% generacion de la red de pesos sinápticos
W = 0;

for i = 1:p
   W = W + P(:,i)*transpose(P(:,i)); 
end

W = W -p.*eye(N);  % Todas las imagenes se enseñan
W2 = P1*P1' - eye(N); % solo paloma
W3 =   P2*P2' + P3*P3' + P4*P4' + P5*P5' + P6*P6' - 5*eye(N); % todo menos paloma

%% ejecucion

% elegir el estado inicial de la red
%h = P7 + 0; %PANDA CON BIGOTE AGREGADO (Anda con W sin P1P1' paloma)
%h = P5 + normrnd(0,1,[N,1]);  % imagen + ruido gaussiano N(0,1)
%h = P1;
%h = cat(1,P2(1:2*N/3),zeros(N/3,1));  %imagen parcial
%h = -P2; % panda negado
h = P4+P5+P6 % Mezcla de patrones

% Imagen inicial
s = signo(h);
imagesc(reshape(s,45,50));

%% async
Ncorridas = 8; %cantidad de corridas
for i= 1:Ncorridas
    vector = randperm(N);

    for i=1:N
        h(vector(i)) = dot(W3(vector(i),:),s);
        s = signo(h);
        pause(.00001);imagesc((reshape(s,45,50)+1)/2)
    end
end
