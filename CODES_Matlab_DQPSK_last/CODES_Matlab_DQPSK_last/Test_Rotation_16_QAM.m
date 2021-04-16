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


%DATA : 188 bytes *8 bits* 60 paquets RS=90240  bits
binary_length = 90240;


TEB= [];%initialize BER 
SNR_dB_start = 0; %SNR range
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





%Data partitioning and QAM Modulation

data_ModQAM = QAM_16_mod(intrlvd );
%%
% plot constellation at transmitter

figure(1);
hold on;
plot(real(data_ModQAM),imag(data_ModQAM),'*');
title('Constellation 16-QAM emise')


%Rotation de constellation
angle=16.8;
qam_rot = rotate_const(data_ModQAM,angle);

%plot constellation after rotation
figure(2);
hold on;
grid on;
plot(real(qam_rot),imag(qam_rot),'*');
title('Constellation 16Qam tournée')

%Décalage cyclique
QAM_decalage = cyclic_delay(qam_rot);
%plot result
figure(3);
hold on;
grid on;
plot(real(QAM_decalage),imag(QAM_decalage),'*');
title('Constellation QPSK décalée')


%%


%Symbols interleaved
sym_interleaved= entrelacement_symboles (QAM_decalage);


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
% 
% for Snr_dB= SNR_dB_start:0.5: SNR_dB_end
%    
%     %Pass the signal through an RAYLEIGH channel
%  NFFT=2048;
%  %Get CIR 
%  hT=Canal_Rayleigh_CSP_();
%   dataAux = conv(hT, Tx_Frame_Final);
% 
%     
%   dataNCh = dataAux(((NFFT/2)+1):end);
% rayleigh_out = dataNCh(1:length(Tx_Frame_Final));
% 
%  n=awgn_noise(rayleigh_out,Snr_dB); %noise vector
%   
%   rxSig =rayleigh_out + n;
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %At the receiver part 
 
 data_receiver= Tx_Frame_Final(:,Tnull+1 :end);
Rx=reshape(data_receiver,OFDM_symbol_block,OFDM_length);

 
 
%OFDM Demodulation
dataOFDM_demodulate = demodulation_OFDM(Rx);



%symbol desinterleaving
sym_desinterleaved =desentrelacement_symbole (dataOFDM_demodulate);
% figure(4);
% hold on;
% plot(real(sym_desinterleaved),imag(sym_desinterleaved),'*');
% title('Constellation QPSK recu')



%Suppression du décalage cyclique
remove_decalage = remove_cyclic_delay(sym_desinterleaved);

%plot results
% figure(5);
% hold on;
% plot(real(remove_decalage),imag(remove_decalage),'*');
% title('Constellation QPSK remove delay')

%Suppression de la rotation de constellation
remove_rotation = delete_rotate_const(remove_decalage,angle);

%plot resiults
% figure(6);
% hold on;
% grid on;
% plot(real(remove_rotation),imag(remove_rotation),'*');
% title('Constellation QPSK non tournée')


remove_rotation_col=remove_rotation.';

%QPSK DEMODULATION
tab = [];
 for pas = 1:length(remove_rotation_col)
    
B = QAM_16_Demapper(remove_rotation_col(pas));

  tab = [tab;B];
end 

tab_redim = tab(:)';

%Remove zero padding

zero_size=75264;
    data_remove_padding= tab_redim(:,1: (466944-zero_size));


%Time desinterleaving

desintrlvd = des_interleaving(data_remove_padding);
 
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


% % end
% 
% %%plot result
% 
% % figure(3)
% % SNR= SNR_dB_start:0.5: SNR_dB_end;
% % semilogy (SNR,TEB,'b-o','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
% % grid on;
% % hold on;
% % xlabel('SNR(dB)');
% % ylabel('BER');
% % legend('QPSK');
% % axis([-5 10 1e-4 1e0]);
% % title('TEB en fonction de SNR');
