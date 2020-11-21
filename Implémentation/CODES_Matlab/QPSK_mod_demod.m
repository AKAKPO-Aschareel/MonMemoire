function [ modData] = QPSK_mod_demod(data)
 
%Initialize variables
M=4; % Modulation order
ini_phase= pi/M;  %initial phase of the PSK-modulated signal
data= [1 0 0 0 1 1 0 1 0 0 1 1 0 0 0 1];


%-------------------------------------------------------
%data= [1 0];
%codedData = convolutionalDAB(data);
 %intrlvd = time_interleaving(codedData);
%intrlvd= bi2de(reshape(intrlvd,4,2),'left-msb');
%-----------------------------------------------


% QPSK Modulation

data= bi2de(reshape(data,8,2),'left-msb'); %data symbols (convert data binary to decimal)
modData = pskmod(data,M,ini_phase);% modulated data symbols

% QPSK Demodulation
dataOut = pskdemod(modData,M,ini_phase); %demodulated signal
dataOut= de2bi(dataOut,'left-msb'); %convert data decimal to binary
demodData= dataOut(:)';
end

