function RxData=demod_16QAM(data)
%Initialize variables;

 %OFDM PARAMETERS
K = 1536 ; %number of sub-carriers 
dataOfdm = 76; % nombres de paquets OFDM
n=4;% bit number
nbits = K * dataOfdm * n ; %nombre de bits total à envoyer
M=16;


%%PROCEDURE


sym_recu=data.';

%demodulation QAM
%SymboleMap=[2 3 0 1];


  %Demod DATA
 demodSig = qamdemod(sym_recu,M);

%converion  decimal en binaire
data_bi = de2bi (demodSig,'left-msb'); 
 
data_bi_redim=reshape(data_bi, 1,length(data_bi)*4);

%Remove zero padding


%%
zero_size=75264;
    data_remove_padding= data_bi_redim(:,1: (nbits-zero_size));


     RxData=data_remove_padding;
end

