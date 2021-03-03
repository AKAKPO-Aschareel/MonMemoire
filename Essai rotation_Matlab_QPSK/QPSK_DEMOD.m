function demod_QPSK_data = QPSK_DEMOD(data)

%Initialize variables;

%QPSK PARAMETERS

n=2;% number of  bits per symbole QPSK
M =4 ; % number of symbole for modulation QPSK
init_phase = pi/4; % phase inital QPSK

 %OFDM PARAMETERS
K = 1536 ; %number of sub-carriers 
dataOfdm = 75; % nombres de paquets OFDM
nbits = K * dataOfdm * n  ; %nombre de bits total à envoyer





%%PROCEDURE
sym_recu=data;

%plot constellation

figure(6);
hold on;
plot(real(sym_recu ),imag(sym_recu),'*');
title('Constellation recu')



%demodulation QPSK
demodData= [];
 for l= 1:dataOfdm
     demod = pskdemod(sym_recu(:,l),M,init_phase); 
     
     demodData = [demodData demod];
 end 

%convert data decimal to binary
demodData = de2bi(demodData,'left-msb'); 


%Remove zero padding



%%

    data_remove_padding= demodData(1: (nbits/2-960),:);


    
    %vecteurs de bits
dataDemodulate = data_remove_padding(:)';


demod_QPSK_data=dataDemodulate;



end

