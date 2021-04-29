%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Avril 2021
% Description : DAB+ Impl�mentation  avec les modulations DQPSK et QPSK
% Canal: Typical Urban environnemnt
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

%QPSK PARAMETERS
qpskmod = comm.QPSKModulator;
qpskdemod = comm.QPSKDemodulator;

M=4; %Ordre de modulation
n=2; %bit number
Rotation_angle_degrees=29.0; %angle de rotation

%%
%OFDM PARAMETERS
OFDM_symbol_block=152; %nombre de symboles OFDM
K=1536; %nombre de sous porteuse de donn�es
FFT_length = 2048; % Taille de ifft
T = 1/2048000; %elementary period in secondes
Tguard = 504* T; %Guard interval duration
Tu = 2048*T; %symbol duration without Tguard
IG_fraction = Tguard/Tu ; %fraction de IG
cp = IG_fraction * FFT_length ;  % cyclic  pr�fix
OFDM_length=2552; %FFT_length+cp
Tnull=2656; %Null_Symbol_Duration
%cp = fraction de IG * FFT_length = 504;
% sub carrier spacing : 1kHz

n_estim=50; %nombre de symboles pilotes

%%
 
        
%Rayleigh Parameters
sampleRate =30.048e6  ;    % Sample rate of 2.048  MHz
maxDopplerShift  = 4;      % Maximum Doppler shift of diffuse components (Hz)
delayVector1 = [0.0 0.2 0.5 1.6 2.3 5.0]; % Discrete delays of six-path channel (s)
delayVector = delayVector1.*10^-6; % Discrete delays of four-path channel (s)
gainVector  = [-3 0 -2 -6 -8 -10];  % Average path gains (dB)

rayChan = comm.RayleighChannel( ...
    'SampleRate',          sampleRate, ...
    'PathDelays',          delayVector, ...
    'AveragePathGains',    gainVector, ...
    'MaximumDopplerShift', maxDopplerShift, ...
    'RandomStream',        'mt19937ar with seed', ...
    'Seed',                10, ...
    'PathGainsOutputPort', true);



%% At the transmitter part 


%DATA : 188 bytes *8 bits* 70 paquets RS= 52640 bits
binary_length = 2* 52640;


TEB_DQPSK= [];%initialize BER for DQPSK
TEB_QPSK= [];%initialize BER for QPSK
TEB_rot= [];%initialize BER for rotation

SNR_dB_start = 0; %SNR range
SNR_dB_end = 18; %SNR range
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
 modSig_DQPSK = dqpskmod(data_dec);
  modSig_DQPSK= modSig_DQPSK.';

  % plot constellation DQPSK

figure(1);
hold on;
plot(real(modSig_DQPSK),imag(modSig_DQPSK),'*');
title('Constellation DQPSK emise')

%%QPSK Symbol Mapper
 modSig_QPSK = qpskmod(data_dec);
 modSig_QPSK= modSig_QPSK.';

% plot constellation QPSK

figure(2);
hold on;
plot(real(modSig_QPSK),imag(modSig_QPSK),'*');
title('Constellation QPSK emise')


%%
%Rotation de constellation
Rotation_angle_radians= 2 *pi*Rotation_angle_degrees/360;
modSig_rot=modSig_QPSK*exp(1i*Rotation_angle_radians);

%plot results
figure(3);
hold on;
plot(real(modSig_rot),imag(modSig_rot),'*');
title('Constellation QPSK tourn�e')

%%
%D�calage cyclique
y=length(modSig_rot);
xx=imag(modSig_rot(y));
for k=2:y
     modSig_decalee(y-k+2)=real(modSig_rot(y-k+2))+ 1i*imag(modSig_rot(y-k+1)); 
end
modSig_decalee(1)= real (modSig_rot(1))+1i*xx;

%plot result
figure(4);
hold on;
grid on;
plot(real(modSig_decalee),imag(modSig_decalee),'*');
title('Constellation d�cal�e')

%%
%Symbols interleaved
p=96 ; % depth of interleaving
 w= length(modSig_DQPSK)/p; % words length
 sym_interleaved_DQPSK = matintrlv(modSig_DQPSK,p,w);
sym_interleaved_QPSK = matintrlv(modSig_QPSK,p,w);
sym_interleaved_rot = matintrlv(modSig_decalee,p,w);



