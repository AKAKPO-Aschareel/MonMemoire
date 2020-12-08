function [DataIN] = dab_desscramble(decodedData)

%Initialize variables 

rxscramble= decodedData ;
K= length(rxscramble);


rxscramble = bi2de(rxscramble(:),'left-msb'); % convert to bytes 
  
  %Get DESCRAMBLING
   prbs_seq = dab_scramble_prbsseq( K );
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

