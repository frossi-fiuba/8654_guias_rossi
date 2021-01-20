 function Y = signo(X)
 Y      = zeros(size(X));
 for ii = 1:numel(X)  
    if X(ii) < 0
        Y(ii) = -1;
    else
        Y(ii) = 1;
    end
 end
 end