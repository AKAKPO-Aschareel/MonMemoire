%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB+ Implémentation  
%Transmission mode : Mode I
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;
close all;


%% Emission


%DATA : 188 bytes *8 bits* 35 paquets RS= 52640 bits
binary_length = 52640;


TEB= [];%initialize BER 
SNR_dB_start = 0; %SNR range
SNR_dB_end = 20; %SNR range

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

%Symbols interleaved
sym_interleaved= entrelacement_symboles (dataQpsk);

%Differential modulation
DQPSK_data = differential_modulator(sym_interleaved);

%OFDM Modulation

dataOFDM_modulate = Modulation(DQPSK_data);

%{
%%
%Pass the signal through an AWGN channel 

for Snr_dB= SNR_dB_start: SNR_dB_end
  Rx= [];
   for k= 1:85  %dtatofdm+Pilot
    rxSig = awgn(dataOFDM_modulate(:,k),Snr_dB,'measured','dB');
    Rx= [Rx rxSig];
  end

%% Reception

%OFDM Demodulation
dataOFDM_demodulate = Demodulation(dataOFDM_modulate );


%symbol desinterleaving
sym_desinterleaved =desentrelacement_symbole (dataOFDM_demodulate);

%QPSK DEMODULATION
data_demodQPSK= QPSK_DEMOD(sym_desinterleaved );


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

figure(3)
SNR= SNR_dB_start:1: SNR_dB_end;
semilogy (SNR,TEB,'r--*','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
grid on;
hold on;
xlabel('SNR(dB)');
ylabel('BER');
legend('QPSK');
axis([0 20 1e-4 1e0]);
title('TEB en fonction de SNR');


%}

