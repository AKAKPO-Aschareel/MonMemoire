
function codedData = convolutionalDAB(data)

%Initialize variables

 

trellis = poly2trellis(7, [133 171 145 133]); %Define trellis

% Convolutional encoding

codedData = convenc(data,trellis); %ouput data of encoder
%x= length (codedData);

end


