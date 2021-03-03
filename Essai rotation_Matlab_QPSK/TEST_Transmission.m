%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB+ Implémentation 
%Test de performance rotation de constellation avec modulation QPSk
%Transmission mode : Mode I
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear ;
clc;
close all;


%% At the transmitter part 


%DATA : 188 bytes *8 bits* 35 paquets RS= 52640 bits
binary_length = 52640;


TEB= [];%initialize BER 
SNR_dB_start = -5; %SNR range
SNR_dB_end = 10; %SNR range

%%
%simulation start

%Define binary sequence of message audio DAB+ represent FIC and MSC data
DataIn = randi ([0,1],1,binary_length); 

%Scrambling
DataScramble = dab_scramble (DataIn, binary_length);


%-----Channel codding-------

%RS encoder

codedRS= RS_essai_DAB(DataScramble);
 

%Convolutionnal coding
coded_convolutional = convolutionalDAB(codedRS);



% Time interleaving
intrlvd = time_interleaving(coded_convolutional);




%QPSK Modulation
dataQpsk = QPSKMOD(intrlvd );
%rotation constellation and cyclic delay 
Qpsk_rot= rotate_const(dataQpsk);

%Symbols interleaved
sym_interleaved= entrelacement_symboles (Qpsk_rot);


%OFDM Modulation
 pilote_OFDM = modPilote();
dataOFDM_modulate = Modulation(sym_interleaved, pilote_OFDM);

 
%%
%Pass the signal through an AWGN channel 

for Snr_dB= SNR_dB_start:0.5: SNR_dB_end
  Rx= [];
   for k= 1:78  %dtatofdm+Pilot
    rxSig = awgn(dataOFDM_modulate(:,k),Snr_dB,'measured','dB');
    Rx= [Rx rxSig];
  end

%%

 %At the receiver part 

%OFDM Demodulation
dataOFDM_demodulate = Demodulation(Rx,pilote_OFDM );



%symbol desinterleaving
sym_desinterleaved =desentrelacement_symbole (dataOFDM_demodulate);

%delete rotation constellation and cyclic delay 
non_rotate_data=delete_rotate_const(sym_desinterleaved);

%QPSK DEMODULATION
data_demodQPSK= QPSK_DEMOD(non_rotate_data);


%Time desinterleaving

desintrlvd = des_interleaving(data_demodQPSK);

%----Channel decoding------


% Convolutional decoding

decodedData_inner  = viterbi(desintrlvd);

% RS Decoding

decoded_RS= RS_decoder_DAB(decodedData_inner);

% Desscrambling

DataOut = dab_desscramble(decoded_RS);

% Calculate the number of bit errors
 nErrors = biterr(DataIn,DataOut);
        
 numBits = binary_length;
    
    
% Estimate the BER
 TEBnew = nErrors/numBits;
 TEB= [TEB TEBnew];


   end

%%plot result

figure(7)
SNR= SNR_dB_start:0.5: SNR_dB_end;
semilogy (SNR,TEB,'b-o','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
grid on;
hold on;
xlabel('SNR(dB)');
ylabel('BER');
legend('QPSK rotated');
axis([-5 10 1e-4 1e0]);
title('TEB en fonction de SNR');




