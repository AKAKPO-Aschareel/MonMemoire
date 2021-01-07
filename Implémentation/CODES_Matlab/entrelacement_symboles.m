function symbol_interleaved = entrelacement_symboles(OFDM_Parameters,data)

M_IFFT = OFDM_Parameters.M_IFFT ; %number of sub-carriers 
dataOfdm = OFDM_Parameters.dataOfdm; % nombres de paquets OFDM

 t=24 ; % depth of interleaving

 data = codedData; % output of convolutionnal encoder
 x= length(data); % data length
  n= x/t; % words length
  
 
%Get time interleaving
%-----------------------------------------------
intrlvd= reshape (data,n,t)';
intrlvd=intrlvd(:)'; 

end

