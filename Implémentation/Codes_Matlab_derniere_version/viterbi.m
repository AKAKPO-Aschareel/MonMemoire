function decodedData  = viterbi(desintrlvd)

 %Viterbi parameters
 L = 7; % constrainte lenght
 R= 1/4; %code rate
 tblen = (2.5*( L-1)) / (1-R ); % positive integer scalar that specifies the traceback depth

 %Define trellis
 trellis = poly2trellis(7, [133 171 145 133]); 

 inputData = desintrlvd; %% bits input


% Convolutional decoding

decodedData = vitdec(inputData,trellis,tblen,'trunc','hard');


end

