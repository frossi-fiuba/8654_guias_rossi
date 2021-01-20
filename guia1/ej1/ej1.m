% Limpio todo
clear all;
close all;
clc
% Defino cantidad de neuronas y patrones de la red
N = 2250; % cant de neuronas
p = 6; % cant de patrones

%% entrenamiento
% imagen 1
imagen = imread('paloma.bmp');
imagen = imagen(1:45,1:50);
P1(:,1) = imagen(:);
P1 = 2*P1 - 1;
P1 = P1(1:N);
% imagen 2
imagen = imread('panda.bmp');
imagen = imagen(1:45,1:50);
P2(:,1) = imagen(:);
P2 = 2*P2 - 1;
P2 = P2(1:N);
% imagen 3
imagen = imread('perro.bmp');
imagen = imagen(1:45,1:50);
P3(:,1) = imagen(:);
P3 = 2*P3 - 1;
P3 = P3(1:N);
%imagen 4
imagen = imread('quijote.bmp');
imagen = imagen(1:45,1:50);
P4(:,1) = imagen(:);
P4 = 2*P4 - 1;
P4 = P4(1:N);
%imagen 5
imagen = imread('torero.bmp');
imagen = imagen(1:45,1:50);
P5(:,1) = imagen(:);
P5 = 2*P5 - 1;
P5 = P5(1:N);
%imagen 6
imagen = imread('v.bmp');
imagen = imagen(1:45,1:50);
P6(:,1) = imagen(:);
P6 = 2*P6 - 1;
P6 = P6(1:N);

% generacion de la red de pesos
P = [P1,P2,P3,P4,P5,P6];
W = 0;

for i = 1:p
   W = W + P(:,i)*transpose(P(:,i)); 
end

W = W -p.*eye(N); 
W2 = P1*P1' - eye(N); % solo paloma
W3 =   P2*P2' + P3*P3' + P4*P4' + P5*P5' + P6*P6' - 5*eye(N); % todo menos paloma
%% ejecucion
% estado inicial
%h = P7 + 0; %PANDA CON BIGOTE AGREGADO (Anda con W sin P1P1' paloma)
%h = P5 + normrnd(0,1,[N,1]);  % imagen + ruido normal estandar
%h = P1;
%h = cat(1,P2(1:2*N/3),zeros(N/3,1));  %imagen parcial
%h = -P2; % panda negado
h = P4+P5+P6 

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


%% sync
h = W*s;
s = signo(h);
imagesc(reshape(s,45,50));



