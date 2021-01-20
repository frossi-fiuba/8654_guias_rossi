%% Ejercicio 3a: Err en funcion del % sinapsis
clear all;
%close all;
clc
N = 100;
p = 10;
p2 = 15;

porc_eliminado = [0:5:100];
samples = 10;

%% Graficos
err = ej3_funcion_v2(samples,N,p,porc_eliminado);
err2 = ej3_funcion_v2(samples,N,p2,porc_eliminado);
figure(1);
errorbar(porc_eliminado,mean(err),std(err))
hold on
errorbar(porc_eliminado,mean(err2),std(err2))
legend ("p=10","p=15")
title("err(%sinapsis eliminadas) N = 100")
xlabel("% sinapsis eliminadas")
ylabel("err")
grid minor
