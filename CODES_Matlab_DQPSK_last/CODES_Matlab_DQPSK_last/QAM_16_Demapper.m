function B = QAM_16_Demapper(delete_rotation)
demod_qam_16_0 = [3.0 + 3.0i	3.0 + 1.0i	1.0 + 3.0i	1.0 + 1.0i	3.0 - 3.0i	3.0 - 1.0i	1.0 - 3.0i	1.0 - 1.0i;
3.0 + 3.0i	3.0 + 1.0i	1.0 + 3.0i	1.0 + 1.0i	-3.0 + 3.0i	-3.0 + 1.0i	-1.0 + 3.0i	-1.0 + 1.0i;
3.0 + 3.0i	3.0 + 1.0i	3.0 - 3.0i	3.0 - 1.0i	-3.0 + 3.0i	-3.0 + 1.0i	-3.0 - 3.0i	-3.0 - 1.0i;
3.0 + 3.0i	1.0 + 3.0i	3.0 - 3.0i	1.0 - 3.0i	-3.0 + 3.0i	-1.0 + 3.0i	-3.0 - 3.0i	-1.0 - 3.0i
];

demod_qam_16_1 = [ -3.0 + 3.0i	-3.0 + 1.0i	-1.0 + 3.0i	-1.0 + 1.0i	-3.0 - 3.0i	-3.0 - 1.0i	-1.0 - 3.0i	-1.0 - 1.0i;
3.0 - 3.0i	3.0 - 1.0i	1.0 - 3.0i	1.0 - 1.0i	-3.0 - 3.0i	-3.0 - 1.0i	-1.0 - 3.0i	-1.0 - 1.0i;
1.0 + 3.0i	1.0 + 1.0i	1.0 - 3.0i	1.0 - 1.0i	-1.0 + 3.0i	-1.0 + 1.0i	-1.0 - 3.0i	-1.0 - 1.0i;
3.0 + 1.0i	1.0 + 1.0i	3.0 - 1.0i	1.0 - 1.0i	-3.0 + 1.0i	-1.0 + 1.0i	-3.0 - 1.0i	-1.0 - 1.0i
]; 
  bit_number=4;
  realite=real(delete_rotation);
  imaginary=imag(delete_rotation);
  
   for k = 1:bit_number  % bit sýrasý MSB to LSB oluyor
      
    %%maximum likelihood function for bit=0 probability
    
    m = (realite-real(demod_qam_16_0(k,1))).^2 + (imaginary-imag(demod_qam_16_0(k,1))).^2;
    for i=2:2^(bit_number-1)
        a = (realite-real(demod_qam_16_0(k,i))).^2 + (imaginary-imag(demod_qam_16_0(k,i))).^2;
        if a<m 
           m=a;
        end
    end
    
    %%maximum likelihood function for bit=0 probability
    
    n = (realite-real(demod_qam_16_1(k,1))).^2 + (imaginary-imag(demod_qam_16_1(k,1))).^2;
    for i=2:2^(bit_number-1)
        a = (realite-real(demod_qam_16_1(k,i))).^2 + (imaginary-imag(demod_qam_16_1(k,i))).^2;
        if a<n
           n=a;
        end
    end
    
    % decision making process 
    if (m > n)     
        B(k) = 1;
    else
        B(k) = 0;
    end
    
   end

 end


