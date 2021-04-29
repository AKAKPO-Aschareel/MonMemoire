

%ENTRELACEMENT



function intrlvd = time_interleaving(codedData)


 %Procedure
 
 t=24 ; % depth of interleaving

 data = codedData; % output of convolutionnal encoder
 x= length(data); % data length
  n= x/t; % words length
  
 
%Get time interleaving
%-----------------------------------------------
intrlvd= reshape (data,n,t)';
intrlvd=intrlvd(:)'; 

 

end

