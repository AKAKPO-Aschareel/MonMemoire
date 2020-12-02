%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Aschareel AKAKPO
% Date: Novembre 2020
% Description : DAB Implémentation                       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
close all;
clc;

%% Emission


%Define binary sequence of message audio DAB+
DataIn = randi ([0,1],1,44); 

%Scrambling
DataOut = dab_scramble (DataIn);


%-----Channel codding-------

%RS encoder
codedRS = Reed_Solomon_Encoder(DataOut);
 

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

%RS Decoding
decoded_RS= Reed_Solomon_Decoder (decodedData_inner);

%Desscrambling

DataIN = dab_desscramble(decoded_RS);

%%END