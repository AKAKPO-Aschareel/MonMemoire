function sym_desinterleaved= desentrelacement_symbole (data)

data= reshape(data,1,76*1536);
 p=96 ; % depth of interleaving
 n= length(data)/p; % words length
 
 
%Get symbol interleaving
%-----------------------------------------------
 

sym_desinterleaved =  matdeintrlv(data,p,n);
%symbol_deintrlvd= reshape(sym_desinterleaved,76,1536);
%sym=reshape(data,1,76*1536);


end


