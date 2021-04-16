function dataDemod_OFDM = demodulation_OFDM(Rx_signal)

FFT_length = 2048;

% Remove prefix cyclic
Suppr_CP = Rx_signal(:,1:FFT_length);

%-----FFT-----
 FFT_function = fft(Suppr_CP ,FFT_length,2); % discrete Fourier transform 
 

 %Zero padding remove and reorder
 
 data_after_remove_zeros= [ FFT_function(:,1281:FFT_length) FFT_function(:,1:768)];


 dataDemod_OFDM = data_after_remove_zeros;
 
 


end

