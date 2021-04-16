clear ;
close all;
clc

K=1536; %carrier data
L=75;%nombre de blocs
N=3072; %bit par blocs

%generation des bits
b= randi([0,1],1,N*L);
b=reshape(b,L,N); %formation des blocs

%Modulation QPSK
q=zeros(L, K);
for L=1:75
    
   for n=1:K
q(L,n)= (1/sqrt(2))*((1-2*b(L,n))+ 1i*(1-2*b(L,n+K)));
   end
end
Y=q;
%%
% plot constellation at transmitter

figure(1);
hold on;
plot(real(Y),imag(Y),'*');
title('Constellation QPSK emise')



