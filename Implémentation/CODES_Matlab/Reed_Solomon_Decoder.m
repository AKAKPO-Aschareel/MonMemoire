function decoded_RS = Reed_Solomon_Decoder(decodedData)


%Parameters for Reed Solomon  code 
%%
m = 4; % number of bits per symbole
k = 11; % Number of symbols per message
n = 2^m-1; % Number of symbols per codeword

msg = decodedData ; % Binary message
msg_size = length (msg); %Binary message length
 

%%
%Procedure
nb_paquets = msg_size/(n*m); % number of message of length k

data=bi2de( reshape(msg, nb_paquets*n, m),'left-msb');% convert binary message to decimal integer 

message = gf(data,m); %creates a Galois field array from the data
message_redim = reshape(message,nb_paquets,n);

decodeRS = rsdec(message_redim,n,k); %  to decode the received signal
decodeRS_redim= reshape(decodeRS, 1,nb_paquets*k);

%conversion du vecteur d’éléments de GF(2M) en un vecteur d’entiers,
            gf_nonzero=gf([1:2^m-1],m);
            expformat=log(gf_nonzero)+1;
            for ii=1:2^m-1
            table_gf2dec(expformat(ii))=ii;
            end
            
data_decode_rs_deci=ReedSolomon_gf2dec(decodeRS_redim,table_gf2dec);
            

data_rs_bin= de2bi(data_decode_rs_deci, 'left-msb'); %convert decimal integer to binary 
 decoded_RS = reshape(data_rs_bin,1,k*nb_paquets*m);




end

