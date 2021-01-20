function Y = err(samples,N,p,porc_eliminado)
%% ej3

for l = 1:samples
    % Construyo la matriz de pesos sinapticos
    P = 2*binornd(1,1/2,N,p)-1;
    W = P*P' - p*eye(N);
    
for k=1:length(porc_eliminado)
    
    W_aux = W;
    
    % elimino 
    vector = randperm(N*N);
    W_aux(vector(1:round(porc_eliminado(k)*N^2/100))) = 0; 
    % Error global
    Y(l,k) = mean(mean((signo(W_aux*P)-P)~=0)); % #bits incorrectos/(N*p)

end

end
end