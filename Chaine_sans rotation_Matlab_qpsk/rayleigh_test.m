
%function rayleigh_out = rayleigh_test()

clear all;
clc;
close all;
TEB=[];  
 
pskModulator = comm.PSKModulator;
%Modulate the signal.
x=randi([0 7],2000,1);
numBits =length (x);
modData = pskModulator(x);

%Add white Gaussian noise to the modulated signal by passing the signal through an AWGN channel.

for snr=0:1: 10
y = awgn(modData,snr,'measured');
%Plot the noiseless and noisy data using scatter plots to observe the effects of noise.

%scatterplot(modData)
%h = scatterplot(y);

pskDemodulator = comm.PSKDemodulator;
demodData=pskDemodulator(y);

% Calculate the number of bit errors
 nErrors = biterr(x,demodData);
        

  
    
% Estimate the BER
 TEBnew = nErrors/numBits;
 TEB= [TEB TEBnew];
end

figure(1)
SNR= 0:1: 10;
semilogy (SNR,TEB,'b-o','MarkerSize',5,'MarkerFacecolor','r','linewidth',2);
grid on;
hold on;
xlabel('SNR(dB)');
ylabel('BER');
legend('testtt');
axis([0 10 1e-4 1e0]);
title('TEB en fonction de SNR');




