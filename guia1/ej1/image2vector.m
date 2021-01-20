function P = image2vector( image ,N)
    imagen = imread(image);
    imagen = imagen(1:45,1:50);
    P(:,1) = imagen(:);
    P = 2*P - 1;
    P = P(1:N);
end

