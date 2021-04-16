function  dataDemod_OFDM= Demod_ComBox(Rx_signal, hF)


% OFDM PARAMETERS Mode I

%K = 1536; %number of sub-carriers

%OFDM_symbol_data_block= 75; %symbols without pilots
FFT_length = 2048;
OFDM_length=2552; %FFT_length+cp
OFDM_symbol_block=75;
Tnull=2656;

%%PROCEDURE
%data= Rx_signal(:,Tnull+1 :end);
%data_redim=reshape(data,OFDM_symbol_block,OFDM_length);


% Remove prefix cyclic
Suppr_CP = Rx_signal(:,1:FFT_length);

%-----FFT-----
 FFT_function = fft(Suppr_CP ,FFT_length,2); % discrete Fourier transform 
 
 
 
 %Estimation Egalistion
     data_est=FFT_function./hF;
 
 %Zero padding remove and reorder
 
 data_after_remove_zeros= [ data_est(:,1281:FFT_length) data_est(:,1:768)];


 dataDemod_OFDM = data_after_remove_zeros;
 
 
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DEMODULATION
