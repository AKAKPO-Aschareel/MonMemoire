function d = cyclic_delay(QpskMod)

y=length(QpskMod);

xx=imag(QpskMod(y));
%
for k=2:y
     d(y-k+2)=real(QpskMod(y-k+2))+ 1i*imag(QpskMod(y-k+1)); 
    
end
d(1)= real (QpskMod(1))+1i*xx;
end

