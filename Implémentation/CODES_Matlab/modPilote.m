function pilote_OFDM = modPilote()
%%To generate the symbols pilots to estimate the channel

%QPSK PARAMETERS of pilots

M=4; % number of symbol for modulation QPSK
n=2; % number of  bits per symbole QPSK
init_phase= pi/4; % phase inital QPSK



% Pliots PARAMETERS 

pilots_carriers = 1536; %number of sub-carriers 
sym_pilots_block= 3; %number of pilots symbols block
total_bitsPilots = pilots_carriers*sym_pilots_block*n ; %number of bits per pilots symbols blocks






%Procedure
 

% Generation of pilots data
dataPilot = randi ([0,1],1,total_bitsPilots);

%conversion S/P et conversion binaire en decimal
symPilote = bi2de (reshape(dataPilot,pilots_carriers*sym_pilots_block,n),'left-msb'); 

% QPSK modulation of pilots symbols
QPSK_Pilote = pskmod(symPilote,M,init_phase);

%conversion S/P 
QPSK_Pilote_redim = reshape(QPSK_Pilote,pilots_carriers,sym_pilots_block); 

%perform differential modulation on QPSK symbol block pilots


%get phase reference symbol 
initial_phase_reference = phase_reference_symbol1()  ;
initial_phase_reference=initial_phase_reference.';


%contenation phase reference symbol+  QPSK symbol pilots
y= [initial_phase_reference QPSK_Pilote_redim];


z=zeros(pilots_carriers, sym_pilots_block);
for k= 1: pilots_carriers
    
     z(k,1)= y(k,1) *y(k,2);

  for j=2:sym_pilots_block
     z(k,j)= z(k,j-1) *y(k,j+1);
  end
 
end
pilote_OFDM=z;
 

 

end

