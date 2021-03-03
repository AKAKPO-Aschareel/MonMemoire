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


%Symbols interleaved
sym_interleaved= entrelacement_symboles (dataQpsk);


%OFDM Modulation
 pilote_OFDM = modPilote();
dataOFDM_modulate = Modulation(sym_interleaved, pilote_OFDM);

 
%%
%{
%%%%%%%%%%%%%%%Creates rayleigh channel%%%%%%%%%%%%%%%%%% 

%Rayleigh channel simulated in urban environment Mode I

 %parameters
 fo=225.648 *1e6; %center frequency for Carrier frequency 12B 
% T-DAB channel in band III VHF, 1.536 MHz bandwidth
 v= 25/3.6 ; %m/s ,% vehicule velocity 25 Km/h

 c= 300* 1e6; % speed of light m/s

fs = 2.048* 1e6; % Hz
pathDelays = [0 0.2 0.5 1.6 2.3 5]*1e-6;    % sec
avgPathGains = [-3 0 -2 -6 -8 -10];      % dB
fD = (v/c)* fo; % Hz
rchan = comm.RayleighChannel('SampleRate',fs, ...
    'PathDelays',pathDelays, ...
    'AveragePathGains',avgPathGains, ...
    'MaximumDopplerShift',fD);
%%
 %Pass the signal through an rayleigh channel 
   rayleigh_out_signal=[];
 for k= 1:78  %dtatofdm+Pilot
  rayleigh_signal = rchan(dataOFDM_modulate(:,k));
  rayleigh_out_signal= [rayleigh_out_signal rayleigh_signal];
 end
%}
 
for Snr_dB= SNR_dB_start:0.5: SNR_dB_end
  Rx= [];
   for k= 1:78  %dtatofdm+Pilot

  %Pass the signal through an AWGN channel
    rxSig = awgn(dataOFDM_modulate(:,k),Snr_dB,'measured','dB');
    Rx= [Rx rxSig];
   end
 


 
  

 
%%

 %At the receiver part 

%OFDM Demodulation
dataOFDM_demodulate = Demodulation(Rx,pilote_OFDM );

%symbol desinterleaving
sym_desinterleaved =desentrelacement_symbole (dataOFDM_demodulate);

%QPSK DEMODULATION
data_demodQPSK= QPSK_DEMOD(sym_desinterleaved);


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
SNR= SNR_dB_start:0.5: SNR_dB_end;
semilogy (SNR,TEB,'b-o','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
grid on;
hold on;
xlabel('SNR(dB)');
ylabel('BER');
legend('QPSK non rotated');
axis([-5 10 1e-4 1e0]);
title('TEB en fonction de SNR');




