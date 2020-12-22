function pilote_OFDM = modPilote()

%QPSK PARAMETERS

M=4; % number of symbole for modulation QPSK
n=2; % number of  bits per symbole QPSK
init_phase= pi/4; % phase inital QPSK



% OFDM PARAMETERS Mode I

M_IFFT = 1536; %number of sub-carriers 
%dataOfdm=75; % nombres de paquets OFDM
%
%cp= 1/2 * M_IFFT;  % définition du préfixe cyclique
%nbits= M_IFFT * dataOfdm *n  ; %nombre de bits total à envoyer

nbPilotes= 25; %nombre de paquets  pilotes
nbitsPilotes = M_IFFT*nbPilotes*n ; %nombre total de bits des pilotes


%Procedure
dataPilote = randi ([0,1],1,nbitsPilotes); %generation du train binaire des pilotes
symPilote = bi2de (reshape(dataPilote,M_IFFT*nbPilotes,n),'left-msb'); %conversion S/P et converion binaire en decimal
modPilote = pskmod(symPilote,M,init_phase); % modulation QPSK des pilotes
modPilote_redim = reshape(modPilote,M_IFFT,nbPilotes); %conversion S/P 

pilote_OFDM=modPilote_redim;
end

