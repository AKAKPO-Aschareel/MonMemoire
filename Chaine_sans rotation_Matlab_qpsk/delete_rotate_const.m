function f = delete_rotate_const(data)

K = 1536 ; %number of sub-carriers 
QPSK_symbol_block = 75; %  number of qpsk symbol block
angle=0.506;

%Suppresion decalage cyclique
d=data;
e=zeros(K, QPSK_symbol_block );
for count=1:K-1
    
    for L=1:QPSK_symbol_block 
    e(count,L)= real(d(count,L))+ 1i*imag (d(count+1,L));
    
    end
    
end
for L=1:QPSK_symbol_block 
e(K,L)=real(d(K,L))+ 1i* imag (d(1,L));

end
z=e;

figure(4);
hold on;
grid on;
plot(real(z),imag(z),'*');
title('Constellation QPSK décalée')


%suppression de rotation de constellation

f= z*exp(-1i*angle);

%plot
figure(5);
hold on;
grid on;
plot(real(f),imag(f),'*');
title('Constellation ')
end

