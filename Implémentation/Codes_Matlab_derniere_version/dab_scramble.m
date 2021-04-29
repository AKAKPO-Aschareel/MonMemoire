function DataOut = dab_scramble (DataIn, binary_length)
 
%Procédure
%-----------------------------------------------

%Initialize variables 

N= binary_length; % Data lenght
data=DataIn;

data = bi2de(data(:),'left-msb'); % convert to bytes 
  
%Get SCRAMBLING
prbs_seq = dab_scramble_prbsseq( N );
prbs_seq = bi2de(prbs_seq(:),'left-msb'); % convert to bytes
    
  
    for i = 1:size(data,2)
        data(:,i) = bitxor(data(:,i), prbs_seq);
    end
    
     if ~isempty(data)
     data = data(:);
     dataBin = de2bi(data,'left-msb')';
    else
     dataBin = [];
    end
    
    
    DataOut = dataBin(:)';
end
