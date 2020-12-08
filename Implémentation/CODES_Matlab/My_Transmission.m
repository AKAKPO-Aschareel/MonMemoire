%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB Implémentation                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear ;
close all;
clc;

%% Emission

binary_length = 44;
numErrs = 0; %errors counter

%Define binary sequence of message audio DAB+
DataIn = randi ([0,1],1,binary_length); 

%Scrambling
DataScramble = dab_scramble (DataIn, binary_length);


%-----Channel codding-------

%RS encoder
codedRS = Reed_Solomon_Encoder(DataScramble);
 

%Convolutionnal coding
codedData = convolutionalDAB(codedRS);



% Time interleaving
intrlvd = time_interleaving(codedData);



%Modulation

dataModulate = Modulation(intrlvd);


%% Reception

%Demodulation
dataDemodulate = Demodulation(dataModulate);


%Time desinterleaving

desintrlvd = des_interleaving(dataDemodulate);

%----Channel decoding------


% Convolutional decoding

decodedData_inner  = viterbi(desintrlvd);

% RS Decoding
decoded_RS= Reed_Solomon_Decoder (decodedData_inner);

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