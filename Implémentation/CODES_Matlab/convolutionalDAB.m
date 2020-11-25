
function codedData = convolutionalDAB(data)

%Initialize variables

DataIn = coding_source(); %input data of transmission

data = dab_scramble (DataIn); % input data of convolutional encoder 

trellis = poly2trellis(7, [133 171 145 133]); %Define trellis

% Convolutional encoding

codedData = convenc(data,trellis); %ouput data of encoder
%x= length (codedData);

end


