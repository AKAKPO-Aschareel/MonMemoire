
function n = awgn_noise_(DataIn,SNRdB)

%Parametres
K = 1536;  % Carriers per symbols data
TU   = 1000;    % Duration of the data part in the OFDM symbol
NFFT = 2048;  % Number of carrier per symbols


% Procedure%%%%%%%%%%%%%%%%%%%%%%%%%

data=DataIn;

  % Signal bandwidth
  sBW = K/TU;
    
  % Noise bandwidth
  nBW = NFFT/TU; 
    
  % Signal power
  p = sum(data.*conj(data))/length(data);
  
  
    
  % noise spectral density
  snr = 10^(SNRdB/10); %Snr to linear scale
   No= p/snr;
  
   %Computer noise
  desv = sqrt(No)/sqrt(2);
   % desv = sqrt(p/snr)/sqrt(2);

  n = randn(size(data)) + 1i*randn(size(data));      
  n = n.*desv;
  
end
  