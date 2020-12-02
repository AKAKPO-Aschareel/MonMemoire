function coded_RS = Reed_Solomon_Encoder(DataOut)

%------------------------------------------------------------------------------------------------------
%Parameters for Reed Solomon  code 

m = 4; % number of bits per symbole
k = 11; % Number of symbols per message
n = 2^m-1; % Number of symbols per codeword

msg =DataOut ; % Binary message
msg_size = length (msg); %Binary message length
 
nb_paquets = msg_size/(k*m); % number of message of length k

%----------------------------------------------------------------------------------------------------


%Procedure

data=bi2de( reshape (msg, nb_paquets*k, m),'left-msb');% convert binary message to decimal integer 

message = gf(data,m); %creates a Galois field array from the data
message_redim = reshape(message,nb_paquets,k);

codeRS = rsenc(message_redim,n,k); % encoder RS
codeRS_redim= reshape(codeRS, 1,nb_paquets*n);


%conversion du vecteur d’éléments de GF(2M) en un vecteur d’entiers,
            gf_nonzero=gf([1:2^m-1],m);
            expformat=log(gf_nonzero)+1;
            for ii=1:2^m-1
            table_gf2dec(expformat(ii))=ii;
            end
            
data_code_rs_deci=ReedSolomon_gf2dec(codeRS_redim,table_gf2dec);
            

data_rs_bi= de2bi(data_code_rs_deci, 'left-msb'); %convert decimal integer to binary 
 coded_RS = reshape(data_rs_bi,1,n*nb_paquets*m);


end

