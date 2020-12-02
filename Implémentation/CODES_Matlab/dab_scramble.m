function DataOut = dab_scramble (DataIn)
 
%Procédure
%-----------------------------------------------

%Initialize variables 

%K_RS=36; % binary sequence length 
%DataIn= randi([0,1],1,K_RS); % Generates binary sequence of message



%DataIn = coding_source(); %data input 
K_RS= length (DataIn);
dataAux=DataIn;

dataAux = bi2de(dataAux(:),'left-msb'); % convert to bytes 
  
  %Get SCRAMBLING
   prbs_seq = dab_scramble_prbsseq( K_RS );
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
