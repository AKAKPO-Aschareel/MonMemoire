% CODAGE CONVOLUTIONNEL %%
% Mother code DAB
% code rate Rc: 1/4
% Generator :(133 171 145 133)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function codedData = convolutionalDAB(codedRS)


% Convolutional coding Parameters 

trellis = poly2trellis(7, [133 171 145 133]); % Define trellis

data = codedRS;

% Convolutional encoding
codedData = convenc(data,trellis); %ouput data of encoder

%x= length (codedData);

end


