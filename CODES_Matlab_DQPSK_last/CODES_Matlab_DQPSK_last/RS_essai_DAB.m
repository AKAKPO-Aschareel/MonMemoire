
%REED SOLOMON SHORTNED ENCODER%%%%
%shortened code RS(204,188,8) from an RS(255,239,8)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function coded_RS= RS_essai_DAB(data)

%Parameters for Original Reed Solomon  code 
m = 8; % number of bits per symbole
K = 239; % Number of symbols per message
N = 2^m-1; % Number of symbols per codeword RS(N,K)


%Parameters for Shortened Reed Solomon  code 
K1 = 188; % Number of symbols per message
N1 = N-(K-K1); % Number of symbols per codeword RS (N1,K1)


 

%%conversion d'un symbole non nul de GF(2^m) en symbole d’entiers,
%
%
 gf_nonzero=gf(1:2^m-1,m);
 expformat=log(gf_nonzero)+1;
      for ii=1:2^m-1
          table_gf2dec(expformat(ii))=ii;
      end
  %---------------------------------------------------------------------------          
            
  
 

 %%%%%% Procedure de codage%%%%%%%%%%

bits_entree =data ; % Binary message scrambling
   

nb_paquets = length(bits_entree)/(K1*m); % number of message of length k1

 
%Generates null bytes filling to 255 bytes words for nb_paquets
zeros_matrix= zeros(m,(K-K1)*nb_paquets)';
zero_length= length(zeros_matrix);% number of zeros 

%Matrix of symbole of K1 data for nb_paquets
data188B = reshape (bits_entree,m, nb_paquets*K1)'; 

%Concatened 51 null bytes + 188data bytes for nb_paquets
data239B= [zeros_matrix; data188B ]; 

%convert binary symbole to decimal integer  
data_sym=bi2de(data239B ,'left-msb');
data_sym_redim= reshape(data_sym',1,nb_paquets*K); %vector of symbole

%creates a Galois field array from the data
message = gf(data_sym_redim,m); 
message_redim = reshape(message,K,nb_paquets)';

% encoding RS
codeRS = rsenc(message_redim,N,K); 
codeRS_redim= reshape(codeRS', 1,nb_paquets*N);

%convert gf symbol to integer
codeRS_de = ReedSolomon_gf2dec(codeRS_redim,table_gf2dec); 
            
%convert  integer to binary 
codeRS_bi= de2bi(codeRS_de', 'left-msb'); 
RS255_239= codeRS_bi;

%Reed solomon (204,188) shortening
RS204_188= RS255_239(zero_length+1:end,:) ;

%convert matrix bits to vector bits
coded_RS = reshape(RS204_188',1,N1*nb_paquets*m);




end

