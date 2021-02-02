function dqsk_demod = differential_demodulator(dataOFDM_demodulate)

DQPSK_symbol_block=75; %dqpsk symbol block
K = 1536;  %carriers data

Rx_data= dataOFDM_demodulate;

%plot
figure(3);
hold on;
plot(real(Rx_data),imag(Rx_data),'*');
title('Constellation pi/4 DQPSK  recu')

%%

%get phase reference symbol 
initial_phase_reference = phase_reference_symbol1()  ;
initial_phase_reference=initial_phase_reference.';



%contenation phase reference symbol+ interleaved QPSK symbol
y= [initial_phase_reference Rx_data];
x=zeros (3,3);
for i= 1: K
    
     x(i,1)= Rx_data(i,1)/ y(i,1);

  for j= 2:DQPSK_symbol_block
     x(i,j)=Rx_data(i,j)/Rx_data(i,j-1) ;  
    
  end
end
 dqsk_demod =x;
end


