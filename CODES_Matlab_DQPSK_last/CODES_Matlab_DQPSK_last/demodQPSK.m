function RxData = demodQPSK(data)
%Initialize variables;


 %OFDM PARAMETERS
K = 1536 ; %number of sub-carriers 
dataOfdm = 76; % nombres de paquets OFDM
nbits = K * dataOfdm * 2 ; %nombre de bits total à envoyer
M=4;
init_phase= pi/4; % phase inital QPSK



%%PROCEDURE


sym_recu=data.';

%demodulation QPSK



  %Demod DATA
 demodSig =pskdemod(sym_recu,M,init_phase);

%converion  decimal en binaire
data_bi = de2bi (demodSig,'left-msb'); 
 
data_bi_redim=reshape(data_bi, 1,length(data_bi)*2);

%Remove zero padding


%%
zero_size=4992;
    data_remove_padding= data_bi_redim(:,1: (nbits-zero_size));


     RxData=data_remove_padding;
    

end

