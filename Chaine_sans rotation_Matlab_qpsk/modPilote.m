function pilote_OFDM = modPilote()
%%To generate the symbols pilots to estimate the channel

%QPSK PARAMETERS of pilots

M=4; % number of symbol for modulation QPSK
n=2; % number of  bits per symbole QPSK
init_phase= pi/4; % phase inital QPSK



% Pliots PARAMETERS 

pilots_carriers = 1536; %number of sub-carriers 
sym_pilots_block= 3; %number of pilots symbols block
total_bitsPilots = pilots_carriers*sym_pilots_block*n ; %number of bits per pilots symbols blocks






%Procedure
 

% Generation of pilots data
dataPilot = randi ([0,1],1,total_bitsPilots);

%conversion S/P et conversion binaire en decimal
symPilote = bi2de (reshape(dataPilot,pilots_carriers*sym_pilots_block,n),'left-msb'); 

% QPSK modulation of pilots symbols
QPSK_Pilote = pskmod(symPilote,M,init_phase);

%conversion S/P 
QPSK_Pilote_redim = reshape(QPSK_Pilote,pilots_carriers,sym_pilots_block); 

pilote_OFDM= QPSK_Pilote_redim;
 

end

