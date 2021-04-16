function Y = differential_demodulator(dataOFDM_demodulate,PRS)

K=1536;
L=75;
Z=dataOFDM_demodulate;


%plot constellation at receiver

figure(3);
hold on;
plot(real(Z),imag(Z),'*');
title('Constellation pi/4 DQPSK recu')

%Differential
%get phase reference symbol received

initial_phase_reference=PRS;

 Y= zeros(L,K);
for K=1:1536

Y(1,K)= Z(1,K)/initial_phase_reference( 1,K);

end

for L=2:75
    for K=1:1536
        Y(L,K)=Z(L,K)/Z(L-1,K);
       
    end
end

end

