%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB Implémentation    
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear ;
close all;
clc;

%% Emission



%188 bytes *8 bits* 35 paquets RS= 52640 bits
binary_length = 52640;


TEB= [];

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


%OFDM Modulation
dataOFDM_modulate = Modulation(sym_interleaved);


%%
%Pass the signal through an AWGN channel 

for snr= 0:0.05:10
  Rx= [];
   for k= 1:75
    rxSig = awgn(dataOFDM_modulate(:,k),snr ,'measured','dB');
    Rx= [Rx rxSig];
  end

%% Reception

%OFDM Demodulation
dataOFDM_demodulate = Demodulation(Rx );

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


snr=0:0.05:10;
figure(3)
 semilogy (snr,TEB,'r-*','linewidth',2)
grid on;
hold on;
xlabel('SNR');
ylabel('TEB');
 axis([0 20 1e-4 1e0]);
    
title('TEB en fonction de SNR');



%%END
