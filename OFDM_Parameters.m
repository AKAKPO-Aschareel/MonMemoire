function [Para] =OFDM_Parameters ()

%QPSK PARAMETERS
Para.M = 4; % number of symbol for  QPSK modulation
Para.n = 2; % number of  bits per symbole QPSK
Para.init_phase = pi/4; % phase inital QPSK

% OFDM PARAMETERS Mode I

Para.M_IFFT = 1536; %number of sub-carriers 
Para.dataOfdm=75; % OFDM symbols per transmission frame without null PR data  frame 
Para.cp = 378;  % d�finition du pr�fixe cyclique
Para.nbits = Para.M_IFFT * Para.dataOfdm*Para.n  ; %nombre de bits total � envoyer

%symbol length TsymOFDM = Tguard + Tu =  0.246 + 1.0 = 1.246ms
%fraction de IG = 0.246/1.0
%cp = 246/1000 * Para.M_IFFT+377.8560;
% sub carrier spacing : 1kHz

Para.nbPilotes = 25; %nombre de paquets  pilotes
Para.nbitsPilotes = Para.M_IFFT*Para.nbPilotes*Para.n ; %nombre total de bits des pilotes


%Others variables
Para.Choix = 1;
Para.padding ='1';


%DQPSK PARAMETERS

end

