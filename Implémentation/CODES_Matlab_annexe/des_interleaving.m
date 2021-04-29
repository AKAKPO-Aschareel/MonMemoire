
function desintrlvd = des_interleaving(dataDemodulate)

%Initialize variables
 x= length(dataDemodulate);% data length
 t=24 ; %depth of interleaving
 n= x/t; % words length
 


input = dataDemodulate;

%Get time desinterleaving
%-----------------------------------------------
desintrlvd= reshape(input,t,n)' ;
desintrlvd = desintrlvd(:)';

end

