function [DataIN] = dab_desscramble(rxscramble)

%Initialize variables 

 
DataIn=[1 0 1 0 1 1 0 1 0 1];
K_RS = length(DataIn);

DataOut = dab_scramble (K_RS ,DataIn);
rxscramble=DataOut;


rxscramble = bi2de(rxscramble(:),'left-msb'); % convert to bytes 
  
  %Get DESCRAMBLING
   prbs_seq = dab_scramble_prbsseq( K_RS );
    prbs_seq = bi2de(prbs_seq(:),'left-msb'); % convert to bytes
    
  
    for i = 1:size(rxscramble,2)
        rxscramble(:,i) = bitxor(rxscramble(:,i), prbs_seq);
    end
    
     if ~isempty(rxscramble)
     rxscramble = rxscramble(:);
     dataAuxBin = de2bi(rxscramble,'left-msb')';
    else
     dataAuxBin = [];
    end
    
    
    DataIN = dataAuxBin(:)';
end

