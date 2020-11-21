
function [codedData,decodedData] = convolutionalDAB(data)

%Initialize variables

data=[1 0]; % binary message
tblen= 2; % positive integer scalar that specifies the traceback depth
trellis = poly2trellis(7, [133 171 145 133]); %Define trellis

% Convolutional encoding

codedData = convenc(data,trellis);% Convolutional encode of msgBits

% Convolutional decoding
decodedData = vitdec(codedData,trellis,tblen,'trunc','hard');

end


