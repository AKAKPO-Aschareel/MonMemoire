function dqpsk = differential_modulator(data)

DQPSK_symbol_block=75; %dqpsk symbol block
K = 1536;  %carriers data

%get phase reference symbol 
initial_phase_reference = phase_reference_symbol1()  ;
initial_phase_reference=initial_phase_reference.';


%Get array of interleaved QPSK symbol

y=data;

%contenation phase reference symbol+ interleaved QPSK symbol
y= [initial_phase_reference y];


%perform differential modulation on QPSK symbol block


z=zeros(K, DQPSK_symbol_block);
for i= 1: K
    
     z(i,1)= y(i,1) *y(i,2);

  for j=2:DQPSK_symbol_block
     z(i,j)= z(i,j-1) *y(i,j+1);
  end
 
end
dqpsk=z;
 %plot results
 figure(2);
hold on;
plot(real(dqpsk),imag(dqpsk),'*');
title('Constellation pi/4 DQPSK emise')


end
 
