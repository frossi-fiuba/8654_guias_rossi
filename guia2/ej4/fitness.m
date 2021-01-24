function F = fitness(W, X, y_d, N_neu, N_capas, size_in, size_out)
    for i = randperm(length(X)) 
        ind = 1;
        h_in = reshape(W(ind:N_neu*size_in), N_neu, size_in)*X(i,:)'; 
        ind = ind + N_neu*size_in; 
        h_in = h_in + reshape(W(ind:ind + N_neu - 1), N_neu, 1);
        ind = ind + N_neu;
        V = tanh(h_in);
        for j =1:(N_capas - 2)
            h_med = reshape(W(ind:ind + N_neu^2 - 1), N_neu, N_neu)*V; 
            ind = ind + N_neu^2; 
            h_med = h_med + reshape(W(ind:ind + N_neu - 1), N_neu, 1);
            ind = ind + N_neu;
            V = tanh(h_med);
        end
        h_out = reshape(W(ind:ind + (N_neu*size_out) - 1 ),size_out, N_neu)*V;
        ind = ind + (N_neu*size_out); 
        h_out = h_out + reshape(W(ind:end), size_out, 1);
        V_out(i,1) = tanh(h_out);
    end
   
    E = 1/size(X,1) *(y_d - V_out)'* (y_d - V_out);
    F = 1 - E/4;

end

