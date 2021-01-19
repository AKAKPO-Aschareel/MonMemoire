
function symbol_intrlvd = entrelacement_symboles(data)

M_IFFT = 1536 ; %number of sub-carriers 
dataOfdm = 75 ; %  symbol OFDM

 t=75 ; % depth of interleaving

 
 
%Get symbol interleaving
%-----------------------------------------------
 data_redim= reshape (data,1,M_IFFT* dataOfdm);
 x= length(data_redim); % data length
  n= x/t; % words length
  
sym_interleaved = matintrlv(data_redim,t,n);
sym_interleaved_matrix= reshape (sym_interleaved,M_IFFT,dataOfdm);

symbol_intrlvd= sym_interleaved_matrix;
end

