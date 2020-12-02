
function dataModulate = Modulation(msgbits)

%Initialisation des variables
%----------------------------------------------------------------------------------

%QPSK PARAMETERS

M=4; % number of symbole for modulation QPSK
n=2; % number of  bits per symbole QPSK
init_phase= pi/4; % phase inital QPSK

Es= 1; %variable d'estimation

% OFDM PARAMETERS

M_IFFT = 10; %nombre de sous porteuses 


dataOfdm=12; % nombres de paquets OFDM
cp= 1/2 * M_IFFT;  % définition du préfixe cyclique
nbits= M_IFFT * dataOfdm *n  ; %nombre de bits total à envoyer

%nbPilotes= 2; %nombre de paquets  pilotes
%nbitsPilotes = M_IFFT*nbPilotes*n ; %nombre total de bits des pilotes


 
%---------------------------------------------------------------------------------------
 
%%%%%modulation QPSK 
 
 mod_norm=sqrt(Es/(1./M.*sum(abs(qammod([0:M-1],M)).^2)));% normalisation
 

 data_n= bi2de (reshape(msgbits,M_IFFT*dataOfdm,n),'left-msb'); %conversion S/P et converion binaire en decimal/ Formation des symboles
 modData= pskmod(data_n,M,init_phase).* mod_norm; % modulation QPSK de l'information
 modData= reshape(modData,M_IFFT,dataOfdm);  %conversion S/P

 
% Affichage constellation emise

figure(1);
hold on;
plot(real(modData),imag(modData),'*');
title('Constellation emise')

%Insertion des symboles pilotes

%dataPilote = randi ([0,1],1,nbitsPilotes); %generation du train binaire des pilotes
%symPilote = bi2de (reshape(dataPilote,M_IFFT*nbPilotes,n),'left-msb'); %conversion S/P et converion binaire en decimal
%modPilote = pskmod(symPilote,M,init_phase).* mod_norm; % modulation QPSK des pilotes
%modPilote = reshape(modPilote,M_IFFT,nbPilotes); %conversion S/P 
 
%dataEnd= [modPilote modData]; %concatenation pilotes+data
 dataEnd= modData;
 %-----IFFT-----
 IFFT_function= ifft(dataEnd,M_IFFT); %Inverse discrete Fourier transform 
 
 %%%% Insertion du préfice cyclique
    Ajout_CP = [ IFFT_function; IFFT_function(1:cp,:)];
    
    dataModulate = Ajout_CP;
 
end

