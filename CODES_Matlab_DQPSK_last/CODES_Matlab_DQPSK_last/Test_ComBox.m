%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB+ Implémentation  avec modulation QPSK
%Transmission mode : Mode I
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear ;
clc;
close all;


%% At the transmitter part 


%DATA : 188 bytes *8 bits* 35 paquets RS= 52640 bits
binary_length = 52640;


% TEB= [];%initialize BER 
SNR_dB_start = 10; %SNR range
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




%Data partitioning and QPSK Modulation

data_ModQPSK = QPSK(intrlvd );
%%
% plot constellation at transmitter

figure(1);
hold on;
plot(real(data_ModQPSK),imag(data_ModQPSK),'*');
title('Constellation QPSK emise')

%%


%Symbols interleaved
sym_interleaved= entrelacement_symboles (data_ModQPSK);


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

  %Pass the signal through an RAYLEIGH channel
 NFFT=2048;
 %Get CIR 
%  hT=Canal_Rayleigh_CSP_();
 hT = GenerateRayleigh('DVB_T');
  dataAux = conv(hT, Tx_Frame_Final);

rayleigh_out = dataAux(1:length(Tx_Frame_Final));

Snr_dB= SNR_dB_start: SNR_dB_end;
nChannelRealizations = 1;
% %add AWGN NOISE 
% 
TEB = zeros(nChannelRealizations,length(Snr_dB));
for indexSnr= 1:length(Snr_dB)
   
    
    for indexChannelRealizations=1:nChannelRealizations
    
 n=awgn_noise(rayleigh_out,Snr_dB(indexSnr)); %noise vector
  
  rxSig =rayleigh_out + n;
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %At the receiver part 
 
 data_receiver= rxSig(:,Tnull+1 :end);
Rx=reshape(data_receiver,OFDM_symbol_block,OFDM_length);

 hF = fftshift(fft(hT,2048));
 
%OFDM Demodulation
dataOFDM_demodulate = Demod_ComBox(Rx,hF);



%symbol desinterleaving
sym_desinterleaved =desentrelacement_symbole (dataOFDM_demodulate);
% figure(2);
% hold on;
% plot(real(sym_desinterleaved),imag(sym_desinterleaved),'*');
% title('Constellation QPSK recu')


%QPSK DEMODULATION
data_demodQPSK= demodQPSK(sym_desinterleaved );


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
 TEB(indexChannelRealizations,indexSnr)=TEBnew;


    end
indexSnr
end
BER = mean(TEB,1);

%%plot result

figure(3)
SNR= Snr_dB;
semilogy (SNR,BER,'b-o','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
grid on;
hold on;
xlabel('SNR(dB)');
ylabel('BER');
legend('QPSK');
axis([1 30 1e-4 1e0]);
title('TEB en fonction de SNR');
