clear all;
clc;
close all;
M=4; % number of symbol for modulation QPSK
init_phase= pi/4;


a=[0 1 1 3 2 2 3];

b= pskmod(a,M,init_phase);



% rotation de constellation
%QPSK ROTATION ANGLE =29.0
angle=0.506;
c=b*exp(1i*angle);
scatterplot(b);
scatterplot(c);

%decalage cyclique


y=length(c);

xx=imag(c(y));
%
for k=2:y
     d(y-k+2)=real(c(y-k+2))+ 1i*imag(c(y-k+1)); 
    %d(y-k+2)=real(c(y-k+2)) +1i*imag(c(y-k)+1);
end
d(1)= real (c(1))+1i*xx;
scatterplot(d);




%Suppresion decalage cyclique
tt= imag (d(1));
for k=1: (length(d)-1)
    e(k)= real(d(k))+ 1i*imag (d(k+1));
    
end
e(y)=real(d(y))+1i*tt;
scatterplot (e);


%suppression de rotation de constellation

f= c*exp(-1i*angle);
scatterplot(f);
 


%16QAM angle=16.8
%64QAM angle= 8.6


