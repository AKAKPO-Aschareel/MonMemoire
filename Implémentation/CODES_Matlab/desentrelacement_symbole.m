function symbol_deintrlvd = desentrelacement_symbole (data)

M_IFFT = 1536 ; %number of sub-carriers 
dataOfdm = 75 ; %  symbol OFDM

 t=75 ; % depth of interleaving

 
 
%Get symbol desinterleaving
%-----------------------------------------------
 sym_redim= reshape (data,1,M_IFFT* dataOfdm);
 x= length(sym_redim); % data length
  n= x/t; % words length
  
sym_desinterleaved =  matdeintrlv(sym_redim,t,n);
sym_desinterleaved_matrix= reshape (sym_desinterleaved,M_IFFT,dataOfdm);

symbol_deintrlvd= sym_desinterleaved_matrix;
end

