%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |3| |-| |E|J|E|R|C|I|C|I|O| |2|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Red de Kohonen - Traveling Salesman problem
   
%% Cleaning
clear all;
close all;
clc

%% Constantes
cant_ins = 2;
Np = 200; % cantidad de ciudades
Nneu = 300; % cantidad de neuronas
ancho_vecindad_vec = 2.5:-0.1:0.2;
eta = 0.4; % cte de aprendizaje

%% Constantes auxiliares
ancho_it = 0; % cuenta iteraciones de cada vez que se achica el ancho de la vecindad
Cit = 1; % cuenta cantidad de iteraciones en calcular C

% posiciones de las ciudades
x = unifrnd(0,1,Np,1);
y = unifrnd(0,1,Np,1);
input = [x,y];

% grafico ciudades
fig1 = figure(1);
scatter(x,y,24, 'filled');
hold on
set(gcf, 'Position', [00,00,500,500])
grid on
grid minor

% inicializo pesos
W1 = unifrnd(0,1,Nneu,1);
W2 = unifrnd(0,1,Nneu,1);

% grafico pesos iniciales
h=scatter(W1,W2,24, 'filled', 'red');
legend("ciudades", "W",'location','northoutside');
h1=plot(W1,W2,'k','HandleVisibility','off');
h2=plot(W1',W2','k','HandleVisibility','off');
saveas(fig1, char(pwd + "\pics\" + Nneu + "x" + Np + '\'+ "kohonen" + string(ancho_it) + ".png")) % para guardar figura
ancho_it = ancho_it + 1;


for ancho_vecindad = ancho_vecindad_vec
    for i = randperm(length(x))
        % coord en espacio del patron
        coord_patron = input(i,:);
        % para cada neurona evaluo el par de pesos sinapticos que este mas cercano al patron en cuestion
        dist = zeros(Nneu,1); % vector de distancias
        for j = 1:Nneu
            coord_W = [W1(j), W2(j)];
            dist(j,1) = norm(coord_patron - coord_W);
        % mido distancia entre el punto y todos los Wi
        %||input(i) - W(i)||  
        end
        % una vez armado el vector de distancias agarro el index de la fila de la nerona ganadora neu_winner
        [dist_neu_winner, x_neu_winner] = min(dist);
        % para cada neurona calculo la funcion vecindad
        for j = 1:Nneu
            % distancia
            dist_neu = norm(j - x_neu_winner);
            % cierro el circulo entre neuronas, de manera que la primera y la ultima esten conectadas
            if (dist_neu == Nneu-1)
                dist_neu = 1;
            end
            % vecindad
            V = exp(-(dist_neu^2/(2*ancho_vecindad^2)));
            % actualizo pesos sinapticos
            W1(j) = W1(j) + eta*V*(x(i) - W1(j));
            W2(j) = W2(j) + eta*V*(y(i) - W2(j));

        end
     

    end

    % actualizo el grafico con los pesos actualizados
    delete(h)
    delete(h1)
    delete(h2)
    h=scatter(W1,W2,24, 'filled', 'red');
    legend("ciudades", "W");
    h1=plot(W1,W2,'k','HandleVisibility','off');
    h2=plot(W1',W2','k','HandleVisibility','off');
    saveas(fig1, char(pwd + "\pics\" + Nneu + "x" + Np + '\'+ "kohonen" + string(ancho_it) + ".png"))
    ancho_it = ancho_it + 1;
    pause(0.01);
    %legend("ciudades", "W");
    
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
        % para cada neurona calculo la funcion vecindad
        
        for j = 1:Nneu
            % distancia
            dist_neu = norm(j - neu_winner);
            % vecindad
            V = exp(-(dist_neu^2/(2*ancho_vecindad^2)));
            C = C + V*norm(coord_patron-[W1(j),W2(j)])^2;
        end
    end
    
    Cvec(Cit) = C/2;
    Cit = Cit + 1;
end

%% Grafico C
figure(2)
plot(Cvec,'linewidth',2)
xlabel("iteraciones",'fontsize',14)
ylabel("C",'fontsize',14)
grid on
grid minor
