%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB Implémentation    
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear ;
close all;
clc;

%% Emission



%188 bytes *8 bits* 35 paquets RS= 52640 bits
binary_length = 52640;

%binary_length = 44;
numErrs = 0; %errors counter

%Define binary sequence of message audio DAB+ represent FIC and MSC data
DataIn = randi ([0,1],1,binary_length); 

%Scrambling
DataScramble = dab_scramble (DataIn, binary_length);


%-----Channel codding-------

%RS encoder
%codedRS = Reed_Solomon_Encoder(DataScramble);
codedRS= RS_essai_DAB(DataScramble);
 

%Convolutionnal coding
coded_convolutional = convolutionalDAB(codedRS);



% Time interleaving
intrlvd = time_interleaving(coded_convolutional);



%Modulation
%define OFDM and QPSK parameters
para= OFDM_Parameters();

dataQpsk = QPSKMOD(para, intrlvd );
dataOFDM_modulate = Modulation(para,dataQpsk);


%% Reception

%Demodulation
dataOFDM_demodulate = Demodulation(para,dataOFDM_modulate);
data_demodQPSK= QPSK_DEMOD(para,dataOFDM_demodulate );


%Time desinterleaving

desintrlvd = des_interleaving(data_demodQPSK);

%----Channel decoding------


% Convolutional decoding

decodedData_inner  = viterbi(desintrlvd);

% RS Decoding
%decoded_RS= Reed_Solomon_Decoder (decodedData_inner);
decoded_RS= RS_decoder_DAB(decodedData_inner);

% Desscrambling

DataOut = dab_desscramble(decoded_RS);

% Calculate the number of bit errors
 nErrors = biterr(DataIn,DataOut);
        
% Increment the error 
 numErrs = numErrs + nErrors;
 
 numBits = binary_length;
    
    
% Estimate the BER
 berEst = numErrs/numBits;

%%END