%%
%OFDM Modulation 
%Redim QPSK symbols after interleaving
DataOFDM_DQPSK = reshape(sym_interleaved_DQPSK,K,OFDM_symbol_block);
DataOFDM_QPSK = reshape(sym_interleaved_QPSK,K,OFDM_symbol_block);
DataOFDM_rot = reshape(sym_interleaved_rot,K,OFDM_symbol_block);

%Zero padding a la taille de ifft et reamenagement des sous porteuses
m= FFT_length-K  ; % size of zeros to each dataEnd  block (512 zeros)
DataOFDM_after_zero_padding_DQPSK= [DataOFDM_DQPSK(769:1536,:) ; zeros(m,OFDM_symbol_block) ; DataOFDM_DQPSK(1:768,:)];
DataOFDM_after_zero_padding_QPSK= [DataOFDM_QPSK(769:1536,:) ; zeros(m,OFDM_symbol_block) ; DataOFDM_QPSK(1:768,:)];
DataOFDM_after_zero_padding_rot= [DataOFDM_rot(769:1536,:) ; zeros(m,OFDM_symbol_block) ; DataOFDM_rot(1:768,:)];

% Symboles a utiliser pour l'estimation du canal
sym_estim_DQPSK=DataOFDM_after_zero_padding_DQPSK(:,1:n_estim);
sym_estim_QPSK=DataOFDM_after_zero_padding_QPSK(:,1:n_estim);
sym_estim_rot=DataOFDM_after_zero_padding_rot(:,1:n_estim);



%IFFT Block
IFFT_function_DQPSK= ifft(DataOFDM_after_zero_padding_DQPSK,FFT_length); %Inverse discrete Fourier transform 
IFFT_function_QPSK= ifft(DataOFDM_after_zero_padding_QPSK,FFT_length); %Inverse discrete Fourier transform 
IFFT_function_rot= ifft(DataOFDM_after_zero_padding_rot,FFT_length); %Inverse discrete Fourier transform 

%Cyclic Prefix
 Ajout_CP_DQPSK = [ IFFT_function_DQPSK ; IFFT_function_DQPSK(1:cp,:)];
 data_after_OFDM_redim_DQPSK=reshape(Ajout_CP_DQPSK,1,OFDM_symbol_block*OFDM_length); 

 Ajout_CP_QPSK = [ IFFT_function_QPSK; IFFT_function_QPSK(1:cp,:)];
 data_after_OFDM_redim_QPSK=reshape(Ajout_CP_QPSK,1,OFDM_symbol_block*OFDM_length); 

 Ajout_CP_rot = [ IFFT_function_rot; IFFT_function_rot(1:cp,:)];
 data_after_OFDM_redim_rot=reshape(Ajout_CP_rot,1,OFDM_symbol_block*OFDM_length); 


 %%
 %Add null symbol at the beginning of frame
null_symb=zeros(1,Tnull);%Null symbol generation
Tx_Frame_Final_DQPSK=[null_symb data_after_OFDM_redim_DQPSK]; %Final frame structure generation %frame length=196608 (one frame)
Tx_Frame_Final_QPSK=[null_symb data_after_OFDM_redim_QPSK]; %Final frame structure generation %frame length=196608 (one frame)
Tx_Frame_Final_rot=[null_symb data_after_OFDM_redim_rot]; %Final frame structure generation %frame length=196608 (one frame)


%%

%Passage dans le canal de rayleigh

