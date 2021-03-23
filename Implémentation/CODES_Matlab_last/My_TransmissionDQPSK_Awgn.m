%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB+ Implémentation  avec modulation DQPSK sur awgn
%Transmission mode : Mode I
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear ;
clc;
close all;

%%Parameters
%%
%DQPSK PARAMETERS
dqpskmod = comm.DQPSKModulator(pi/4,'BitInput',false);
dqpskdemod = comm.DQPSKDemodulator(pi/4,'BitOutput',false);

M=4; %Ordre de modulation
n=2; %bit number

%%
%OFDM PARAMETERS
OFDM_symbol_block=76; %nombre de symboles OFDM
K=1536; %nombre de sous porteuse de données
FFT_length = 2048; % Taille de ifft
T = 1/2048000; %elementary period in secondes
Tguard = 504* T; %Guard interval duration
Tu = 2048*T; %symbol duration without Tguard
IG_fraction = Tguard/Tu ; %fraction de IG
cp = IG_fraction * FFT_length ;  % cyclic  préfix
OFDM_length=2552; %FFT_length+cp
Tnull=2656; %Null_Symbol_Duration
%cp = fraction de IG * FFT_length = 504;
% sub carrier spacing : 1kHz


%% At the transmitter part 


%DATA : 188 bytes *8 bits* 35 paquets RS= 52640 bits
binary_length = 52640;


TEB= [];%initialize BER 
SNR_dB_start = 0; %SNR range
SNR_dB_end = 5; %SNR range

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
%%
%Data partitioning and QPSK Modulation

%%Block Partioner
total_bit= K*OFDM_symbol_block*n; 
s= length (intrlvd);

%%Zero padding
 nb_zero=zeros(1, total_bit-s); %define number of zero
 data_padding= [intrlvd nb_zero ];
data_padding_redim =reshape(data_padding,length (data_padding)/2,n);

%converion binaire en decimal
data_dec = bi2de (data_padding_redim ,'left-msb'); 

%%DQPSK Symbol Mapper
 modSig = dqpskmod(data_dec);
  modSig= modSig.';



% plot constellation at transmitter

figure(1);
hold on;
plot(real(modSig),imag(modSig),'*');
title('Constellation DQPSK emise')

%%
%Symbols interleaved
sym_interleaved= entrelacement_symboles (modSig);

%%
%OFDM Modulation 
%Redim QPSK symbols after interleaving
DataOFDM = reshape(sym_interleaved,76,1536);

%Zero padding a la taille de ifft et reamenagement des sous porteuses
m= FFT_length-K  ; % size of zeros to each dataEnd  block (512 zeros)
DataOFDM_after_zero_padding= [DataOFDM(:,769:1536)  zeros(OFDM_symbol_block,m) DataOFDM(:,1:768)];

%IFFT Block
IFFT_function= ifft(DataOFDM_after_zero_padding,FFT_length,2); %Inverse discrete Fourier transform 

%Cyclic Prefix
 Ajout_CP = [ IFFT_function IFFT_function(:,1:cp)];
 data_after_OFDM_redim=reshape(Ajout_CP,1,OFDM_symbol_block*OFDM_length); 
%%
 %Add null symbol at the beginning of frame
null_symb=zeros(1,Tnull);%Null symbol generation
Tx_Frame_Final=[null_symb data_after_OFDM_redim]; %Final frame structure generation %frame length=196608 (one frame)

%%
%add AWGN NOISE 

for Snr_dB= SNR_dB_start:0.5: SNR_dB_end
    rxSig=awgn(Tx_Frame_Final,Snr_dB,'measured','dB');
    
    
  
 %At the receiver part 
 
 data_receiver= rxSig(:,Tnull+1 :end);
 Rx=reshape(data_receiver,OFDM_symbol_block,OFDM_length);

%% 
%OFDM Demodulation

% Remove prefix cyclic
Suppr_CP = Rx(:,1:FFT_length);

%FFT
FFT_function = fft(Suppr_CP ,FFT_length,2); % discrete Fourier transform 
 
%Zero padding remove and reorder
 data_after_remove_zeros= [ FFT_function(:,1281:FFT_length) FFT_function(:,1:768)];
 
%%
%symbol desinterleaving
sym_desinterleaved =desentrelacement_symbole (data_after_remove_zeros);
% figure(2);
% hold on;
% plot(real(sym_desinterleaved),imag(sym_desinterleaved),'*');
% title('Constellation DQPSK recu')

%%
%%DQPSK DEMODULATION
sym_recu=sym_desinterleaved.';
demodSig = dqpskdemod(sym_recu);
%converion  decimal en binaire
data_bi = de2bi (demodSig,'left-msb');  
data_bi_redim=reshape(data_bi, 1,length(data_bi)*2);

%Remove zero padding
zero_size=4992;
data_remove_padding= data_bi_redim(:,1: (total_bit-zero_size));
%%
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


end

%%plot result

figure(2)
SNR= SNR_dB_start:0.5: SNR_dB_end;
semilogy (SNR,TEB,'b-o','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
grid on;
hold on;
xlabel('SNR(dB)');
ylabel('BER');
legend('DQPSK AWGN');
axis([0 10 1e-4 1e0]);
title('TEB en fonction de SNR');





