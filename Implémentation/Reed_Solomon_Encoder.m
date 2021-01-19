
%REED SOLOMON ENCODER%%%%

function coded_RS = Reed_Solomon_Encoder(DataOut)

%------------------------------------------------------------------------------------------------------
%Parameters for Reed Solomon  code 

m = 4; % number of bits per symbole
k = 11; % Number of symbols per message
n = 2^m-1; % Number of symbols per codeword RS

bits_entree =DataOut ; % Binary message scrambling
 
nb_paquets = length(bits_entree)/(k*m); % number of message of length k

%%conversion d'un symbole non nul de GF(2^m) en symbole d’entiers,
%
%
 gf_nonzero=gf(1:2^m-1,m);
 expformat=log(gf_nonzero)+1;
      for ii=1:2^m-1
          table_gf2dec(expformat(ii))=ii;
      end
            
            
   %Procedure de codage
   %
msg = bits_entree; %vecteurs de bits correspondant à nb_paquets de k*m bits
msg_matrix= reshape (msg,m, nb_paquets*k)';% matrice de symbole binaire
data_sym=bi2de(msg_matrix ,'left-msb');% convert binary message to decimal integer and formation of symbole 
data_sym_redim= reshape(data_sym',1,nb_paquets*k);
message = gf(data_sym_redim,m); %creates a Galois field array from the data
message_redim = reshape(message,k,nb_paquets)';

codeRS = rsenc(message_redim,n,k); % encoder RS
codeRS_redim= reshape(codeRS', 1,nb_paquets*n);
           
codeRS_de = ReedSolomon_gf2dec(codeRS_redim,table_gf2dec); %convert gf symbol to integer
            

codeRS_bi= de2bi(codeRS_de', 'left-msb'); %convert  integer to binary 

 coded_RS = reshape(codeRS_bi',1,n*nb_paquets*m);%convert matrix bits to vector bits


end

