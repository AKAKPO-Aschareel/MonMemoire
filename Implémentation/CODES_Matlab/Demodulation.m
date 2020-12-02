

function dataDemodulate = Demodulation(dataModulate)

%Initialize variables;

M=4; %nombre de symbole pour une modulation QPSK
n=2; %nombre de bits par symbole QPSK
init_phase= pi/4; %phase inital QPSK

M_IFFT = 10; %nombre de sous porteuses 
Es= 1; %variable d'estimation





mod_norm=sqrt(Es/(1./M.*sum(abs(qammod([0:M-1],M)).^2)));% normalisation


%Suppresion prefixe cyclique

Suppr_CP = dataModulate(1:M_IFFT,:);

%-----FFT-----
 FFT_function = fft(Suppr_CP ,M_IFFT); % discrete Fourier transform 

 
%estimation et egalisation
%--------------------------------------------

fftOut=FFT_function(:); %conversion P/S
demodData = pskdemod(fftOut.*(1/mod_norm),M,init_phase); % demodulation QPSK de l'information
demodData = de2bi(demodData,'left-msb'); %convert data decimal to binary

dataDemodulate = demodData(:)';
end

