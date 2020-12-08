

function dataDemodulate = Demodulation(dataModulate)

%Initialize variables;

%QPSK PARAMETERS
M=4; %nombre de symbole pour une modulation QPSK
n=2; %nombre de bits par symbole QPSK
init_phase= pi/4; %phase inital QPSK

%
M_IFFT = 10; %nombre de sous porteuses 



%%PROCEDURE

%Suppresion prefixe cyclique

Suppr_CP = dataModulate(1:M_IFFT,:);

%-----FFT-----
 FFT_function = fft(Suppr_CP ,M_IFFT); % discrete Fourier transform 

 
%estimation et egalisation
%--------------------------------------------

fftOut=FFT_function(:); %conversion P/S


%demodulation QPSK
demodData = pskdemod(fftOut,M,init_phase); 

%convert data decimal to binary
demodData = de2bi(demodData,'left-msb'); 

dataDemodulate = demodData(:)';
end

