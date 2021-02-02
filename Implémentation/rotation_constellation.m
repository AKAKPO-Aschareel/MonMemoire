clear all;
clc;
close all;
M=4; % number of symbol for modulation QPSK
init_phase= pi/4;


%QPSK ROTATION ANGLE =29.0
angle=(29* pi)/180;

%Modulation

data= randi([0,1],10,2);

data_symbole= bi2de (data,'left-msb'); 
data_mod= pskmod(data_symbole,M,init_phase);

%plot constellation 
scatterplot (data_mod);


% rotation de constellation
c=data_mod*exp(1i*angle);

scatterplot(c);
  

 %suppression de rotation de constellation

  d= c*exp(-1i*angle);
  scatterplot(d);
 
 %---


%16QAM angle=16.8
M2 = 16;
angle2=(16.8* pi)/180;
x = (0:M2-1)';
%Modulate the data using the qammod function.

y = qammod(x,M2);

%Display the modulated signal constellation using the scatterplot function.

scatterplot(y);

% rotation de constellation
z=y*exp(1i*angle2);

scatterplot(z);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


dqpskmod = comm.DQPSKModulator('BitInput',true);
 txData = randi([0 1],100,1);
    modSig = dqpskmod(txData);
    scatterplot (modSig);
    
% rotation de constellation
rot= modSig*exp(1i*angle);

scatterplot(rot);