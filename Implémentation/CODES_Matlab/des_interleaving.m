
function desintrlvd = des_interleaving()

%Initialize variables
 t= 24; %depth of interleaving
 n= 6; % words length
 
dataModulate = Modulation(); % données en entree du demodulateur

input = Demodulation(dataModulate);
trellis = poly2trellis(7, [133 171 145 133]); %Define trellis

%Get time desinterleaving
%-----------------------------------------------
desintrlvd= reshape(input,t,n)' ;
desintrlvd = desintrlvd(:)';

end

