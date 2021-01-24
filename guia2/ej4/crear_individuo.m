function  W = crear_individuo(mu, var, size_w_in, size_w_out,size_w_mid) 
    largo = size_w_in + size_w_mid + size_w_out;
    W = normrnd(mu, var, largo,1);
end
