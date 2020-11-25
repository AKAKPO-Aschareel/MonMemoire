
%ENTRELACEMENT
%-------------------------------------------------------------
function intrlvd = time_interleaving(codedData)

%Initialize variables
DataIn = coding_source(); %input data of transmission

data = dab_scramble (DataIn); % input data of convolutional encoder 

codedData = convolutionalDAB(data); %données à entrelacer
 t= 24; %depth of interleaving
 n= 6; % words length
 
%Get time interleaving
%-----------------------------------------------
codedData= reshape (codedData,n,t)';
intrlvd=codedData(:)'; 


end

