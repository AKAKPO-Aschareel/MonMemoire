function e = remove_cyclic_delay(d)

y=length(d);
tt= imag (d(1));

for k=1: (length(d)-1)
    e(k)= real(d(k))+ 1i*imag (d(k+1));
    
end
e(y)=real(d(y))+1i*tt;
end

