function decodedData  = viterbi()
clear all;
codedData = des_interleaving();


trellis = poly2trellis(7, [133 171 145 133]); %Define trellis

% Convolutional decoding
tblen= 2; % positive integer scalar that specifies the traceback depth
decodedData = vitdec(codedData,trellis,tblen,'trunc','hard');


end

