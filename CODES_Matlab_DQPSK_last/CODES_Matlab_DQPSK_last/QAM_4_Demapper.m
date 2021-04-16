function B = QAM_4_Demapper(delete_rotation)
qam_constellation_0= [1.0 + 1.0i	1.0 - 1.0i ;1.0 + 1.0i	-1.0 + 1.0i];
   qam_constellation_1= [-1.0 + 1.0i	-1.0 - 1.0i; 1.0 - 1.0i	-1.0 - 1.0i];
 
  bit_number=2;
  realite=real(delete_rotation);
  imaginary=imag(delete_rotation);
  
   for k = 1:bit_number  % bit sýrasý MSB to LSB oluyor
      
    %%maximum likelihood function for bit=0 probability
    
    m = (realite-real(qam_constellation_0(k,1))).^2 + (imaginary-imag(qam_constellation_0(k,1))).^2;
    for i=2:2^(bit_number-1)
        a = (realite-real(qam_constellation_0(k,i))).^2 + (imaginary-imag(qam_constellation_0(k,i))).^2;
        if a<m 
           m=a;
        end
    end
    
    %%maximum likelihood function for bit=0 probability
    
    n = (realite-real(qam_constellation_1(k,1))).^2 + (imaginary-imag(qam_constellation_1(k,1))).^2;
    for i=2:2^(bit_number-1)
        a = (realite-real(qam_constellation_1(k,i))).^2 + (imaginary-imag(qam_constellation_1(k,i))).^2;
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

