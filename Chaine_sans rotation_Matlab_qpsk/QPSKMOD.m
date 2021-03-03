function modDataQpsk = QPSKMOD(data)

%Initialisation des variables
%----------------------------------------------------------------------------------

%QPSK PARAMETERS for Mode I

M=4; % number of symbol for modulation QPSK
n=2; % number of  bits per symbole QPSK
init_phase= pi/4; % phase inital QPSK
K = 1536 ; %number of sub-carriers 
QPSK_symbol_block = 75; %  number of qpsk symbol block

%data size for mode I
% total_bit=fic_bit + msc_bit 
%
%
total_bit= 230400; 




 
%---------------------------------------------------------------------------------------
 %%
%%Block Partionner

 msgbits= data;
s= length (msgbits);
 if s < total_bit
     
   %%%%% GET PADDING%%%%%%
  nb_zero= total_bit-s; %define number of zero
     
    
msgbits_redim= reshape(msgbits,[],n); %conversion S/P   

data_padding= [msgbits_redim;  zeros(nb_zero/2,n) ];
msgbits_matrix=data_padding;

 else
msgbits_matrix= reshape(msgbits,K*QPSK_symbol_block,n);

 end
 
%converion binaire en decimal/ Formation des symboles
 data_n = bi2de (msgbits_matrix,'left-msb'); 
 data_block = reshape (data_n,K, QPSK_symbol_block);
 
 %% QPSK Symbol Mapper
 

 modDataQpsk= [];
 
 for l= 1:QPSK_symbol_block
     QPSK_sym= pskmod(data_block(:,l),M,init_phase); % modulation QPSK de l'information
     modDataQpsk= [modDataQpsk QPSK_sym];
 end  
 
 
% Affichage constellation emise

figure(1);
hold on;
plot(real(modDataQpsk),imag(modDataQpsk),'*');
title('Constellation QPSK emise')
end

