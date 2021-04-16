clear;
close all;
clc;


%Create a DQPSK modulator and demodulator pair. Create an AWGN channel object having two bits per symbol.



dqpskmod = comm.DQPSKModulator(pi/4,'BitInput',true);


dqpskdemod = comm.DQPSKDemodulator(pi/4,'BitOutput',true);

%M = 4;

%Generate a sequence of 4-ary random symbols.
 txData = randi([0 1],307200,1);
    modSig = dqpskmod(txData);
    modSig2=reshape(modSig,2048,75);

figure(1);
hold on;
plot(real(modSig2),imag(modSig2),'*');
title('Constellation emise')

Y=ifft(modSig2,2048);
Z=fft(Y,2048);
Z=reshape(Z,153600,1);
figure(2);
hold on;
plot(real(Z),imag(Z),'*');
title('Constellation emise')

demodSig=dqpskdemod (Z);
 
 nErrors = biterr(txData,demodSig);
        
 numBits = length(txData);
    
    
% Estimate the BER
 TEBnew = nErrors/numBits;
 