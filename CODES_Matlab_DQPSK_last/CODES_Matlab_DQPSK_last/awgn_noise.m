
function n = awgn_noise(DataIn,SNRdB)



% Procedure%%%%%%%%%%%%%%%%%%%%%%%%%

    
  % Signal power
  p = sum(DataIn.*conj(DataIn))/length(DataIn);
  
  
    
  % noise spectral density
  snr = 10^(SNRdB/10); %Snr to linear scale
   No= p/snr;
  
   %Computer noise
  desv = sqrt(No)/sqrt(2);
   % desv = sqrt(p/snr)/sqrt(2);

  n = randn(size(DataIn)) + 1i*randn(size(DataIn));      
  n = n.*desv;
  
end
  