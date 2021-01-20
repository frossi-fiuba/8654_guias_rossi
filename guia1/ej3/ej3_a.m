%%% Autor: Francisco Rossi
%%% Materia: 86.54 - Redes Neuronales, Facultad de Ingeniería (U.B.A)
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% |G|U|I|A| |1| |-| |E|J|E|R|C|I|C|I|O| |3a|
%%% +-+-+-+-+ +-+ +-+ +-+-+-+-+-+-+-+-+-+ +-+
%%% Error de la red de Hopfield (82') en funcion del % sinapsis eliminadas (82')

%% Cleaning
clear all;
close all;
clc

%% Definicion de variables
N = 100;
p = 10;
p2 = 15;

porc_eliminado = [0:5:100];
samples = 10;

%% Graficos
err = f_err(samples,N,p,porc_eliminado);
err2 = f_err(samples,N,p2,porc_eliminado);
figure(1);
errorbar(porc_eliminado,mean(err),std(err))
hold on
errorbar(porc_eliminado,mean(err2),std(err2))
legend ("p=10","p=15")
title("err(%sinapsis eliminadas) N = 100")
xlabel("% sinapsis eliminadas")
ylabel("err")
grid minor
