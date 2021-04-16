%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB+ Implémentation  avec modulation 4QAM
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
SNR_dB_end = 0; %SNR range

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





%Data partitioning and QAM Modulation

data_ModQAM = QAM_mod(intrlvd );
%%
% plot constellation at transmitter

figure(1);
hold on;
plot(real(data_ModQAM),imag(data_ModQAM),'*');
title('Constellation 4-QAM emise')




%Symbols interleaved
sym_interleaved= entrelacement_symboles (data_ModQAM);


%OFDM Modulation 
 OFDM_symbol_block=76;
 OFDM_length=2552;
data_after_OFDM = Modulation(sym_interleaved); 

%Add null symbol at the beginning of frame
data_after_OFDM_redim=reshape(data_after_OFDM,1,OFDM_symbol_block*OFDM_length); 

%Null symbol generator
Tnull=2656;
null_symb=zeros(1,Tnull);

%Final frame structure generation

Tx_Frame_Final=[null_symb data_after_OFDM_redim];%frame length=196608 (one frame)


% %add AWGN NOISE 
 
for Snr_dB= SNR_dB_start:0.5: SNR_dB_end
 
  %Pass the signal through an AWGN channel
    rxSig = awgn(Tx_Frame_Final,Snr_dB,'measured','dB');
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %At the receiver part 
 
 data_receiver= rxSig(:,Tnull+1 :end);
 Rx=reshape(data_receiver,OFDM_symbol_block,OFDM_length);

 
 
%OFDM Demodulation
dataOFDM_demodulate = demodulation_OFDM(Rx);



%symbol desinterleaving
sym_desinterleaved =desentrelacement_symbole (dataOFDM_demodulate);
% figure(2);
% hold on;
% plot(real(sym_desinterleaved),imag(sym_desinterleaved),'*');
% title('Constellation QPSK recu')


% %QPSK DEMODULATION
data_demodQAM= demod_4QAM(sym_desinterleaved);


%Time desinterleaving

desintrlvd = des_interleaving(data_demodQAM);

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

figure(2)
SNR= SNR_dB_start:0.5: SNR_dB_end;
semilogy (SNR,TEB,'b-o','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
grid on;
hold on;
xlabel('SNR(dB)');
ylabel('BER');
legend('QPSK');
axis([-5 10 1e-4 1e0]);
title('TEB en fonction de SNR');





