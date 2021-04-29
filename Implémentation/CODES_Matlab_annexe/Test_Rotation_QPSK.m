%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB+ Implémentation  avec modulation QPSK sur canal de
% rayleigh et awgn
%Transmission mode : Mode I
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear ;
clc;
close all;

%%Parameters
%%
%QPSK PARAMETERS
qpskmod = comm.QPSKModulator;
M=4; %Ordre de modulation
n=2; %bit number
Rotation_angle_degrees=29.0; %angle de rotation

%%
%OFDM PARAMETERS
OFDM_symbol_block=152; %nombre de symboles OFDM
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

n_estim=50; %nombre de symboles pilotes

%%
 
        
%Rayleigh Parameters
sampleRate =30.048e6;    % Sample rate of 2.048  MHz
maxDopplerShift  =5 ;      % Maximum Doppler shift of diffuse components (Hz) 25km/h, first channel 
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
binary_length = 2*52640;


TEB= [];%initialize BER 
SNR_dB_start = 0; %SNR range
SNR_dB_end = 20; %SNR range
pas=2;
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

%%QPSK Symbol Mapper
 modSig =qpskmod(data_dec );
 
 modSig= modSig.';
 
% plot constellation QPSK classique
figure(1);
hold on;
plot(real(modSig),imag(modSig),'*');
title('Constellation QPSK classsique')

%%
%Rotation de constellation
Rotation_angle_radians= 2 *pi*Rotation_angle_degrees/360;
modSig_rot=modSig*exp(1i*Rotation_angle_radians);

%plot results
figure(2);
hold on;
plot(real(modSig_rot),imag(modSig_rot),'*');
title('Constellation QPSK tournée')

%%
%Décalage cyclique
y=length(modSig_rot);
xx=imag(modSig_rot(y));
for k=2:y
     modSig_decalee(y-k+2)=real(modSig_rot(y-k+2))+ 1i*imag(modSig_rot(y-k+1)); 
end
modSig_decalee(1)= real (modSig_rot(1))+1i*xx;

%plot result
figure(3);
hold on;
grid on;
plot(real(modSig_decalee),imag(modSig_decalee),'*');
title('Constellation décalée')


%%

%Symbols interleaved
p=96 ; % depth of interleaving
 n= length(modSig)/p; % words length
 sym_interleaved = matintrlv(modSig_decalee,p,n);

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

for Snr_dB= SNR_dB_start:pas: SNR_dB_end
    signal_recu=awgn(ray_Out,Snr_dB,'measured','dB');




 %At the receiver part 
 signal_recu2=signal_recu.';
 data_receiver= signal_recu2(:,Tnull+1 :end);
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
redim= reshape(data_after_remove_zeros,1,OFDM_symbol_block*K);
sym_desinterleaved =  matdeintrlv(redim,p,n);
%%
%Suppression du décalage cyclique
y=length(sym_desinterleaved);
tt= imag (sym_desinterleaved(1));

for k=1: (length(sym_desinterleaved)-1)
    sym_non_decalee(k)= real(sym_desinterleaved(k))+ 1i*imag (sym_desinterleaved(k+1));
    
end
sym_non_decalee(y)=real(sym_desinterleaved(y))+1i*tt;
% figure(4);
% hold on;
% plot(real(sym_non_decalee),imag(sym_non_decalee),'*');
% title('Constellation non decalee')





%% Demappeur
% Matrice de démappage
Mat_Demap=[0 0 real(qpskmod(0)*exp(1i*Rotation_angle_radians)) imag(qpskmod(0)*exp(1i*Rotation_angle_radians));0 1 real(qpskmod(1)*exp(1i*Rotation_angle_radians)) imag(qpskmod(1)*exp(1i*Rotation_angle_radians));1 0 real(qpskmod(2)*exp(1i*Rotation_angle_radians)) imag(qpskmod(2)*exp(1i*Rotation_angle_radians));1 1 real(qpskmod(3)*exp(1i*Rotation_angle_radians)) imag(qpskmod(3)*exp(1i*Rotation_angle_radians))];

j=1;

for k=1: (length(sym_non_decalee))
    % Premier bit
  Rep1 = min((((abs(Mat_Demap(3,3)-real(sym_non_decalee(k))))^2)+((abs(Mat_Demap(3,4)-imag(sym_non_decalee(k))))^2)),(((abs(Mat_Demap(4,3)-real(sym_non_decalee(k))))^2)+((abs(Mat_Demap(4,4)-imag(sym_non_decalee(k))))^2)))- min((((abs(Mat_Demap(1,3)-real(sym_non_decalee(k))))^2)+((abs(Mat_Demap(1,4)-imag(sym_non_decalee(k))))^2)),(((abs(Mat_Demap(2,3)-real(sym_non_decalee(k))))^2)+((abs(Mat_Demap(2,4)-imag(sym_non_decalee(k))))^2)));
    if Rep1<0
        b1=1;
    end
    if Rep1>=0
        b1=0;
    end
    data_recu(k,j)=b1;
    j=j+1;
    % Second bit
  Rep2 = min((((abs(Mat_Demap(2,3)-real(sym_non_decalee(k))))^2)+((abs(Mat_Demap(2,4)-imag(sym_non_decalee(k))))^2)),(((abs(Mat_Demap(4,3)-real(sym_non_decalee(k))))^2)+((abs(Mat_Demap(4,4)-imag(sym_non_decalee(k))))^2)))- min((((abs(Mat_Demap(1,3)-real(sym_non_decalee(k))))^2)+((abs(Mat_Demap(1,4)-imag(sym_non_decalee(k))))^2)),(((abs(Mat_Demap(3,3)-real(sym_non_decalee(k))))^2)+((abs(Mat_Demap(3,4)-imag(sym_non_decalee(k))))^2)));  
    if Rep2<0
          b2=1;
    end
    if Rep2>=0
        b2=0;
    end
    data_recu(k,j)=b2;
    j=1;
end
data_demap=reshape(data_recu,1,size(data_recu,1)*size(data_recu,2));

%Remove zero padding
data_remove_padding= data_demap(:,1: s);
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
    
    
% Estimate the BERTEBnew = nErrors/numBits;
 TEBnew = nErrors/numBits;
 TEB= [TEB TEBnew];




%  %EVM
%         BER_M0 = zeros(K,1);
%         for u=1:K
%             EVM0(u)= sqrt((sum((abs((DataOFDM(u,:)) - ( data_after_remove_zeros(u,:)))).^2))./(sum(((abs((DataOFDM(u,:)))).^2))));
%             
%             BER_M0(u) =  (2/n)*qfunc((sqrt((2))*sin(pi/(M)))/EVM0(u));   % Used in first paper
% 
%         end
%            % BER_MQ(j)= sum(BER_M0)./K;
%            BER_MQ= sum(BER_M0)/K;
%             TEB= [TEB BER_MQ];

end

%%plot result

figure(4)
SNR= SNR_dB_start:pas: SNR_dB_end;
semilogy (SNR,TEB,'r-o','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
grid on;
hold on;
xlabel('SNR(dB)');
ylabel('BER');
legend('QPSK tournée Rayleigh');
axis([0 20 1e-4 1e0]);
title('TEB en fonction de SNR');





