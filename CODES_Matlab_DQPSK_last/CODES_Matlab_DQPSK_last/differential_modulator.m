function Z= differential_modulator(data,PRS)

K=1536;
L=75;
Y=data;

%Differential
%get phase reference symbol 

initial_phase_reference=PRS;

 Z= zeros(L,K);
 
 for K=1:1536
 Z(1,K)=initial_phase_reference(1,K) *Y(1,K);
 
 end
for L=2:75
    for K=1:1536
    Z(L,K)= Z(L-1,K)*Y(L,K);
    end
end

 %
 %for L=2:75

  %   Z(L,K) = Z(L-1,K) * Y(L,K);
 %end


end



 



 

    
