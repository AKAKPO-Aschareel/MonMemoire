function pilote_OFDM = modPilote()

%QPSK PARAMETERS

M=4; % number of symbole for modulation QPSK
n=2; % number of  bits per symbole QPSK
init_phase= pi/4; % phase inital QPSK



% OFDM PARAMETERS Mode I

M_IFFT = 1536; %number of sub-carriers 


nbPilotes= 10; %nombre de paquets  pilotes
nbitsPilotes = M_IFFT*nbPilotes*n ; %nombre total de bits des pilotes


%Procedure
 

%generation du train binaire des pilotes
dataPilote = randi ([0,1],1,nbitsPilotes);

%conversion S/P et converion binaire en decimal
symPilote = bi2de (reshape(dataPilote,M_IFFT*nbPilotes,n),'left-msb'); 

% modulation QPSK des pilotes
modPilote = pskmod(symPilote,M,init_phase);

%conversion S/P 
modPilote_redim = reshape(modPilote,M_IFFT,nbPilotes); 

pilote_OFDM=modPilote_redim;

end

