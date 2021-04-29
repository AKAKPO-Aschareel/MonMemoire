
% REED SOLOMON SHORTNED DECODER %%%%
%shortened code RS(204,188,8) from an RS(255,239,8)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function decoded_RS= RS_decoder_DAB(codeword) 

%Parameters for Original Reed Solomon  code 
m = 8; % number of bits per symbole
K = 239; % Number of symbols per message
N = 2^m-1; % Number of symbols per codeword RS(N,K)

%Parameters for Shortened Reed Solomon  code 
K1 = 188; % Number of symbols per message
N1 = N-(K-K1); % Number of symbols per codeword RS (N1,K1)

%conversion du vecteur d’éléments de GF(2M) en un vecteur d’entiers,
            gf_nonzero=gf(1:2^m-1,m);
            expformat=log(gf_nonzero)+1;
            for ii=1:2^m-1
            table_gf2dec(expformat(ii))=ii;
            end
 %-----------------------------------------------------------------------          




%%%% Procedure de decodage

coded_RS =codeword;
msg = coded_RS ; % Binary message
nb_paquets = length(msg)/(N1*m); % number of codeword of length N1

%Generates null bytes filling to 255 bytes words for nb_paquets
zeros_matrix= zeros(m,(K-K1)*nb_paquets)';
zero_length= length(zeros_matrix);% number of zeros 

%Matrix of symbole of N1 data for nb_paquets
data204B = reshape (msg,m, nb_paquets*N1)';

%Concatened 51 null bytes + 204 data bytes for nb_paquets
data255B= [zeros_matrix; data204B ]; 

% convert binary codeword to decimal integer 
code_sym=bi2de(data255B,'left-msb');
code_sym_redim = reshape(code_sym',1,nb_paquets*N);

%creates a Galois field array from the data
message = gf(code_sym_redim,m); 
message_redim = reshape(message,N,nb_paquets)';

% decode the received signal
decodeRS = rsdec(message_redim,N,K); 
decodeRS_redim= reshape(decodeRS', 1,nb_paquets*K);

%convert gf symbol to integer
data_decode_rs_deci=ReedSolomon_gf2dec(decodeRS_redim,table_gf2dec);


%convert decimal integer to binary 
data_rs_bin= de2bi(data_decode_rs_deci', 'left-msb'); 
 decoded_RS255_239= data_rs_bin;

%Reed solomon (204,188) shortening
decoded_RS204_188= decoded_RS255_239(zero_length+1:K*nb_paquets,:) ;

%convert matrix bits to vector bits
decoded_RS = reshape(decoded_RS204_188',1,K1*nb_paquets*m);






end








