%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |3| |-| |E|J|E|R|C|I|C|I|O| |1|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Red de Kohonen 
   
% Cleaning
clear all;
close all;
clc

% Constantes

cant_ins = 2;
Np = 2000; % cantidad de patrones
Nneu = 15*15; % cantidad de neuronas
R = 1; %radio del circulo
ancho_vecindad_vec = 2:-0.1:0.2;
eta = 0.4; % cte de aprendizaje

% Constantes auxiliares
dred = 1/255*[139,0,0]; % color para grafico
ancho_it = 0; % cuenta iteraciones de cada vez que se achica el ancho de la vecindad
Cit = 1; % cuenta cantidad de iteraciones en calcular C
% !! Para probar != patrones ir comentando y descomentando las secciones de generacion de patrones

%% CIRCULARES
% genero los patrones uniformes en el circulo unitario
 theta = 2*pi*rand(Np,1);
 r = R*sqrt(rand(Np,1));
 x = r.*cos(theta);
 y = r.*sin(theta);
 input = [x,y];

%% CUADRADOS
%  % genero los patrones uniforme en el cuadrado
%  x = unifrnd(-1,1,Np,1);
%  y = unifrnd(-1,1,Np,1);
%  input = [x,y];
%  %para plotear cuadrado
% sq_x = 2*[0, 1, 1, 0, 0] - 1;
% sq_y = 2* [0, 0, 1, 1, 0] -1;

%% CLUSTERS
% genero patrones en 2 clusters uniformes
%  x1 = unifrnd(-0.75,-0.5,Np/2,1);
%  y1 = unifrnd(-0.75,-0.5,Np/2,1);
%  x2 = unifrnd(0.5,0.75,Np/2,1);
%  y2 = unifrnd(0.5,0.75,Np/2,1);
%  x = [x1;x2];
%  y = [y1;y2];
%  input = [x,y];


% grafico patrones
fig1 = figure(1);
scatter(x,y,24, 'filled')
hold on
%plot(sq_x,sq_y,'k')% descomentar para cuadrado
viscircles([0,0],[1],'edgecolor','k');  circulo unitario
set(gcf, 'Position', [00,00,500,500])
grid on
grid minor

% inicializo pesos sinapticos en un cuadrado centrado
W1 = unifrnd(-0.1,0.1,Nneu,1);
W2 = unifrnd(-0.1,0.1,Nneu,1);

% plot iniciales
h = plot(reshape(W1,sqrt(Nneu),sqrt(Nneu))',reshape(W2,sqrt(Nneu),sqrt(Nneu))', 'k', 'linewidth',2);
h2 = plot(reshape(W1,sqrt(Nneu),sqrt(Nneu)),reshape(W2,sqrt(Nneu),sqrt(Nneu)), 'k', 'linewidth',2);
h3 = plot(W1,W2, 'or');

%saveas(fig1, char(pwd + "\pics\square\" + "kohonen" + string(ancho_it) + ".png")) % guardo figura
ancho_it = ancho_it + 1;
Cvec = zeros(length(ancho_vecindad_vec),1); % guardo memoria para guardar los valores de C

for ancho_vecindad = ancho_vecindad_vec
    % empiezo eligiendo 1 patron al azar
    for i = randperm(length(x))
        % coord del patron en espacio de patrones y pesos sinapticos
        coord_patron = input(i,:);
        % para cada neurona evaluo el par de pesos sinapticos que este mas cercano al patron en cuestion
        dist = zeros(Nneu,1); % vector de distancias entre pesos y patrones
        for j = 1:Nneu
            coord_W = [W1(j), W2(j)];
            dist(j,1) = norm(coord_patron - coord_W);
        % mido distancia entre el punto y todos los Wi
        %||input(i) - W(i)||  
        end
        % una vez armado el vector de distancias agarro el index de la fila de la nerona ganadora neu_winner
        [dist_neu_winner, neu_winner] = min(dist);
        [y_neu_winner, x_neu_winner] = ind2sub([sqrt(Nneu) sqrt(Nneu)], neu_winner); % paso el indice a su correspondiente matricial
        % para cada neurona calculo la funcion vecindad
        for j = 1:Nneu
            [y_neu, x_neu] = ind2sub([sqrt(Nneu) sqrt(Nneu)], j);
            %distancia
            dist_neu = norm([x_neu,y_neu] - [x_neu_winner,y_neu_winner]);
            % vecindad
            V = exp(-(dist_neu^2/(2*ancho_vecindad^2)));
            % actualizo pesos sinapticos
            W1(j) = W1(j) + eta*V*(x(i) - W1(j));
            W2(j) = W2(j) + eta*V*(y(i) - W2(j));

        end
    
    end

        % actualizo el grafico con los nuevos valores
        delete(h)
        delete(h2)
        delete(h3)
        h = plot(reshape(W1,sqrt(Nneu),sqrt(Nneu))',reshape(W2,sqrt(Nneu),sqrt(Nneu))', 'k', 'linewidth',2);
        h2 = plot(reshape(W1,sqrt(Nneu),sqrt(Nneu)),reshape(W2,sqrt(Nneu),sqrt(Nneu)), 'k', 'linewidth',2);
        h3 = plot(W1,W2, 'or');
        %saveas(fig1, char(pwd + "\pics\square\" + "kohonen" + string(ancho_it) + ".png"))
        ancho_it = ancho_it + 1;
        pause(0.01);
        
        % Ahora repito casi el mismo procedimiento una vez actualizados todos los patrones para calcular C
        C = 0; % inciializo en 0
        for i = 1:length(x)
            % coord en espacio del patron
            coord_patron = input(i,:);
            % para cada neurona evaluo el par de pesos sinapticos que este mas cercano al patron en cuestion
            dist = zeros(Nneu,1); % vector de distancias

            % busco neu ganadora
            for j = 1:Nneu
                coord_W = [W1(j), W2(j)];
                dist(j,1) = norm(coord_patron - coord_W);
                % mido distancia entre el punto y todos los Wi
                %||input(i) - W(i)||  
            end
            
            % index de la fila de la nerona ganadora neu_winner
            [dist_neu_winner, neu_winner] = min(dist);
            [y_neu_winner, x_neu_winner] = ind2sub([sqrt(Nneu) sqrt(Nneu)], neu_winner);
            % para cada neurona calculo la funcion vecindad
            
            for j = 1:Nneu
                [y_neu, x_neu] = ind2sub([sqrt(Nneu) sqrt(Nneu)], j);
                % distancia
                dist_neu = norm([x_neu,y_neu] - [x_neu_winner,y_neu_winner]);
                % vecindad
                V = exp(-(dist_neu^2/(2*ancho_vecindad^2)));
                C = C + V*norm(coord_patron-[W1(j),W2(j)])^2;
            end
        end
        
        Cvec(Cit) = C/2; % guardo C
        Cit = Cit + 1;

end

%% Grafico de C
figure(2)
plot(Cvec,'linewidth',2)
xlabel("iteraciones",'fontsize',14)
ylabel("C",'fontsize',14)
grid on
grid minor





