clear all;
clc;
close all;
M=4; % number of symbol for modulation QPSK
init_phase= pi/4;
angle=0.506;

data= randi([0,1],20,2);
data_symbole= bi2de (data,'left-msb'); 
b= pskmod(data_symbole,M,init_phase);
c=b*exp(1i*angle);
scatterplot(b);
scatterplot(c);




