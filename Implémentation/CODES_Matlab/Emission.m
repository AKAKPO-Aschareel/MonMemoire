%Implementation DAB+ system Emission
%------------------------------------------------
% Generates a binary messsage random bit sequence
%------------------------------------------------
clear all;
msgBit= randi([0,1],1,1504);
taille= lenght(msgBit); %binary message lenght




%Energy dispersal------------------
 scrambling = dab_scramble (taille,msgBit);
