function dqpsk = differential_modulator(data)

DQPSK_symbol_block=75; %dqpsk symbol block
M_IFFT = 1536; %carriers

%get phase reference symbol 
initial_phase_reference = phase_reference_symbol1()  ;
initial_phase_reference=initial_phase_reference';


%Get array of interleaved QPSK symbol

y=data;

%contenation phase reference symbol+ interleaved QPSK symbol
y= [initial_phase_reference y];


%perform differential modulation on QPSK symbol block


z=zeros(M_IFFT, DQPSK_symbol_block);
for k= 1: M_IFFT
    
     z(k,1)= y(k,1) *y(k,2);

  for j=2:DQPSK_symbol_block
     z(k,j)= z(k,j-1) *y(k,j+1);
  end
 
end
dqpsk=z;
 
 figure(2);
hold on;
plot(real(dqpsk),imag(dqpsk),'*');
title('Constellation pi/4 DQPSK')
 end