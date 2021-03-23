function sym_interleaved= entrelacement_symboles(data)


 p=96 ; % depth of interleaving
 n= length(data)/p; % words length
 
 
%Get symbol interleaving
%-----------------------------------------------
 
 
sym_interleaved = matintrlv(data,p,n);


end


