function [Para] =OFDM_Parameters ()

%QPSK PARAMETERS
Para.M = 4; % number of symbol for  QPSK modulation
Para.n = 2; % number of  bits per symbole QPSK
Para.init_phase = pi/4; % phase inital QPSK

% OFDM PARAMETERS Mode I

Para.M_IFFT = 1536; %number of sub-carriers 
Para.dataOfdm=75; % nombres de paquets OFDM
Para.cp = 1/2 * M_IFFT;  % définition du préfixe cyclique
Para.nbits = M_IFFT * dataOfdm *n  ; %nombre de bits total à envoyer

Para.nbPilotes = 25; %nombre de paquets  pilotes
Para.nbitsPilotes = M_IFFT*nbPilotes*n ; %nombre total de bits des pilotes


%Others variables
Para.Choix = 1;
Para.padding ='1';

end

