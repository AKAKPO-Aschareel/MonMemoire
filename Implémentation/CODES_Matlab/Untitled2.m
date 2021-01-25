clear all;
clc;
close all;
M=4; % number of symbol for modulation QPSK
init_phase= pi/4;

data= randi([0,1],115200,2);
data_symbole= bi2de (data,'left-msb'); 
y= pskmod(data_symbole,M,init_phase);
y=reshape(y,1536,75);


%get phase reference symbol symbol
initial_phase_reference = phase_reference_symbol1()  ;
initial_phase_reference=initial_phase_reference';


%perform differential modulation on QPSK symbol block
%contenation 
y= [initial_phase_reference y];


%perform differential modulation on QPSK symbol block


z=zeros(1536,75);
for k= 1: 1536
    
     z(k,1)= y(k,1) *y(k,2);

  for j=2:75
     z(k,j)= z(k,j-1) *y(k,j+1);
  end
 
end
dqpsk=z;
 
 figure(3);
hold on;
plot(real(dqpsk),imag(dqpsk),'*');
title('Constellation emise')
