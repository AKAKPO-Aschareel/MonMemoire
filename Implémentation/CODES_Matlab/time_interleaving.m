
%ENTRELACEMENT-DESENTRELACEMENT%
%-------------------------------------------------------------
function [intrlvd, desintrlvd ] = time_interleaving(codedData)

data= [1 0]; %Code convolutional input

codedData = convolutionalDAB(data); % donnees en sortie du codeur convolutionnel à entrelacer
 
%Get time interleaving
%-----------------------------------------------
codedData= reshape (codedData,2,4)';
intrlvd=codedData(:)'; 

%Get time desinterleaving
%-----------------------------------------------
desintrlvd= reshape(intrlvd,4,2)' ;
desintrlvd = desintrlvd(:)';

end

