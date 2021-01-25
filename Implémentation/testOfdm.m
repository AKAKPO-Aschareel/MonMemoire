clear;
clc ;
close all;

%Initialisation des variables
%----------------------------------------------------------------------------------

%QPSK PARAMETERS

M=4; %nombre de symbole pour une modulation QPSK
n=2; %nombre de bits par symbole QPSK
init_phase= pi/4; %phase inital QPSK

Choix=1;

%OFDM PARAMETERS

M_IFFT= 1536; %nombre de sous porteuses 

dataOfdm= 75; % nombres de paquets OFDM
cp= 1/2 * M_IFFT;  % définition du préfixe cyclique
nbits= M_IFFT * dataOfdm *n  ; %nombre de bits total à envoyer
sym_Ofdm = dataOfdm * M_IFFT; %nombre de symboles OFDM à envoyer
nbPilotes = 25; %nombre de paquets  pilotes
nbitsPilotes = M_IFFT*nbPilotes*n ; %nombre total de bits des pilotes
%---------------------------------------------------------------------------------------
 
%%%%%modulation QPSK 
 

 msgBits=randi ([0,1],1,nbits); %generation du train binaire d'inforamtion
 
 data= bi2de (reshape(msgBits,sym_Ofdm,n),'left-msb'); %conversion S/P et converion binaire en decimal/ Formation des symboles
 modData= pskmod(data,M,init_phase); % modulation QPSK de l'information
 modData_redim= reshape(modData,M_IFFT,dataOfdm);  %conversion S/P

 
% Affichage constellation emise

figure(1);
hold on;
plot(real(modData),imag(modData),'*');
title('Constellation emise')

%Insertion des symboles pilotes

dataPilote = randi ([0,1],1,nbitsPilotes); %generation du train binaire des pilotes
symPilote = bi2de (reshape(dataPilote,M_IFFT*nbPilotes,n),'left-msb'); %conversion S/P et converion binaire en decimal
modPilote = pskmod(symPilote,M,init_phase); % modulation QPSK des pilotes
modPilote_redim = reshape(modPilote,M_IFFT,nbPilotes); %conversion S/P 
 
dataEnd= [modPilote_redim modData_redim]; %concatenation pilotes+data
 
 %-----IFFT-----
 IFFT_function= ifft(dataEnd,M_IFFT); %Inverse discrete Fourier transform 
 
 %%%% Insertion du préfice cyclique
    Ajout_CP = [ IFFT_function; IFFT_function(1:cp,:)];
  
     txSig = Ajout_CP ;
%-------------------------------------------------------------------------------------------------------------  

%Passage dans le canal par paquet%%%

Rx= [];
   for k= 1:dataOfdm +nbPilotes
    rxSig = awgn( txSig(:,k),3,'measured','dB');
    Rx= [Rx rxSig];
  end
%--------------------------------------------------------------------------------

% DEMODULATION

%Suppresion prefixe cyclique

Suppr_CP = Rx(1:M_IFFT,:);

%-----FFT-----
 FFT_function = fft(Suppr_CP ,M_IFFT); % discrete Fourier transform 

 
% récuperation des pilotes
pilote_recup (:,1:nbPilotes) = FFT_function(:,1:nbPilotes );

%recuperation de la data 
data_recup(:,1:dataOfdm) = FFT_function (:, nbPilotes+1:end);


 % Estimation de canal
  EQUALIZATION_Type = 'Zero-Forcing'; %choix de la technique d'égalisation 
  
  %Egalisation de canal
  
  if (Choix == 1)
      if strcmp (EQUALIZATION_Type,'Zero-Forcing')==1 %methode du zero forcing
          channel = sum( ((pilote_recup)./(modPilote_redim)),2)/nbPilotes ;
          channel_inv= 1./channel;
          
          %egalisation des symboles recus
          u= 1: dataOfdm; 
          sym_recu(:,u) = diag(channel_inv)*data_recup(:,u);
      end    
          
  else
      sym_recu = data_recup; %pas d'egalisation
  end

  % Affichage constellation recu

figure(2);
hold on;
plot(real(sym_recu ),imag(sym_recu),'*');
title('Constellation recu')



%demodulation QPSK
demodData = pskdemod(sym_recu,M,init_phase); 

%recuperation des symboles binaire
demodData = de2bi(demodData,'left-msb'); %convert data decimal to binary

%vecteurs de bits
dataDemodulate = demodData(:)';