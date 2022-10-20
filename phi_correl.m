%% Calculate the phi coefficent
% This function will calculate the phi coefficent for two binary vectors:
% The binary Vectors needs to be the input and the output will be the phi
% coefficent
% Matthias Sure
function phi = phi_correl(Vector_1,Vector_2)
    a = size(find(Vector_1 == 0 & Vector_2 == 0),1);
    b = size(find(Vector_1 == 1 & Vector_2 == 0),1);
    c = size(find(Vector_1 == 0 & Vector_2 == 1),1);
    d = size(find(Vector_1 == 1 & Vector_2 == 1),1);
    phi = (a*d-b*c)/sqrt((a+b)*(c+d)*(a+c)*(b+d));
end