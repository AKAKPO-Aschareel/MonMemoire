
function desintrlvd = des_interleaving(dataDemodulate)

%Initialize variables
 x= length(dataDemodulate);% Convolutional code word length
 t=24 ; %depth of interleaving
 n= x/t; % words length
 


input = dataDemodulate;
trellis = poly2trellis(7, [133 171 145 133]); %Define trellis

%Get time desinterleaving
%-----------------------------------------------
desintrlvd= reshape(input,t,n)' ;
desintrlvd = desintrlvd(:)';

end

