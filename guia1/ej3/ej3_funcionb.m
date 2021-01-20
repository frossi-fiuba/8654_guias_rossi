 function Y = err(samples,N,p,porc_eliminado)
%% ej3

for l = 1:samples
    % Construyo la matriz de pesos sinapticos
    P = 2*binornd(1,1/2,N,p)-1;
    W = P*P' - p*eye(N);
    
for k=1:length(porc_eliminado)
    
    W_aux = W;
    
    z = 1;
    i = 2;
    j = 1;
    while (z <=  ((N^2-N)*porc_eliminado(k))/200)
        W_aux(i,j) = 0;
        W_aux(j,i) = 0;
        i = i + 1;
        if (i > N)
            j = j + 1;
            i = j + 1;
        end
    z = z + 1;
    end
    % Error global
    Y(l,k) = mean(mean((signo(W_aux*P)-P)~=0)); % #bits incorrectos/(N*p)
    
    if(Y(l,k) < perr)
        p = p + 1;
    else
        C = (pmax-1)/N;
    end
    
end

end
end