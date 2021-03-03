clear all;
clc;
close all;
M=4; % number of symbol for modulation QPSK
init_phase= pi/4;


a= [0 1 1 3 2 0 1 3 2 2];

b= pskmod(a,M,init_phase);
b=reshape(b,5,2);

%plot results
figure(1);
hold on;
grid on;
plot(real(b),imag(b),'*');
title('Constellation QPSK emise')




%QPSK ROTATION ANGLE =29.0
Rotation_angle_degrees=29.0;
Rotation_angle_radians= 2 *pi*Rotation_angle_degrees/360;

c=b *exp(1i*Rotation_angle_radians);

figure(2);
hold on;
grid on;
plot(real(c),imag(c),'*');
title('Constellation QPSK tournée')



%decalage cyclique

d=zeros(5, 2);
for k= 2: 5
    for L= 1:2
     
     d(k,L)= real(c(k,L) ) + 1i*imag(c(k-1,L));            
 
    end 
end

 for L=1:2
   d(1,L)= real (c(1,L)) + 1i* imag(c(5,L));
   %d(1)= real (c(1))+1i*xx;
  end

q=d;
figure(3);
hold on;
grid on;
plot(real(q),imag(q),'*');
title('Constellation QPSK décalée')

%Suppresion decalage cyclique

e=zeros(5, 2);
for k=1:4
    
    for L=1:2
    e(k,L)= real(d(k,L))+ 1i*imag (d(k+1,L));
    
    end
    
end
for L=1:2
e(5,L)=real(d(5,L))+ 1i* imag (d(1,L));

end
z=e;

figure(4);
hold on;
grid on;
plot(real(z),imag(z),'*');
title('Constellation QPSK décalée')


%suppression de rotation de constellation

f= e *exp(-1i*Rotation_angle_radians);

%plot
figure(5);
hold on;
grid on;
plot(real(f),imag(f),'*');
title('Constellation QPSK non rotated')