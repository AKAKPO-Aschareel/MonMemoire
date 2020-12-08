function DataOut = dab_scramble (DataIn, binary_length)
 
%Procédure
%-----------------------------------------------

%Initialize variables 

N= binary_length; % Data lenght
dataAux=DataIn;

dataAux = bi2de(dataAux(:),'left-msb'); % convert to bytes 
  
%Get SCRAMBLING
prbs_seq = dab_scramble_prbsseq( N );
prbs_seq = bi2de(prbs_seq(:),'left-msb'); % convert to bytes
    
  
    for i = 1:size(dataAux,2)
        dataAux(:,i) = bitxor(dataAux(:,i), prbs_seq);
    end
    
     if ~isempty(dataAux)
     dataAux = dataAux(:);
     dataAuxBin = de2bi(dataAux,'left-msb')';
    else
     dataAuxBin = [];
    end
    
    
    DataOut = dataAuxBin(:)';
end
