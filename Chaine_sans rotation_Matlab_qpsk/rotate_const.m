function qpsk_rot = rotate_const(data)

K = 1536 ; %number of sub-carriers 
QPSK_symbol_block = 75; %  number of qpsk symbol block

%QPSK ROTATION ANGLE =29.0
Rotation_angle_degrees=29.0;
Rotation_angle_radians= 2 *pi*Rotation_angle_degrees/360;

c=data*exp(1i*angle);

figure(2);
hold on;
grid on;
plot(real(c),imag(c),'*');
title('Constellation QPSK tournée')



%decalage cyclique

d=zeros(K,QPSK_symbol_block);
for count= 2: K
    for L= 1:QPSK_symbol_block
     
     d(count,L)= real(c(count,L) ) + 1i*imag(c(count-1,L));            
 
    end 
end

 for L=1:QPSK_symbol_block
   d(1,L)= real (c(1,L)) + 1i* imag(c(K,L));
   
  end

qpsk_rot=d;
figure(3);
hold on;
grid on;
plot(real(qpsk_rot),imag(qpsk_rot),'*');
title('Constellation QPSK décalée')
end

