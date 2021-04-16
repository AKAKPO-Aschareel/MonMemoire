function RxData = DQPSK_DEMOD(data)

%Initialize variables;



 %OFDM PARAMETERS
K = 1536 ; %number of sub-carriers 
dataOfdm = 76; % nombres de paquets OFDM
nbits = K * dataOfdm * 2 ; %nombre de bits total à envoyer


%%PROCEDURE
sym_recu=reshape(data,1,dataOfdm*K);

sym_recu=sym_recu.';

%demodulation DQPSK

 %Create a DQPSK demodulator
dqpskdemod = comm.DQPSKDemodulator(pi/4,'BitOutput',false);

%Demo Data
demodSig = dqpskdemod(sym_recu); 
 
%converion  decimal en binaire
data_bi = de2bi (demodSig,'left-msb'); 
 
data_bi_redim=reshape(data_bi, 1,length(data_bi)*2);



%Remove zero padding



%%
zero_size=4992;
    data_remove_padding= data_bi_redim(:,1: (nbits-zero_size));


     RxData=data_remove_padding;
    

end


