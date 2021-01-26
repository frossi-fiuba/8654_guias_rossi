%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |2| |-| |E|J|E|R|C|I|C|I|O| |Adicional - Boltzmann|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Boltzmann

% Cleaning
clear all;
close all;
clc

cant_imagenes = 200;
mu = 0;
var = 1;
epsilon = 0.1; % cte de divergencia contrastiva

itermax = 5e3;

f = waitbar(0,'Inicializando...');

Nv = 784; %cantidad de neuronas de la capa visible
Nh = 10; %cantidad de neuronas de la capa oculta

% importo imagenes de entrenamiento y de testeo
datos_train = load('datosTrain.mat');
datos_train = datos_train.data'/255;
datos_test = load('datosTest.mat');
datos_test = datos_test.data'/255;

% matriz de pesos
W = normrnd(mu,var,Nv,Nh);

% genero bias capas visible y oculta
b_v = normrnd(mu,var,Nv,1);
b_h = normrnd(mu,var,Nh,1);

% declaro y guardo memoria
v_data = zeros(784,itermax);
h_data = zeros(10,itermax);
v_recon = zeros(784,itermax);
h_recon = zeros(10,itermax);
E_vec = zeros(itermax,1);

% 200 imagenes, cada columna es una imagen recorro una por una

for i = 1:itermax
waitbar(i/itermax,f,"Iteracion: "+i+"/"+itermax);
E = 0;
    for k = 1:cant_imagenes
        
        m_data = datos_train(:,k);
        v = normrnd(m_data,1);

        p = logistic(b_h + W'*v); % prob de 1 o 0 en capa oculta
      
        h = binornd(1,p); % hidden layer output

        v_data(:,k) = v; 
        h_data(:,k) = h; 

        % recostruccion
        m_recon = b_v + W*h;

        v = normrnd(m_recon,1);

        p = logistic(b_h + W'*v);
        h = binornd(1,p);

        v_recon(:,k) = v; 
        h_recon(:,k) = h;
        
       
         E = E + mean(abs(m_data-m_recon));
    end
    
    % error promedio
    E_vec(i) = E/cant_imagenes;

    % actualizo pesos y bias
    delta_w = epsilon/cant_imagenes*((v_data*h_data')-(v_recon*h_recon'));
    delta_b_v = epsilon*(mean(v_data,2)-mean(v_recon,2));
    delta_b_h = epsilon*(mean(h_data,2)-mean(h_recon,2));

    W = W + delta_w;
    b_v = b_v + delta_b_v;
    b_h = b_h + delta_b_h;
    
     %E(i) = mean(abs(m_data-m_recon));
    
end
close(f);

%% Graficos

figure()
plot(1:itermax, E_vec)
title("Error en funcion de la cantidad de iteraciones")
xlabel("Iteracion")
ylabel("E")
grid minor

%%
load('datosTest.mat');
data = data'/255;

for i=1:size(data,2)
    v = data(:,i);
    v_rs = reshape(v,28,28);
    
    fig1 = figure(1);
    imagesc(v_rs');
    axis off;
    colormap(gray(256));
    saveas(fig1, char("pics\test_"+i+"_in.png"),'png')
    
    v_recon = b_v + W*logistic(b_h + W'*v);
    v_recon_rs = reshape(v_recon,[28,28]);
    fig2 = figure(2);
    imagesc(v_recon_rs');
    axis off;
    colormap(gray(256));
    saveas(fig2, char("pics\test_"+i+"_out.png"), 'png')
end 
