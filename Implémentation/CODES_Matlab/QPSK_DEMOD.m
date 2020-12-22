function demod_QPSK_data = QPSK_DEMOD(OFDM_Parameters,data)

%Initialize variables;

%QPSK PARAMETERS

M=OFDM_Parameters.M; % number of symbole for modulation QPSK
init_phase = OFDM_Parameters.init_phase; % phase inital QPSK
nbits = OFDM_Parameters.nbits; %nombre de bits total à envoyer



padding='1';

%%PROCEDURE



sym_recu=data;
figure(2);
hold on;
plot(real(sym_recu ),imag(sym_recu),'*');
title('Constellation recu')



%demodulation QPSK
demodData = pskdemod(sym_recu,M,init_phase); 

%convert data decimal to binary
demodData = de2bi(demodData,'left-msb'); 


%Remove zero padding

if padding == '1'
    data_remove_padding= demodData(1: (nbits/2-960),:);
end

    
    %vecteurs de bits
dataDemodulate = data_remove_padding(:)';


demod_QPSK_data=dataDemodulate;


end

