function modDataQpsk = QPSKMOD(OFDM_Parameters,data)

%Initialisation des variables
%----------------------------------------------------------------------------------

%QPSK PARAMETERS

M=OFDM_Parameters.M; % number of symbole for modulation QPSK
n=OFDM_Parameters.n; % number of  bits per symbole QPSK
init_phase= OFDM_Parameters.init_phase; % phase inital QPSK



% OFDM PARAMETERS Mode I

M_IFFT = OFDM_Parameters.M_IFFT ; %number of sub-carriers 
dataOfdm = OFDM_Parameters.dataOfdm; % nombres de paquets OFDM

nbits=OFDM_Parameters.nbits; %nombre de bits total à envoyer


 
%---------------------------------------------------------------------------------------
 

 msgbits= data;
s= length (msgbits);
 if s < nbits
     
   %%%%% GET PADDING%%%%%%
  nb_zero= nbits-s; %define number of zero
     
    
msgbits_redim= reshape(msgbits,[],n); %conversion S/P   

data_padding= [msgbits_redim;  zeros(nb_zero/2,n) ];
msgbits_matrix=data_padding;

 else
msgbits_matrix= reshape(msgbits,M_IFFT*dataOfdm,n);

 end
 
%converion binaire en decimal/ Formation des symboles
 data_n= bi2de (msgbits_matrix,'left-msb'); 
 
 %%%%%modulation QPSK 
 modDataQpsk= pskmod(data_n,M,init_phase); % modulation QPSK de l'information
 modDataQpsk= reshape(modDataQpsk,M_IFFT,dataOfdm);  %conversion S/P

 
% Affichage constellation emise

figure(1);
hold on;
plot(real(modDataQpsk),imag(modDataQpsk),'*');
title('Constellation emise')
end