ray_Out_DQPSK =rayChan(Tx_Frame_Final_DQPSK.');
ray_Out_QPSK =rayChan(Tx_Frame_Final_QPSK.');
ray_Out_rot=rayChan(Tx_Frame_Final_rot.');

%add AWGN NOISE 

for Snr_dB= SNR_dB_start:pas: SNR_dB_end
    rxSig_DQPSK=awgn(ray_Out_DQPSK,Snr_dB,'measured','dB');
   rxSig_QPSK=awgn(ray_Out_QPSK,Snr_dB,'measured','dB');
   rxSig_rot=awgn(ray_Out_rot,Snr_dB,'measured','dB');


 
    
  
 %At the receiver part 
 signal_recu2_DQPSK = rxSig_DQPSK.';
 signal_recu2_QPSK = rxSig_QPSK.';
 signal_recu2_rot=rxSig_rot.';


 data_receiver_DQPSK= signal_recu2_DQPSK(:,Tnull+1 :end);
 data_receiver_QPSK= signal_recu2_QPSK(:,Tnull+1 :end);
 data_receiver_rot= signal_recu2_rot(:,Tnull+1 :end);
 

 signal_recu2_DQPSK_redim=reshape(data_receiver_DQPSK,OFDM_length,OFDM_symbol_block);
signal_recu2_QPSK_redim=reshape(data_receiver_QPSK,OFDM_length,OFDM_symbol_block);
signal_recu2_rot_redim=reshape(data_receiver_rot,OFDM_length,OFDM_symbol_block);

%% 
%OFDM Demodulation

% Remove prefix cyclic
Suppr_CP_DQPSK = signal_recu2_DQPSK_redim(1:FFT_length,:);
Suppr_CP_QPSK = signal_recu2_QPSK_redim(1:FFT_length,:);
Suppr_CP_rot = signal_recu2_rot_redim(1:FFT_length,:);

%FFT
FFT_function_DQPSK = fft(Suppr_CP_DQPSK ,FFT_length); % discrete Fourier transform 
FFT_function_QPSK = fft(Suppr_CP_QPSK ,FFT_length); % discrete Fourier transform 
FFT_function_rot = fft(Suppr_CP_rot ,FFT_length); % discrete Fourier transform 
 
%D�termination des coeficients de chaque sous porteuse

% Symboles utilis�s pour l'estimation recus
%DQPSK
sym_recu_estim_DQPSK=FFT_function_DQPSK(:,1:n_estim);
channel_DQPSK = sum(((sym_recu_estim_DQPSK)./(sym_estim_DQPSK)),2)/n_estim;  % 1 moyennecolonne/C 2 LIGNE/L R�ponse fr�quentielle du canal pour les Nsp Symboles pilotes
  channel_inva_DQPSK = 1./channel_DQPSK ; 

%QPSK
sym_recu_estim_QPSK=FFT_function_QPSK(:,1:n_estim);
channel_QPSK = sum(((sym_recu_estim_QPSK)./(sym_estim_QPSK)),2)/n_estim;  % 1 moyennecolonne/C 2 LIGNE/L R�ponse fr�quentielle du canal pour les Nsp Symboles pilotes
  channel_inva_QPSK = 1./channel_QPSK ; 

  %Rotation
sym_recu_estim_rot=FFT_function_rot(:,1:n_estim);
channel_rot = sum(((sym_recu_estim_rot)./(sym_estim_rot)),2)/n_estim;  % 1 moyennecolonne/C 2 LIGNE/L R�ponse fr�quentielle du canal pour les Nsp Symboles pilotes
            channel_inva_rot = 1./channel_rot ; 


%% Egalisation
sig_esch_DQPSK=diag(channel_inva_DQPSK)*FFT_function_DQPSK ;
sig_esch_QPSK=diag(channel_inva_QPSK)*FFT_function_QPSK ;
sig_esch_rot=diag(channel_inva_rot)*FFT_function_rot ;

%Zero padding remove and reorder
 data_after_remove_zeros_DQPSK= [ sig_esch_DQPSK(1281:FFT_length,:); sig_esch_DQPSK(1:768,:)];
 data_after_remove_zeros_QPSK= [ sig_esch_QPSK(1281:FFT_length,:); sig_esch_QPSK(1:768,:)];
 data_after_remove_zeros_rot= [ sig_esch_rot(1281:FFT_length,:); sig_esch_rot(1:768,:)];

 %data_after_remove_zeros= [ FFT_function(1281:FFT_length,:); FFT_function(1:768,:)];

%%
%symbol desinterleaving
redim_DQPSK= reshape(data_after_remove_zeros_DQPSK,1,OFDM_symbol_block*K);
redim_QPSK= reshape(data_after_remove_zeros_QPSK,1,OFDM_symbol_block*K);
redim_rot= reshape(data_after_remove_zeros_rot,1,OFDM_symbol_block*K);

sym_desinterleaved_DQPSK =  matdeintrlv(redim_DQPSK,p,w);
sym_desinterleaved_QPSK =  matdeintrlv(redim_QPSK,p,w);
sym_desinterleaved_rot =  matdeintrlv(redim_rot,p,w);
% figure(2);
% hold on;
% plot(real(sym_desinterleaved),imag(sym_desinterleaved),'*');
% title('Constellation DQPSK recu')

%%
%%DQPSK DEMODULATION
sym_recu1=sym_desinterleaved_DQPSK.';
demodSig_DQPSK = dqpskdemod(sym_recu1);

%%QPSK DEMODULATION
sym_recu2=sym_desinterleaved_QPSK.';
demodSig_QPSK = qpskdemod(sym_recu2);

%converion  decimal en binaire
data_bi_DQPSK = de2bi (demodSig_DQPSK,'left-msb');  
data_bi_QPSK = de2bi (demodSig_QPSK,'left-msb'); 

data_bi_redim_DQPSK=reshape(data_bi_DQPSK, 1,length(data_bi_DQPSK)*2);
data_bi_redim_QPSK=reshape(data_bi_QPSK, 1,length(data_bi_QPSK)*2);

%%
%Suppression du d�calage cyclique
y=length(sym_desinterleaved_rot);
tt= imag (sym_desinterleaved_rot(1));

for k=1: (length(sym_desinterleaved_rot)-1)
    sym_non_decalee(k)= real(sym_desinterleaved_rot(k))+ 1i*imag (sym_desinterleaved_rot(k+1));
    
end
sym_non_decalee(y)=real(sym_desinterleaved_rot(y))+1i*tt;
% figure(4);
% hold on;
% plot(real(sym_non_decalee),imag(sym_non_decalee),'*');
% title('Constellation non decalee')





%% Demappeur
% Matrice de d�mappage
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

%%
%Remove zero padding

data_remove_padding_DQPSK= data_bi_redim_DQPSK(:,1: s);
data_remove_padding_QPSK= data_bi_redim_QPSK(:,1: s);
data_remove_padding_rot= data_demap(:,1: s);

%%
%Time desinterleaving
desintrlvd_DQPSK = des_interleaving(data_remove_padding_DQPSK);
desintrlvd_QPSK = des_interleaving(data_remove_padding_QPSK);
desintrlvd_rot = des_interleaving(data_remove_padding_rot);

%----Channel decoding------


% Convolutional decoding

decodedData_inner_DQPSK  = viterbi(desintrlvd_DQPSK);
decodedData_inner_QPSK  = viterbi(desintrlvd_QPSK);
decodedData_inner_rot  = viterbi(desintrlvd_rot);

% RS Decoding

decoded_RS_DQPSK= RS_decoder_DAB(decodedData_inner_DQPSK);
decoded_RS_QPSK= RS_decoder_DAB(decodedData_inner_QPSK);
decoded_RS_rot= RS_decoder_DAB(decodedData_inner_rot);


% Desscrambling

DataOut_DQPSK = dab_desscramble(decoded_RS_DQPSK);
DataOut_QPSK = dab_desscramble(decoded_RS_QPSK);
DataOut_rot = dab_desscramble(decoded_RS_rot);

% Calculate the number of bit errors
 nErrors_DQPSK = biterr(DataIn,DataOut_DQPSK);
  nErrors_QPSK = biterr(DataIn,DataOut_QPSK);       
nErrors_rot = biterr(DataIn,DataOut_rot);

  numBits = binary_length;
    
    
% Estimate the BER
%DQPSK
 TEBnew_DQPSK = nErrors_DQPSK/numBits;
 TEB_DQPSK= [TEB_DQPSK TEBnew_DQPSK];
 
 %QPSK
 TEBnew_QPSK = nErrors_QPSK/numBits;
 TEB_QPSK= [TEB_QPSK TEBnew_QPSK];

%ROTATION
TEBnew_rot = nErrors_rot/numBits;
 TEB_rot= [TEB_rot TEBnew_rot];


end

%%plot result

figure(5)
SNR= SNR_dB_start:pas: SNR_dB_end;

semilogy (SNR,TEB_DQPSK,'r-o','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
grid on;
hold on;

semilogy (SNR,TEB_QPSK,'b-d','MarkerSize',5,'MarkerFacecolor','b','linewidth',2);
grid on;
hold on;

semilogy (SNR,TEB_rot,'c-*','MarkerSize',5,'MarkerFacecolor','c','linewidth',2);
grid on;
hold on;

xlabel('RSB (Rapport Signal � Bruit) en dB');
ylabel('TEB (Taux d''Erreur Binaire)');
axis([0 18 1e-4 1e0]);
legend('pi/4 DQPSK','QPSK','QPSK with rotation');
title('DAB+ sur le canal TU6 ');






