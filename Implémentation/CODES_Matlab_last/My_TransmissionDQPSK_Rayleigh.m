%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB+ Implémentation  avec modulation DQPSK sur canal
% Rayleigh
%Transmission mode : Mode I
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear ;
clc;
close all;

%%Parameters
%%
%DQPSK PARAMETERS

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

n_estim=10; %nombre de symboles pilotes

%%
 
        
%Rayleigh Parameters
sampleRate = 2.048e6;    % Sample rate of 2.048  MHz
maxDopplerShift  = 4;      % Maximum Doppler shift of diffuse components (Hz)
delayVector1 = [0.0 0.2 0.5 1.6 2.3 5.0]; % Discrete delays of six-path channel (s)
delayVector = delayVector1.*10^-6; % Discrete delays of four-path channel (s)
gainVector  = [-3 0 -2 -6 -8 -10];  % Average path gains (dB)
% delayVector = (0:5:15)*1e-6; % Discrete delays of four-path channel (s)
% gainVector  = [0 -1 -2 -3];  % Average path gains (dB)

rayChan = comm.RayleighChannel( ...
    'SampleRate',          sampleRate, ...
    'PathDelays',          delayVector, ...
    'AveragePathGains',    gainVector, ...
    'MaximumDopplerShift', maxDopplerShift, ...
    'RandomStream',        'mt19937ar with seed', ...
    'Seed',                10, ...
    'PathGainsOutputPort', true);



%% At the transmitter part 


%DATA : 188 bytes *8 bits* 35 paquets RS= 52640 bits
binary_length = 52640;


TEB= [];%initialize BER 
SNR_dB_start = 0; %SNR range
SNR_dB_end = 12; %SNR range

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
 modSig = dpskmod(data_dec ,M,pi/4);

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
DataOFDM = reshape(sym_interleaved,K,OFDM_symbol_block);

%Zero padding a la taille de ifft et reamenagement des sous porteuses
m= FFT_length-K  ; % size of zeros to each dataEnd  block (512 zeros)
DataOFDM_after_zero_padding= [DataOFDM(769:1536,:) ; zeros(m,OFDM_symbol_block); DataOFDM(1:768,:)];

% Symboles a utiliser pour l'estimation du canal
sym_estim=DataOFDM_after_zero_padding(:,1:n_estim);

%IFFT Block
IFFT_function= ifft(DataOFDM_after_zero_padding,FFT_length); %Inverse discrete Fourier transform 

%Cyclic Prefix
 Ajout_CP = [ IFFT_function; IFFT_function(1:cp,:)];
 data_after_OFDM_redim=reshape(Ajout_CP,1,OFDM_symbol_block*OFDM_length); 

 %%
 %Add null symbol at the beginning of frame
null_symb=zeros(1,Tnull);%Null symbol generation
Tx_Frame_Final=[null_symb data_after_OFDM_redim]; %Final frame structure generation %frame length=196608 (one frame)

%%
%Passage dans le canal de rayleigh

ray_Out=rayChan(Tx_Frame_Final.');

for Snr_dB= SNR_dB_start:0.5: SNR_dB_end
    signal_recu=awgn(ray_Out,Snr_dB,'measured','dB');




 %At the receiver part 
 signal_recu2=signal_recu.';
 data_receiver=  signal_recu2(:,Tnull+1 :end);
 signal_recu_redim=reshape(data_receiver,OFDM_length,OFDM_symbol_block);

%% 
%OFDM Demodulation

% Remove prefix cyclic
Suppr_CP = signal_recu_redim(1:FFT_length,:);

%FFT
FFT_function = fft(Suppr_CP ,FFT_length); % discrete Fourier transform 
 

%Détermination des coeficients de chaque sous porteuse

% Symboles utilisés pour l'estimation recus
sym_recu_estim=FFT_function(:,1:n_estim);
channel = sum(((sym_recu_estim)./(sym_estim)),2)/n_estim;  % 1 moyennecolonne/C 2 LIGNE/L Réponse fréquentielle du canal pour les Nsp Symboles pilotes
            channel_inva = 1./channel ; 


%% Egalisation
sig_esch=diag(channel_inva)*FFT_function ;

%Zero padding remove and reorder
 data_after_remove_zeros= [ sig_esch(1281:FFT_length,:); sig_esch(1:768,:)];
 %data_after_remove_zeros= [ FFT_function(1281:FFT_length,:); FFT_function(1:768,:)];
 
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
demodSig = dpskdemod(sym_recu,M,pi/4); 

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
semilogy (SNR,TEB,'r-o','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
grid on;
hold on;
xlabel('SNR(dB)');
ylabel('BER');

legend('DQPSK RAYLEIGH');
axis([0 15 1e-4 1e0]);
title('TEB en fonction de SNR');





