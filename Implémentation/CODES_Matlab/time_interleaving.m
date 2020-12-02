
%ENTRELACEMENT
%-------------------------------------------------------------
function intrlvd = time_interleaving(codedData)

%Initialize variables
 x= length(codedData);% Convolutional code word length
 t=24 ; %depth of interleaving
 n= x/t; % words length
 
%Get time interleaving
%-----------------------------------------------
intrlvd= reshape (codedData,n,t)';
intrlvd=intrlvd(:)'; 


end

